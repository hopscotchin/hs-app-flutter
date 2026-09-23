import CleverTapSDK
import Flutter
import UIKit
import UserNotifications
import clevertap_plugin

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    registerCleverTapPushTemplateCategory()

    // Everything below must run *before* super, which is what triggers
    // `didInitializeImplicitFlutterEngine` and therefore plugin registration.
    //
    // Touching `CleverTapPlugin.sharedInstance()` here also brings up
    // `CleverTap.sharedInstance()` (the plugin's `init` wires its delegates to
    // it), so the SDK exists by the time APNs hands us a device token below —
    // which on a fresh install can land before any Dart code has run.
    CleverTapPlugin.sharedInstance().applicationDidLaunch(options: launchOptions)

    // Nobody sets this by default, so without it `userNotificationCenter(_:didReceive:…)`
    // below is dead code and CleverTap never learns a notification was tapped.
    //
    // Claiming it ahead of firebase_messaging is deliberate and safe: when that
    // plugin finds a delegate already set that conforms to `FlutterAppLifeCycleProvider`
    // (which `FlutterAppDelegate` does) it leaves it in place, and keeps
    // receiving both callbacks anyway — `FlutterAppDelegate` forwards them to
    // its `lifeCycleDelegate`, i.e. to every registered plugin.
    UNUserNotificationCenter.current().delegate = self

    // Ask APNs for a device token explicitly. Until now this happened only as a
    // side effect of firebase_messaging's auto-init, which quietly made
    // CleverTap's push token depend on Firebase configuring successfully. The
    // call is idempotent, so it is harmless if the plugin asks as well, and it
    // does not prompt anyone — iOS issues a device token whether or not
    // notification permission has been granted.
    application.registerForRemoteNotifications()

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  /// The CleverTap Flutter plugin has no `didRegisterForRemoteNotificationsWithDeviceToken`
  /// hook of its own, and the SDK is not auto-integrated here (that would mean a
  /// second swizzler alongside Firebase's), so the APNs token has to be handed
  /// over by hand. Without this the CleverTap dashboard has no iOS token for the
  /// device and cannot deliver anything to it at all.
  override func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    // Deliberately not wrapped in `#if DEBUG`: the Runner target never defines
    // `SWIFT_ACTIVE_COMPILATION_CONDITIONS = DEBUG` (only RunnerTests does), so
    // that guard is always false here and silently removes the code — which is
    // exactly what hid this token from us for a whole debugging session.
    //
    // The token CleverTap ends up holding is otherwise invisible from here, and
    // a stale one on the profile looks identical to a misconfigured dashboard.
    // Cross-check this hex against the device listed on the CleverTap profile.
    let hex = deviceToken.map { String(format: "%02x", $0) }.joined()
    NSLog("[CleverTap] APNs token: %@", hex)
    NSLog("[CleverTap] APNs token length: %d bytes (expected 32)", deviceToken.count)
    NSLog("[CleverTap] SDK instance available: %@", CleverTap.sharedInstance() != nil ? "YES" : "NO")
    CleverTap.sharedInstance()?.setPushToken(deviceToken)
    super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }

  /// Without this a failed registration is completely silent — the app simply
  /// never gets a token and CleverTap keeps whatever stale one it already had.
  override func application(
    _ application: UIApplication,
    didFailToRegisterForRemoteNotificationsWithError error: Error
  ) {
    NSLog("[CleverTap] APNs registration FAILED: %@", error.localizedDescription)
    super.application(application, didFailToRegisterForRemoteNotificationsWithError: error)
  }

  /// Notification tapped (including the push-template action buttons registered
  /// below). `handleNotificationWithData` records the click for attribution and
  /// fires `CleverTapPushNotificationDelegate`, which the plugin forwards to
  /// Dart's `setCleverTapPushClickedPayloadReceivedHandler` — that is what
  /// `DeepLinkService` listens on to route `wzrk_dl`.
  ///
  /// `completionHandler` is deliberately not called here — `super` forwards to
  /// the registered plugins and firebase_messaging always calls it, so invoking
  /// it here too would fire it twice.
  ///
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    CleverTap.sharedInstance()?.handleNotification(
      withData: response.notification.request.content.userInfo
    )
    super.userNotificationCenter(
      center,
      didReceive: response,
      withCompletionHandler: completionHandler
    )
  }

  /// Foreground presentation. Without this a push that arrives while the app is
  /// open is silently dropped: firebase_messaging owns the default and starts
  /// from `UNNotificationPresentationOptionNone`, adding alert/sound/badge only
  /// if Dart has called `setForegroundNotificationPresentationOptions`, which
  /// this app never does.
  ///
  /// `super` is deliberately not called here. It forwards to the registered
  /// plugins and firebase_messaging always invokes the completion handler, so
  /// letting both run would fire it twice. Nothing in this app consumes
  /// `Messaging#onMessage`, so bypassing that plugin costs us nothing — and
  /// routing through CleverTap's own helper means a campaign marked
  /// silent-in-foreground (`wzrk_sif`) is still honoured, while non-CleverTap
  /// notifications pass through with the defaults below unchanged.
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    CleverTap.handleWillPresent(
      notification,
      withDefaultOptions: [.banner, .list, .sound, .badge],
      completionHandler: completionHandler
    )
  }

  /// Registers the category CleverTapNotificationContent's Info.plist
  /// (UNNotificationExtensionCategory) expects, with the action buttons
  /// CleverTap's push template UI drives (e.g. carousel back/next, view in
  /// app). Required for the Notification Content Extension to be invoked.
  private func registerCleverTapPushTemplateCategory() {
    let back = UNNotificationAction(identifier: "action_1", title: "Back", options: [])
    let next = UNNotificationAction(identifier: "action_2", title: "Next", options: [])
    let viewInApp = UNNotificationAction(identifier: "action_3", title: "View In App", options: [])
    let category = UNNotificationCategory(
      identifier: "CTNotification",
      actions: [back, next, viewInApp],
      intentIdentifiers: [],
      options: []
    )
    UNUserNotificationCenter.current().setNotificationCategories([category])
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }
}
