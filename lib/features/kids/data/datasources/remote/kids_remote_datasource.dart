import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../../core/constants/api_constants.dart';
import '../../models/child_mutation_response_model.dart';
import '../../models/children_response_model.dart';

part 'kids_remote_datasource.g.dart';

@RestApi()
@lazySingleton
abstract class KidsRemoteDatasource {
  @factoryMethod
  factory KidsRemoteDatasource(Dio dio) = _KidsRemoteDatasource;

  @GET(ApiConstants.kidsList)
  Future<ChildrenResponseModel> getChildren({@CancelRequest() CancelToken? cancelToken});

  @POST(ApiConstants.kidsSave)
  Future<ChildMutationResponseModel> saveChild({
    @Body() required Map<String, dynamic> body,
    @CancelRequest() CancelToken? cancelToken,
  });

  @DELETE(ApiConstants.kidsDelete)
  Future<ChildMutationResponseModel> deleteChild({
    @Path('kidId') required int kidId,
    @CancelRequest() CancelToken? cancelToken,
  });
}

/// Raw Dio rather than generated Retrofit: ApiConstants.kidsFormConfig is a newly-proposed
/// contract with no fixed shape backend has committed to yet, so this
/// returns the raw decoded map for KidFormConfigModel to parse defensively,
/// rather than binding to a strict generated response type.
@lazySingleton
class KidsFormConfigFetcher {
  KidsFormConfigFetcher(this._dio);

  final Dio _dio;

  Future<Map<String, dynamic>> fetch({CancelToken? cancelToken}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiConstants.kidsFormConfig,
      cancelToken: cancelToken,
    );
    return response.data ?? const {};
  }
}
