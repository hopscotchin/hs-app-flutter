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
    on<LoadNextHomePage>(_onLoadNext);
  }

  final GetHomePageUseCase _getHomePage;

  String _pageName = DiscoverStrings.defaultPageName;
  int _pageNo = 1;

  Future<void> _onLoad(LoadHomePage event, Emitter<HomeState> emit) async {
    _pageName = event.pageName ?? DiscoverStrings.defaultPageName;
    _pageNo = 1;
    emit(state.copyWith(status: HomeStatus.loading, isLoadingMore: false, errorMessage: ''));
    await _fetch(emit, append: false);
  }

  Future<void> _onRefresh(RefreshHomePage event, Emitter<HomeState> emit) async {
    _pageNo = 1;
    emit(state.copyWith(status: HomeStatus.loading, isLoadingMore: false, errorMessage: ''));
    try {
      await _fetch(emit, append: false);
    } finally {
      event.onComplete?.call();
    }
  }

  Future<void> _onLoadNext(LoadNextHomePage _, Emitter<HomeState> emit) async {
    // Hard stop when the server has told us there is no further page.
    // The UI scroll listener can keep firing as the user scrolls — this
    // guard is the single source of truth for "stop paginating".
    if (!state.hasNextPage || state.isLoadingMore) return;
    emit(state.copyWith(isLoadingMore: true));
    _pageNo += 1;
    await _fetch(emit, append: true);
  }

  Future<void> _fetch(Emitter<HomeState> emit, {required bool append}) async {
    final token = swapCancelToken();
    final result = await _getHomePage(
      GetHomePageParams(pageName: _pageName, pageNo: _pageNo, cancelToken: token),
    );
    result.fold((failure) {
      if (failure is RequestCancelledFailure) return;
      if (append) {
        // Rewind the optimistic pageNo bump so the next attempt retries.
        _pageNo -= 1;
        emit(state.copyWith(isLoadingMore: false));
      } else if (state.status == HomeStatus.success) {
        // Silent reload (same tab) failed — keep showing the existing
        // data instead of swapping to a full-screen error. User can
        // pull-to-refresh to retry.
        return;
      } else {
        emit(HomeState(status: HomeStatus.failure, errorMessage: failure.message));
      }
    }, (page) => _emit(page, emit, append: append));
  }

  void _emit(HomePageEntity page, Emitter<HomeState> emit, {required bool append}) {
    if (!page.isSuccessful) {
      emit(
        HomeState(
          status: HomeStatus.failure,
          errorMessage: page.popUpMessage ?? DiscoverStrings.somethingWentWrong,
        ),
      );
      return;
    }

    if (!append) {
      emit(HomeState(status: HomeStatus.success, homePage: page));
      return;
    }

    final current = state.homePage;
    if (current == null) {
      emit(HomeState(status: HomeStatus.success, homePage: page));
      return;
    }

    final merged = page.copyWith(
      pageComponents: [...current.pageComponents, ...page.pageComponents],
      // Server may resend sortingOptions on every page — keep the first
      // page's list as the source of truth for the tab strip.
      sortingOptions: current.sortingOptions.isNotEmpty
          ? current.sortingOptions
          : page.sortingOptions,
    );
    emit(state.copyWith(status: HomeStatus.success, homePage: merged, isLoadingMore: false));
  }
}
