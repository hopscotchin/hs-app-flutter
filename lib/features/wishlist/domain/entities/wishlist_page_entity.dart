import 'package:freezed_annotation/freezed_annotation.dart';

import 'wishlist_product_entity.dart';

part 'wishlist_page_entity.freezed.dart';

@freezed
abstract class WishlistPageEntity with _$WishlistPageEntity {
  const WishlistPageEntity._();

  const factory WishlistPageEntity({
    @Default(0) int totalRecords,
    @Default(false) bool hasNextPage,
    @Default(<WishlistProductEntity>[]) List<WishlistProductEntity> items,

    /// Opaque analytics blob from the response — spread onto `wishlist_viewed`
    /// verbatim. The backend owns every key; the client never reads one.
    @Default(<String, dynamic>{}) Map<String, dynamic> trackingMeta,
  }) = _WishlistPageEntity;

  bool get hasReachedEnd => !hasNextPage;

  WishlistPageEntity merge(WishlistPageEntity next) => WishlistPageEntity(
    totalRecords: next.totalRecords,
    hasNextPage: next.hasNextPage,
    items: [...items, ...next.items],
    // Page 1's blob is the one `wishlist_viewed` shipped with; keep it stable
    // across pagination so later reads describe the same screen entry.
    trackingMeta: trackingMeta,
  );

  /// Drop the product with [id] and decrement the running total. Used after a
  /// successful remove / move-to-bag so the tile disappears without a refetch.
  WishlistPageEntity removeById(int id) => copyWith(
    items: items.where((e) => e.product.id != id).toList(growable: false),
    totalRecords: totalRecords > 0 ? totalRecords - 1 : 0,
  );
}
