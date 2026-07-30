import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/recommendations_entity.dart';
import '../repositories/pdp_repository.dart';

@lazySingleton
class GetRecommendationsUseCase
    implements UseCase<RecommendationsEntity, GetRecommendationsParams> {
  GetRecommendationsUseCase(this._repository);
  final PdpRepository _repository;

  @override
  Future<Either<Failure, RecommendationsEntity>> call(
    GetRecommendationsParams params,
  ) => _repository.getRecommendations(
    params.productId,
    pageNo: params.pageNo,
    cancelToken: params.cancelToken,
  );
}

class GetRecommendationsParams extends Equatable {
  const GetRecommendationsParams({
    required this.productId,
    this.pageNo = 1,
    this.cancelToken,
  });

  final int productId;
  final int pageNo;
  final CancelToken? cancelToken;

  @override
  List<Object?> get props => [productId, pageNo];
}
