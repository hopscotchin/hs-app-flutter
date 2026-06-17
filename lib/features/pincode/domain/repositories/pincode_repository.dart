import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../entities/pincode_check_result_entity.dart';

abstract class PincodeRepository {
  /// Validates delivery serviceability for [pincode] via PUT `/delivery/pincode/{pincode}`.
  /// Request has no body. Response carries `action` (success/failure),
  /// `popUpMessage`, and `messageBar`.
  Future<Either<Failure, PincodeCheckResultEntity>> checkDeliveryPincode({
    required String pincode,
    CancelToken? cancelToken,
  });
}