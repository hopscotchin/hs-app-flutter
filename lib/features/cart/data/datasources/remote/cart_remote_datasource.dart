import '../../../../../core/network/api_client.dart';
import '../../../../../core/constants/api_constants.dart';
import '../../models/add_to_cart_response_model.dart';
import '../../models/cart_model.dart';
import 'package:injectable/injectable.dart';

abstract class CartRemoteDataSource {
  Future<AddToCartResponseModel> addToCart(String skuId, int quantity);
  Future<AddToCartResponseModel> buyNow(String skuId, int quantity);
  Future<CartModel> getCart();
  Future<CartModel> removeCartItem(String sku);
  Future<CartModel> updateCartItem(String sku, int quantity);
  Future<CartModel> moveToWishlist(String sku, {int? productId, int? price});
  Future<CartModel> applyPromoCode(String promoCode);
  Future<CartModel> removePromoCode(String promoCode);
  Future<CartModel> mergeCart();
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
    return AddToCartResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<AddToCartResponseModel> buyNow(String skuId, int quantity) async {
    final response = await apiClient.post(
      ApiConstants.buyNow,
      data: {'sku': skuId, 'quantity': '$quantity'},
    );
    return AddToCartResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<CartModel> getCart() async {
    final response = await apiClient.get(ApiConstants.shoppingCart);
    return CartModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<CartModel> removeCartItem(String sku) async {
    // TODO: implement applyPromoCode
    throw UnimplementedError();
  }

  @override
  Future<CartModel> updateCartItem(String sku, int quantity) async {
    // TODO: implement applyPromoCode
    throw UnimplementedError();
  }

  @override
  Future<CartModel> moveToWishlist(
    String sku, {
    int? productId,
    int? price,
  }) async {
    // TODO: implement applyPromoCode
    throw UnimplementedError();
  }

  @override
  Future<CartModel> applyPromoCode(String promoCode) {
    // TODO: implement applyPromoCode
    throw UnimplementedError();
  }

  @override
  Future<CartModel> mergeCart() {
    // TODO: implement mergeCart
    throw UnimplementedError();
  }

  @override
  Future<CartModel> removePromoCode(String promoCode) {
    // TODO: implement removePromoCode
    throw UnimplementedError();
  }

}
