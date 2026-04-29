/// Base class for all analytics events
abstract class AnalyticsEvent {
  String get eventName;
  Map<String, dynamic>? get parameters;
}

/// App-level events
class AppOpenEvent extends AnalyticsEvent {
  @override
  String get eventName => 'app_open';

  @override
  Map<String, dynamic>? get parameters => null;
}

class AppCloseEvent extends AnalyticsEvent {
  @override
  String get eventName => 'app_close';

  @override
  Map<String, dynamic>? get parameters => null;
}
