import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/pincode_check_entity.dart';
import '../repositories/plp_repository.dart';

@lazySingleton
class CheckPincodeUseCase implements UseCase<PincodeCheckEntity, CheckPincodeParams> {
  CheckPincodeUseCase(this._repository);

  final PlpRepository _repository;

  @override
  Future<Either<Failure, PincodeCheckEntity>> call(CheckPincodeParams params) {
    return _repository.checkPincode(
      pincode: params.pincode,
      productId: params.productId,
      cancelToken: params.cancelToken,
    );
  }
}

class CheckPincodeParams extends Equatable {
  const CheckPincodeParams({
    required this.pincode,
    this.productId = -1,
    this.cancelToken,
  });

  final String pincode;
  final int productId;
  final CancelToken? cancelToken;

  // CancelToken intentionally excluded — not a semantic field.
  @override
  List<Object?> get props => [pincode, productId];
}
