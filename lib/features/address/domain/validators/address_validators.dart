/// Mirror of Android `ValidateMobileUseCase`, `ValidatePinCodeUseCase`,
/// `ValidateBasicUseCase`. Stateless predicates — kept as pure functions
/// so the bloc can call them synchronously while typing.
abstract final class AddressValidators {
  static const int mobileLength = 10;
  static const int pincodeLength = 6;

  /// Non-empty after trim.
  static bool validateBasic(String? input) {
    if (input == null) return false;
    return input.isNotEmpty;
  }

  /// Exactly 10 digits (whitespace ignored).
  static bool validateMobile(String? mobile) {
    if (mobile == null || mobile.isEmpty) return false;
    final stripped = mobile.replaceAll(RegExp(r'\s+'), '');
    if (stripped.length != mobileLength) return false;
    return RegExp(r'^\d+$').hasMatch(stripped);
  }

  /// Exactly 6 digits, no spaces allowed.
  static bool validatePincode(String? pincode) {
    if (pincode == null || pincode.isEmpty) return false;
    if (pincode.contains(' ')) return false;
    if (pincode.length != pincodeLength) return false;
    return RegExp(r'^\d+$').hasMatch(pincode);
  }

  /// Strip whitespace — matches Android `mobileNumber` getter.
  static String stripWhitespace(String input) =>
      input.replaceAll(RegExp(r'\s'), '');
}
