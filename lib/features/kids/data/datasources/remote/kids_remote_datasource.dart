import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../../core/constants/api_constants.dart';
import '../../models/child_mutation_response_model.dart';
import '../../models/children_response_model.dart';
import '../../models/kid_form_config_response_model.dart';

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

  @GET(ApiConstants.kidsFormConfig)
  Future<KidFormConfigResponseModel> getFormConfig({
    @CancelRequest() CancelToken? cancelToken,
  });
}
