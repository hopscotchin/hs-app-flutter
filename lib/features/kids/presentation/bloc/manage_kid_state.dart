part of 'manage_kid_bloc.dart';

enum ManageKidMode { create, update }

@freezed
abstract class ManageKidState with _$ManageKidState {
  const factory ManageKidState({
    @Default(ManageKidMode.create) ManageKidMode mode,
    ChildEntity? original,
    // Screen copy + avatar catalog — starts as the local fallback (set in
    // _onInit) so the page never blocks on the config network call; may be
    // swapped for backend-sourced content once the fetch resolves.
    KidFormConfigEntity? config,
    @Default('') String name,
    // Nullable and unset by default — neither Boy nor Girl is pre-selected;
    // the user must actively choose one (checked in validation before submit).
    ChildGender? gender,
    DateTime? dob,
    // Unchecked by default — consent must be an explicit opt-in action by
    // the user, not a pre-ticked box, on both create and edit.
    @Default(false) bool consentGiven,
    @Default(false) bool isSubmitting,
    String? submitError,
    ChildEntity? saved,
  }) = _ManageKidState;
}

extension ManageKidStateX on ManageKidState {
  bool get isDirty {
    if (mode == ManageKidMode.create) {
      return name.isNotEmpty || dob != null || consentGiven;
    }
    final o = original;
    if (o == null) return false;
    return name != o.name || gender != o.gender || dob != o.dob;
  }
}
