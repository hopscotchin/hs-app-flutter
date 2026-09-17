import 'package:json_annotation/json_annotation.dart';

import '../../../../core/entities/visual_cue_entity.dart';
import '../../../../core/models/visual_cue_model.dart';
import '../../../../core/utils/json_parsers.dart';
import '../../../plp/data/models/media_item_model.dart';
import '../../../plp/data/models/product_price_model.dart';
import '../../../plp/domain/entities/listing_product_entity.dart';
import '../../../plp/domain/entities/wishlist_info_entity.dart';
import '../../domain/entities/wishlist_product_entity.dart';
import 'wishlist_sku_model.dart';

part 'wishlist_product_model.g.dart';

/// One entry in the wishlist listing `records[]`. Shares the PLP product
/// shape (media / priceInfo / visualCue) and carries `skus[]`, which drive
/// both the sold-out state and the size choices in the move-to-bag sheet.
///
/// `wishlistInfo` holds the membership `id` used to remove the item. The v2
/// response carries no `wishlistedSku`, so move-to-bag falls back to the
/// first available SKU (and the sheet when there is more than one).
@JsonSerializable(createToJson: false)
class WishlistProductModel {
  const WishlistProductModel({
    required this.productId,
    required this.name,
    this.hasSizeChart = false,
    this.media = const [],
    this.priceInfo,
    this.wishlistInfo,
    this.visualCue,
    this.trackingMeta,
    this.skus = const [],
  });

  /// Product id. The listing sends it as `id` (not `productId`).
  @JsonKey(name: 'id', fromJson: parseToInt)
  final int productId;
  @JsonKey(fromJson: parseToString)
  final String name;

  @JsonKey(fromJson: parseToBool)
  final bool hasSizeChart;

  @JsonKey(defaultValue: [])
  final List<MediaItemModel> media;

  final ProductPriceModel? priceInfo;

  @JsonKey(name: 'wishlistInfo')
  final Map<String, dynamic>? wishlistInfo;

  @JsonKey(name: 'visualCue')
  final Map<String, dynamic>? visualCue;

  final Map<String, dynamic>? trackingMeta;

  @JsonKey(defaultValue: [])
  final List<WishlistSkuModel> skus;

  factory WishlistProductModel.fromJson(Map<String, dynamic> json) =>
      _$WishlistProductModelFromJson(json);
}

extension WishlistProductModelX on WishlistProductModel {
  WishlistProductEntity toEntity() {
    final imageUrls = media
        .where((m) => m.isImage && (m.url?.isNotEmpty ?? false))
        .map((m) => m.url!)
        .toList(growable: false);

    final cue = (visualCue == null || visualCue!.isEmpty)
        ? null
        : VisualCueModel.fromJson(visualCue!);
    final cues = cue == null
        ? const <VisualCueEntity>[]
        : <VisualCueEntity>[cue];

    // First in-stock SKU (if any). Absence of an available SKU on a
    // non-empty list means the product is sold out.
    WishlistSkuModel? availableSku;
    for (final sku in skus) {
      if (sku.isAvailable) {
        availableSku = sku;
        break;
      }
    }
    final soldOut = skus.isNotEmpty && availableSku == null;

    final wl = wishlistInfo ?? const <String, dynamic>{};
    final wishlistedSku = parseToStringOrNull(wl['wishlistedSku']);
    final moveToBagSku = (wishlistedSku != null && wishlistedSku.isNotEmpty)
        ? wishlistedSku
        : (availableSku?.skuId ?? (skus.isNotEmpty ? skus.first.skuId : null));

    final brandName = trackingMeta == null
        ? null
        : parseToStringOrNull(trackingMeta!['brandName']);

    final product = ListingProductEntity(
      id: productId,
      name: name,
      brandName: brandName,
      // canWishlist is deliberately false: the wishlist tile shows a delete
      // action instead of the heart icon, so ProductTile must not render it.
      wishlistInfo: WishlistInfoEntity(
        id: parseToIntOrNull(wl['id']),
        isWishlisted: true,
        canWishlist: false,
      ),
      soldOut: soldOut,
      imageUrls: imageUrls,
      price: priceInfo?.toEntity(),
      visualCues: cues,
      trackingMeta: trackingMeta,
    );

    return WishlistProductEntity(
      product: product,
      moveToBagSku: moveToBagSku,
      wishlistedSku: wishlistedSku,
      hasSizeChart: hasSizeChart,
      skus: skus.map((s) => s.toEntity()).toList(growable: false),
    );
  }
}
