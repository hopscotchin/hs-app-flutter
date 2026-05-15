import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../../core/constants/api_constants.dart';
import '../../models/home_page_response_model.dart';

part 'home_remote_datasource.g.dart';

@RestApi()
@lazySingleton
abstract class HomeRemoteDataSource {
  @factoryMethod
  factory HomeRemoteDataSource(Dio dio) = _HomeRemoteDataSource;

  @GET(ApiConstants.homePage)
  Future<HomePageResponseModel> getPage({
    @Query('pageName') required String pageName,
    @Query('pageSize') required String pageSize,
    @Query('pageNo') required String pageNo,
    @CancelRequest() CancelToken? cancelToken,
  });
}
