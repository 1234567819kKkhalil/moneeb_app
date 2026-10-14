import Foundation
import CoreLocation
import UIKit

/// Native iOS persistent location tracker for an active Umrah task.
///
/// Why native (not Flutter/geolocator): on iOS the Dart engine is suspended the
/// moment the app is backgrounded/terminated. The only way to keep delivering
/// location — and to be relaunched after the user swipes the app away — is a
/// native `CLLocationManager` with background updates + Significant Location
/// Change monitoring. Sending is also done natively (URLSession) so it works
/// even when no Flutter engine is running.
///
/// Limitation (Apple, not ours): after a full terminate/swipe-away iOS only
/// relaunches the app on *significant* movement (~hundreds of metres), not on
/// every metre. While the app is alive (foreground/background/locked) updates
/// follow `distanceFilter` and are continuous.
@objc class LocationTracker: NSObject, CLLocationManagerDelegate {

  @objc static let shared = LocationTracker()

  private let manager = CLLocationManager()

  // Persisted across termination so a cold relaunch can resume + keep sending.
  private let kActive = "lt_active"
  private let kOrderId = "lt_orderId"
  private let kBaseUrl = "lt_baseUrl"
  private let kAccessToken = "lt_accessToken"
  private let kRefreshToken = "lt_refreshToken"
  private let kExpiryMs = "lt_expiryMs"
  private let kNeedsLogout = "lt_needsLogout"

  private var defaults: UserDefaults { UserDefaults.standard }
  private var isRefreshing = false

