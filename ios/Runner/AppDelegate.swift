import Flutter
import UIKit
import GoogleMaps
import flutter_local_notifications

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {

  private let locationChannelName = "com.linkcom.moneeb/location_tracker"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyB9CxNuxdChphIsStU5xFnA5fIxebFUnC8")

    UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate

    setupLocationChannel()

    // If the app was cold-launched in the background by a Significant Location
    // Change (i.e. it had been terminated/swiped away during an active Umrah
    // task), resume tracking + sending immediately.
    LocationTracker.shared.resumeIfActive()

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func setupLocationChannel(retries: Int = 12) {
    // This app uses a UISceneDelegate (FlutterSceneDelegate), so the
    // FlutterViewController / rootViewController may not be attached yet at
    // didFinishLaunching. Retry briefly until it is available.
    guard let controller = window?.rootViewController as? FlutterViewController else {
      if retries > 0 {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
          self?.setupLocationChannel(retries: retries - 1)
        }
      } else {
        NSLog("[LocationTracker] Could not obtain FlutterViewController for channel.")
      }
      return
    }
    let channel = FlutterMethodChannel(name: locationChannelName,
                                       binaryMessenger: controller.binaryMessenger)
    channel.setMethodCallHandler { (call, result) in
      let args = call.arguments as? [String: Any] ?? [:]
      switch call.method {
      case "start":
        LocationTracker.shared.start(
          orderId: args["orderId"] as? String ?? "",
          baseUrl: args["baseUrl"] as? String ?? "",
          accessToken: args["accessToken"] as? String ?? "",
          refreshToken: args["refreshToken"] as? String ?? "",
          expiryMs: (args["expiryMs"] as? NSNumber)?.doubleValue ?? 0)
        result(true)
      case "stop":
        LocationTracker.shared.stop()
        result(true)
      case "updateToken":
        LocationTracker.shared.updateToken(
          accessToken: args["accessToken"] as? String ?? "",
          refreshToken: args["refreshToken"] as? String ?? "",
          expiryMs: (args["expiryMs"] as? NSNumber)?.doubleValue ?? 0)
        result(true)
      case "currentToken":
        result(LocationTracker.shared.currentToken())
      case "consumeLogoutFlag":
        result(LocationTracker.shared.consumeLogoutFlag())
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
      GeneratedPluginRegistrant.register(with: registry)
    }
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }

@available(iOS 12.0, *)
  override func userNotificationCenter(
      _ center: UNUserNotificationCenter,
      openSettingsFor notification: UNNotification?
  ) {
      let controller = window?.rootViewController as! FlutterViewController
      let channel = FlutterMethodChannel(
          name: "com.example.flutter_local_notifications_example/settings",
          binaryMessenger: controller.binaryMessenger)

      channel.invokeMethod("showNotificationSettings", arguments: nil)
  }
}
