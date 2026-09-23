import 'package:dio/dio.dart';

import '../../../../checkout/data/models/buy_now_model.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/constants/api_constants.dart';
import '../../models/add_to_cart_response_model.dart';
import '../../models/cart_model.dart';
import 'package:injectable/injectable.dart';

abstract class CartRemoteDataSource {
  Future<AddToCartResponseModel> addToCart(Map<String, Object?> body);
  Future<AddToCartResponseModel> buyNow(Map<String, Object?> body);

  /// [instantCheckout] scopes every cart call to the single buy-now item: the
  /// backend answers with just that line rather than the whole bag. Android
  /// sends the same `instantCheckout` flag from `CartViewModel.isFromBuyNow`.
  ///
  /// [dismiss] tells the backend the user closed a dismissible cart message
  /// bar, so it stops sending it — Android's `CartViewModel.isCartDismissible`.
  Future<CartModel> getCart({
    bool isMergeCall = false,
    bool instantCheckout = false,
    bool dismiss = false,
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
  Future<BuyNowModel> orderNow({CancelToken? cancelToken});
}

@LazySingleton(as: CartRemoteDataSource)
class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final ApiClient apiClient;

  CartRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<AddToCartResponseModel> addToCart(Map<String, Object?> body) async {
    final response = await apiClient.post(ApiConstants.addToCart, data: body);
    return AddToCartResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<AddToCartResponseModel> buyNow(Map<String, Object?> body) async {
    final response = await apiClient.post(ApiConstants.buyNow, data: body);
    return AddToCartResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<CartModel> getCart({
    bool isMergeCall = false,
    bool instantCheckout = false,
    bool dismiss = false,
    CancelToken? cancelToken,
  }) async {
    final response = await apiClient.get(
      ApiConstants.shoppingCart,
      queryParameters: {
        'isMergeCall': isMergeCall,
        'instantCheckout': instantCheckout,
        'dismiss': dismiss,
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
    return CartModel.fromJson(response.data as Map<String, dynamic>);
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
    return CartModel.fromJson(response.data as Map<String, dynamic>);
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
    final response = await apiClient.post(ApiConstants.mergeCart, cancelToken: cancelToken);
    return CartModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<BuyNowModel> orderNow({CancelToken? cancelToken}) async {
    final response = await apiClient.get(ApiConstants.orderNow, cancelToken: cancelToken);
    return BuyNowModel.fromJson(response.data as Map<String, dynamic>);
  }
}
