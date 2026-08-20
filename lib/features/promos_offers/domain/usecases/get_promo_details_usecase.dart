import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/promo_details_entity.dart';
import '../repositories/promos_offers_repository.dart';

@lazySingleton
class GetPromoDetailsUseCase
    implements UseCase<PromoDetailsEntity, GetPromoDetailsParams> {
  GetPromoDetailsUseCase(this._repository);
  final PromosOffersRepository _repository;

  @override
  Future<Either<Failure, PromoDetailsEntity>> call(
    GetPromoDetailsParams params,
  ) => _repository.getPromoDetails(
    promoId: params.promoId,
    cancelToken: params.cancelToken,
  );
}

class GetPromoDetailsParams extends Equatable {
  const GetPromoDetailsParams({required this.promoId, this.cancelToken});

  final int promoId;
  final CancelToken? cancelToken;

  @override
  List<Object?> get props => [promoId];
}
