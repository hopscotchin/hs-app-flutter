import 'analytics_events.dart';

/// Product Detail Page events
class PdpScreenViewedEvent extends AnalyticsEvent {
  final String productId;
  final String productName;
  final double price;

  PdpScreenViewedEvent({
    required this.productId,
    required this.productName,
    required this.price,
  });

  @override
  String get eventName => 'pdp_screen_viewed';

  @override
  Map<String, dynamic>? get parameters => {
    'product_id': productId,
    'product_name': productName,
    'price': price,
  };
}

class PdpAddToCartEvent extends AnalyticsEvent {
  final String productId;
  final String productName;
  final double price;
  final int quantity;

  PdpAddToCartEvent({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
  });

  @override
  String get eventName => 'pdp_add_to_cart';

  @override
  Map<String, dynamic>? get parameters => {
    'product_id': productId,
    'product_name': productName,
    'price': price,
    'quantity': quantity,
  };
}

class PdpAddToWishlistEvent extends AnalyticsEvent {
  final String productId;
  final String productName;

  PdpAddToWishlistEvent({required this.productId, required this.productName});

  @override
  String get eventName => 'pdp_add_to_wishlist';

  @override
  Map<String, dynamic>? get parameters => {
    'product_id': productId,
    'product_name': productName,
  };
}

class PdpShareEvent extends AnalyticsEvent {
  final String productId;
  final String shareMethod;

  PdpShareEvent({required this.productId, required this.shareMethod});

  @override
  String get eventName => 'pdp_share';

  @override
  Map<String, dynamic>? get parameters => {
    'product_id': productId,
    'share_method': shareMethod,
  };
}
