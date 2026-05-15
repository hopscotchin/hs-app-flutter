part of 'home_bloc.dart';

enum HomeStatus { initial, loading, success, failure }

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    @Default(HomeStatus.initial) HomeStatus status,
    HomePageEntity? homePage,
    @Default('') String errorMessage,
  }) = _HomeState;
}

extension HomeStateX on HomeState {
  bool get isLoading => status == HomeStatus.loading;
  bool get isSuccess => status == HomeStatus.success;
  bool get isFailure => status == HomeStatus.failure;
  bool get hasData => homePage != null;
}
