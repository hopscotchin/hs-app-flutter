import 'package:json_annotation/json_annotation.dart';

import '../../../plp/data/models/page_meta_model.dart';
import '../../domain/entities/wishlist_page_entity.dart';
import 'wishlist_product_model.dart';

part 'wishlist_page_response_model.g.dart';

/// Opaque analytics blob. Keys/values are owned by the backend (the Analytics
/// team drives them); the client never reads a key out of it — it only spreads
/// the map onto the `wishlist_viewed` payload. Anything non-map degrades to
/// empty rather than throwing.
Map<String, dynamic> _parseTrackingMeta(dynamic value) =>
    value is Map ? Map<String, dynamic>.from(value) : const <String, dynamic>{};

/// Network envelope for one page of the customer's wishlist.
///
/// Carries only success-path fields — error envelopes are detected and
/// thrown inside the network layer, then mapped to `Failure` by
/// `safeApiCall`, so this model assumes success.
@JsonSerializable(createToJson: false)
class WishlistPageResponseModel {
  const WishlistPageResponseModel({
    this.pageMeta,
    this.records = const [],
    this.trackingMeta = const <String, dynamic>{},
  });

  final PageMetaModel? pageMeta;

  @JsonKey(defaultValue: [])
  final List<WishlistProductModel> records;

  @JsonKey(fromJson: _parseTrackingMeta)
  final Map<String, dynamic> trackingMeta;

  factory WishlistPageResponseModel.fromJson(Map<String, dynamic> json) =>
      _$WishlistPageResponseModelFromJson(json);
}

extension WishlistPageResponseModelX on WishlistPageResponseModel {
  WishlistPageEntity toEntity() => WishlistPageEntity(
    totalRecords: pageMeta?.totalCount ?? records.length,
    hasNextPage: pageMeta?.hasNextPage ?? false,
    items: records.map((r) => r.toEntity()).toList(growable: false),
    trackingMeta: trackingMeta,
  );
}
