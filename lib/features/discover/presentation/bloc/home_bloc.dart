import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/base/base_bloc.dart';
import '../../../../core/constants/strings/discover_strings.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/home_page_entity.dart';
import '../../domain/usecases/get_home_page_usecase.dart';

part 'home_bloc.freezed.dart';
part 'home_event.dart';
part 'home_state.dart';

@injectable
class HomeBloc extends BaseBloc<HomeEvent, HomeState> {
  HomeBloc(this._getHomePage) : super(const HomeState()) {
    on<LoadHomePage>(_onLoad);
    on<RefreshHomePage>(_onRefresh);
  }

  final GetHomePageUseCase _getHomePage;

  Future<void> _onLoad(LoadHomePage _, Emitter<HomeState> emit) async {
    emit(const HomeState(status: HomeStatus.loading));
    final token = swapCancelToken();
    final result = await _getHomePage(GetHomePageParams(cancelToken: token));
    result.fold(
      (failure) {
        if (failure is RequestCancelledFailure) return;
        emit(HomeState(status: HomeStatus.failure, errorMessage: failure.message));
      },
      (page) => _emitPageResult(page, emit),
    );
  }

  Future<void> _onRefresh(RefreshHomePage _, Emitter<HomeState> emit) async {
    final token = swapCancelToken();
    final result = await _getHomePage(GetHomePageParams(cancelToken: token));
    result.fold(
      (failure) {
        if (failure is RequestCancelledFailure) return;
        emit(HomeState(status: HomeStatus.failure, errorMessage: failure.message));
      },
      (page) => _emitPageResult(page, emit),
    );
  }

  void _emitPageResult(HomePageEntity page, Emitter<HomeState> emit) {
    if (!page.isSuccessful) {
      emit(HomeState(
        status: HomeStatus.failure,
        errorMessage: page.popUpMessage ?? DiscoverStrings.somethingWentWrong,
      ));
    } else {
      emit(HomeState(status: HomeStatus.success, homePage: page));
    }
  }
}
