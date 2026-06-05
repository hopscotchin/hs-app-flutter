import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../../core/constants/api_constants.dart';
import '../../models/register_device_model.dart';

part 'device_remote_datasource.g.dart';

@RestApi()
@lazySingleton
abstract class DeviceRemoteDatasource {
  @factoryMethod
  factory DeviceRemoteDatasource(Dio dio) = _DeviceRemoteDatasource;

  @POST(ApiConstants.registerDevice)
  Future<RegisterDeviceModel> registerDevice({
    @Body() required Map<String, dynamic> body,
    @CancelRequest() CancelToken? cancelToken,
  });
}
