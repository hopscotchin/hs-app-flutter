import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/entities/visual_cue_entity.dart';
import 'cart_item_detail_entity.dart';
import 'cart_item_media_entity.dart';
import 'cart_item_price_info_entity.dart';
import 'cart_item_wishlist_info_entity.dart';

class CartItemEntity extends Equatable {
  final String? sku;
  final int? brandId;
  final String? brandName;
  final String? size;
  final int? productId;
  final CartItemWishlistInfoEntity? wishlistInfo;
  final int? shoppingCartItemId;
  final List<CartItemMediaEntity> media;
  final int? selectMaxValue;
  final CartItemPriceInfoEntity? priceInfo;
  final int? quantity;
  final String? productName;
  final bool isSoldOut;
  final bool isSizeSoldOut;
  final String? estimatedDelivery;
  final String? stockAvailabilityStatus;
  final String? stockAvailabilityStatusColor;
  final String? createdDate;
  final bool isSingleSize;
  final VisualCueEntity? visualCue;

  /// Dynamic, ordered detail rows — e.g. "Price dropped by ₹100", "Non
  /// returnable & non exchangeable" (with a tooltip action), "₹199 saved
  /// from BUY5 coupon". Replaces the old fixed `priceDropText`/
  /// `appliedPromo`/`itemMessageBar` fields, which only supported one row
  /// each in a fixed order.
  final List<CartItemDetailEntity> cartItemDetails;

  final String? categoryName;
  final String? crmProductName;
  final String? slug;

  /// Analytics-only metadata — sent verbatim to tracking, never parsed or
  /// rendered. Keep it as raw JSON rather than a typed entity so new backend
  /// fields flow straight to analytics without app changes.
  final Map<String, dynamic>? trackingMeta;

  const CartItemEntity({
    this.sku,
    this.brandId,
    this.brandName,
    this.size,
    this.productId,
    this.wishlistInfo,
    this.shoppingCartItemId,
    this.media = const [],
    this.selectMaxValue,
    this.priceInfo,
    this.quantity,
    this.productName,
    this.isSoldOut = false,
    this.isSizeSoldOut = false,
    this.estimatedDelivery,
    this.stockAvailabilityStatus,
    this.stockAvailabilityStatusColor,
    this.createdDate,
    this.isSingleSize = false,
    this.visualCue,
    this.cartItemDetails = const [],
    this.categoryName,
    this.crmProductName,
    this.slug,
    this.trackingMeta,
  });

  bool get isCompletelySoldOut => isSoldOut || isSizeSoldOut;

  /// First IMAGE-type media URL, falling back to the first media item of any
  /// type when none is explicitly tagged IMAGE.
  String? get imgSrc {
    if (media.isEmpty) return null;
    final image = media.where((m) => m.isImage).firstOrNull;
    return image?.url ?? media.first.url;
  }

  @override
  List<Object?> get props => [
    sku,
    brandId,
    brandName,
    size,
    productId,
    wishlistInfo,
    shoppingCartItemId,
    media,
    selectMaxValue,
    priceInfo,
    quantity,
    productName,
    isSoldOut,
    isSizeSoldOut,
    estimatedDelivery,
    stockAvailabilityStatus,
    stockAvailabilityStatusColor,
    createdDate,
    isSingleSize,
    visualCue,
    cartItemDetails,
    categoryName,
    crmProductName,
    slug,
    trackingMeta,
  ];
}
