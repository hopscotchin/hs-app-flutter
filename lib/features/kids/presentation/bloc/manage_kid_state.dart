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
    File? photoFile,
    String? existingImageUrl,
    // Set when the user picks a preset avatar instead of a real photo —
    // mutually exclusive with photoFile/existingImageUrl (selecting one
    // clears the others). See PhotoSourceBottomSheet's placeholder-icon
    // note: no real illustrated avatar assets exist yet.
    int? avatarId,
    // Pre-checked by default (matches the design — the checkbox starts
    // checked, the user unchecks it to withhold consent) on both create
    // and edit.
    @Default(true) bool consentGiven,
    @Default(false) bool isSubmitting,
    String? submitError,
    ChildEntity? saved,
  }) = _ManageKidState;
}

extension ManageKidStateX on ManageKidState {
  bool get isDirty {
    if (mode == ManageKidMode.create) {
      return name.isNotEmpty || dob != null || photoFile != null || avatarId != null || consentGiven;
    }
    final o = original;
    if (o == null) return false;
    return name != o.name ||
        gender != o.gender ||
        dob != o.dob ||
        photoFile != null ||
        avatarId != null;
  }

  String? get photoPreviewPath => photoFile?.path;

  /// Never null in practice (set synchronously in _onInit before the UI
  /// ever builds), but this keeps the UI from needing null-checks in the
  /// brief window before the first ManageKidState.init lands.
  KidFormConfigEntity get effectiveConfig => config ?? KidFormConfigEntity.fallback();
}
