import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../../core/constants/api_constants.dart';
import '../../models/check_mobile_response/check_mobile_response_model.dart';
import '../../models/logout/logout_model.dart';
import '../../models/send_otp_response/send_otp_response_model.dart';
import '../../models/signup_otp_response/signup_otp_response_model.dart';
import '../../models/verify_otp_response/verify_otp_response_model.dart';

part 'auth_remote_datasource.g.dart';

@RestApi()
@lazySingleton
abstract class AuthRemoteDatasource {
  @factoryMethod
  factory AuthRemoteDatasource(Dio dio) = _AuthRemoteDatasource;

  @POST(ApiConstants.sendOtp)
  Future<SendOtpResponseModel> sendOtp({
    @Body() required Map<String, dynamic> body,
    @CancelRequest() CancelToken? cancelToken,
  });

  @POST('/{path}')
  Future<SendOtpResponseModel> sendOtpViaPath({
    @Path('path') required String path,
    @Body() required Map<String, dynamic> body,
    @CancelRequest() CancelToken? cancelToken,
  });

  @POST(ApiConstants.verifyOtp)
  Future<VerifyOtpResponseModel> verifyOtp({
    @Body() required Map<String, dynamic> body,
    @CancelRequest() CancelToken? cancelToken,
  });

  @POST(ApiConstants.singUpSendOtp)
  Future<SignupOtpResponseModel> register({
    @Body() required Map<String, dynamic> body,
    @CancelRequest() CancelToken? cancelToken,
  });

  @POST(ApiConstants.checkMobile)
  Future<CheckMobileResponseModel> checkMobile({
    @Body() required Map<String, dynamic> body,
    @CancelRequest() CancelToken? cancelToken,
  });

  @GET(ApiConstants.logout)
  Future<LogoutModel> logout({@CancelRequest() CancelToken? cancelToken});
}