  override init() {
    super.init()
    manager.delegate = self
    manager.desiredAccuracy = kCLLocationAccuracyBest
    manager.distanceFilter = 10 // metres — "send whenever he moves"
    manager.pausesLocationUpdatesAutomatically = false
    manager.allowsBackgroundLocationUpdates = true
    manager.activityType = .fitness
    if #available(iOS 11.0, *) {
      manager.showsBackgroundLocationIndicator = true
    }
  }

  // MARK: - Public control (called from Flutter via MethodChannel)

  @objc func start(orderId: String,
                   baseUrl: String,
                   accessToken: String,
                   refreshToken: String,
                   expiryMs: Double) {
    defaults.set(true, forKey: kActive)
    defaults.set(orderId, forKey: kOrderId)
    defaults.set(normalizedBaseUrl(baseUrl), forKey: kBaseUrl)
    defaults.set(accessToken, forKey: kAccessToken)
    defaults.set(refreshToken, forKey: kRefreshToken)
    defaults.set(expiryMs, forKey: kExpiryMs)
    defaults.set(false, forKey: kNeedsLogout)

    manager.requestAlwaysAuthorization()
    manager.startUpdatingLocation()
    manager.startMonitoringSignificantLocationChanges()
  }

  @objc func stop() {
    defaults.set(false, forKey: kActive)
    defaults.removeObject(forKey: kOrderId)
    manager.stopUpdatingLocation()
    manager.stopMonitoringSignificantLocationChanges()
  }

  /// Called from AppDelegate on every launch (including a cold relaunch
  /// triggered by a Significant Location Change after the app was killed).
  @objc func resumeIfActive() {
    guard defaults.bool(forKey: kActive) else { return }
    manager.startUpdatingLocation()
    manager.startMonitoringSignificantLocationChanges()
  }

  /// Keep the native token copy in sync with the Dart token manager while the
  /// app is alive, so native sends/refreshes use the freshest credentials.
  @objc func updateToken(accessToken: String, refreshToken: String, expiryMs: Double) {
    defaults.set(accessToken, forKey: kAccessToken)
    defaults.set(refreshToken, forKey: kRefreshToken)
    defaults.set(expiryMs, forKey: kExpiryMs)
  }

  /// Latest native-held token, so Dart can adopt it on launch (it may be newer
  /// than Dart's copy if native refreshed while the app was terminated).
  @objc func currentToken() -> [String: Any] {
    return [
      "accessToken": defaults.string(forKey: kAccessToken) ?? "",
      "refreshToken": defaults.string(forKey: kRefreshToken) ?? "",
      "expiryMs": defaults.double(forKey: kExpiryMs),
      "active": defaults.bool(forKey: kActive),
    ]
  }

  /// Reads + clears the "server returned 401" flag so Dart can log the user out.
  @objc func consumeLogoutFlag() -> Bool {
    let needs = defaults.bool(forKey: kNeedsLogout)
    if needs { defaults.set(false, forKey: kNeedsLogout) }
    return needs
  }

  // MARK: - CLLocationManagerDelegate

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard defaults.bool(forKey: kActive), let loc = locations.last else { return }
    sendLocation(loc)
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    NSLog("[LocationTracker] didFailWithError: \(error.localizedDescription)")
  }

  // MARK: - Networking

  private func sendLocation(_ loc: CLLocation) {
    guard let orderId = defaults.string(forKey: kOrderId),
          let baseUrl = defaults.string(forKey: kBaseUrl),
          let url = URL(string: "\(baseUrl)tracking/\(orderId)/location") else { return }

    // Buy time to finish the request if we're in the background.
    var bgTask = UIBackgroundTaskIdentifier.invalid
    bgTask = UIApplication.shared.beginBackgroundTask {
      UIApplication.shared.endBackgroundTask(bgTask)
      bgTask = .invalid
    }
    let endBg = {
      if bgTask != .invalid {
        UIApplication.shared.endBackgroundTask(bgTask)
        bgTask = .invalid
      }
    }

    ensureValidToken { [weak self] token in
      guard let self = self, let token = token else { endBg(); return }

      var req = URLRequest(url: url)
      req.httpMethod = "POST"
      req.setValue("application/json", forHTTPHeaderField: "Content-Type")
      req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
      let body: [String: Any] = [
        "lat": loc.coordinate.latitude,
        "lng": loc.coordinate.longitude,
        "isBackgroundUpdate": true,
      ]
      req.httpBody = try? JSONSerialization.data(withJSONObject: body)

      URLSession.shared.dataTask(with: req) { _, resp, _ in
        if let http = resp as? HTTPURLResponse, http.statusCode == 401 {
          self.handleUnauthorized()
        }
        endBg()
      }.resume()
    }
  }

  /// Proactively refreshes the access token before it expires (mirrors the
  /// Dart `IsolatedTokenManager` logic). Refresh response shape:
  /// `{ "data": { "accessToken", "refreshToken", "expiresIn" } }`.
  private func ensureValidToken(_ completion: @escaping (String?) -> Void) {
    let expiry = defaults.double(forKey: kExpiryMs)
    let nowMs = Date().timeIntervalSince1970 * 1000
    if nowMs < expiry - 30_000 { // 30s safety buffer
      completion(defaults.string(forKey: kAccessToken))
      return
    }

    guard !isRefreshing,
          let baseUrl = defaults.string(forKey: kBaseUrl),
          let refresh = defaults.string(forKey: kRefreshToken),
          let url = URL(string: "\(baseUrl)auth/refresh") else {
      completion(defaults.string(forKey: kAccessToken))
      return
    }
    isRefreshing = true

    var req = URLRequest(url: url)
    req.httpMethod = "POST"
    req.setValue("application/json", forHTTPHeaderField: "Content-Type")
    req.httpBody = try? JSONSerialization.data(withJSONObject: ["refreshToken": refresh])

    URLSession.shared.dataTask(with: req) { [weak self] data, resp, _ in
      guard let self = self else { completion(nil); return }
      self.isRefreshing = false

      if let http = resp as? HTTPURLResponse, http.statusCode == 401 {
        self.handleUnauthorized()
        completion(nil)
        return
      }
      guard let data = data,
            let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
            let d = json["data"] as? [String: Any],
            let at = d["accessToken"] as? String, !at.isEmpty else {
        completion(self.defaults.string(forKey: self.kAccessToken))
        return
      }
      let rt = (d["refreshToken"] as? String) ?? refresh
      let expiresIn = (d["expiresIn"] as? Double) ?? 5
      let newExpiry = (Date().timeIntervalSince1970 + expiresIn) * 1000
      self.updateToken(accessToken: at, refreshToken: rt, expiryMs: newExpiry)
      completion(at)
    }.resume()
  }

  private func handleUnauthorized() {
    defaults.set(false, forKey: kActive)
    defaults.set(true, forKey: kNeedsLogout)
    defaults.removeObject(forKey: kAccessToken)
    manager.stopUpdatingLocation()
    manager.stopMonitoringSignificantLocationChanges()
  }

  // MARK: - Helpers

  private func normalizedBaseUrl(_ url: String) -> String {
    return url.hasSuffix("/") ? url : url + "/"
  }
}
