import 'dart:async';
import 'dart:developer';
import 'dart:io' show Platform;
import 'dart:ui';

import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:moneeb/core/base/di/data_injector.dart';
import 'package:moneeb/core/config/config.dart';
import 'package:moneeb/core/utils/utils_imports.dart';
import 'package:moneeb/common/domain/models/token_entity.dart';
import 'package:moneeb/features/authentication/authentication_imports.dart';

// Constants
// const _kForegroundIntervalSec = 15;
const _kUpdateLocationIntervalSec = 30;

// iOS <-> native CLLocationManager bridge (see ios/Runner/LocationTracker.swift).
const _kIosLocationChannel = MethodChannel('com.linkcom.moneeb/location_tracker');

const _kNotificationChannelId = 'omrah_tracking_channel';
const _kNotificationChannelName = 'Umrah Tracking';
const _kNotificationId = 888;

// Service class
class ProviderTrackingService {
  ProviderTrackingService._();

  static ProviderTrackingService? _instance;
  static ProviderTrackingService get instance =>
      _instance ??= ProviderTrackingService._();

  String? _activeOrderId;
  String? get activeOrderId => _activeOrderId;

  final FlutterBackgroundService _service = FlutterBackgroundService();

  // Listens for a self-initiated stop (e.g. the user tapped "Close" on the
  // notification) so we can clear local state and allow re-starting later.
  StreamSubscription<Map<String, dynamic>?>? _stoppedSub;

  // ---- iOS-specific state ----
  // On iOS all location capture + server delivery happens natively (see
  // ios/Runner/LocationTracker.swift) so it survives background / locked /
  // terminated states. Dart only seeds credentials and starts/stops it.
  bool _iosActive = false;

  // is background service is running
  Future<bool> get isRunning => Platform.isIOS
      ? Future.value(_iosActive)
      : _service.isRunning();

  Future<void> startTracking(String orderId) async {
    if (_activeOrderId == orderId) return;

    // Stop any existing tracking before starting a new one.
    if (_activeOrderId != null) {
      await _stopTracking();
    }

    _activeOrderId = orderId;

    if (Platform.isIOS) {
      await _startIosTracking(orderId);
    } else {
      // Android — existing foreground-service approach.
      // Subscribe once so a stop triggered from the notification clears state.
      _stoppedSub ??= _service.on('trackingStopped').listen((_) {
        _activeOrderId = null;
      });

      final running = await _service.isRunning();
      if (!running) {
        await _service.startService();
        // Give the isolate a moment to boot and register listeners.
        await Future.delayed(const Duration(milliseconds: 1000));
      }

      _service.invoke('startTracking', {'orderId': orderId});
    }

    log('ProviderTrackingService - Started tracking order: $orderId');
  }

  // ---------------------------------------------------------------------------
  // iOS: hand off to the native CLLocationManager tracker. It keeps tracking +
  // sending while the app is foreground / background / locked, and is even
  // relaunched after a full terminate via Significant Location Change.
  // We seed it with the current auth token so it can POST + refresh natively.
  // ---------------------------------------------------------------------------
  Future<void> _startIosTracking(String orderId) async {
    // Ensure encryption is registered (needed to decrypt the stored token).
    if (!injector.isRegistered<Encryption>()) {
      injector.registerLazySingleton<Encryption>(() => AESEncryption());
    }

    // Read (and proactively refresh) the current token, then seed native with
    // it. Native handles all subsequent refreshes/sends on its own.
    final TokenEntity? token = await _readToken();

    try {
      await _kIosLocationChannel.invokeMethod('start', {
        'orderId': orderId,
        'baseUrl': Constants.endpoint,
        'accessToken': token?.accessToken ?? '',
        'refreshToken': token?.refreshToken ?? '',
        'expiryMs':
            token?.accessTokenExpirationDate.millisecondsSinceEpoch.toDouble() ??
            0,
      });
      _iosActive = true;
    } catch (e) {
      log('[iOS Tracking] Failed to start native tracker: $e');
    }
  }

  Future<TokenEntity?> _readToken() async {
    try {
      return await IsolatedTokenManager().token;
    } catch (e) {
      log('[iOS Tracking] Could not read token: $e');
      return null;
    }
  }

  Future<void> _stopIosTracking() async {
    _iosActive = false;
    try {
      await _kIosLocationChannel.invokeMethod('stop');
    } catch (e) {
      log('[iOS Tracking] Failed to stop native tracker: $e');
    }
  }

