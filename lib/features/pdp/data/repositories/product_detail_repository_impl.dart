import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/mixins/safe_api_call.dart';
import '../../../../core/network/connectivity/network_info.dart';
import '../../domain/entities/add_to_cart_response_entity.dart';
import '../../domain/entities/pincode_check_entity.dart';
import '../../domain/entities/product_detail_entity.dart';
import '../../domain/entities/wishlist_response_entity.dart';
import '../../domain/repositories/product_detail_repository.dart';
import '../datasources/remote/pdp_remote_datasource.dart';

@LazySingleton(as: ProductDetailRepository)
class ProductDetailRepositoryImpl
    with SafeApiCall
    implements ProductDetailRepository {
  final PdpRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ProductDetailRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ProductDetailEntity>> getProductDetails(
    int productId,
  ) {
    return safeApiCall(
      networkInfo,
      () => remoteDataSource.getProductDetails(productId),
    );
  }

  @override
  Future<Either<Failure, AddToCartResponseEntity>> addToCart(
    String skuId,
    int quantity,
  ) {
    return safeApiCall(
      networkInfo,
      () => remoteDataSource.addToCart(skuId, quantity),
    );
  }

  @override
  Future<Either<Failure, AddToCartResponseEntity>> buyNow(
    String skuId,
    int quantity,
  ) {
    return safeApiCall(
      networkInfo,
      () => remoteDataSource.buyNow(skuId, quantity),
    );
  }

  @override
  Future<Either<Failure, WishlistResponseEntity>> addToWishlist(
    String productId,
    int price,
    String? skuId,
  ) {
    return safeApiCall(
      networkInfo,
      () => remoteDataSource.addToWishlist(productId, price, skuId),
    );
  }

  @override
  Future<Either<Failure, void>> removeFromWishlist(String wishlistId) {
    return safeApiCall(
      networkInfo,
      () => remoteDataSource.removeFromWishlist(wishlistId),
    );
  }

  @override
  Future<Either<Failure, PincodeCheckEntity>> verifyPincode(
    int productId,
    String pincode,
  ) {
    return safeApiCall(
      networkInfo,
      () => remoteDataSource.verifyPincode(productId, pincode),
    );
  }
}
