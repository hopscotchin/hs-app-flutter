import 'analytics_events.dart';

/// Home screen events
class HomeScreenViewedEvent extends AnalyticsEvent {
  @override
  String get eventName => 'home_screen_viewed';

  @override
  Map<String, dynamic>? get parameters => null;
}

class HomeBannerClickedEvent extends AnalyticsEvent {
  final String bannerId;
  final String bannerName;

  HomeBannerClickedEvent({required this.bannerId, required this.bannerName});

  @override
  String get eventName => 'home_banner_clicked';

  @override
  Map<String, dynamic>? get parameters => {
    'banner_id': bannerId,
    'banner_name': bannerName,
  };
}
