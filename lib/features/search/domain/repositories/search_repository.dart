import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../entities/search_suggestion_entity.dart';

abstract class SearchRepository {
  Future<Either<Failure, List<SearchSuggestionEntity>>> getSuggestions({
    required String query,
    CancelToken? cancelToken,
  });
}
