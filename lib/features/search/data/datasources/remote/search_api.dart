import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../../core/constants/api_constants.dart';
import '../../models/search_suggestions_response_model.dart';

part 'search_api.g.dart';

@RestApi()
@lazySingleton
abstract class SearchApi {
  @factoryMethod
  factory SearchApi(Dio dio) = _SearchApi;

  @GET(ApiConstants.searchAutoSuggest)
  Future<SearchSuggestionsResponseModel> getAutoSuggestions({
    @Query('query') required String query,
    @CancelRequest() CancelToken? cancelToken,
  });
}
