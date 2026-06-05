import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/pincode_info_entity.dart';
import '../repositories/address_repository.dart';

@lazySingleton
class CheckPincodeUseCase
    implements UseCase<PincodeInfoEntity, CheckPincodeParams> {
  CheckPincodeUseCase(this._repository);
  final AddressRepository _repository;

  @override
  Future<Either<Failure, PincodeInfoEntity>> call(
    CheckPincodeParams params,
  ) => _repository.checkPincode(
    pincode: params.pincode,
    exchangeFlow: params.exchangeFlow,
    cancelToken: params.cancelToken,
  );
}

class CheckPincodeParams extends Equatable {
  const CheckPincodeParams({
    required this.pincode,
    this.exchangeFlow = false,
    this.cancelToken,
  });

  final String pincode;
  final bool exchangeFlow;
  final CancelToken? cancelToken;

  @override
  List<Object?> get props => [pincode, exchangeFlow];
}
