import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/mixins/safe_api_call.dart';
import '../../../../core/network/connectivity/network_info.dart';
import '../../domain/entities/promo_action_result_entity.dart';
import '../../domain/entities/promo_details_entity.dart';
import '../../domain/entities/promo_offers_entity.dart';
import '../../domain/entities/promo_offers_source.dart';
import '../../domain/repositories/promos_offers_repository.dart';
import '../datasources/remote/promos_offers_api.dart';
import '../models/promo_action_response_model.dart';
import '../models/promo_apply_request_model.dart';
import '../models/promo_details_response_model.dart';
import '../models/promos_offers_response_model.dart';

/// Repository implementation for promos & offers.
///
/// All error translation (Dio + AppException → Failure) happens inside
/// [safeApiCall]. There is no try/catch in this file.
@LazySingleton(as: PromosOffersRepository)
class PromosOffersRepositoryImpl
    with SafeApiCall
    implements PromosOffersRepository {
  final PromosOffersApi _api;
  final NetworkInfo _networkInfo;

  PromosOffersRepositoryImpl(this._api, this._networkInfo);

  @override
  Future<Either<Failure, PromoOffersEntity>> getPromosOffers({
    PromoOffersSource fromLocation = PromoOffersSource.cart,
    int productId = 0,
    CancelToken? cancelToken,
  }) {
    return safeApiCall(_networkInfo, () async {
      final response = await _api.getPromosOffersFrom(
        fromLocation: fromLocation,
        productId: productId,
        cancelToken: cancelToken,
      );
      return response.toEntity();
    });
  }

  @override
  Future<Either<Failure, PromoDetailsEntity>> getPromoDetails({
    required int promoId,
    CancelToken? cancelToken,
  }) {
    return safeApiCall(_networkInfo, () async {
      final response = await _api.getPromoDetails(
        promoId: promoId,
        cancelToken: cancelToken,
      );
      return response.toEntity();
    });
  }

  @override
  Future<Either<Failure, PromoActionResultEntity>> applyPromo({
    required String promoCode,
    CancelToken? cancelToken,
  }) {
    return safeApiCall(_networkInfo, () async {
      // Trim at the network boundary rather than trusting callers. The cart's
      // text field already blocks whitespace, but apply is also driven by the
      // offers sheet and by the post-login resume, and a stray space would
      // make the backend reject an otherwise valid code.
      final response = await _api.applyPromo(
        request: PromoApplyRequestModel(promoCode: promoCode.trim()),
        cancelToken: cancelToken,
      );
      return response.toEntity();
    });
  }

  @override
  Future<Either<Failure, PromoActionResultEntity>> removePromo({
    required String promoCode,
    CancelToken? cancelToken,
  }) {
    return safeApiCall(_networkInfo, () async {
      final response = await _api.removePromo(
        promoCode: promoCode.trim(),
        cancelToken: cancelToken,
      );
      return response.toEntity();
    });
  }
}
