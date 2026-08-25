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

/// Photo upload is NOT part of the generated Retrofit interface above — it's
/// a raw multipart call against a placeholder endpoint (see ApiConstants.
/// kidsPhotoUpload) because no confirmed upload contract exists yet. Kept as
/// a plain injectable class so the repository can call it without depending
/// on Retrofit codegen for something this provisional.
@lazySingleton
class KidsPhotoUploader {
  KidsPhotoUploader(this._dio);

  final Dio _dio;

  Future<String> upload(String filePath, {CancelToken? cancelToken}) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
    });
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConstants.kidsPhotoUpload,
      data: formData,
      cancelToken: cancelToken,
    );
    return response.data?['imageUrl'] as String? ?? '';
  }
}

/// Also raw Dio rather than generated Retrofit — same reasoning as
/// [KidsPhotoUploader]: ApiConstants.kidsFormConfig is a newly-proposed
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
