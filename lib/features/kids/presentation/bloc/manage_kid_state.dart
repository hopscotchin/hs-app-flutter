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
    // Unchecked by default on create — consent must be an explicit opt-in
    // action by the user, not a pre-ticked box. `_onInit` overrides this to
    // the stored value on edit, where consent was already given when the
    // child was created.
    @Default(false) bool consentGiven,
    // Set when submit is attempted with an unchecked consent box — driven
    // inline under the checkbox (red border + message) instead of the
    // generic bottom toast, per the updated Figma. Cleared as soon as the
    // user checks the box.
    @Default(false) bool consentError,
    @Default(false) bool isSubmitting,
    // Field-validation failure (name/gender/dob) — shown as a bottom toast.
    String? submitError,
    // Save-call failure at the network/server level — shown as an inline
    // banner at the top of the form instead, since it's not something the
    // user can fix by editing a field.
    String? apiError,
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

  /// Consent is intentionally excluded — the Save button stays enabled once
  /// the other fields are filled, and an unchecked consent box is surfaced
  /// as its own inline error (see [consentError]) rather than disabling the
  /// button. Mirrors the non-consent checks in
  /// `ManageKidBloc._firstValidationError`.
  bool get isFormComplete => name.trim().isNotEmpty && gender != null && dob != null;
}
