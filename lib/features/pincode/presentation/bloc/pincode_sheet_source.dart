import '../../../../core/constants/strings/auto_test_strings.dart';

/// Where the pincode bottom sheet was launched from. Drives post-selection
/// behavior (e.g. PDP skips serviceability check and runs its own
/// product-aware verifyPincode). Add new entry points here as they appear.
///
/// [cart] and [pdp] are pincode-only (no address list). [checkout] is the
/// upcoming flow that lists saved addresses and shows a bottom action button —
/// not wired yet.
enum PincodeSheetSource { cart, pdp, checkout }
extension PincodeSheetSourceKeys on PincodeSheetSource {
  /// Automation-key prefix for this entry point, so the sheet's keys read
  /// `cart_pincode_sheet_*` / `pdp_pincode_sheet_*` rather than a bare
  /// `pincode_sheet_*` that would match whichever copy is open.
  String get keyPrefix => switch (this) {
    PincodeSheetSource.cart => PincodeTestStrings.cartHost,
    PincodeSheetSource.pdp => PincodeTestStrings.pdpHost,
    PincodeSheetSource.checkout => PincodeTestStrings.checkoutHost,
  };
}
