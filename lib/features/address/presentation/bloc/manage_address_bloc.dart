import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/base/base_bloc.dart';
import '../../../../core/constants/strings/address_pincode_strings.dart';
import '../../../../core/entities/message_bar_entity.dart';
import '../../../../core/error/failures.dart';
import '../../data/managers/address_cache_manager.dart';
import '../../domain/entities/address_entity.dart';
import '../../domain/entities/address_input.dart';
import '../../domain/entities/manage_address_args.dart';
import '../../domain/entities/shipment_address_entity.dart';
import '../../domain/usecases/check_pincode_usecase.dart';
import '../../domain/usecases/create_address_usecase.dart';
import '../../domain/usecases/select_address_usecase.dart';
import '../../domain/usecases/update_address_usecase.dart';
import '../../domain/validators/address_validators.dart';

part 'manage_address_event.dart';
part 'manage_address_state.dart';

@injectable
class ManageAddressBloc
    extends BaseBloc<ManageAddressEvent, ManageAddressState> {
  ManageAddressBloc(
    this._createAddress,
    this._updateAddress,
    this._checkPincode,
    this._selectAddress,
    this._cache,
  ) : super(const ManageAddressState()) {
    on<ManageAddressInitialized>(_onInitialized);
    on<ManageAddressFieldChanged>(_onFieldChanged);
    on<ManageAddressDefaultToggled>(_onDefaultToggled);
    on<ManageAddressLocationUpdated>(_onLocationUpdated);
    on<ManageAddressSubmitted>(_onSubmitted);
    on<_PincodeLookupRequested>(_onPincodeLookup);
    on<ManageAddressMessageBarCleared>(
      (e, emit) => emit(state.copyWith(clearMessageBar: true)),
    );
    on<ManageAddressTransientConsumed>(
      (e, emit) => emit(
        state.copyWith(
          clearToast: true,
          clearShipmentResult: true,
          clearSubmittedAddress: true,
        ),
      ),
    );
  }

  final CreateAddressUseCase _createAddress;
  final UpdateAddressUseCase _updateAddress;
  final CheckPincodeUseCase _checkPincode;
  final SelectAddressUseCase _selectAddress;
  final AddressCacheManager _cache;

  void _onInitialized(
    ManageAddressInitialized event,
    Emitter<ManageAddressState> emit,
  ) {
    final args = event.args;
    final addr = args.address;
    final mode = args.mode;

    final values = <ManageAddressField, String>{
      ManageAddressField.name: addr?.name ?? '',
      ManageAddressField.mobile: addr?.mobile ?? '',
      ManageAddressField.alternateMobile: addr?.alternateMobile ?? '',
      ManageAddressField.pincode: addr?.pincode ?? '',
      ManageAddressField.city: addr?.city ?? '',
      ManageAddressField.state: addr?.state ?? '',
      ManageAddressField.address1: addr?.address1 ?? '',
      ManageAddressField.streetAddress: addr?.streetAddress ?? '',
      ManageAddressField.landmark: addr?.landmark ?? '',
    };

    emit(
      ManageAddressState(
        flow: args.flow,
        mode: mode,
        fromScreen: args.fromScreen,
        popUpStyle: args.popUpStyle,
        addressId: addr?.id,
        addressToEdit: addr,
        values: values,
        isDefault: addr?.isDefault ?? false,
        location: addr?.location,
        pinCodeLocation: addr?.pinCodeLocation,
        knownPincode: addr?.pincode.isNotEmpty == true ? addr!.pincode : null,
        knownPincodeCity: addr?.city ?? '',
        knownPincodeState: addr?.state ?? '',
      ),
    );
  }

  void _onFieldChanged(
    ManageAddressFieldChanged event,
    Emitter<ManageAddressState> emit,
  ) {
    final values = Map<ManageAddressField, String>.from(state.values);
    values[event.field] = event.value;

    final errors = Map<ManageAddressField, bool>.from(state.errors)
      ..[event.field] = false;
    final errorMessages = Map<ManageAddressField, String?>.from(
      state.errorMessages,
    )..[event.field] = null;

    if (event.field == ManageAddressField.pincode) {
      final stripped = event.value.replaceAll(' ', '');
      if (state.knownPincode != null &&
          stripped == state.knownPincode) {
        values[ManageAddressField.city] = state.knownPincodeCity;
        values[ManageAddressField.state] = state.knownPincodeState;
        if (state.knownPincodeCity.isNotEmpty) {
          errors[ManageAddressField.city] = false;
          errorMessages[ManageAddressField.city] = null;
        }
        if (state.knownPincodeState.isNotEmpty) {
          errors[ManageAddressField.state] = false;
          errorMessages[ManageAddressField.state] = null;
        }
      } else {
        values[ManageAddressField.city] = '';
        values[ManageAddressField.state] = '';
      }
      emit(
        state.copyWith(
          values: values,
          errors: errors,
          errorMessages: errorMessages,
        ),
      );
      if (stripped.length == AddressValidators.pincodeLength &&
          stripped != state.knownPincode) {
        add(_PincodeLookupRequested(stripped));
      }
      return;
    }

    emit(
      state.copyWith(
        values: values,
        errors: errors,
        errorMessages: errorMessages,
      ),
    );
  }

  Future<void> _onPincodeLookup(
    _PincodeLookupRequested event,
    Emitter<ManageAddressState> emit,
  ) async {
    final pincode = event.pincode;
    if (!AddressValidators.validatePincode(pincode)) return;

    emit(state.copyWith(pincodeChecking: true, clearMessageBar: true));
    final token = swapCancelToken();
    final result = await _checkPincode(
      CheckPincodeParams(
        pincode: pincode,
        exchangeFlow: state.flow == ManageAddressFlow.exchange,
        cancelToken: token,
      ),
    );

    result.fold(
      (failure) {
        if (failure is RequestCancelledFailure) return;
        emit(state.copyWith(pincodeChecking: false));
      },
      (info) {
        if (!info.isSuccessful) {
          final msg =
              info.firstErrorMessage ?? AddressStrings.errorInvalidPincode;
          final errors = Map<ManageAddressField, bool>.from(state.errors)
            ..[ManageAddressField.pincode] = true;
          final messages = Map<ManageAddressField, String?>.from(
            state.errorMessages,
          )..[ManageAddressField.pincode] = msg;
          emit(
            state.copyWith(
              pincodeChecking: false,
              errors: errors,
              errorMessages: messages,
            ),
          );
          return;
        }
        final values = Map<ManageAddressField, String>.from(state.values);
        final errors = Map<ManageAddressField, bool>.from(state.errors);
        final messages = Map<ManageAddressField, String?>.from(
          state.errorMessages,
        );
        if (info.city.isNotEmpty) {
          values[ManageAddressField.city] = info.city;
          errors[ManageAddressField.city] = false;
          messages[ManageAddressField.city] = null;
        }
        if (info.state.isNotEmpty) {
          values[ManageAddressField.state] = info.state;
          errors[ManageAddressField.state] = false;
          messages[ManageAddressField.state] = null;
        }
        emit(
          state.copyWith(
            pincodeChecking: false,
            values: values,
            errors: errors,
            errorMessages: messages,
            knownPincode: pincode,
            knownPincodeCity: info.city,
            knownPincodeState: info.state,
            pinCodeLocation: info.location.latitude > 0 ? info.location : null,
            clearMessageBar: true,
          ),
        );
      },
    );
  }

  void _onDefaultToggled(
    ManageAddressDefaultToggled event,
    Emitter<ManageAddressState> emit,
  ) {
    emit(state.copyWith(isDefault: event.isDefault));
  }

  void _onLocationUpdated(
    ManageAddressLocationUpdated event,
    Emitter<ManageAddressState> emit,
  ) {
    final loc = event.location;
    if (loc == null || (loc.latitude == 0 && loc.longitude == 0)) {
      emit(state.copyWith(clearLocation: true));
    } else {
      emit(state.copyWith(location: loc));
    }
  }

  Future<void> _onSubmitted(
    ManageAddressSubmitted event,
    Emitter<ManageAddressState> emit,
  ) async {
    final errors = <ManageAddressField, bool>{};
    final messages = <ManageAddressField, String?>{};

    bool checkBasic(ManageAddressField f, String message) {
      final ok = AddressValidators.validateBasic(state.valueOf(f));
      errors[f] = !ok;
      if (!ok) messages[f] = message;
      return ok;
    }

    checkBasic(ManageAddressField.name, AddressStrings.errorName);

    final mobileOk = AddressValidators.validateMobile(state.mobileDigits);
    errors[ManageAddressField.mobile] = !mobileOk;
    if (!mobileOk) {
      messages[ManageAddressField.mobile] = AddressStrings.errorInvalidMobile;
    }

    final pincodeOk = AddressValidators.validatePincode(state.pincodeDigits);
    errors[ManageAddressField.pincode] = !pincodeOk;
    if (!pincodeOk) {
      messages[ManageAddressField.pincode] =
          AddressStrings.errorInvalidPincode;
    }

    checkBasic(ManageAddressField.city, AddressStrings.errorCity);
    checkBasic(ManageAddressField.state, AddressStrings.errorState);
    checkBasic(ManageAddressField.address1, AddressStrings.errorAddress);
    checkBasic(ManageAddressField.streetAddress, AddressStrings.errorAddress);

    final altRaw = state.alternateMobileDigits;
    if (altRaw.isNotEmpty) {
      final altOk = AddressValidators.validateMobile(altRaw);
      errors[ManageAddressField.alternateMobile] = !altOk;
      if (!altOk) {
        messages[ManageAddressField.alternateMobile] =
            AddressStrings.errorInvalidMobile;
      }
    } else {
      errors[ManageAddressField.alternateMobile] = false;
      messages[ManageAddressField.alternateMobile] = null;
    }

    final hasError = errors.values.any((v) => v);
    if (hasError) {
      emit(state.copyWith(errors: errors, errorMessages: messages));
      return;
    }

    emit(state.copyWith(errors: errors, errorMessages: messages));

    if (state.flow == ManageAddressFlow.returnFlow) {
      _emitShipmentResult(emit);
      return;
    }

    await _submitToApi(emit);
  }

  void _emitShipmentResult(Emitter<ManageAddressState> emit) {
    final fullName = state.valueOf(ManageAddressField.name).trim();
    final parts = fullName.split(RegExp(r'\s+')).where((s) => s.isNotEmpty).toList();
    final firstName = parts.isNotEmpty ? parts.first : '';
    final lastName =
        parts.length > 1 ? parts.sublist(1).join(' ').trim() : '';

    final addr1 = state.valueOf(ManageAddressField.address1);
    final street = state.valueOf(ManageAddressField.streetAddress);
    final landmark = state.valueOf(ManageAddressField.landmark);
    final city = state.valueOf(ManageAddressField.city);
    final stateName = state.valueOf(ManageAddressField.state);
    final pincode = state.pincodeDigits;

    final pieces = [addr1, street, landmark, city, stateName]
        .where((s) => s.isNotEmpty)
        .toList();
    final base = pieces.join(', ');
    final display = pincode.isNotEmpty ? '$base - $pincode' : base;

    final shipment = ShipmentAddressEntity(
      firstName: firstName,
      lastName: lastName,
      mobile: state.mobileDigits,
      alternateMobile: state.alternateMobileDigits,
      pincode: pincode,
      city: city,
      state: stateName,
      address1: addr1,
      streetAddress: street,
      landmark: landmark,
      primary: state.isDefault,
      displayAddress: display,
      opa: false,
      available: true,
    );

    emit(
      state.copyWith(
        status: ManageAddressStatus.returnReady,
        shipmentResult: shipment,
      ),
    );
  }

  Future<void> _submitToApi(Emitter<ManageAddressState> emit) async {
    emit(
      state.copyWith(status: ManageAddressStatus.submitting, clearMessageBar: true),
    );

    final input = AddressInput(
      name: state.valueOf(ManageAddressField.name),
      mobile: state.mobileDigits,
      pincode: state.pincodeDigits,
      city: state.valueOf(ManageAddressField.city),
      state: state.valueOf(ManageAddressField.state),
      address1: state.valueOf(ManageAddressField.address1),
      streetAddress: state.valueOf(ManageAddressField.streetAddress),
      landmark: state.valueOf(ManageAddressField.landmark),
      alternateMobile: state.alternateMobileDigits,
      isDefault: state.isDefault,
      location: _effectiveLocation(),
      deliveryAction:
          state.flow == ManageAddressFlow.exchange ? 'EXCHANGE' : null,
    );

    final token = swapCancelToken();
    final result = state.mode == ManageAddressMode.create
        ? await _createAddress(
            CreateAddressParams(
              input: input,
              cartFlow: state.flow == ManageAddressFlow.cart,
              cancelToken: token,
            ),
          )
        : await _updateAddress(
            UpdateAddressParams(
              addressId: state.addressId!,
              input: input,
              cancelToken: token,
            ),
          );

    await result.fold<Future<void>>((failure) async {
      _handleFailure(emit, failure);
    }, (mutation) async {
      if (!mutation.isSuccessful) {
        if (mutation.messageBars.isNotEmpty) {
          emit(
            state.copyWith(
              status: ManageAddressStatus.idle,
              messageBar: mutation.messageBars.first,
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: ManageAddressStatus.idle,
              toastMessage: mutation.popUpMessage.isNotEmpty
                  ? mutation.popUpMessage
                  : AddressStrings.genericTryLater,
            ),
          );
        }
        return;
      }

      final picked = _pickResultingAddress(mutation.currentAddress, mutation.items);

      await _persistAddressesCache(mutation.rawItems);

      if (state.isCartFlow && picked != null) {
        if (mutation.popUpMessage.isNotEmpty) {
          emit(state.copyWith(toastMessage: mutation.popUpMessage));
        }
        await _selectForCart(emit, picked);
      } else {
        emit(
          state.copyWith(
            status: ManageAddressStatus.success,
            submittedAddress: picked,
            toastMessage: mutation.popUpMessage.isNotEmpty
                ? mutation.popUpMessage
                : null,
          ),
        );
      }
    });
  }

  Future<void> _persistAddressesCache(
    List<Map<String, dynamic>> rawItems,
  ) async {
    if (state.flow == ManageAddressFlow.account) return;
    if (rawItems.isEmpty) return;
    await _cache.setAll(rawItems);
  }

  AddressLocationEntity? _effectiveLocation() {
    final loc = state.location;
    if (loc == null) return null;
    if (loc.latitude > 0 && loc.longitude > 0) return loc;
    return null;
  }

  AddressEntity? _pickResultingAddress(
    AddressEntity? currentAddress,
    List<AddressEntity> items,
  ) {
    if (state.mode == ManageAddressMode.create) {
      if (currentAddress != null) return currentAddress;
      if (items.isNotEmpty) return items.first;
      return null;
    }

    return state.addressToEdit?.copyWith(
      name: state.valueOf(ManageAddressField.name),
      mobile: state.mobileDigits,
      alternateMobile: state.alternateMobileDigits,
      pincode: state.pincodeDigits,
      city: state.valueOf(ManageAddressField.city),
      state: state.valueOf(ManageAddressField.state),
      address1: state.valueOf(ManageAddressField.address1),
      streetAddress: state.valueOf(ManageAddressField.streetAddress),
      landmark: state.valueOf(ManageAddressField.landmark),
      isDefault: state.isDefault,
      location: _effectiveLocation(),
      pinCodeLocation: state.pinCodeLocation,
    );
  }

  Future<void> _selectForCart(
    Emitter<ManageAddressState> emit,
    AddressEntity picked,
  ) async {
    final token = swapCancelToken();
    final result = await _selectAddress(
      SelectAddressParams(addressId: picked.id, cancelToken: token),
    );
    result.fold(
      (failure) {
        if (failure is RequestCancelledFailure) return;
        emit(
          state.copyWith(
            status: ManageAddressStatus.idle,
            toastMessage: failure.message,
          ),
        );
      },
      (mutation) {
        if (mutation.isSuccessful) {
          emit(
            state.copyWith(
              status: ManageAddressStatus.success,
              submittedAddress: picked,
              toastMessage: mutation.popUpMessage.isNotEmpty
                  ? mutation.popUpMessage
                  : null,
            ),
          );
        } else if (mutation.messageBars.isNotEmpty) {
          emit(
            state.copyWith(
              status: ManageAddressStatus.idle,
              messageBar: mutation.messageBars.first,
            ),
          );
        } else if (mutation.popUpMessage.isNotEmpty) {
          emit(
            state.copyWith(
              status: ManageAddressStatus.idle,
              toastMessage: mutation.popUpMessage,
            ),
          );
        } else {
          emit(state.copyWith(status: ManageAddressStatus.idle));
        }
      },
    );
  }

  void _handleFailure(
    Emitter<ManageAddressState> emit,
    Failure failure,
  ) {
    if (failure is RequestCancelledFailure) return;
    if (failure is ApiFailure && failure.messageBars.isNotEmpty) {
      emit(
        state.copyWith(
          status: ManageAddressStatus.idle,
          messageBar: failure.messageBars.first,
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        status: ManageAddressStatus.idle,
        toastMessage: failure.message,
      ),
    );
  }

  /// True if the user has typed anything (create mode) or changed any field
  /// from the snapshot (update mode). Used by the back-press guard.
  bool get isDirty {
    if (state.mode == ManageAddressMode.create) {
      return state.valueOf(ManageAddressField.name).isNotEmpty ||
          state.mobileDigits.isNotEmpty ||
          state.pincodeDigits.isNotEmpty ||
          state.valueOf(ManageAddressField.city).isNotEmpty ||
          state.valueOf(ManageAddressField.state).isNotEmpty ||
          state.valueOf(ManageAddressField.address1).isNotEmpty ||
          state.valueOf(ManageAddressField.streetAddress).isNotEmpty;
    }
    final addr = state.addressToEdit;
    if (addr == null) return false;
    return state.valueOf(ManageAddressField.name) != addr.name ||
        state.mobileDigits != addr.mobile ||
        state.pincodeDigits != addr.pincode ||
        state.valueOf(ManageAddressField.city) != addr.city ||
        state.valueOf(ManageAddressField.state) != addr.state ||
        state.valueOf(ManageAddressField.address1) != addr.address1 ||
        state.valueOf(ManageAddressField.streetAddress) != addr.streetAddress;
  }
}
