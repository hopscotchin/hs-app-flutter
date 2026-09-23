import CTNotificationService

/// `CTNotificationServiceExtension` downloads the rich media attached to a
/// CleverTap push and hands the enriched notification back to the system, so
/// the Notification Content Extension can render the template; no overrides
/// are required here.
class NotificationService: CTNotificationServiceExtension {
}
