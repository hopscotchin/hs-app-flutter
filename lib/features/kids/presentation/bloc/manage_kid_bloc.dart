import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/analytics/events/analytics_helper.dart';
import '../../../../core/analytics/events/modules/kids_events.dart';
import '../../../../core/base/base_bloc.dart';
import '../../../../core/constants/strings/kids_strings.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/child_entity.dart';
import '../../domain/entities/kid_form_config_entity.dart';
import '../../domain/usecases/get_kid_form_config_usecase.dart';
import '../../domain/usecases/save_child_usecase.dart';

part 'manage_kid_bloc.freezed.dart';
part 'manage_kid_event.dart';
part 'manage_kid_state.dart';

@injectable
class ManageKidBloc extends BaseBloc<ManageKidEvent, ManageKidState> {
  ManageKidBloc(this._saveChild, this._getFormConfig, this._analytics)
    : super(const ManageKidState()) {
    on<InitManageKid>(_onInit);
    on<NameChanged>(_onNameChanged);
    on<DobChanged>(_onDobChanged);
    on<GenderChanged>(_onGenderChanged);
    on<ConsentChanged>(_onConsentChanged);
    on<SubmitKid>(_onSubmit);
  }

  final SaveChildUseCase _saveChild;
  final GetKidFormConfigUseCase _getFormConfig;
  final AnalyticsHelper _analytics;

  Future<void> _onInit(InitManageKid event, Emitter<ManageKidState> emit) async {
    final existing = event.existing;
    // `config` starts null so the UI can show a real loading state — see
    // KidsRepositoryImpl.getFormConfig, which only resolves to the local
    // fallback copy if the fetch genuinely fails; on success it carries the
    // live backend content.
    emit(
      ManageKidState(
        mode: existing == null ? ManageKidMode.create : ManageKidMode.update,
        original: existing,
        name: existing?.name ?? '',
        gender: existing?.gender,
        dob: existing?.dob,
      ),
    );

    final result = await _getFormConfig(const GetKidFormConfigParams());
    result.fold((_) {}, (config) => emit(state.copyWith(config: config)));
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
    emit(state.copyWith(consentGiven: event.given));
  }

  /// Single consolidated message, shown as one bottom toast rather than
  /// separate inline errors per field (per design feedback — Figma only
  /// ever shows one error surface, not three).
  String? _firstValidationError() {
    if (state.name.trim().isEmpty) return KidsStrings.nameRequiredError;
    if (state.gender == null) return KidsStrings.genderRequiredError;
    if (state.dob == null) return KidsStrings.dobRequiredError;
    // Consent applies on both create and edit — the "Edit Profile" design
    // shows the same checkbox, so it's not create-only.
    if (!state.consentGiven) return KidsStrings.consentRequiredError;
    return null;
  }

  Future<void> _onSubmit(SubmitKid event, Emitter<ManageKidState> emit) async {
    final validationError = _firstValidationError();
    if (validationError != null) {
      emit(state.copyWith(submitError: validationError));
      return;
    }

    emit(state.copyWith(isSubmitting: true, submitError: null));

    final child = ChildEntity(
      id: state.original?.id ?? 0,
      name: state.name.trim(),
      gender: state.gender!, // validated non-null above
      dob: state.dob,
      imageUrl: state.original?.imageUrl,
      consent: state.consentGiven,
    );

    final result = await _saveChild(SaveChildParams(child: child));

    result.fold(
      (failure) {
        if (failure is RequestCancelledFailure) return;
        emit(state.copyWith(isSubmitting: false, submitError: failure.message));
      },
      (saved) {
        emit(state.copyWith(isSubmitting: false, saved: saved));
        if (state.mode == ManageKidMode.create) {
          _analytics.logChildProfileAdded(saved);
        } else {
          _analytics.logChildProfileEdited(saved);
        }
      },
    );
  }
}
