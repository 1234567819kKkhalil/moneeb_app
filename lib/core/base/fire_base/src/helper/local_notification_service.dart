part of fire_base;

class LocalNotificationService {
  LocalNotificationService._initiate();
  static final LocalNotificationService _instance =
      LocalNotificationService._initiate();
  static LocalNotificationService get instance => _instance;

  final _localNotificationService = FlutterLocalNotificationsPlugin();

  //Observers - To track the updates in notification like (notification arrived, removed, ..etc)
  final List<NotificationObserver> _observers = [];

  void attachObserver<T>(NotificationObserver observer) {
    _observers.add(observer);
  }

  void deAttachObserver(NotificationObserver observer) {
    _observers.remove(observer);
  }

  void notifyNotificationsUpdated({
    required int addCount,
    required bool reset,
  }) {
    for (var observer in _observers) {
      observer.onNotificationUpdates?.call(addCount, reset);
    }
  }

  int getNotificationHashedId(String id) {
    if (id.isEmpty) {
      return RandomId.generateInt();
    }

    try {
      var bytes = utf8.encode(id);
      var digest = md5.convert(bytes);
      return digest.hashCode;
    } catch (e) {
      return RandomId.generateInt();
    }
  }

  //Initialize notification service
  Future<void> initialize() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    DarwinInitializationSettings iosInitializationSettings =
        const DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    final InitializationSettings settings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _localNotificationService.initialize(
      settings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    // Explicitly create the prayer times channel with MAX importance
    // (channel importance can only be set on first creation — clear app data if changing)
    if (Platform.isAndroid) {
      final androidPlugin = _localNotificationService
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      await androidPlugin?.createNotificationChannel(
        const AndroidNotificationChannel(
          'prayer_times_channel',
          'Prayer Times',
          description: 'Notifications for daily prayer times',
          importance: Importance.max,
          playSound: true,
          enableVibration: true,
        ),
      );
      log('🔔 [Notification] Channel created/updated: prayer_times_channel');
    }

    final notificationAppLaunchDetails = await _localNotificationService
        .getNotificationAppLaunchDetails();

    if ((notificationAppLaunchDetails?.didNotificationLaunchApp ?? false)) {
      _onDidReceiveNotificationResponse(
        notificationAppLaunchDetails?.notificationResponse,
      );
    }

    _requestPermissions();
  }

