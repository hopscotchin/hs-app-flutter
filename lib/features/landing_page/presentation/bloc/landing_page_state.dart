part of 'landing_page_bloc.dart';

enum LandingPageStatus { initial, loading, success, failure }

@freezed
abstract class LandingPageState with _$LandingPageState {
  const factory LandingPageState({
    @Default(LandingPageStatus.initial) LandingPageStatus status,
    HomePageEntity? homePage,
    @Default('') String errorMessage,
  }) = _LandingPageState;
}

extension LandingPageStateX on LandingPageState {
  bool get isLoading => status == LandingPageStatus.loading;
  bool get isSuccess => status == LandingPageStatus.success;
  bool get isFailure => status == LandingPageStatus.failure;
  bool get hasData => homePage != null;
}
