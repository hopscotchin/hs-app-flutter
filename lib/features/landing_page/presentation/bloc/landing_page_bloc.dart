import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/base/base_bloc.dart';
import '../../../../core/constants/strings/discover_strings.dart';
import '../../../../core/error/failures.dart';
import '../../../discover/domain/entities/home_page_entity.dart';
import '../../domain/usecases/get_landing_page_usecase.dart';

part 'landing_page_bloc.freezed.dart';
part 'landing_page_event.dart';
part 'landing_page_state.dart';

@injectable
class LandingPageBloc extends BaseBloc<LandingPageEvent, LandingPageState> {
  LandingPageBloc(this._getLandingPage) : super(const LandingPageState()) {
    on<LoadLandingPage>(_onLoad);
    on<RefreshLandingPage>(_onRefresh);
  }

  final GetLandingPageUseCase _getLandingPage;
  String? _pageName;

  Future<void> _onLoad(LoadLandingPage event, Emitter<LandingPageState> emit) async {
    _pageName = event.pageName;
    emit(const LandingPageState(status: LandingPageStatus.loading));
    final token = swapCancelToken();
    final result = await _getLandingPage(
      GetLandingPageParams(pageName: event.pageName, cancelToken: token),
    );
    result.fold(
      (failure) {
        if (failure is RequestCancelledFailure) return;
        emit(LandingPageState(
          status: LandingPageStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (page) => _emitPageResult(page, emit),
    );
  }

  Future<void> _onRefresh(
    RefreshLandingPage _,
    Emitter<LandingPageState> emit,
  ) async {
    if (_pageName == null) return;
    final token = swapCancelToken();
    final result = await _getLandingPage(
      GetLandingPageParams(pageName: _pageName!, cancelToken: token),
    );
    result.fold(
      (failure) {
        if (failure is RequestCancelledFailure) return;
        emit(LandingPageState(
          status: LandingPageStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (page) => _emitPageResult(page, emit),
    );
  }

  void _emitPageResult(HomePageEntity page, Emitter<LandingPageState> emit) {
    if (!page.isSuccessful) {
      emit(LandingPageState(
        status: LandingPageStatus.failure,
        errorMessage: page.popUpMessage ?? DiscoverStrings.somethingWentWrong,
      ));
    } else {
      emit(LandingPageState(status: LandingPageStatus.success, homePage: page));
    }
  }
}
