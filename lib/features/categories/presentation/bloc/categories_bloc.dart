import 'dart:async';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/analytics/events/analytics_helper.dart';
import '../../../../core/analytics/events/modules/categories_events.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/categories_page_entity.dart';
import '../../domain/usecases/get_categories_page_usecase.dart';

part 'categories_event.dart';
part 'categories_state.dart';

@injectable
class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final GetCategoriesPageUseCase getCategoriesPageUseCase;
  final AnalyticsHelper _analytics;
  CancelToken? _cancelToken;

  CategoriesBloc(this.getCategoriesPageUseCase, this._analytics)
    : super(const CategoriesInitial()) {
    on<LoadCategories>(_onLoadCategories);
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<CategoriesState> emit,
  ) async {
    emit(const CategoriesLoading());
    _cancelToken?.cancel();
    _cancelToken = CancelToken();
    final result = await getCategoriesPageUseCase(NoParams());
    result.fold(
      (failure) => emit(CategoriesError(message: failure.message)),
      (page) {
        if (!page.isSuccessful) {
          emit(const CategoriesError(message: 'Something went wrong. Please try again.'));
          return;
        }
        emit(CategoriesLoaded(page: page));
        unawaited(_analytics.logCategoryTreeViewed(departmentName: page.pageMeta?.pageName));
      },
    );
  }

  @override
  Future<void> close() {
    _cancelToken?.cancel();
    return super.close();
  }
}
