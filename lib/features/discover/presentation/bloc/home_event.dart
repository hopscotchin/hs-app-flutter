part of 'home_bloc.dart';

@freezed
sealed class HomeEvent with _$HomeEvent {
  const factory HomeEvent.load() = LoadHomePage;
  const factory HomeEvent.refresh() = RefreshHomePage;
}
