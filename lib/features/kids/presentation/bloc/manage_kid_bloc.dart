import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/analytics/events/analytics_helper.dart';
import '../../../../core/analytics/events/modules/kids_events.dart';
import '../../../../core/base/base_bloc.dart';
import '../../../../core/constants/strings/kids_strings.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/child_entity.dart';
import '../../domain/usecases/save_child_usecase.dart';

part 'manage_kid_bloc.freezed.dart';
part 'manage_kid_event.dart';
part 'manage_kid_state.dart';

@injectable
class ManageKidBloc extends BaseBloc<ManageKidEvent, ManageKidState> {
  ManageKidBloc(this._saveChild, this._analytics) : super(const ManageKidState()) {
    on<InitManageKid>(_onInit);
    on<NameChanged>(_onNameChanged);
    on<DobChanged>(_onDobChanged);
    on<GenderChanged>(_onGenderChanged);
    on<ConsentChanged>(_onConsentChanged);
    on<SubmitKid>(_onSubmit);
  }

  final SaveChildUseCase _saveChild;
  final AnalyticsHelper _analytics;

  void _onInit(InitManageKid event, Emitter<ManageKidState> emit) {
    final existing = event.existing;
    emit(
      ManageKidState(
        mode: existing == null ? ManageKidMode.create : ManageKidMode.update,
        original: existing,
        name: existing?.name ?? '',
        gender: existing?.gender,
        // `dob` stays null for an existing child too — it's the live
        // picker's own session value, and dob is locked/never re-picked on
        // edit (the field's initial display comes straight from
        // `existing.displayDob` instead — see `_DobField`).
        // Edit pre-fills from the stored value — consent was already given
        // when this child was created (submit requires it), so the box
        // starts checked. Create still starts unchecked: a new profile has
        // no prior consent to reflect, so it stays an explicit opt-in.
        consentGiven: existing?.consent ?? false,
      ),
    );
  }

  void _onNameChanged(NameChanged event, Emitter<ManageKidState> emit) {
    emit(state.copyWith(name: event.name));
  }

  void _onDobChanged(DobChanged event, Emitter<ManageKidState> emit) {
    emit(state.copyWith(dob: event.dob));
  }

  void _onGenderChanged(GenderChanged event, Emitter<ManageKidState> emit) {
    emit(state.copyWith(gender: event.gender));
  }

  void _onConsentChanged(ConsentChanged event, Emitter<ManageKidState> emit) {
    emit(
      state.copyWith(
        consentGiven: event.given,
        // Checking the box clears its own error immediately; unchecking it
        // doesn't re-show one until the next submit attempt.
        consentError: event.given ? false : state.consentError,
      ),
    );
  }

  /// Single consolidated message, shown as one bottom toast rather than
  /// separate inline errors per field (per design feedback — Figma only
  /// ever shows one error surface, not three). Consent is validated
  /// separately in [_onSubmit] since it now surfaces inline instead.
  String? _firstValidationError() {
    if (state.name.trim().isEmpty) return KidsStrings.nameRequiredError;
    if (state.gender == null) return KidsStrings.genderRequiredError;
    // A freshly-picked date (create, or a re-pick) satisfies this, as does
    // an existing child's own locked dob (edit, never re-picked) — either
    // way there's something to submit.
    if (state.dob == null && state.original?.displayDob == null) {
      return KidsStrings.dobRequiredError;
    }
    return null;
  }

  Future<void> _onSubmit(SubmitKid event, Emitter<ManageKidState> emit) async {
    final validationError = _firstValidationError();
    if (validationError != null) {
      emit(state.copyWith(submitError: validationError));
      return;
    }

    // Consent applies on both create and edit — the "Edit Profile" design
    // shows the same checkbox, so it's not create-only. Shown as an inline
    // error under the checkbox rather than blocking the button entirely.
    if (!state.consentGiven) {
      emit(state.copyWith(consentError: true));
      return;
    }

    emit(
      state.copyWith(
        isSubmitting: true,
        submitError: null,
        consentError: false,
        apiError: null,
      ),
    );

    // Resolves the outgoing "DD-MM-YYYY" dob directly — from a freshly
    // picked date when the user (re-)picked one, otherwise from the
    // existing child's own `displayDob` with its spaces stripped (a plain
    // text transform, not date parsing) when dob is locked and unchanged.
    final pickedDob = state.dob;
    final requestDob = pickedDob != null
        ? '${_pad(pickedDob.day)}-${_pad(pickedDob.month)}-${pickedDob.year}'
        : state.original?.displayDob?.replaceAll(' ', '');

    final child = ChildEntity(
      id: state.original?.id ?? 0,
      name: state.name.trim(),
      gender: state.gender!, // validated non-null above
      displayDob: requestDob,
      consent: state.consentGiven,
    );

    final result = await _saveChild(SaveChildParams(child: child));

    result.fold(
      (failure) {
        if (failure is RequestCancelledFailure) return;
        // The save call itself failed (network/server) rather than a fixable
        // field — an inline banner, not the field-validation toast.
        emit(
          state.copyWith(
            isSubmitting: false,
            apiError: KidsStrings.apiErrorBannerSubtitle,
          ),
        );
      },
      (saved) {
        emit(state.copyWith(isSubmitting: false, saved: saved));
        if (state.mode == ManageKidMode.create) {
          unawaited(_analytics.logChildProfileAdded(saved));
        } else {
          unawaited(_analytics.logChildProfileEdited(saved));
        }
      },
    );
  }
}

String _pad(int value) => value.toString().padLeft(2, '0');
