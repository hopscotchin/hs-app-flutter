import 'package:dio/dio.dart';

import '../../../../../core/network/api_client.dart';
import '../../../../../core/constants/api_constants.dart';
import '../../models/add_to_cart_response_model.dart';
import '../../models/cart_model.dart';
import 'package:injectable/injectable.dart';

abstract class CartRemoteDataSource {
  Future<AddToCartResponseModel> addToCart(String skuId, int quantity);
  Future<AddToCartResponseModel> buyNow(String skuId, int quantity);
  Future<CartModel> getCart({bool isMergeCall = false, CancelToken? cancelToken});
  Future<CartModel> removeCartItem(String sku, {CancelToken? cancelToken});
  Future<CartModel> updateCartItem(String sku, int quantity, {CancelToken? cancelToken});
  Future<CartModel> moveToWishlist(
    String sku, {
    int? productId,
    int? price,
    CancelToken? cancelToken,
  });
  Future<CartModel> mergeCart({CancelToken? cancelToken});
}

@LazySingleton(as: CartRemoteDataSource)
class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final ApiClient apiClient;

  CartRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<AddToCartResponseModel> addToCart(String skuId, int quantity) async {
    final response = await apiClient.post(
      ApiConstants.addToCart,
      data: {'sku': skuId, 'quantity': '$quantity'},
    );
    return AddToCartResponseModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  @override
  Future<AddToCartResponseModel> buyNow(String skuId, int quantity) async {
    final response = await apiClient.post(
      ApiConstants.buyNow,
      data: {'sku': skuId, 'quantity': '$quantity'},
    );
    return AddToCartResponseModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  @override
  Future<CartModel> getCart({bool isMergeCall = false, CancelToken? cancelToken}) async {
    final response = await apiClient.get(
      ApiConstants.shoppingCart,
      queryParameters: {'isMergeCall': isMergeCall, 'instantCheckout': false},
      cancelToken: cancelToken,
    );
    // v6 returns the response in the app's native shape already.
    return CartModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<CartModel> removeCartItem(String sku, {CancelToken? cancelToken}) async {
    final response = await apiClient.delete(
      '${ApiConstants.removeFromCart}/$sku',
      queryParameters: {'instantCheckout': false},
      cancelToken: cancelToken,
    );
    return CartModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<CartModel> updateCartItem(
    String sku,
    int quantity, {
    CancelToken? cancelToken,
  }) async {
    final response = await apiClient.put(
      '${ApiConstants.updateCartItem}/$sku',
      queryParameters: {'instantCheckout': false},
      data: {'sku': sku, 'quantity': quantity},
      cancelToken: cancelToken,
    );
    return CartModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<CartModel> moveToWishlist(
    String sku, {
    int? productId,
    int? price,
    CancelToken? cancelToken,
  }) async {
    final response = await apiClient.put(
      ApiConstants.moveToWishlistFromCart,
      queryParameters: {'instantCheckout': false},
      data: {
        'sku': sku,
        if (productId != null) 'productId': productId,
        if (price != null) 'price': price,
      },
      cancelToken: cancelToken,
    );
    return CartModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<CartModel> mergeCart({CancelToken? cancelToken}) async {
    final response = await apiClient.post(
      ApiConstants.mergeCart,
      cancelToken: cancelToken,
    );
    return CartModel.fromJson(response.data as Map<String, dynamic>);
  }
}
