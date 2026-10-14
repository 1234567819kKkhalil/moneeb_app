part of fire_base;

class FirebaseHelper {
  static FirebaseMessaging? _firebaseMessaging;
  static String bgIsolateName = "bgNotificationIsolate";

  static Future<void> init() async {
    await initApp();
    await initMessaging();
  }

  /// Fast part: makes Firebase itself usable.
  static Future<void> initApp() => _initializeFirebaseApp();

  /// Slow part: it may wait for the user to answer the notification
  /// permission dialog, so never block the first screen on it.
  static Future<void> initMessaging() async {
    await Future.wait([
      _initCloudMessaging(),
      // _initializeRemoteConfig(),
    ]);
  }

  /// To Initialize Firebase
  static Future<void> _initializeFirebaseApp() async {
    try{
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    } catch (e) {
      debugPrint("Error Initializing Cloud Messaging or Firebase: ${e.toString()}");
    }
  }


  static Future<void> _initCloudMessaging() async {
    if (_firebaseMessaging != null) return;

    _firebaseMessaging = FirebaseMessaging.instance;

    final settings = await requestNotificationPermissions();
    if (settings.authorizationStatus != AuthorizationStatus.denied) {
      await LocalNotificationService.instance.initialize();
      await _enableForegroundNotifications();
      setUpNotificationListener();
    }
  }

  /// To Initialize Firebase Remote Config
  // static Future<void> _initializeRemoteConfig() async {
  //   try {
  //     await FirebaseRemoteConfigManager.instance.initializeRemoteConfig();
  //   } catch (e) {
  //     Logger().e("FIREBASE REMOTE CONFIG", error: e);
  //   }
  // }

  static Future<void> _enableForegroundNotifications() async {
    await Future.wait([
      _iosForegroundSetup(),
      _androidForegroundSetup(),
    ]);
  }

  static Future<void> _androidForegroundSetup() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
    );

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

  }

  static Future<void> _iosForegroundSetup() async {
    await _firebaseMessaging?.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  static Future<NotificationSettings> getNotificationSettings() async {
    return await FirebaseMessaging.instance.getNotificationSettings();
  }

  /// To Request Notification Permissions (For IOS)
  static Future<NotificationSettings> requestNotificationPermissions() async {
    return await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );
  }

  /// Routes a system notification the app was opened from. Only the provider's
  /// rejected proof is routed from here for now.
  static void _routeOpenedNotification(RemoteMessage message) {
    final notificationEntity = ReceivedNotificationEntity.fromJson(message.data);

    if (notificationEntity.isProviderProofRejected) {
      ExternalForwardingHandler.handleNotificationFromEntity(notificationEntity);
    }
  }

  static Future<void> setUpNotificationListener() async {
    final message = await FirebaseMessaging.instance.getInitialMessage();

    if (message != null) {
      LocalNotificationService.instance.showNotification(message, isOpenedByUser: true);
      _routeOpenedNotification(message);
    }

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) {
      log(
        'Received On Background Message On Open App: ${message.toString()}',
        name: "Firebase Messaging Notification",
      );

      if (message != null) {
        LocalNotificationService.instance.showNotification(message, isOpenedByUser: true);
        _routeOpenedNotification(message);
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      log('Received On Foreground Message: ${message.toString()}', name: "Firebase Messaging Notification");

      if (message != null) {
        LocalNotificationService.instance.showNotification(message,);
      }
    });

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    if(kDebugMode){
      try{
        print("FCM TOKEN: ${await FirebaseMessaging.instance.getToken()}");
      } catch(e){}
    }
  }

  //Communicate with firebaseMessagingBackgroundHandler
  static void setupBgNotfIsolateServer() {
    ReceivePort port = ReceivePort();
    IsolateNameServer.registerPortWithName(port.sendPort, bgIsolateName);

    //to update notification counts in the UI, because if the app is in background, the notification will be received in FirebaseBackgroundHandler that opens another service to manage notifications,
    //so in order to communicate with this service, we initialized this listener
    port.listen((msg) {
      log("MESSAGE FROM PORT $msg");

      if (msg is Map<String, dynamic>) {
        LocalNotificationService.instance.notifyNotificationsUpdated(addCount: -1, reset: false);
      }
    });
  }

  static void removeBgNotfIsolateServer(){
    IsolateNameServer.removePortNameMapping(bgIsolateName);
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log("Received On BACKGROUND: ${message.toString()}");

  await FirebaseHelper.init();

  //Notify the ui about the notification received from background
  IsolateNameServer.lookupPortByName(FirebaseHelper.bgIsolateName)?.send(message.data);

  try {
    await LocalNotificationService.instance.showNotification(message, isFromBackground: true);
  } catch (e) {
    logDebug(e.toString());
  }
}