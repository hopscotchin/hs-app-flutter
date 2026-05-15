import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../../core/constants/api_constants.dart';
import '../../models/account_model.dart';

part 'account_remote_data_source.g.dart';

@RestApi()
@lazySingleton
abstract class AccountRemoteDataSource {
  @factoryMethod
  factory AccountRemoteDataSource(Dio dio) = _AccountRemoteDataSource;

  @GET(ApiConstants.myAccount)
  Future<AccountModel> getAccount({
    @CancelRequest() CancelToken? cancelToken
  });

  @DELETE(ApiConstants.forgetGuestUser)
  Future<void> forgetGuestUser({
    @CancelRequest() CancelToken? cancelToken
  });
}
