import 'dart:developer';
import 'package:injectable/injectable.dart';

import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/models/action_response.dart';
import '../../models/add_to_cart_response_model.dart';
import '../../models/pincode_check_model.dart';
import '../../models/product_detail_model.dart';
import '../../models/wishlist_response_model.dart';

abstract class PdpRemoteDataSource {
  Future<ProductDetailModel> getProductDetails(int productId);
  Future<AddToCartResponseModel> addToCart(String skuId, int quantity);
  Future<AddToCartResponseModel> buyNow(String skuId, int quantity);
  Future<WishlistResponseModel> addToWishlist(
    String productId,
    int price,
    String? skuId,
  );
  Future<ActionResponse> removeFromWishlist(String wishlistId);
  Future<PincodeCheckModel> verifyPincode(int productId, String pincode);
}

@LazySingleton(as: PdpRemoteDataSource)
class PdpRemoteDataSourceImpl implements PdpRemoteDataSource {
  final ApiClient apiClient;

  PdpRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<ProductDetailModel> getProductDetails(int productId) async {
    final response = await apiClient.get(
      '${ApiConstants.productDetails}/$productId',
    );
    final json = response.data as Map<String, dynamic>;
    log('PDP API response keys: ${json.keys.toList()}', name: 'PDP');
    if (json.containsKey('product')) {
      final product = json['product'];
      if (product is Map<String, dynamic>) {
        log('Product keys: ${product.keys.toList()}', name: 'PDP');
      }
    }
    try {
      return ProductDetailModel.fromJson(json);
    } catch (e, s) {
      log('PDP parsing error: $e', name: 'PDP', error: e, stackTrace: s);
      rethrow;
    }
  }

  @override
  Future<AddToCartResponseModel> addToCart(String skuId, int quantity) async {
    final response = await apiClient.post(
      ApiConstants.addToCart,
      data: {'sku': skuId, 'quantity': '$quantity'},
    );
    final json = response.data as Map<String, dynamic>;
    return AddToCartResponseModel.fromJson(json);
  }

  @override
  Future<AddToCartResponseModel> buyNow(String skuId, int quantity) async {
    final response = await apiClient.post(
      ApiConstants.buyNow,
      data: {'sku': skuId, 'quantity': '$quantity'},
    );
    final json = response.data as Map<String, dynamic>;
    return AddToCartResponseModel.fromJson(json);
  }

  @override
  Future<WishlistResponseModel> addToWishlist(
    String productId,
    int price,
    String? skuId,
  ) async {
    final body = <String, dynamic>{'productId': productId, 'price': price};
    if (skuId != null) body['sku'] = skuId;

    final response = await apiClient.post(ApiConstants.wishlist, data: body);
    final json = response.data as Map<String, dynamic>;
    return WishlistResponseModel.fromJson(json);
  }

  @override
  Future<ActionResponse> removeFromWishlist(String wishlistId) async {
    final response = await apiClient.delete(
      '${ApiConstants.wishlist}/$wishlistId',
    );
    final json = response.data as Map<String, dynamic>;
    return _SimpleActionResponse.fromJson(json);
  }

  @override
  Future<PincodeCheckModel> verifyPincode(int productId, String pincode) async {
    final response = await apiClient.get(
      '${ApiConstants.productDetails}/$productId/edd',
      queryParameters: {'pincode': pincode},
    );
    final json = response.data as Map<String, dynamic>;
    return PincodeCheckModel.fromJson(json);
  }
}

/// Lightweight ActionResponse for endpoints that only return base fields.
class _SimpleActionResponse extends ActionResponse {
  _SimpleActionResponse.fromJson(super.json) : super.fromJson();

  @override
  List<Object?> get props => [action, message];
}
