import '../../domain/entities/wishlist_response_entity.dart';

class WishlistResponseModel extends WishlistResponseEntity {
  const WishlistResponseModel({super.wishlistItemId});

  /// The BFF returns `wishlistItemId` as a numeric value (e.g. `14938297`),
  /// not a string. A blunt `json['wishlistItemId'] as String?` throws a
  /// TypeError, which `safeApiCall` then surfaces as a generic Failure —
  /// the UI sees an API "success" in the network tab but the bloc gets a
  /// failure result, so the heart icon never flips. Stringify any num.
  WishlistResponseModel.fromJson(super.json)
    : super.fromJson(wishlistItemId: _readId(json['wishlistItemId']));

  static String? _readId(dynamic raw) {
    if (raw == null) return null;
    if (raw is String) return raw;
    if (raw is num) return raw.toString();
    return raw.toString();
  }
}
