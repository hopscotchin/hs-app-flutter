import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/analytics/constants/analytics_defaults.dart';
import '../../../../core/analytics/events/analytics_helper.dart';
import '../../../../core/analytics/events/modules/home_events.dart';
import '../../../../core/analytics/home/home_track_analytic_manager.dart';
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
  HomeBloc(this._getHomePage, this._analytics, this._homeTrack)
    : super(const HomeState()) {
    on<LoadHomePage>(_onLoad);
    on<RefreshHomePage>(_onRefresh);
    on<LoadNextHomePage>(_onLoadNext);
  }

  final GetHomePageUseCase _getHomePage;
  final AnalyticsHelper _analytics;
  final HomeTrackAnalyticManager _homeTrack;

  String _pageName = DiscoverStrings.defaultPageName;
  int _pageNo = 1;

  /// Fires `homepage_viewed` only on the FIRST successful load of this bloc
  /// instance. Mirrors Android `CollectionsFragment.kt:588` which excludes
  /// `fromRefresh || sortOptionSelected || onPagination`. Tab-strip changes
  /// after the first load reuse the same bloc instance and so are filtered
  /// out by this flag.
  bool _hasFiredHomePageViewed = false;

  Future<void> _onLoad(LoadHomePage event, Emitter<HomeState> emit) async {
    _pageName = event.pageName ?? DiscoverStrings.defaultPageName;
    _pageNo = 1;
    // Fire the lifecycle chain (app_launched → application_opened →
    // homepage_viewed) up-front so those events queue to Segment BEFORE
    // the network response can trigger impressions. Guarded to run only on
    // the first load per bloc instance (mirrors Android's fromRefresh /
    // sortOptionSelected / onPagination exclusion).
    if (!_hasFiredHomePageViewed) {
      _hasFiredHomePageViewed = true;
      unawaited(_analytics.logHomePageViewed(fromScreen: FromScreens.discover));
    }
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
      _homeTrack.pageComponents = page.pageComponents;
      return;
    }

    final current = state.homePage;
    if (current == null) {
      emit(HomeState(status: HomeStatus.success, homePage: page));
      _homeTrack.pageComponents = page.pageComponents;
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
    _homeTrack.pageComponents = merged.pageComponents;
  }

  @override
  Future<void> close() async {
    // Flush any pending horizontal-carousel scrolls, then destroy the tracker
    // so the next Discover instance starts clean. Tile impressions now fire
    // eagerly per visibility cross, so there's no impression buffer to drain.
    await _homeTrack.flushCarouselScrolls();
    _homeTrack.destroyFromHomeBloc();
    return super.close();
  }

}
