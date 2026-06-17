import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/search_suggestion_entity.dart';
import '../repositories/search_repository.dart';

@lazySingleton
class GetSearchSuggestionsUseCase
    implements UseCase<List<SearchSuggestionEntity>, GetSearchSuggestionsParams> {
  GetSearchSuggestionsUseCase(this._repository);

  final SearchRepository _repository;

  @override
  Future<Either<Failure, List<SearchSuggestionEntity>>> call(
    GetSearchSuggestionsParams params,
  ) {
    return _repository.getSuggestions(
      query: params.query,
      cancelToken: params.cancelToken,
    );
  }
}

class GetSearchSuggestionsParams extends Equatable {
  const GetSearchSuggestionsParams({required this.query, this.cancelToken});

  final String query;
  final CancelToken? cancelToken;

  @override
  List<Object?> get props => [query];
}