  // Stop tracking the current order but keep the service alive for a quick restart.
  Future<void> _stopTracking() async {
    if (_activeOrderId == null) return;

    log('[ProviderTrackingService] Stopping tracking for: $_activeOrderId');
    _activeOrderId = null;

    if (Platform.isIOS) {
      await _stopIosTracking();
    } else {
      _service.invoke('stopTracking');
    }
  }

  // Fully stop tracking and shut down the background service isolate.
  Future<void> dispose() async {
    try {
      _activeOrderId = null;

      if (Platform.isIOS) {
        await _stopIosTracking();
      } else {
        _service.invoke('stopTracking');
        _service.invoke('stopService');
      }

      log('[ProviderTrackingService] Service disposed.');
    } catch (e) {}
  }

  // ---------------------------------------------------------------------------
  // App-startup sync (iOS). Call once on launch:
  //  - adopt any token native refreshed while the app was terminated, and
  //  - if the server returned 401 during background tracking, surface it so the
  //    user gets logged out.
  // Returns true if the user should be logged out.
  // ---------------------------------------------------------------------------
  Future<bool> syncIosOnStartup() async {
    if (!Platform.isIOS) return false;

    if (!injector.isRegistered<Encryption>()) {
      injector.registerLazySingleton<Encryption>(() => AESEncryption());
    }

    try {
      final bool needsLogout =
          (await _kIosLocationChannel.invokeMethod<bool>('consumeLogoutFlag')) ??
          false;
      if (needsLogout) {
        await _stopIosTracking();
        return true;
      }

      // Adopt native token if it is newer than the Dart-stored one (native may
      // have refreshed it while the app was terminated).
      final Map? nativeToken =
          await _kIosLocationChannel.invokeMethod<Map>('currentToken');
      if (nativeToken != null && (nativeToken['active'] == true)) {
        final String accessToken = (nativeToken['accessToken'] as String?) ?? '';
        final double expiryMs =
            (nativeToken['expiryMs'] as num?)?.toDouble() ?? 0;
        if (accessToken.isNotEmpty) {
          final current = await _readToken();
          final currentExpiry =
              current?.accessTokenExpirationDate.millisecondsSinceEpoch ?? 0;
          if (expiryMs > currentExpiry && current != null) {
            IsolatedTokenManager().setTokenToLocalStorage(
              current.copyWith(
                accessToken: accessToken,
                refreshToken:
                    (nativeToken['refreshToken'] as String?) ??
                    current.refreshToken,
                accessTokenExpirationDate:
                    DateTime.fromMillisecondsSinceEpoch(expiryMs.toInt()),
              ),
            );
          }
        }
      }
    } catch (e) {
      log('[iOS Tracking] startup sync failed: $e');
    }
    return false;
  }
}

// -----------------
// Background service initializer (used by both platforms at startup)
// -----------------------
Future<void> initializeBackgroundService() async {
  final service = FlutterBackgroundService();

  // --- Android notification channel ----
  const channel = AndroidNotificationChannel(
    _kNotificationChannelId,
    _kNotificationChannelName,
    description: 'Tracks provider location during Umrah journey',
    importance: Importance.low,
  );

  final _notfPlugin = FlutterLocalNotificationsPlugin();
  await _notfPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(channel);

  // ---- Configure the service -----
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: _onServiceStart,
      autoStart: false,
      isForegroundMode: true,
      notificationChannelId: _kNotificationChannelId,
      initialNotificationTitle: 'Umrah Tracker',
      initialNotificationContent: 'Preparing',
      foregroundServiceNotificationId: _kNotificationId,
      foregroundServiceTypes: [AndroidForegroundType.location],
    ),
    iosConfiguration: IosConfiguration(
      autoStart: false,
      onForeground: _onServiceStart,
      onBackground: _onIosBackground,
    ),
  );
}

