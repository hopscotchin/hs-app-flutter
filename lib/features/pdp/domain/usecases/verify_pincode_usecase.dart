import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/pincode_check_entity.dart';
import '../repositories/pdp_repository.dart';

@lazySingleton
class VerifyPincodeUseCase implements UseCase<PincodeCheckEntity, VerifyPincodeParams> {
  VerifyPincodeUseCase(this._repository);

  final PdpRepository _repository;

  @override
  Future<Either<Failure, PincodeCheckEntity>> call(VerifyPincodeParams params) {
    return _repository.verifyPincode(
      params.productId,
      params.pincode,
      cancelToken: params.cancelToken,
    );
  }
}

class VerifyPincodeParams extends Equatable {
  const VerifyPincodeParams({required this.productId, required this.pincode, this.cancelToken});

  final int productId;
  final String pincode;
  final CancelToken? cancelToken;

  @override
  List<Object?> get props => [productId, pincode];
}
