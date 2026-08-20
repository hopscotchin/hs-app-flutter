import '../../../../core/models/visual_cue_model.dart';
import '../../../../core/utils/json_parsers.dart';
import '../../domain/entities/cart_item_entity.dart';
import 'cart_item_detail_model.dart';
import 'cart_item_media_model.dart';
import 'cart_item_price_info_model.dart';
import 'cart_item_wishlist_info_model.dart';

class CartItemModel extends CartItemEntity {
  const CartItemModel({
    super.sku,
    super.brandId,
    super.brandName,
    super.size,
    super.productId,
    super.wishlistInfo,
    super.shoppingCartItemId,
    super.media,
    super.selectMaxValue,
    super.priceInfo,
    super.quantity,
    super.productName,
    super.isSoldOut,
    super.isSizeSoldOut,
    super.estimatedDelivery,
    super.stockAvailabilityStatus,
    super.stockAvailabilityStatusColor,
    super.createdDate,
    super.isSingleSize,
    super.visualCue,
    super.cartItemDetails,
    super.categoryName,
    super.crmProductName,
    super.slug,
    super.trackingMeta,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    final wishlistJson = json['wishlistInfo'] as Map<String, dynamic>?;
    final priceInfoJson = json['priceInfo'] as Map<String, dynamic>?;
    final visualCueJson = json['visualCue'] as Map<String, dynamic>?;

    return CartItemModel(
      sku: parseToStringOrNull(json['sku']),
      brandId: parseToIntOrNull(json['brandId']),
      brandName: parseToStringOrNull(json['brandName']),
      size: parseToStringOrNull(json['size']),
      productId: parseToIntOrNull(json['productId']),
      wishlistInfo: wishlistJson != null
          ? CartItemWishlistInfoModel.fromJson(wishlistJson)
          : null,
      shoppingCartItemId: parseToIntOrNull(json['shoppingCartItemId']),
      media: CartItemMediaModel.listFromJson(json['media'] as List<dynamic>?),
      selectMaxValue: parseToIntOrNull(json['selectMaxValue']),
      priceInfo: priceInfoJson != null
          ? CartItemPriceInfoModel.fromJson(priceInfoJson)
          : null,
      quantity: parseToIntOrNull(json['quantity']),
      productName: parseToStringOrNull(json['productName']),
      isSoldOut: parseToBool(json['isSoldOut']),
      isSizeSoldOut: parseToBool(json['isSizeSoldOut']),
      estimatedDelivery: parseToStringOrNull(json['estimatedDelivery']),
      stockAvailabilityStatus: parseToStringOrNull(
        json['stockAvailabilityStatus'],
      ),
      stockAvailabilityStatusColor: parseToStringOrNull(
        json['stockAvailabilityStatusColor'],
      ),
      createdDate: parseToStringOrNull(json['createdDate']),
      isSingleSize: parseToBool(json['isSingleSize']),
      visualCue: visualCueJson != null
          ? VisualCueModel.fromJson(visualCueJson)
          : null,
      cartItemDetails: CartItemDetailModel.listFromJson(
        json['cartItemDetails'] as List<dynamic>?,
      ),
      categoryName: parseToStringOrNull(json['categoryName']),
      crmProductName: parseToStringOrNull(json['crm_product_name']),
      slug: parseToStringOrNull(json['slug']),
      trackingMeta: json['trackingMeta'] as Map<String, dynamic>?,
    );
  }
}
