part of 'pincode_sheet_bloc.dart';

enum PincodeSheetStatus { initial, loaded }

@freezed
abstract class PincodeSheetState with _$PincodeSheetState {
  const factory PincodeSheetState({
    @Default(PincodeSheetStatus.initial) PincodeSheetStatus status,
    @Default(PincodeSheetSource.cart) PincodeSheetSource source,
    @Default(<AddressEntity>[]) List<AddressEntity> addresses,
    int? selectedAddressId,
    @Default('') String enteredPincode,

    /// The pincode in effect when the sheet opened, reported as `from_pincode`.
    ///
    /// Fixed for the sheet's lifetime — it is the value being replaced, so it
    /// must not follow [lastCheckedValidPincode], which moves with each check
    /// and would make the second check in one session report the first as its
    /// "from".
    String? initialPincode,
    String? lastCheckedValidPincode,
    @Default(false) bool isChecking,
    @Default(<MessageBarEntity>[]) List<MessageBarEntity> messageBars,
    // PDP-only: plain inline error shown when the product-aware verify fails.
    String? pincodeError,
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