// -------------
// Top-level isolate entry points (Android only in practice)
// --------------------
@pragma('vm:entry-point')
Future<bool> _onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
void _onServiceStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  // --- State --------
  String? currentOrderId;
  Timer? trackingTimer;
  // bool isInForeground = true;
  //
  // if(service is AndroidServiceInstance) {
  //   isInForeground = await service.isForegroundService();
  // } else {
  //   //todo: there is no isForegroundService in ios service, so find a way to know
  //   isInForeground = true;
  // }

  // -- Dependencies -----------
  IsolatedDioHelper dioHelper = IsolatedDioHelper();
  final battery = Battery();
  final notifPlugin = FlutterLocalNotificationsPlugin();

  // --- Notification helper -----------------------------
  // We post the foreground notification ourselves via flutter_local_notifications
  // (instead of service.setForegroundNotificationInfo) so we can attach a
  // "Close" action button. The id must match foregroundServiceNotificationId so
  // it updates the same foreground-service notification rather than stacking.
  void updateNotification({required String title, required String body}) {
    if (service is! AndroidServiceInstance) return;

    notifPlugin.show(
      _kNotificationId,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _kNotificationChannelId,
          _kNotificationChannelName,
          ongoing: true,
          autoCancel: false,
          onlyAlertOnce: true,
          importance: Importance.low,
          priority: Priority.low,
        ),
      ),
    );
  }

  // --- Location fetch -------------------------------
  Future<Position?> fetchPosition() async {
    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );
    } catch (e) {
      log('[TrackingIsolate] getCurrentPosition failed: $e');

      // Fall back to last known position.
      try {
        return await Geolocator.getLastKnownPosition();
      } catch (_) {
        return null;
      }
    }
  }

  // --- Battery helpers -----------------------------
  Future<int> getBatteryLevel() async {
    try {
      return await battery.batteryLevel;
    } catch (_) {
      return -1;
    }
  }

  Future<bool> getIsCharging() async {
    try {
      return (await battery.batteryState) == BatteryState.charging;
    } catch (_) {
      return false;
    }
  }

  // --- Core send with retries -----------------
  Future<void> sendLocation(String orderId) async {
    final position = await fetchPosition();
    if (position == null) {
      log('[TrackingIsolate] Skipping send — no position available.');
      return;
    }

    final data = {
      'lat': position.latitude,
      'lng': position.longitude,
      'isBackgroundUpdate': true,
      'batteryLevelPercent': await getBatteryLevel(),
      'isCharging': await getIsCharging(),
    };

    try {
      await dioHelper.post('tracking/$orderId/location', data: data);

      updateNotification(
        title: 'Umrah Tracker',
        body: 'Tracking active • updated at ${_formatTime(DateTime.now())}',
      );

      return;
    } catch (e) {
      // All retries exhausted.
      updateNotification(
        title: 'Umrah Tracker',
        body:
            'Tracking active • last send failed at ${_formatTime(DateTime.now())}',
      );
    }
  }

  // --- Timer management -----------------
  void startTimer() {
    trackingTimer?.cancel();

    injector.registerLazySingleton<Encryption>(() {
      return AESEncryption();
    });

    // final intervalSec = isInForeground
    //     ? _kForegroundIntervalSec
    //     : _kBackgroundIntervalSec;

    // Send immediately, then start periodic timer.
    if (currentOrderId != null) {
      sendLocation(currentOrderId!);
    }

    trackingTimer = Timer.periodic(
      Duration(seconds: _kUpdateLocationIntervalSec),
      (_) {
        if (currentOrderId != null) {
          sendLocation(currentOrderId!);
        }
      },
    );
  }

  // --- Service event listeners ----------
  service.on('startTracking').listen((data) {
    final orderId = data?['orderId'] as String?;
    if (orderId == null || orderId == currentOrderId) return;

    currentOrderId = orderId;

    updateNotification(title: 'Umrah Tracker', body: 'Tracking your journey…');

    startTimer();
  });

  service.on('stopTracking').listen((_) {
    trackingTimer?.cancel();
    trackingTimer = null;
    currentOrderId = null;

    updateNotification(title: 'Umrah Tracker', body: 'Tracking paused');
  });

  service.on('stopService').listen((_) {
    trackingTimer?.cancel();
    trackingTimer = null;
    currentOrderId = null;

    // Let the main isolate clear its active-order state, then remove the
    // notification we posted ourselves (stopSelf won't clear a custom one).
    service.invoke('trackingStopped');
    notifPlugin.cancel(_kNotificationId);
    service.stopSelf();
  });
}

/// Runs in the background isolate, where the DI container and the localizer
/// are not available — hence the locale-free variant.
String _formatTime(DateTime t) => AppTimeFormat.timeWithoutLocale(t);
