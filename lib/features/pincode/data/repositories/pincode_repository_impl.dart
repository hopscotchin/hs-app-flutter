import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/mixins/safe_api_call.dart';
import '../../../../core/network/connectivity/network_info.dart';
import '../../domain/entities/pincode_check_result_entity.dart';
import '../../domain/repositories/pincode_repository.dart';
import '../datasources/remote/pincode_remote_datasource.dart';
import '../models/pincode_check_response_model.dart';

@LazySingleton(as: PincodeRepository)
class PincodeRepositoryImpl with SafeApiCall implements PincodeRepository {
  PincodeRepositoryImpl(this._remoteDatasource, this._networkInfo);

  final PincodeRemoteDatasource _remoteDatasource;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, PincodeCheckResultEntity>> checkDeliveryPincode({
    required String pincode,
    CancelToken? cancelToken,
  }) {
    return safeApiCall(_networkInfo, () async {
      final response = await _remoteDatasource.checkDeliveryPincode(
        pincode: pincode,
        cancelToken: cancelToken,
      );
      return response.toEntity();
    });
  }
}