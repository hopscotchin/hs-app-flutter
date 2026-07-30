import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/analytics/events/analytics_helper.dart';
import '../../../../core/analytics/events/modules/landing_page_events.dart';
import '../../../../core/analytics/home/home_track_analytic_manager.dart';
import '../../../../core/base/base_bloc.dart';
import '../../../../core/router/navigation_observer.dart';
import '../../../../core/constants/strings/discover_strings.dart';
import '../../../../core/error/failures.dart';
import '../../../discover/domain/entities/home_page_entity.dart';
import '../../../discover/domain/usecases/get_home_page_usecase.dart';

part 'landing_page_bloc.freezed.dart';
part 'landing_page_event.dart';
part 'landing_page_state.dart';

@injectable
class LandingPageBloc extends BaseBloc<LandingPageEvent, LandingPageState> {
  LandingPageBloc(
    this._getHomePage,
    this._homeTrack,
    this._analytics,
    this._navObserver,
  ) : super(const LandingPageState()) {
    on<LoadLandingPage>(_onLoad);
    on<RefreshLandingPage>(_onRefresh);
    on<LoadNextLandingPage>(_onLoadNext);
  }

  final GetHomePageUseCase _getHomePage;
  final HomeTrackAnalyticManager _homeTrack;
  final AnalyticsHelper _analytics;
  final AppNavigationObserver _navObserver;

  String? _pageName;
  int _pageNo = 1;

  /// One-shot guard — `special_page_viewed` is a per-screen-instance event
  /// (mirrors Android `SearchResultsShowingBoutiquesActivity` firing once in
  /// `onCreate`). Pagination + pull-to-refresh MUST NOT re-fire it.
  bool _hasFiredSpecialPageViewed = false;

  Future<void> _onLoad(
    LoadLandingPage event,
    Emitter<LandingPageState> emit,
  ) async {
    _pageName = event.pageName;
    _pageNo = 1;
    // Preserve the previous page snapshot through the loading transition
    // so the screen doesn't flash empty between fetches. The tracker gets
    // flipped into LP mode inside [_emit] once pageMeta.pageId + pageName
    // are available — impressions only fire after paint, which is after
    // that update lands.
    emit(state.copyWith(
      status: LandingPageStatus.loading,
      isLoadingMore: false,
      errorMessage: '',
    ));
    await _fetch(emit, append: false);
  }

  Future<void> _onRefresh(
    RefreshLandingPage _,
    Emitter<LandingPageState> emit,
  ) async {
    if (_pageName == null) return;
    _pageNo = 1;
    await _fetch(emit, append: false);
  }

  Future<void> _onLoadNext(
    LoadNextLandingPage _,
    Emitter<LandingPageState> emit,
  ) async {
    // Hard stop when the server has signalled no further page.
    if (_pageName == null) return;
    if (!state.hasNextPage) return;
    if (state.isLoadingMore) return;
    emit(state.copyWith(isLoadingMore: true));
    _pageNo += 1;
    await _fetch(emit, append: true);
  }

  Future<void> _fetch(
    Emitter<LandingPageState> emit, {
    required bool append,
  }) async {
    final pageName = _pageName;
    if (pageName == null) return;
    final token = swapCancelToken();
    final result = await _getHomePage(
      GetHomePageParams(
        pageName: pageName,
        pageNo: _pageNo,
        cancelToken: token,
      ),
    );
    result.fold(
      (failure) {
        if (failure is RequestCancelledFailure) return;
        if (append) {
          _pageNo -= 1;
          emit(state.copyWith(isLoadingMore: false));
        } else {
          emit(LandingPageState(
            status: LandingPageStatus.failure,
            errorMessage: failure.message,
          ));
        }
      },
      (page) => _emit(page, emit, append: append),
    );
  }

  void _emit(
    HomePageEntity page,
    Emitter<LandingPageState> emit, {
    required bool append,
  }) {
    if (!page.isSuccessful) {
      emit(LandingPageState(
        status: LandingPageStatus.failure,
        errorMessage:
            page.popUpMessage ?? DiscoverStrings.somethingWentWrong,
      ));
      return;
    }

    if (!append) {
      emit(LandingPageState(
        status: LandingPageStatus.success,
        homePage: page,
      ));
      _refineLpContext(page);
      _homeTrack.pageComponents = page.pageComponents;
      _fireSpecialPageViewedIfNeeded(page);
      return;
    }

    final current = state.homePage;
    if (current == null) {
      emit(LandingPageState(
        status: LandingPageStatus.success,
        homePage: page,
      ));
      _refineLpContext(page);
      _homeTrack.pageComponents = page.pageComponents;
      _fireSpecialPageViewedIfNeeded(page);
      return;
    }

    final merged = page.copyWith(
      pageComponents: [
        ...current.pageComponents,
        ...page.pageComponents,
      ],
      sortingOptions:
          current.sortingOptions.isNotEmpty
              ? current.sortingOptions
              : page.sortingOptions,
    );
    emit(state.copyWith(
      status: LandingPageStatus.success,
      homePage: merged,
      isLoadingMore: false,
    ));
    _homeTrack.pageComponents = merged.pageComponents;
  }

  /// The route observer flips the tracker to `fromHomePage: false` at push
  /// time, but it doesn't have `pageMeta` yet. Once the response arrives,
  /// call it back to fill `lp_id` / `lp_name`. Back-nav to this LP replays
  /// this path via `didPop → didPush`-equivalent observer callbacks +
  /// state restoration from the current snapshot, so no manual resume hook
  /// is needed.
  void _refineLpContext(HomePageEntity page) {
    _navObserver.setLandingPageContext(
      name: page.pageMeta?.pageName ?? _pageName,
      id: page.pageMeta?.pageId?.toString(),
    );
  }

  /// Fires `special_page_viewed` once per bloc instance on the first
  /// successful load. Pagination + pull-to-refresh reuse the same bloc, so
  /// the `_hasFiredSpecialPageViewed` guard keeps this from re-firing.
  void _fireSpecialPageViewedIfNeeded(HomePageEntity page) {
    if (_hasFiredSpecialPageViewed) return;
    final id = page.pageMeta?.pageId;
    final name = page.pageMeta?.pageName;
    if (id == null || name == null) return;
    _hasFiredSpecialPageViewed = true;
    unawaited(_analytics.logSpecialPageViewed(id: id, name: name));
  }

  @override
  Future<void> close() async {
    // Flush any pending horizontal-carousel scrolls. Tracker context and
    // per-screen visibility reset are owned by AppNavigationObserver —
    // whichever route surfaces next re-applies the right context via didPop.
    // NEVER call `_homeTrack.destroy()` here: the tracker is a shared
    // singleton and destroy() would wipe Home's pageComponents/sortBar,
    // silencing Home's impressions on back-nav.
    await _homeTrack.flushCarouselScrolls();
    return super.close();
  }
}
