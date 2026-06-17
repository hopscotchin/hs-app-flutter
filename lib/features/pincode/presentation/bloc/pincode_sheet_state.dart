part of 'pincode_sheet_bloc.dart';

enum PincodeSheetStatus { initial, loaded }

@freezed
abstract class PincodeSheetState with _$PincodeSheetState {
  const factory PincodeSheetState({
    @Default(PincodeSheetStatus.initial) PincodeSheetStatus status,
    @Default(<AddressEntity>[]) List<AddressEntity> addresses,
    int? selectedAddressId,
    @Default('') String enteredPincode,
    String? lastCheckedValidPincode,
    @Default(false) bool isChecking,
    @Default(<MessageBarEntity>[]) List<MessageBarEntity> messageBars,
    String? toastMessage,
    String? popResult,
  }) = _PincodeSheetState;
}

extension PincodeSheetStateX on PincodeSheetState {
  AddressEntity? get selectedAddress {
    if (selectedAddressId == null) return null;
    for (final a in addresses) {
      if (a.id == selectedAddressId) return a;
    }
    return null;
  }

  List<AddressEntity> get defaultAddresses =>
      addresses.where((a) => a.isDefault).toList(growable: false);

  List<AddressEntity> get otherAddresses =>
      addresses.where((a) => !a.isDefault).toList(growable: false);
}