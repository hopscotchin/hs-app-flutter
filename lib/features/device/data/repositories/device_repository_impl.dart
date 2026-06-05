import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/mixins/safe_api_call.dart';
import '../../../../core/network/connectivity/network_info.dart';
import '../../domain/repositories/device_repository.dart';
import '../datasources/remote/device_remote_datasource.dart';

@LazySingleton(as: DeviceRepository)
class DeviceRepositoryImpl with SafeApiCall implements DeviceRepository {
  DeviceRepositoryImpl(this._api, this._networkInfo);

  final DeviceRemoteDatasource _api;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, void>> registerDevice({
    required String deviceToken,
    required String deviceType,
    CancelToken? cancelToken,
  }) =>
      safeApiCall(_networkInfo, () async {
        await _api.registerDevice(
          body: {'deviceToken': deviceToken, 'deviceType': deviceType},
          cancelToken: cancelToken,
        );
      });
}
