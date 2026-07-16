import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/base/base_bloc.dart';
import '../../../../core/entities/message_bar_entity.dart';
import '../../../../core/error/failures.dart';
import '../../../address/data/managers/address_cache_manager.dart';
import '../../../address/data/models/address_model.dart';
import '../../../address/domain/entities/address_entity.dart';
import '../../../address/domain/usecases/select_address_usecase.dart';
import '../../domain/usecases/check_delivery_pincode_usecase.dart';
import 'pincode_sheet_source.dart';

export 'pincode_sheet_source.dart';

part 'pincode_sheet_bloc.freezed.dart';
part 'pincode_sheet_event.dart';
part 'pincode_sheet_state.dart';

@injectable
class PincodeSheetBloc extends BaseBloc<PincodeSheetEvent, PincodeSheetState> {
  PincodeSheetBloc(this._checkPincode, this._selectAddress, this._cache)
      : super(const PincodeSheetState()) {
    on<OpenPincodeSheet>(_onOpen);
    on<SelectPincodeAddress>(_onSelectAddress);
    on<FocusPincodeInput>(_onFocusInput);
    on<PincodeInputChanged>(_onPincodeChanged);
    on<ApplyPincode>(_onApply);
  }

  final CheckDeliveryPincodeUseCase _checkPincode;
  final SelectAddressUseCase _selectAddress;
  final AddressCacheManager _cache;

  void _onOpen(OpenPincodeSheet event, Emitter<PincodeSheetState> emit) {
    final raw = _cache.cached ?? const <Map<String, dynamic>>[];
    final addresses = raw
        .map((m) => AddressModel.fromJson(m).toEntity())
        .toList(growable: false);
    // Restore the last address picked from the sheet (cart or PDP) so its
    // indicator shows again — but only if it still exists in the list.
    final trackedId = _cache.lastSelectedPincodeAddressId;
    final selectedId =
        addresses.any((a) => a.id == trackedId) ? trackedId : null;
    emit(PincodeSheetState(
      status: PincodeSheetStatus.loaded,
      source: event.source,
      addresses: addresses,
      selectedAddressId: selectedId,
    ));
  }

  Future<void> _onSelectAddress(
    SelectPincodeAddress event,
    Emitter<PincodeSheetState> emit,
  ) async {
    final current = state;
    final addr = current.addresses.firstWhere(
      (a) => a.id == event.addressId,
      orElse: () => const AddressEntity(),
    );
    if (addr.id == 0 || !addr.isServicable) return;

    // From PDP: skip both the serviceability check and the selectAddress API —
    // PDP runs its own product-aware verifyPincode after the sheet pops. Pop
    // immediately with the address pincode.
    if (current.source == PincodeSheetSource.pdp) {
      // Track this address so its indicator shows next time the sheet opens.
      unawaited(_cache.setLastSelectedPincodeAddressId(addr.id));
      emit(current.copyWith(
        selectedAddressId: event.addressId,
        enteredPincode: '',
        lastCheckedValidPincode: addr.pincode,
        isChecking: false,
        messageBars: const [],
        toastMessage: null,
      ));
      return;
    }

    emit(current.copyWith(
      selectedAddressId: event.addressId,
      enteredPincode: '',
      lastCheckedValidPincode: null,
      isChecking: true,
      messageBars: const [],
      toastMessage: null,
    ));

    await _runCheck(addr.pincode, emit, addressId: addr.id);
  }

  void _onFocusInput(
    FocusPincodeInput event,
    Emitter<PincodeSheetState> emit,
  ) {
    if (state.selectedAddressId == null) return;
    emit(state.copyWith(
      selectedAddressId: null,
      lastCheckedValidPincode: null,
      messageBars: const [],
    ));
  }

  void _onPincodeChanged(
    PincodeInputChanged event,
    Emitter<PincodeSheetState> emit,
  ) {
    emit(state.copyWith(
      enteredPincode: event.pincode,
      lastCheckedValidPincode: null,
    ));
  }

