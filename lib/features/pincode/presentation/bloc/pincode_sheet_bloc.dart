import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/analytics/constants/analytics_defaults.dart';
import '../../../../core/analytics/events/analytics_helper.dart';
import '../../../../core/analytics/events/modules/cart_events.dart';
import '../../../../core/base/base_bloc.dart';
import '../../../../core/entities/message_bar_entity.dart';
import '../../../../core/error/failures.dart';
import '../../../address/data/managers/address_cache_manager.dart';
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
  PincodeSheetBloc(this._checkPincode, this._selectAddress, this._cache, this._analytics)
    : super(const PincodeSheetState()) {
    on<OpenPincodeSheet>(_onOpen);
    on<SelectPincodeAddress>(_onSelectAddress);
    on<FocusPincodeInput>(_onFocusInput);
    on<PincodeInputChanged>(_onPincodeChanged);
    on<ApplyPincode>(_onApply);
    on<PdpVerifyFailed>(_onPdpVerifyFailed);
  }

  final CheckDeliveryPincodeUseCase _checkPincode;
  final SelectAddressUseCase _selectAddress;
  final AddressCacheManager _cache;
  final AnalyticsHelper _analytics;

  void _onOpen(OpenPincodeSheet event, Emitter<PincodeSheetState> emit) {
    final addresses = _cache.cachedEntities;
    // Restore the last address picked from the sheet (cart or PDP) so its
    // indicator shows again — but only if it still exists in the list.
    final trackedId = _cache.lastSelectedPincodeAddressId;
    final selectedId = addresses.any((a) => a.id == trackedId) ? trackedId : null;
    emit(
      PincodeSheetState(
        status: PincodeSheetStatus.loaded,
        source: event.source,
        initialPincode: event.currentPincode,
        addresses: addresses,
        selectedAddressId: selectedId,
      ),
    );
  }

  Future<void> _onSelectAddress(SelectPincodeAddress event, Emitter<PincodeSheetState> emit) async {
    final current = state;
    final addr = current.addresses.firstWhere(
      (a) => a.id == event.addressId,
      orElse: () => const AddressEntity(),
    );
    if (addr.id == 0 || !addr.isServicable) return;

    // From PDP: skip both the serviceability check and the selectAddress API —
    // the sheet runs its own product-aware verifyPincode in-place. Show the
    // loader while it runs; the sheet pops itself on success (see
    // PincodeBottomSheet.onPdpVerify).
    if (current.source == PincodeSheetSource.pdp) {
      // Track this address so its indicator shows next time the sheet opens.
      unawaited(_cache.setLastSelectedPincodeAddressId(addr.id));
      emit(
        current.copyWith(
          selectedAddressId: event.addressId,
          enteredPincode: '',
          lastCheckedValidPincode: addr.pincode,
          isChecking: true,
          messageBars: const [],
          pincodeError: null,
          toastMessage: null,
        ),
      );
      return;
    }

    emit(
      current.copyWith(
        selectedAddressId: event.addressId,
        enteredPincode: '',
        lastCheckedValidPincode: null,
        isChecking: true,
        messageBars: const [],
        toastMessage: null,
      ),
    );

    await _runCheck(addr.pincode, emit, addressId: addr.id);
  }

  void _onFocusInput(FocusPincodeInput event, Emitter<PincodeSheetState> emit) {
    if (state.selectedAddressId == null) return;
    emit(
      state.copyWith(
        selectedAddressId: null,
        lastCheckedValidPincode: null,
        messageBars: const [],
        pincodeError: null,
      ),
    );
  }

  void _onPincodeChanged(PincodeInputChanged event, Emitter<PincodeSheetState> emit) {
    emit(
      state.copyWith(
        enteredPincode: event.pincode,
        lastCheckedValidPincode: null,
        pincodeError: null,
      ),
    );
  }

  Future<void> _onApply(ApplyPincode event, Emitter<PincodeSheetState> emit) async {
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
      emit(
        current.copyWith(
          selectedAddressId: null,
          lastCheckedValidPincode: pincode,
          isChecking: true,
          messageBars: const [],
          pincodeError: null,
          toastMessage: null,
        ),
      );
      return;
    }

    emit(
      current.copyWith(
        isChecking: true,
        messageBars: const [],
        toastMessage: null,
        selectedAddressId: null,
      ),
    );

    await _runCheck(pincode, emit);
  }

  void _onPdpVerifyFailed(PdpVerifyFailed event, Emitter<PincodeSheetState> emit) {
    // The caller ran the product-aware verify and it failed. Drop the loader,
    // invalidate the pending pincode (disables Proceed), and show the error as
    // a plain inline message.
    emit(
      state.copyWith(
        isChecking: false,
        lastCheckedValidPincode: null,
        pincodeError: event.pincodeError,
      ),
    );
  }

  /// `from_screen` for the pincode events — the sheet is opened from three
  /// surfaces and reports the one it was launched from.
  String get _analyticsFromScreen => switch (state.source) {
    PincodeSheetSource.cart => FromScreens.shoppingCart,
    PincodeSheetSource.pdp => FromScreens.product,
    PincodeSheetSource.checkout => FromScreens.orderCheckout,
  };

  Future<void> _runCheck(String pincode, Emitter<PincodeSheetState> emit, {int? addressId}) async {
    final token = swapCancelToken();
    final result = await _checkPincode(
      CheckDeliveryPincodeParams(pincode: pincode, cancelToken: token),
    );

    // Fired on the API answering, not on it succeeding: `pincode_checked`
    // measures the check, and an unserviceable pincode is a result worth
    // counting — dropping it would make the serviceability rate unmeasurable.
    //
    // `pincode` is the new value being checked; `from_pincode` is the one it
    // replaces, fixed at open. It was `lastCheckedValidPincode`, which moves
    // with each check — so a second check in one session reported the first as
    // its "from" instead of the pincode the user actually arrived with, and
    // the first check reported `standard` even when the cart had one.
    _analytics.logPincodeChecked(
      fromScreen: _analyticsFromScreen,
      pincode: pincode,
      fromPincode: state.initialPincode,
    );

    await result.fold(
      (failure) async {
        if (failure is RequestCancelledFailure) return;
        final bars = failure is ApiFailure && failure.messageBars.isNotEmpty
            ? failure.messageBars
            : <MessageBarEntity>[];
        emit(
          state.copyWith(
            isChecking: false,
            messageBars: bars,
            toastMessage: bars.isEmpty ? failure.message : null,
          ),
        );
      },
      (info) async {
        if (info.isSuccessful) {
          if (addressId != null) {
            await _selectAddressOnSuccess(pincode, addressId, emit);
            return;
          }
          emit(
            state.copyWith(
              isChecking: false,
              lastCheckedValidPincode: pincode,
              toastMessage: info.popUpMessage.isEmpty ? null : info.popUpMessage,
              messageBars: const [],
              popResult: pincode,
            ),
          );
        } else {
          emit(
            state.copyWith(
              isChecking: false,
              lastCheckedValidPincode: null,
              messageBars: info.messageBars,
              toastMessage: info.messageBars.isEmpty && info.popUpMessage.isNotEmpty
                  ? info.popUpMessage
                  : null,
            ),
          );
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
        emit(
          state.copyWith(
            isChecking: false,
            messageBars: bars,
            toastMessage: bars.isEmpty ? failure.message : null,
          ),
        );
      },
      (mutation) {
        if (mutation.isSuccessful) {
          unawaited(_cache.setPrimary(addressId));
          // Track this address so its indicator shows next time the sheet opens.
          unawaited(_cache.setLastSelectedPincodeAddressId(addressId));
          // Cart: no Proceed button anymore — close the sheet with the
          // validated pincode as soon as the address select succeeds.
          emit(
            state.copyWith(
              isChecking: false,
              lastCheckedValidPincode: pincode,
              toastMessage: mutation.popUpMessage.isEmpty ? null : mutation.popUpMessage,
              messageBars: const [],
              popResult: pincode,
            ),
          );
        } else {
          emit(
            state.copyWith(
              isChecking: false,
              messageBars: mutation.messageBars,
              toastMessage: mutation.messageBars.isEmpty && mutation.popUpMessage.isNotEmpty
                  ? mutation.popUpMessage
                  : null,
            ),
          );
        }
      },
    );
  }
}
