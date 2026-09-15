import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/kids_list_content_entity.dart';
import '../repositories/kids_repository.dart';

@lazySingleton
class GetChildrenUseCase implements UseCase<ChildrenListResult, GetChildrenParams> {
  GetChildrenUseCase(this._repository);

  final KidsRepository _repository;

  @override
  Future<Either<Failure, ChildrenListResult>> call(GetChildrenParams params) =>
      _repository.getChildren(cancelToken: params.cancelToken);
}

class GetChildrenParams extends Equatable {
  const GetChildrenParams({this.cancelToken});

  final CancelToken? cancelToken;

  @override
  List<Object?> get props => [];
}
