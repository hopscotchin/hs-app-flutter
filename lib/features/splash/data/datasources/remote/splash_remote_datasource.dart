import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../../core/constants/api_constants.dart';
import '../../models/app_config_response.dart';
import '../../models/customer_info_model.dart';

part 'splash_remote_datasource.g.dart';

@RestApi()
@lazySingleton
abstract class SplashRemoteDatasource {
  @factoryMethod
  factory SplashRemoteDatasource(Dio dio) = _SplashRemoteDatasource;

  @GET(ApiConstants.appConfig)
  Future<AppConfigResponse> getAppConfig({@CancelRequest() CancelToken? cancelToken});

  @GET(ApiConstants.customerInfo)
  Future<CustomerInfoModel> getCustomerInfo({@CancelRequest() CancelToken? cancelToken});
}
