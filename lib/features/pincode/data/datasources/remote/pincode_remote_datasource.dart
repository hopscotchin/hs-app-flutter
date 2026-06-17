import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../../core/constants/api_constants.dart';
import '../../models/pincode_check_response_model.dart';

part 'pincode_remote_datasource.g.dart';

@RestApi()
@lazySingleton
abstract class PincodeRemoteDatasource {
  @factoryMethod
  factory PincodeRemoteDatasource(Dio dio) = _PincodeRemoteDatasource;

  @PUT(ApiConstants.deliveryPincode)
  Future<PincodeCheckResponseModel> checkDeliveryPincode({
    @Path('pincode') required String pincode,
    @CancelRequest() CancelToken? cancelToken,
  });
}