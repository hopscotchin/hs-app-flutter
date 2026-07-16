import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/mixins/safe_api_call.dart';
import '../../../../core/network/connectivity/network_info.dart';
import '../../domain/entities/add_to_cart_response_entity.dart';
import '../../domain/entities/cart_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/remote/cart_remote_datasource.dart';
import '../models/add_to_cart_response_model.dart';

@LazySingleton(as: CartRepository)
class CartRepositoryImpl with SafeApiCall implements CartRepository {
  final CartRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  CartRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, AddToCartResponseEntity>> addToCart(String skuId, int quantity) {
    return safeApiCall(networkInfo, () async => (await remoteDataSource.addToCart(skuId, quantity)).toEntity());
  }

  @override
  Future<Either<Failure, AddToCartResponseEntity>> buyNow(String skuId, int quantity) {
    return safeApiCall(networkInfo, () async => (await remoteDataSource.buyNow(skuId, quantity)).toEntity());
  }

  @override
  Future<Either<Failure, CartEntity>> getCart() {
    return safeApiCall(networkInfo, remoteDataSource.getCart);
  }

  @override
  Future<Either<Failure, CartEntity>> removeCartItem(String sku) {
    return safeApiCall(networkInfo, () => remoteDataSource.removeCartItem(sku));
  }

  @override
  Future<Either<Failure, CartEntity>> updateCartItem(String sku, int quantity) {
    return safeApiCall(
      networkInfo,
      () => remoteDataSource.updateCartItem(sku, quantity),
    );
  }

  @override
  Future<Either<Failure, CartEntity>> moveToWishlist(
    String sku, {
    int? productId,
    int? price,
  }) {
    return safeApiCall(
      networkInfo,
      () => remoteDataSource.moveToWishlist(
        sku,
        productId: productId,
        price: price,
      ),
    );
  }

  @override
  Future<Either<Failure, CartEntity>> applyPromoCode(String promoCode) {
    return safeApiCall(
      networkInfo,
      () => remoteDataSource.applyPromoCode(promoCode),
    );
  }

  @override
  Future<Either<Failure, CartEntity>> removePromoCode(String promoCode) {
    return safeApiCall(
      networkInfo,
      () => remoteDataSource.removePromoCode(promoCode),
    );
  }

  @override
  Future<Either<Failure, CartEntity>> mergeCart() {
    return safeApiCall(networkInfo, remoteDataSource.mergeCart);
  }
}
