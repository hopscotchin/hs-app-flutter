part of 'kids_bloc.dart';

@freezed
sealed class KidsEvent with _$KidsEvent {
  const factory KidsEvent.load() = LoadChildren;
  const factory KidsEvent.refresh() = RefreshChildren;
  const factory KidsEvent.delete(int childId) = DeleteChild;
  const factory KidsEvent.clearDeleteFeedback() = ClearDeleteFeedback;
}
