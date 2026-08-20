import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/promo_offers_entity.dart';
import '../entities/promo_offers_source.dart';
import '../repositories/promos_offers_repository.dart';

@lazySingleton
class GetPromosOffersUseCase
    implements UseCase<PromoOffersEntity, GetPromosOffersParams> {
  GetPromosOffersUseCase(this._repository);
  final PromosOffersRepository _repository;

  @override
  Future<Either<Failure, PromoOffersEntity>> call(
    GetPromosOffersParams params,
  ) => _repository.getPromosOffers(
    fromLocation: params.fromLocation,
    productId: params.productId,
    cancelToken: params.cancelToken,
  );
}

class GetPromosOffersParams extends Equatable {
  const GetPromosOffersParams({
    this.fromLocation = PromoOffersSource.cart,
    this.productId = 0,
    this.cancelToken,
  });

  /// Surface that opened the sheet.
  final PromoOffersSource fromLocation;

  /// `0` for cart-level offers, the product id when opened from PDP.
  final int productId;
  final CancelToken? cancelToken;

  @override
  List<Object?> get props => [fromLocation, productId];
}
