import 'analytics_events.dart';

/// Splash screen events
class SplashScreenViewedEvent extends AnalyticsEvent {
  @override
  String get eventName => 'splash_screen_viewed';

  @override
  Map<String, dynamic>? get parameters => null;
}

class DeeplinkReceivedEvent extends AnalyticsEvent {
  final String deeplink;

  DeeplinkReceivedEvent({required this.deeplink});

  @override
  String get eventName => 'deeplink_received';

  @override
  Map<String, dynamic>? get parameters => {'deeplink': deeplink};
}