  Future<void> _onApply(
    ApplyPincode event,
    Emitter<PincodeSheetState> emit,
  ) async {
    final current = state;
    final pincode = current.enteredPincode.trim();
    if (pincode.length != 6) return;

    // A raw pincode was applied — drop any tracked address so the sheet
    // shows no selection next time it opens.
    unawaited(_cache.setLastSelectedPincodeAddressId(null));

    // From PDP: skip the serviceability check. Show the Apply loader while the
    // sheet drives PDP's own product-aware verifyPincode; the sheet pops itself
    // once that API returns (see PincodeBottomSheet.onPdpVerify).
    if (current.source == PincodeSheetSource.pdp) {
      emit(current.copyWith(
        selectedAddressId: null,
        lastCheckedValidPincode: pincode,
        isChecking: true,
        messageBars: const [],
        toastMessage: null,
      ));
      return;
    }

    emit(current.copyWith(
      isChecking: true,
      messageBars: const [],
      toastMessage: null,
      selectedAddressId: null,
    ));

    await _runCheck(pincode, emit);
  }

  Future<void> _runCheck(
    String pincode,
    Emitter<PincodeSheetState> emit, {
    int? addressId,
  }) async {
    final token = swapCancelToken();
    final result = await _checkPincode(
      CheckDeliveryPincodeParams(pincode: pincode, cancelToken: token),
    );

    await result.fold(
      (failure) async {
        if (failure is RequestCancelledFailure) return;
        final bars = failure is ApiFailure && failure.messageBars.isNotEmpty
            ? failure.messageBars
            : <MessageBarEntity>[];
        emit(state.copyWith(
          isChecking: false,
          messageBars: bars,
          toastMessage: bars.isEmpty ? failure.message : null,
        ));
      },
      (info) async {
        if (info.isSuccessful) {
          if (addressId != null) {
            await _selectAddressOnSuccess(pincode, addressId, emit);
            return;
          }
          emit(state.copyWith(
            isChecking: false,
            lastCheckedValidPincode: pincode,
            toastMessage: info.popUpMessage.isEmpty ? null : info.popUpMessage,
            messageBars: const [],
            popResult: pincode,
          ));
        } else {
          emit(state.copyWith(
            isChecking: false,
            lastCheckedValidPincode: null,
            messageBars: info.messageBars,
            toastMessage: info.messageBars.isEmpty && info.popUpMessage.isNotEmpty
                ? info.popUpMessage
                : null,
          ));
        }
      },
    );
  }

  Future<void> _selectAddressOnSuccess(
    String pincode,
    int addressId,
    Emitter<PincodeSheetState> emit,
  ) async {
    final token = swapCancelToken();
    final result = await _selectAddress(
      SelectAddressParams(addressId: addressId, cancelToken: token),
    );

    result.fold(
      (failure) {
        if (failure is RequestCancelledFailure) return;
        final bars = failure is ApiFailure && failure.messageBars.isNotEmpty
            ? failure.messageBars
            : <MessageBarEntity>[];
        emit(state.copyWith(
          isChecking: false,
          messageBars: bars,
          toastMessage: bars.isEmpty ? failure.message : null,
        ));
      },
      (mutation) {
        if (mutation.isSuccessful) {
          unawaited(_cache.setPrimary(addressId));
          // Track this address so its indicator shows next time the sheet opens.
          unawaited(_cache.setLastSelectedPincodeAddressId(addressId));
          emit(state.copyWith(
            isChecking: false,
            lastCheckedValidPincode: pincode,
            toastMessage:
                mutation.popUpMessage.isEmpty ? null : mutation.popUpMessage,
            messageBars: const [],
          ));
        } else {
          emit(state.copyWith(
            isChecking: false,
            messageBars: mutation.messageBars,
            toastMessage:
                mutation.messageBars.isEmpty && mutation.popUpMessage.isNotEmpty
                    ? mutation.popUpMessage
                    : null,
          ));
        }
      },
    );
  }
}