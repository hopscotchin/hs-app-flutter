part of 'landing_page_bloc.dart';

@freezed
sealed class LandingPageEvent with _$LandingPageEvent {
  const factory LandingPageEvent.load({required String pageName}) =
      LoadLandingPage;
  const factory LandingPageEvent.refresh() = RefreshLandingPage;
}
