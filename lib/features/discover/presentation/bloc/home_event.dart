part of 'home_bloc.dart';

@freezed
sealed class HomeEvent with _$HomeEvent {
  /// Fresh load. Pass [pageName] to switch the page (e.g. when a SpringTab
  /// is tapped); omit to keep the current/default pageName.
  const factory HomeEvent.load({String? pageName}) = LoadHomePage;

  /// Pull-to-refresh — reloads page 1 with the current pageName.

  const factory HomeEvent.refresh({void Function()? onComplete}) = RefreshHomePage;

  /// Append the next page when [HomePageEntity.hasNextPage] is true.
  const factory HomeEvent.loadNext() = LoadNextHomePage;
}
