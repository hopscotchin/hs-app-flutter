import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/base/base_bloc.dart';
import '../../../../core/constants/strings/discover_strings.dart';
import '../../../../core/error/failures.dart';
import '../../../discover/domain/entities/home_page_entity.dart';
import '../../../discover/domain/usecases/get_home_page_usecase.dart';

part 'landing_page_bloc.freezed.dart';
part 'landing_page_event.dart';
part 'landing_page_state.dart';

@injectable
class LandingPageBloc extends BaseBloc<LandingPageEvent, LandingPageState> {
  LandingPageBloc(this._getHomePage) : super(const LandingPageState()) {
    on<LoadLandingPage>(_onLoad);
    on<RefreshLandingPage>(_onRefresh);
    on<LoadNextLandingPage>(_onLoadNext);
  }

  final GetHomePageUseCase _getHomePage;

  String? _pageName;
  int _pageNo = 1;

  Future<void> _onLoad(
    LoadLandingPage event,
    Emitter<LandingPageState> emit,
  ) async {
    _pageName = event.pageName;
    _pageNo = 1;
    // Preserve the previous page snapshot through the loading transition
    // so the screen doesn't flash empty between fetches.
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
      return;
    }

    final current = state.homePage;
    if (current == null) {
      emit(LandingPageState(
        status: LandingPageStatus.success,
        homePage: page,
      ));
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
  }
}
