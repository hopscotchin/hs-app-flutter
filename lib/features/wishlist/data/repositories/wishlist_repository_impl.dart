import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/mixins/safe_api_call.dart';
import '../../../../core/network/connectivity/network_info.dart';
import '../../domain/entities/move_to_cart_result_entity.dart';
import '../../domain/entities/wishlist_page_entity.dart';
import '../../domain/entities/wishlist_response_entity.dart';
import '../../domain/repositories/wishlist_repository.dart';
import '../datasources/remote/wishlist_listing_api.dart';
import '../datasources/remote/wishlist_remote_datasource.dart';
import '../models/move_to_cart_response_model.dart';
import '../models/remove_from_wishlist_response_model.dart';
import '../models/wishlist_page_response_model.dart';
import '../models/wishlist_response_model.dart';

@LazySingleton(as: WishlistRepository)
class WishlistRepositoryImpl with SafeApiCall implements WishlistRepository {
  final WishlistRemoteDataSource remoteDataSource;
  final WishlistListingApi listingApi;
  final NetworkInfo networkInfo;

  WishlistRepositoryImpl({
    required this.remoteDataSource,
    required this.listingApi,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, WishlistResponseEntity>> addToWishlist(
    String productId,
    int price,
    String? skuId,
  ) {
    return safeApiCall(
      networkInfo,
      () async => (await remoteDataSource.addToWishlist(
        productId,
        price,
        skuId,
      )).toEntity(),
    );
  }

  @override
  Future<Either<Failure, String?>> removeFromWishlist(String wishlistId) {
    return safeApiCall(
      networkInfo,
      () async =>
          (await remoteDataSource.removeFromWishlist(wishlistId)).message,
    );
  }

  @override
  Future<Either<Failure, MoveToCartResultEntity>> moveToCart({
    required String wishlistItemId,
    required String skuId,
    int quantity = 1,
  }) {
    return safeApiCall(
      networkInfo,
      () async => (await remoteDataSource.moveToCart(
        wishlistItemId: wishlistItemId,
        skuId: skuId,
        quantity: quantity,
      )).toEntity(),
    );
  }

  @override
  Future<Either<Failure, WishlistPageEntity>> getWishlist({
    required int pageNo,
    required int pageSize,
    CancelToken? cancelToken,
  }) {
    return safeApiCall(networkInfo, () async {
      final response = await listingApi.getWishlist(
        pageNo: pageNo,
        pageSize: pageSize,
        cancelToken: cancelToken,
      );
      return response.toEntity();
    });
  }
}
