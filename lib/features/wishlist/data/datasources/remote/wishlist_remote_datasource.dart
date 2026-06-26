import 'package:injectable/injectable.dart';

import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/models/action_response.dart';
import '../../models/wishlist_response_model.dart';

abstract class WishlistRemoteDataSource {
  Future<WishlistResponseModel> addToWishlist(String productId, int price, String? skuId);
  Future<ActionResponse> removeFromWishlist(String wishlistId);
}

@LazySingleton(as: WishlistRemoteDataSource)
class WishlistRemoteDataSourceImpl implements WishlistRemoteDataSource {
  final ApiClient apiClient;

  WishlistRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<WishlistResponseModel> addToWishlist(String productId, int price, String? skuId) async {
    final body = <String, dynamic>{'productId': productId, 'price': price};
    if (skuId != null) body['sku'] = skuId;

    final response = await apiClient.post(ApiConstants.wishlist, data: body);
    final json = response.data as Map<String, dynamic>;
    return WishlistResponseModel.fromJson(json);
  }

  @override
  Future<ActionResponse> removeFromWishlist(String wishlistId) async {
    final response = await apiClient.delete('${ApiConstants.wishlist}/$wishlistId');
    final json = response.data as Map<String, dynamic>;
    return _SimpleActionResponse.fromJson(json);
  }
}

/// Lightweight ActionResponse for endpoints that only return base fields.
class _SimpleActionResponse extends ActionResponse {
  _SimpleActionResponse.fromJson(super.json) : super.fromJson();

  @override
  List<Object?> get props => [action, message];
}
