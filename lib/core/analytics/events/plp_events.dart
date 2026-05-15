import 'analytics_events.dart';

/// Product Listing Page events
class PlpScreenViewedEvent extends AnalyticsEvent {
  final String categoryId;
  final String categoryName;

  PlpScreenViewedEvent({required this.categoryId, required this.categoryName});

  @override
  String get eventName => 'plp_screen_viewed';

  @override
  Map<String, dynamic>? get parameters => {
    'category_id': categoryId,
    'category_name': categoryName,
  };
}

class PlpProductClickedEvent extends AnalyticsEvent {
  final String productId;
  final String productName;
  final int position;

  PlpProductClickedEvent({
    required this.productId,
    required this.productName,
    required this.position,
  });

  @override
  String get eventName => 'plp_product_clicked';

  @override
  Map<String, dynamic>? get parameters => {
    'product_id': productId,
    'product_name': productName,
    'position': position,
  };
}

class PlpFilterAppliedEvent extends AnalyticsEvent {
  final Map<String, dynamic> filters;

  PlpFilterAppliedEvent({required this.filters});

  @override
  String get eventName => 'plp_filter_applied';

  @override
  Map<String, dynamic>? get parameters => {'filters': filters};
}

class PlpSortAppliedEvent extends AnalyticsEvent {
  final String sortOption;

  PlpSortAppliedEvent({required this.sortOption});

  @override
  String get eventName => 'plp_sort_applied';

  @override
  Map<String, dynamic>? get parameters => {'sort_option': sortOption};
}
