import 'package:dio/dio.dart';

import '../../../../../core/network/api_client.dart';
import '../../../../../core/constants/api_constants.dart';
import '../../models/home_page_response_model.dart';

abstract class HomeRemoteDataSource {
  Future<HomePageResponseModel> getHomePage({
    int pageNo = 1,
    CancelToken? cancelToken,
  });
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiClient apiClient;

  static const String _pageName = 'discover';
  static const int _defaultPageSize = 20;

  HomeRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<HomePageResponseModel> getHomePage({
    int pageNo = 1,
    CancelToken? cancelToken,
  }) async {
    final response = await apiClient.get(
      ApiConstants.homePage,
      queryParameters: {
        'pageName': _pageName,
        'pageSize': _defaultPageSize.toString(),
        'pageNo': pageNo.toString(),
      },
      cancelToken: cancelToken,
    );
    return HomePageResponseModel.fromJson(
        response.data as Map<String, dynamic>);
  }
}
