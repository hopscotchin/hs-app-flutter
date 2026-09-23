package `in`.hopscotch.android.flutter.notification

import com.clevertap.android.sdk.pushnotification.fcm.CTFcmMessageHandler
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage

/**
 * Forwards every FCM message to CleverTap alongside Flutter's own
 * `firebase_messaging` handling (both receive the same message
 * independently). `CTFcmMessageHandler` no-ops for payloads that aren't
 * CleverTap campaigns, so this is safe to call unconditionally.
 */
class FCMMessageListenerService : FirebaseMessagingService() {
    override fun onMessageReceived(message: RemoteMessage) {
        super.onMessageReceived(message)
        CTFcmMessageHandler().createNotification(applicationContext, message)
    }

    override fun onNewToken(token: String) {
        super.onNewToken(token)
        CTFcmMessageHandler().onNewToken(applicationContext, token)
    }
}
