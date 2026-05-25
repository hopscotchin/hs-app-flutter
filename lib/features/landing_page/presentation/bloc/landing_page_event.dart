part of 'landing_page_bloc.dart';

@freezed
sealed class LandingPageEvent with _$LandingPageEvent {
  /// Initial load — the pageName comes from the route arguments.
  const factory LandingPageEvent.load({required String pageName}) =
      LoadLandingPage;

  /// Pull-to-refresh — reloads page 1 with the current pageName.
  const factory LandingPageEvent.refresh() = RefreshLandingPage;

  /// Append the next page when [HomePageEntity.hasNextPage] is true.
  const factory LandingPageEvent.loadNext() = LoadNextLandingPage;
}
