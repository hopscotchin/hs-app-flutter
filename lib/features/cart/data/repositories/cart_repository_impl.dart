import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/entities/message_bar_entity.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/logger/my_logger.dart';
import '../../../../core/mixins/safe_api_call.dart';
import '../../../../core/models/message_bar_model.dart';
import '../../../../core/network/connectivity/network_info.dart';
import '../../../../core/services/pref_manager.dart';
import '../../domain/entities/add_to_cart_response_entity.dart';
import '../../domain/entities/cart_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/remote/cart_remote_datasource.dart';
import '../models/add_to_cart_response_model.dart';

@LazySingleton(as: CartRepository)
class CartRepositoryImpl with SafeApiCall implements CartRepository {
  final CartRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final PrefManager prefManager;

  CartRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
    required this.prefManager,
  });

  @override
  Future<Either<Failure, AddToCartResponseEntity>> addToCart(String skuId, int quantity) {
    return safeApiCall(
      networkInfo,
      () => remoteDataSource.addToCart(skuId, quantity).then((m) => m.toEntity()),
    );
  }

  @override
  Future<Either<Failure, AddToCartResponseEntity>> buyNow(String skuId, int quantity) {
    return safeApiCall(
      networkInfo,
      () => remoteDataSource.buyNow(skuId, quantity).then((m) => m.toEntity()),
    );
  }

  @override
  Future<Either<Failure, CartEntity>> getCart({
    bool isMergeCall = false,
    CancelToken? cancelToken,
  }) {
    return safeApiCall(
      networkInfo,
      () => remoteDataSource.getCart(isMergeCall: isMergeCall, cancelToken: cancelToken),
    );
  }

  @override
  Future<Either<Failure, CartEntity>> removeCartItem(String sku, {CancelToken? cancelToken}) {
    return safeApiCall(
      networkInfo,
      () => remoteDataSource.removeCartItem(sku, cancelToken: cancelToken),
    );
  }

  @override
  Future<Either<Failure, CartEntity>> updateCartItem(
    String sku,
    int quantity, {
    CancelToken? cancelToken,
  }) {
    return safeApiCall(
      networkInfo,
      () => remoteDataSource.updateCartItem(sku, quantity, cancelToken: cancelToken),
    );
  }

  @override
  Future<Either<Failure, CartEntity>> moveToWishlist(
    String sku, {
    int? productId,
    int? price,
    CancelToken? cancelToken,
  }) {
    return safeApiCall(
      networkInfo,
      () => remoteDataSource.moveToWishlist(
        sku,
        productId: productId,
        price: price,
        cancelToken: cancelToken,
      ),
    );
  }

  @override
  Future<Either<Failure, CartEntity>> mergeCart({CancelToken? cancelToken}) {
    return safeApiCall(networkInfo, () => remoteDataSource.mergeCart(cancelToken: cancelToken));
  }

  @override
  Future<Either<Failure, List<MessageBarEntity>>> getStaticMessageBars() async {
    final raw = prefManager.cartMessageBars;
    if (raw == null || raw.isEmpty) return const Right([]);
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const Right([]);
      return Right(
        decoded
            .whereType<Map<String, dynamic>>()
            .map(MessageBarModel.fromJson)
            .toList(),
      );
    } catch (e, s) {
      // Written by the splash app-config sync; a malformed payload means the
      // cart simply shows no static bars rather than failing to load.
      logger.e('Malformed cached cart message bars', error: e, stackTrace: s);
      return const Left(CacheFailure(message: 'Invalid cached cart message bars'));
    }
  }
}
