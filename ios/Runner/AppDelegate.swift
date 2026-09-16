import Flutter
import UIKit
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    registerCleverTapPushTemplateCategory()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
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
