import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../plp/domain/entities/listing_product_entity.dart';

part 'tile_entity.freezed.dart';

/// One item in a PDP rail — recently-viewed or recommendations.
///
/// The wrapper exists for analytics. A rail tile carries **two** tracking blocks
/// with different roles, and merging them would destroy one:
///
/// * [trackingMeta] — the tile *as a click target*, holding the already-prefixed
///   `clicked_product_*` keys. This is what a rail-click event chains.
/// * [product] — the product's own identity, whose `trackingMeta` uses unprefixed
///   names (`product_id`, `product_name`). Merging that over the PDP's own block
///   would overwrite `product_id`, `price`, `gender` and the rest, erasing the
///   source PDP from its own event.
///
/// Role therefore comes from *which node* is chained, never from a key name — the
/// rule in `docs/analytics/pdp/contract/passthrough-spec.md`.
@freezed
abstract class TileEntity with _$TileEntity {
  const factory TileEntity({
    required ListingProductEntity product,

    /// `tiles[].trackingMeta` — the prefixed click block, forwarded whole.
    Map<String, dynamic>? trackingMeta,
  }) = _TileEntity;
}
