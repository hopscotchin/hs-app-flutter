import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/mixins/safe_api_call.dart';
import '../../../../core/network/connectivity/network_info.dart';
import '../../domain/entities/search_suggestion_entity.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/remote/search_api.dart';
import '../models/search_suggestion_model.dart';

@LazySingleton(as: SearchRepository)
class SearchRepositoryImpl with SafeApiCall implements SearchRepository {
  SearchRepositoryImpl(this._api, this._networkInfo);

  final SearchApi _api;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, List<SearchSuggestionEntity>>> getSuggestions({
    required String query,
    CancelToken? cancelToken,
  }) {
    return safeApiCall(_networkInfo, () async {
      final response = await _api.getAutoSuggestions(
        query: query,
        cancelToken: cancelToken,
      );
      return response.suggestions.map((s) => s.toEntity()).toList();
    });
  }
}
