import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/size_chart_entity.dart';
import '../repositories/pdp_repository.dart';

@lazySingleton
class GetSizeChartUseCase
    implements UseCase<SizeChartEntity, GetSizeChartParams> {
  GetSizeChartUseCase(this._repository);

  final PdpRepository _repository;

  @override
  Future<Either<Failure, SizeChartEntity>> call(GetSizeChartParams params) {
    return _repository.getSizeChart(
      params.productId,
      cancelToken: params.cancelToken,
    );
  }
}

class GetSizeChartParams extends Equatable {
  const GetSizeChartParams({required this.productId, this.cancelToken});

  final int productId;
  final CancelToken? cancelToken;

  @override
  List<Object?> get props => [productId];
}
