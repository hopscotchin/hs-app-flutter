import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/pincode_check_result_entity.dart';
import '../repositories/pincode_repository.dart';

@lazySingleton
class CheckDeliveryPincodeUseCase
    implements UseCase<PincodeCheckResultEntity, CheckDeliveryPincodeParams> {
  CheckDeliveryPincodeUseCase(this._repository);
  final PincodeRepository _repository;

  @override
  Future<Either<Failure, PincodeCheckResultEntity>> call(
    CheckDeliveryPincodeParams params,
  ) => _repository.checkDeliveryPincode(
    pincode: params.pincode,
    cancelToken: params.cancelToken,
  );
}

class CheckDeliveryPincodeParams extends Equatable {
  const CheckDeliveryPincodeParams({
    required this.pincode,
    this.cancelToken,
  });

  final String pincode;
  final CancelToken? cancelToken;

  @override
  List<Object?> get props => [pincode];
}