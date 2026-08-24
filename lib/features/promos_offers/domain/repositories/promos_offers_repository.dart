import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../entities/promo_action_result_entity.dart';
import '../entities/promo_details_entity.dart';
import '../entities/promo_offers_entity.dart';
import '../entities/promo_offers_source.dart';

/// Domain contract for reading and mutating promo offers.
///
/// Returns `Either<Failure, T>` — never throws. Accepts a [CancelToken]
/// so the BLoC can cancel a superseded in-flight request.
abstract class PromosOffersRepository {
  Future<Either<Failure, PromoOffersEntity>> getPromosOffers({
    PromoOffersSource fromLocation = PromoOffersSource.cart,
    int productId = 0,
    CancelToken? cancelToken,
  });

  Future<Either<Failure, PromoDetailsEntity>> getPromoDetails({
    required int promoId,
    CancelToken? cancelToken,
  });

  Future<Either<Failure, PromoActionResultEntity>> applyPromo({
    required String promoCode,
    PromoOffersSource fromLocation = PromoOffersSource.cart,
    CancelToken? cancelToken,
  });

  Future<Either<Failure, PromoActionResultEntity>> removePromo({
    required String promoCode,
    CancelToken? cancelToken,
  });
}