  /// TEST: Shows an immediate notification — use to verify notifications work at all.
  Future<void> showImmediateTestNotification() async {
    log('🔔 [Notification] Showing immediate test notification...');
    await _localNotificationService.show(
      999,
      '🔔 اختبار الإشعارات',
      'إذا ظهر هذا الإشعار فالنظام يعمل بشكل صحيح',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'prayer_times_channel',
          'Prayer Times',
          channelDescription: 'Notifications for daily prayer times',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
    log('✅ [Notification] Immediate test notification sent!');
  }

  Future<void> _requestPermissions() async {
    if (Platform.isAndroid) {
      final bool isAndroidNotificationEnabled =
          await _localNotificationService
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >()
              ?.areNotificationsEnabled() ??
          false;

      if (isAndroidNotificationEnabled) {
        final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
            _localNotificationService
                .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin
                >();
        await androidImplementation?.requestNotificationsPermission();
      }
    } else if (Platform.isIOS) {
      await _localNotificationService
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }
  }

  //Prevents duplicate notifications (using previousId)
  String? previousId;

  Future<void> showNotification(
    RemoteMessage message, {
    bool isFromBackground = false,
    /// The app was opened by tapping this notification.
    bool isOpenedByUser = false,
  }) async {
    final ReceivedNotificationEntity notificationEntity =
        ReceivedNotificationEntity.fromJson(message.data);
    log("NOTIFICATION => $notificationEntity");
    log("DATA => ${message.data}");

    //Do not show notification if it was already shown, To prevent duplication specially in IOS
    if (previousId != null &&
        previousId == notificationEntity.id &&
        notificationEntity.id.isNotEmpty) {
      return;
    }

    previousId = notificationEntity.id;

    //Setup notification details
    AndroidNotificationDetails? androidNotificationDetails;
    DarwinNotificationDetails? iosNotificationDetails;

    String notificationThumbnailFilePath = '';

    //ANDROID configuration
    if (Platform.isAndroid) {
      StyleInformation? styleInformation;

      if (notificationThumbnailFilePath.isNotEmpty) {
        styleInformation = BigPictureStyleInformation(
          FilePathAndroidBitmap(notificationThumbnailFilePath),
        );
      }

      androidNotificationDetails = AndroidNotificationDetails(
        'high_importance_channel',
        'high_importance_channel',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableLights: true,
        channelShowBadge: true,
        styleInformation: await NotificationStyleHandler('').getAndroidStyle(),
      );
    }

    //IOS configuration
    if (Platform.isIOS) {
      iosNotificationDetails = DarwinNotificationDetails(
        // attachments: await NotificationStyleHandler(notificationEntity.senderImageUrl??'').getIosAttachments(),
        attachments: await NotificationStyleHandler('').getIosAttachments(),
      );
    }

    //Show notification
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    //Inform the UI to Update notification count
    if (notificationEntity.id.isNotEmpty && !isFromBackground) {
      notifyNotificationsUpdated(addCount: 1, reset: false);

      _refreshOmrahStepIfAvailable(
        notificationEntity,
        isOpenedByUser: isOpenedByUser,
      );
    }

    await _localNotificationService.show(
      getNotificationHashedId(notificationEntity.id),
      message.notification?.title,
      message.notification?.body,
      notificationDetails,
      payload: json.encode(message.data),
    );
  }

  void _onDidReceiveNotificationResponse(
    NotificationResponse? notificationResponse,
  ) async {
    ExternalForwardingHandler.handleNotificationFromPayload(
      notificationResponse,
    );
  }

  void _refreshOmrahStepIfAvailable(
    ReceivedNotificationEntity notificationEntity, {
    required bool isOpenedByUser,
  }) async {
    try {
      final BuildContext appContext =
          await AppRouteNavigator.getAppContextWhenAvailable();
      if (!appContext.mounted) return;

      final userModel = appContext.read<AuthenticationBloc>().getUserModel;
      final bool isUser = userModel.role == UserRoleEnum.user;

      if (isUser) {
        injector<NotificationActionsUpdater>().refreshOmrahPage(
          notificationEntity.referenceOrderId,
        );
      } else if (notificationEntity.isProviderProofRejected && !isOpenedByUser) {
        //bring the provider to the rejected step while he is using the app,
        //a tapped notification is routed by ExternalForwardingHandler instead
        ProviderOmrahPage.openRejectedStep(
          appContext,
          orderId: notificationEntity.referenceOrderId,
          step: notificationEntity.ritualStep!,
          interruptUpload: false,
        );
      }
    } catch (e) {}
  }

  Future<String> _downloadAndSaveFile(String url) async {
    final String dirPath =
        await AppUtilsDirectoriesPaths.getNotificationThumbnailsDirPath();
    final File file = File(
      path.join(dirPath, DateTime.now().millisecondsSinceEpoch.toString()),
    );

    final http.Response response = await http.get(Uri.parse(url));
    await file.writeAsBytes(response.bodyBytes);
    return file.path;
  }

  /// Base ID for prayer time notifications.
  ///
  /// Each prayer gets its OWN id (`kPrayerNotificationBaseId + index`).
  /// Scheduling them all under a single id makes every call overwrite the
  /// previously pending alarm, so only the last prayer of the day (Isha)
  /// would ever fire.
  static const int kPrayerNotificationBaseId = 100;

  /// Upper bound on how many prayer notifications can be pending at once.
  /// Also defines the id range cleared by [cancelPrayerNotifications].
  static const int kPrayerNotificationSlots = 10;

  /// Guards against two overlapping scheduling runs (HomePage and
  /// PrayerTimesPage each create their own cubit and fetch on build).
  bool _isSchedulingPrayers = false;

  NotificationDetails _prayerNotificationDetails({Duration? autoDismissAfter}) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'prayer_times_channel',
        'Prayer Times',
        channelDescription: 'Notifications for daily prayer times',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        // Android dismisses the notification by itself once this window
        // elapses. Set to the gap until the next prayer, so e.g. the Maghrib
        // alert disappears exactly when the Isha alert arrives and the tray
        // never accumulates old prayers.
        timeoutAfter: autoDismissAfter?.inMilliseconds,
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        // iOS has no timeoutAfter equivalent; the thread id at least collapses
        // the prayer alerts into a single stack in Notification Center.
        threadIdentifier: 'prayer_times',
      ),
    );
  }

  /// Cancels every prayer slot — this clears both the pending alarms AND any
  /// prayer notification still sitting in the tray.
  Future<void> cancelPrayerNotifications() async {
    for (int i = 0; i < kPrayerNotificationSlots; i++) {
      await _localNotificationService.cancel(kPrayerNotificationBaseId + i);
    }
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    required String timezone,
    Duration? autoDismissAfter,
  }) async {
    tz.Location location;
    try {
      location = tz.getLocation(timezone);
    } catch (e) {
      log('⚠️ Unknown timezone "$timezone", falling back to device local: $e');
      location = tz.local;
    }

    final tz.TZDateTime now = tz.TZDateTime.now(location);
    tz.TZDateTime tzScheduledTime = tz.TZDateTime(
      location,
      scheduledTime.year,
      scheduledTime.month,
      scheduledTime.day,
      scheduledTime.hour,
      scheduledTime.minute,
    );

    // Already passed today → schedule the first occurrence tomorrow instead of
    // dropping the prayer entirely. It repeats daily from then on.
    if (!tzScheduledTime.isAfter(now)) {
      tzScheduledTime = tzScheduledTime.add(const Duration(days: 1));
    }

    Future<void> schedule(AndroidScheduleMode mode) {
      return _localNotificationService.zonedSchedule(
        id,
        title,
        body,
        tzScheduledTime,
        _prayerNotificationDetails(autoDismissAfter: autoDismissAfter),
        androidScheduleMode: mode,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }

    try {
      // alarmClock uses AlarmManager.setAlarmClock() — most reliable on Samsung/OEM devices
      await schedule(AndroidScheduleMode.alarmClock);
      log('✅ Prayer notification scheduled: [$id] $title @ $tzScheduledTime');
    } catch (e) {
      if (!e.toString().contains('exact_alarms_not_permitted')) {
        log('❌ Error scheduling notification [$title]: $e');
        return;
      }
      try {
        await schedule(AndroidScheduleMode.inexactAllowWhileIdle);
        log('✅ Prayer notification scheduled (inexact fallback): [$id] $title @ $tzScheduledTime');
      } catch (fallbackError) {
        log('❌ Error scheduling notification (fallback) [$title]: $fallbackError');
      }
    }
  }

  Future<void> schedulePrayerNotifications({
    required Map<String, DateTime> prayerTimes,
    required String timezone,
    String Function(String prayerName)? bodyBuilder,
  }) async {
    // Both HomePage and PrayerTimesPage fetch on build. Without this guard the
    // two runs interleave their cancel/schedule cycles and can leave the tray
    // holding two copies of the same prayer.
    if (_isSchedulingPrayers) {
      log('⏳ [Notification] Prayer scheduling already running, skipping this run');
      return;
    }
    _isSchedulingPrayers = true;

    try {
      // Clears stale alarms AND any prayer notification left in the tray,
      // including ids written by older builds of the app.
      await cancelPrayerNotifications();

      final entries = prayerTimes.entries
          .take(kPrayerNotificationSlots)
          .toList();

      if (prayerTimes.length > entries.length) {
        log('⚠️ [Notification] Only $kPrayerNotificationSlots slots available, '
            '${prayerTimes.length - entries.length} prayer(s) skipped');
      }

      for (int i = 0; i < entries.length; i++) {
        final entry = entries[i];

        // How long this alert stays in the tray: until the next prayer fires.
        // The last prayer wraps around to the first one of the next day.
        final DateTime nextTime = entries[(i + 1) % entries.length].value;
        Duration visibleFor = nextTime.difference(entry.value);
        if (visibleFor <= Duration.zero) {
          visibleFor += const Duration(days: 1);
        }
        // Leave a small margin so the old alert is gone before the new one
        // lands, rather than both being visible for a moment.
        visibleFor -= const Duration(seconds: 10);

        final body = bodyBuilder != null
            ? bodyBuilder(entry.key)
            : appLocalizer.prayerTimeAlert(entry.key);

        await scheduleNotification(
          id: kPrayerNotificationBaseId + i,
          title: entry.key,
          body: body,
          scheduledTime: entry.value,
          timezone: timezone,
          autoDismissAfter: visibleFor,
        );
      }
    } finally {
      _isSchedulingPrayers = false;
    }

    // Diagnostic: list what Android has pending
    final pending = await _localNotificationService
        .pendingNotificationRequests();
    log('🔍 [Notification] Pending after scheduling: ${pending.length} notifications');
    for (final p in pending) {
      log('🔍 [Notification]   → ID=${p.id} | title=${p.title}');
    }
  }

  //Notification Erasers
  void clearAllNotifications() {
    Eraser.clearAllAppNotifications();
    Eraser.resetBadgeCountAndRemoveNotificationsFromCenter();
  }
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) async {
  ExternalForwardingHandler.handleNotificationFromPayload(notificationResponse);
}
