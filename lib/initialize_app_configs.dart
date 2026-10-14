import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:moneeb/core/utils/utils_imports.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player_media_kit/video_player_media_kit.dart';
import 'core/base/di/data_injector.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz_loc;
import 'package:flutter_timezone/flutter_timezone.dart';

import 'core/base/fire_base/fire_base.dart';
import 'features/omrah/provider/presentation/manager/provider_tracking_service.dart';

Future<void> initializeAppConfig() async {
  WidgetsFlutterBinding.ensureInitialized();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );

  // Set preferred orientations (portrait only)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: SystemUiOverlay.values,
  );

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.light,
  );

  await initializeDependencies();

  DeviceSpecsUtils.instance.init();
  // RealTimeService.instance.init();

  // Everything else runs after the first frame so the splash shows up
  // immediately (see [appConfigReady]).
  unawaited(_initializeDeferredAppConfig());
}

final Completer<void> _appConfigReady = Completer<void>();

/// Completes once Firebase, timezones and the video backend are ready. Await
/// it before doing anything that needs them (e.g. the auth flow).
Future<void> get appConfigReady => _appConfigReady.future;

Future<void> _initializeDeferredAppConfig() async {
  try {
    await Future.wait([
      FirebaseHelper.initApp(),
      _registerMediaKitVideoBackEndOnOlderDevices(),
      _initializeTimeZone(),
    ]);
  } finally {
    _appConfigReady.complete();
  }

  // These may show permission dialogs and take as long as the user needs, so
  // they must not block the app flow.
  try {
    await FirebaseHelper.initMessaging();
  } catch (e) {
    log('Error initializing messaging: $e');
  }

  try {
    await initializeBackgroundService();
  } catch (e) {
    log("Error initializing background services: $e");
  }
}

Future<void> _initializeTimeZone() async {
  tz.initializeTimeZones();
  try {
    final localTz = (await FlutterTimezone.getLocalTimezone()).toString();
    tz_loc.setLocalLocation(tz_loc.getLocation(localTz));
  } catch (e) {
    log('Could not detect local timezone: $e');
  }
}

//todo: remove if flutter fixed the video player on older devices
Future<void> _registerMediaKitVideoBackEndOnOlderDevices() async {
  if (Platform.isAndroid) {
    try {
      int sdkVersion = (await DeviceInfoPlugin().androidInfo).version.sdkInt;

      if (sdkVersion < 30) {
        VideoPlayerMediaKit.ensureInitialized(android: true);
      }
    } catch (e) {}
  }
}
