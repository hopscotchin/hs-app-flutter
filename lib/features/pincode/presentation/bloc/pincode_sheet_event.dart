part of 'pincode_sheet_bloc.dart';

@freezed
sealed class PincodeSheetEvent with _$PincodeSheetEvent {
  const factory PincodeSheetEvent.open({
    @Default(PincodeSheetSource.cart) PincodeSheetSource source,
  }) = OpenPincodeSheet;
  const factory PincodeSheetEvent.selectAddress(int addressId) =
      SelectPincodeAddress;
  const factory PincodeSheetEvent.focusInput() = FocusPincodeInput;
  const factory PincodeSheetEvent.pincodeChanged(String pincode) =
      PincodeInputChanged;
  const factory PincodeSheetEvent.apply() = ApplyPincode;
  /// PDP-only: the product-aware verify (run by the caller) failed. Clears the
  /// loader and shows [error] as a plain inline message.
  const factory PincodeSheetEvent.pdpVerifyFailed(String? pincodeError) =
      PdpVerifyFailed;
}