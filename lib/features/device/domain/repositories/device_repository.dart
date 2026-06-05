import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';

abstract class DeviceRepository {
  Future<Either<Failure, void>> registerDevice({
    required String deviceToken,
    required String deviceType,
    CancelToken? cancelToken,
  });
}
