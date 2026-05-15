import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../../core/constants/api_constants.dart';
import '../../models/login_model.dart';
import '../../models/logout/logout_model.dart';

part 'auth_remote_datasource.g.dart';

@RestApi()
@lazySingleton
abstract class AuthRemoteDatasource {
  @factoryMethod
  factory AuthRemoteDatasource(Dio dio) = _AuthRemoteDatasource;

  @POST(ApiConstants.sendOtp)
  Future<LoginModel> sendOtp({
    @Body() required Map<String, dynamic> body,
    @CancelRequest() CancelToken? cancelToken,
  });

  @POST(ApiConstants.verifyOtp)
  Future<LoginModel> verifyOtp({
    @Body() required Map<String, dynamic> body,
    @CancelRequest() CancelToken? cancelToken,
  });

  @POST(ApiConstants.registerSendOtp)
  Future<LoginModel> register({
    @Body() required Map<String, dynamic> body,
    @CancelRequest() CancelToken? cancelToken,
  });

  @GET(ApiConstants.logout)
  Future<LogoutModel> logout({@CancelRequest() CancelToken? cancelToken});
}
