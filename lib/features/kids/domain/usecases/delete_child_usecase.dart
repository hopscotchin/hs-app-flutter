import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/kids_repository.dart';

@lazySingleton
class DeleteChildUseCase implements UseCase<String, DeleteChildParams> {
  DeleteChildUseCase(this._repository);

  final KidsRepository _repository;

  @override
  Future<Either<Failure, String>> call(DeleteChildParams params) =>
      _repository.deleteChild(childId: params.childId, cancelToken: params.cancelToken);
}

class DeleteChildParams extends Equatable {
  const DeleteChildParams({required this.childId, this.cancelToken});

  final int childId;
  final CancelToken? cancelToken;

  @override
  List<Object?> get props => [childId];
}
