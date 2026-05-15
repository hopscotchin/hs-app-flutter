import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/network/api_client.dart';
import '../../models/listing_data_model.dart';
import '../../models/plp_filter_model.dart';

abstract class PlpRemoteDataSource {
  Future<ListingDataModel> getPlpProducts({
    required Map<String, dynamic> queryParams,
    CancelToken? cancelToken,
  });

  Future<ListingDataModel> getBoutiqueProducts({
    required Map<String, dynamic> queryParams,
    CancelToken? cancelToken,
  });

  Future<PlpFilterModel> getFilterData({
    required Map<String, dynamic> queryParams,
    CancelToken? cancelToken,
  });
}

@LazySingleton(as: PlpRemoteDataSource)
class PlpRemoteDataSourceImpl implements PlpRemoteDataSource {
  final ApiClient apiClient;

  PlpRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<ListingDataModel> getPlpProducts({
    required Map<String, dynamic> queryParams,
    CancelToken? cancelToken,
  }) async {
    final response = await apiClient.get(
      ApiConstants.plpProducts,
      queryParameters: queryParams,
      cancelToken: cancelToken,
    );
    return ListingDataModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<ListingDataModel> getBoutiqueProducts({
    required Map<String, dynamic> queryParams,
    CancelToken? cancelToken,
  }) async {
    final response = await apiClient.get(
      ApiConstants.boutiqueProducts,
      queryParameters: queryParams,
      cancelToken: cancelToken,
    );
    return ListingDataModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<PlpFilterModel> getFilterData({
    required Map<String, dynamic> queryParams,
    CancelToken? cancelToken,
  }) async {
    final response = await apiClient.get(
      ApiConstants.plpFilter,
      queryParameters: queryParams,
      cancelToken: cancelToken,
    );
    return PlpFilterModel.fromJson(response.data as Map<String, dynamic>);
  }
}
