import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/promo_action_result_entity.dart';
import '../repositories/promos_offers_repository.dart';

@lazySingleton
class RemovePromoUseCase
    implements UseCase<PromoActionResultEntity, RemovePromoParams> {
  RemovePromoUseCase(this._repository);
  final PromosOffersRepository _repository;

  @override
  Future<Either<Failure, PromoActionResultEntity>> call(
    RemovePromoParams params,
  ) =>
      _repository.removePromo(
        promoCode: params.promoCode,
        cancelToken: params.cancelToken,
      );
}

class RemovePromoParams extends Equatable {
  const RemovePromoParams({required this.promoCode, this.cancelToken});

  final String promoCode;
  final CancelToken? cancelToken;

  @override
  List<Object?> get props => [promoCode];
}