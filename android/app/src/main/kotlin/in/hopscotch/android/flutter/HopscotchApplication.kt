package `in`.hopscotch.android.flutter

import android.app.Application
import android.app.NotificationManager
import android.content.pm.ApplicationInfo
import android.os.Build
import `in`.hopscotch.android.flutter.notification.NotificationChannels
import com.clevertap.android.pushtemplates.PushTemplateNotificationHandler
import com.clevertap.android.sdk.ActivityLifecycleCallback
import com.clevertap.android.sdk.CleverTapAPI
import com.clevertap.android.sdk.interfaces.NotificationHandler

class HopscotchApplication : Application() {
    override fun onCreate() {
        // Must run before super.onCreate() — without it CleverTap has no
        // reference to the current foreground Activity, so SDK calls that
        // need one (promptForPushNotification, in-app messages, deep link
        // tracking) silently no-op. Confirmed via the SDK's own startup log:
        // "Activity Lifecycle Callback not registered...".
        ActivityLifecycleCallback.register(this)
        super.onCreate()

        val isDebuggable = (applicationInfo.flags and ApplicationInfo.FLAG_DEBUGGABLE) != 0
        if (isDebuggable) {
            CleverTapAPI.setDebugLevel(CleverTapAPI.LogLevel.VERBOSE)
        }

        // Required for push templates (rating, five-icon, timer, carousel,
        // zero-bezel, input box, …) to render instead of the default layout.
        CleverTapAPI.setNotificationHandler(PushTemplateNotificationHandler() as NotificationHandler)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            NotificationChannels.all.forEach { (name, id) ->
                CleverTapAPI.createNotificationChannel(
                    this,
                    id,
                    name,
                    NotificationChannels.DESCRIPTION,
                    NotificationManager.IMPORTANCE_MAX,
                    true,
                )
            }
        }

        CleverTapAPI.getDefaultInstance(this)?.enableDeviceNetworkInfoReporting(true)
    }
}
