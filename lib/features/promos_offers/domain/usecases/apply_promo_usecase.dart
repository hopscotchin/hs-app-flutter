import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/promo_action_result_entity.dart';
import '../repositories/promos_offers_repository.dart';

@lazySingleton
class ApplyPromoUseCase
    implements UseCase<PromoActionResultEntity, ApplyPromoParams> {
  ApplyPromoUseCase(this._repository);
  final PromosOffersRepository _repository;

  @override
  Future<Either<Failure, PromoActionResultEntity>> call(
    ApplyPromoParams params,
  ) =>
      _repository.applyPromo(
        promoCode: params.promoCode,
        cancelToken: params.cancelToken,
      );
}

class ApplyPromoParams extends Equatable {
  const ApplyPromoParams({required this.promoCode, this.cancelToken});

  final String promoCode;
  final CancelToken? cancelToken;

  @override
  List<Object?> get props => [promoCode];
}