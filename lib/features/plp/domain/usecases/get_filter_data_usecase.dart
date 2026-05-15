import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/plp_filter_entity.dart';
import '../repositories/plp_repository.dart';

@lazySingleton
class GetFilterDataUseCase
    implements UseCase<PlpFilterEntity, GetFilterDataParams> {
  final PlpRepository repository;

  GetFilterDataUseCase(this.repository);

  @override
  Future<Either<Failure, PlpFilterEntity>> call(GetFilterDataParams params) {
    return repository.getFilterData(
      queryParams: params.queryParams,
      cancelToken: params.cancelToken,
    );
  }
}

class GetFilterDataParams extends Equatable {
  final Map<String, dynamic> queryParams;
  final CancelToken? cancelToken;

  const GetFilterDataParams({required this.queryParams, this.cancelToken});

  @override
  List<Object?> get props => [queryParams, cancelToken];
}
