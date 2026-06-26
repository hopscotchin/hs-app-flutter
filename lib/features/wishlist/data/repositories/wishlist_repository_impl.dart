import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/mixins/safe_api_call.dart';
import '../../../../core/network/connectivity/network_info.dart';
import '../../domain/entities/wishlist_response_entity.dart';
import '../../domain/repositories/wishlist_repository.dart';
import '../datasources/remote/wishlist_remote_datasource.dart';

@LazySingleton(as: WishlistRepository)
class WishlistRepositoryImpl with SafeApiCall implements WishlistRepository {
  final WishlistRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  WishlistRepositoryImpl({required this.remoteDataSource, required this.networkInfo});

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
    return safeApiCall(networkInfo, () => remoteDataSource.removeFromWishlist(wishlistId));
  }
}
