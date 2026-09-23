package `in`.hopscotch.android.flutter.notification

/**
 * Channel id/name pairs must match the native Android app's
 * (in.hopscotch.android:common CleverTapHelper) exactly — both apps share the
 * same CleverTap account, and campaigns already configured there target
 * these channel ids. `id` is what CleverTap registers as the Android
 * NotificationChannel id; `name` is the user-visible channel label.
 */
object NotificationChannels {
    const val DESCRIPTION = "Hopscotch"

    val all = listOf(
        "Account" to "Account & Orders",
        "Offers" to "Offers & Sales",
        "Recommendations" to "Recommendations",
        "Trends" to "Trends & Deals",
    )
}
