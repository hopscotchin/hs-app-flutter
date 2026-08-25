import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/kid_form_config_entity.dart';
import '../repositories/kids_repository.dart';

@lazySingleton
class GetKidFormConfigUseCase implements UseCase<KidFormConfigEntity, GetKidFormConfigParams> {
  GetKidFormConfigUseCase(this._repository);

  final KidsRepository _repository;

  @override
  Future<Either<Failure, KidFormConfigEntity>> call(GetKidFormConfigParams params) =>
      _repository.getFormConfig(cancelToken: params.cancelToken);
}

class GetKidFormConfigParams extends Equatable {
  const GetKidFormConfigParams({this.cancelToken});

  final CancelToken? cancelToken;

  @override
  List<Object?> get props => [];
}
