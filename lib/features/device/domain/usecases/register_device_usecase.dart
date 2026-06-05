import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/device_repository.dart';

@lazySingleton
class RegisterDeviceUseCase implements UseCase<void, RegisterDeviceParams> {
  RegisterDeviceUseCase(this._repository);

  final DeviceRepository _repository;

  @override
  Future<Either<Failure, void>> call(RegisterDeviceParams params) =>
      _repository.registerDevice(
        deviceToken: params.deviceToken,
        deviceType: params.deviceType,
        cancelToken: params.cancelToken,
      );
}

class RegisterDeviceParams extends Equatable {
  const RegisterDeviceParams({
    required this.deviceToken,
    required this.deviceType,
    this.cancelToken,
  });

  final String deviceToken;
  final String deviceType;
  final CancelToken? cancelToken;

  @override
  List<Object?> get props => [deviceToken, deviceType];
  // cancelToken intentionally excluded — not a semantic field
}
