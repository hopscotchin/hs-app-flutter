import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/models/action_response.dart';
import '../../models/add_to_cart_response_model.dart';
import '../../models/cart_model.dart';

abstract class CartRemoteDataSource {
  Future<AddToCartResponseModel> addToCart(String skuId, int quantity);
  Future<AddToCartResponseModel> buyNow(String skuId, int quantity);

  /// [instantCheckout] scopes every cart call to the single buy-now item: the
  /// backend answers with just that line rather than the whole bag. Android
  /// sends the same `instantCheckout` flag from `CartViewModel.isFromBuyNow`.
  Future<CartModel> getCart({
    bool isMergeCall = false,
    bool instantCheckout = false,
    CancelToken? cancelToken,
  });
  Future<CartModel> removeCartItem(
    String sku, {
    bool instantCheckout = false,
    CancelToken? cancelToken,
  });
  Future<CartModel> updateCartItem(
    String sku,
    int quantity, {
    bool instantCheckout = false,
    CancelToken? cancelToken,
  });
  Future<CartModel> moveToWishlist(
    String sku, {
    int? productId,
    int? price,
    bool instantCheckout = false,
    CancelToken? cancelToken,
  });
  Future<CartModel> mergeCart({CancelToken? cancelToken});
}

@LazySingleton(as: CartRemoteDataSource)
class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final ApiClient apiClient;

  CartRemoteDataSourceImpl({required this.apiClient});

  /// The cart BFF answers HTTP 200 even when it rejects a mutation, signalling
  /// it only with `action: "failure"` plus a `message`/`messageBars` and no
  /// `cartItems` (e.g. "Cart limit of 100 items exceeded!"). Parsing that
  /// straight into a [CartModel] yields an EMPTY, apparently-successful cart —
  /// so every mutation runs the body through [ActionResponse.validate] first,
  /// which raises `ApiFailureException` and lands on `SafeApiCall`'s
  /// `ApiFailure` branch with the message bars attached.
  Map<String, dynamic> _validated(Object? data) =>
      // ignore: deprecated_member_use_from_same_package
      ActionResponse.validate(data as Map<String, dynamic>);

  @override
  Future<AddToCartResponseModel> addToCart(String skuId, int quantity) async {
    final response = await apiClient.post(
      ApiConstants.addToCart,
      data: {'sku': skuId, 'quantity': '$quantity'},
    );
    return AddToCartResponseModel.fromJson(_validated(response.data));
  }

  @override
  Future<AddToCartResponseModel> buyNow(String skuId, int quantity) async {
    final response = await apiClient.post(
      ApiConstants.buyNow,
      data: {'sku': skuId, 'quantity': '$quantity'},
    );
    return AddToCartResponseModel.fromJson(_validated(response.data));
  }

  @override
  Future<CartModel> getCart({
    bool isMergeCall = false,
    bool instantCheckout = false,
    CancelToken? cancelToken,
  }) async {
    final response = await apiClient.get(
      ApiConstants.shoppingCart,
      queryParameters: {
        'isMergeCall': isMergeCall,
        'instantCheckout': instantCheckout,
      },
      cancelToken: cancelToken,
    );
    // v6 returns the response in the app's native shape already.
    return CartModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<CartModel> removeCartItem(
    String sku, {
    bool instantCheckout = false,
    CancelToken? cancelToken,
  }) async {
    final response = await apiClient.delete(
      '${ApiConstants.removeFromCart}/$sku',
      queryParameters: {'instantCheckout': instantCheckout},
      cancelToken: cancelToken,
    );
    return CartModel.fromJson(_validated(response.data));
  }

  @override
  Future<CartModel> updateCartItem(
    String sku,
    int quantity, {
    bool instantCheckout = false,
    CancelToken? cancelToken,
  }) async {
    final response = await apiClient.put(
      '${ApiConstants.updateCartItem}/$sku',
      queryParameters: {'instantCheckout': instantCheckout},
      data: {'sku': sku, 'quantity': quantity},
      cancelToken: cancelToken,
    );
    return CartModel.fromJson(_validated(response.data));
  }

  @override
  Future<CartModel> moveToWishlist(
    String sku, {
    int? productId,
    int? price,
    bool instantCheckout = false,
    CancelToken? cancelToken,
  }) async {
    final response = await apiClient.put(
      ApiConstants.moveToWishlistFromCart,
      queryParameters: {'instantCheckout': instantCheckout},
      data: {'sku': sku, 'productId': ?productId, 'price': ?price},
      cancelToken: cancelToken,
    );
    return CartModel.fromJson(_validated(response.data));
  }

  @override
  Future<CartModel> mergeCart({CancelToken? cancelToken}) async {
    final response = await apiClient.post(
      ApiConstants.mergeCart,
      cancelToken: cancelToken,
    );
    return CartModel.fromJson(_validated(response.data));
  }
}
