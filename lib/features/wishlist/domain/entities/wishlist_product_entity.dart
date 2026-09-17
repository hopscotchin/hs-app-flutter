import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../pdp/domain/entities/sku_entity.dart';
import '../../../plp/domain/entities/listing_product_entity.dart';
import '../../../plp/domain/entities/wishlist_info_entity.dart';

part 'wishlist_product_entity.freezed.dart';

/// A single wishlist listing tile.
///
/// Wraps the shared [ListingProductEntity] (used for display: image, name,
/// price, sold-out scrim, visual cues) and adds the SKU used when moving the
/// item to the bag, plus the item's SKUs for the size-selection sheet.
@freezed
abstract class WishlistProductEntity with _$WishlistProductEntity {
  const factory WishlistProductEntity({
    required ListingProductEntity product,
    String? moveToBagSku,

    /// The size the user wishlisted, when the response carries one. Unlike
    /// [moveToBagSku] this is never a fallback — it is null when the API sent
    /// no `wishlistInfo.wishlistedSku`.
    String? wishlistedSku,
    @Default(false) bool hasSizeChart,
    @Default(<SkuEntity>[]) List<SkuEntity> skus,
  }) = _WishlistProductEntity;
}

extension WishlistProductEntityX on WishlistProductEntity {
  int get id => product.id;
  bool get isSoldOut => product.soldOut;

  /// The wishlist membership id used to remove the item. Null when the API
  /// did not supply a usable id.
  String? get wishlistId => product.wishlistInfo.wishlistId;

  /// Move-to-bag is possible only for an in-stock item that carries a SKU.
  bool get canMoveToBag =>
      !product.soldOut && (moveToBagSku?.isNotEmpty ?? false);

  /// SKUs the user can actually pick in the size sheet.
  List<SkuEntity> get selectableSkus =>
      skus.where((s) => s.enable == true && s.skuId != null).toList();

  /// Size the sheet opens on: the wishlisted one, but only when it is still
  /// among the selectable SKUs. A sold-out or missing wishlisted size leaves
  /// the sheet unpicked, like the PDP.
  String? get preselectedSkuId {
    final wishlisted = wishlistedSku;
    if (wishlisted == null || wishlisted.isEmpty) return null;
    for (final sku in selectableSkus) {
      if (sku.skuId == wishlisted) return wishlisted;
    }
    return null;
  }

  /// Move-to-bag always confirms the size through the sheet, so the user can
  /// see the size chart and the picked size's price/EDD before committing —
  /// even when only one SKU is available.
  bool get needsSizeSelection => selectableSkus.isNotEmpty;
}
