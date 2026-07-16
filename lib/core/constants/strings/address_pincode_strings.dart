class AddressStrings {
  AddressStrings._();

  static const String noSavedAddresses = 'No saved addresses yet';
  static const String defaultAddressHeading = 'DEFAULT ADDRESS';
  static const String otherAddressHeading = 'OTHER ADDRESS';
  static const String addNewAddress = 'Add A New Address';

  static const String edit = 'EDIT';
  static const String remove = 'REMOVE';
  static const String continueLabel = 'Continue';
  static const String nonServiceable = 'Non-Serviceable';

  static const String confirmDeletePrompt =
      'Are you sure you want to remove this address?';

  // Manage address page
  static const String addAddressTitle = 'Add Address';
  static const String editAddressTitle = 'Edit Address';
  static const String removeAddressTitle = 'Remove Address';
  static const String shipToTitle = 'Ship To';
  static const String name = 'Name';
  static const String mobile = 'Mobile';
  static const String alternativeMobile = 'Alternative Mobile';
  static const String city = 'City';
  static const String state = 'State';
  static const String pincode = 'Pincode';
  static const String flatHouse = 'Flat / House No. / Building / Apartment';
  static const String streetArea = 'Street, Area';
  static const String landmark = 'Landmark';
  static const String markItOnMap = 'Mark It On Map';
  static const String locationUpdated = 'Location updated';
  static const String makeDefault = 'Make this as my default address';
  static const String setAsDefault = 'Set this as my default address';
  static const String cancel = 'Cancel';
  static const String save = 'Save';

  // Validation error messages
  static const String errorRequired = 'This field is required';
  static const String errorInvalidMobile =
      "Check if you've entered a 10 digit Indian mobile number";
  static const String errorInvalidPincode = 'Please enter a valid pincode';
  static const String errorName = 'Enter your name, please';
  static const String errorCity = 'City is required';
  static const String errorState = 'State is required';
  static const String errorAddress = 'Please enter your complete address';

  // Tooltips
  static const String tooltipAlternativeMobile =
      'In case your primary number is unreachable.';
  static const String tooltipLocation =
      'Mark your exact location on map for faster delivery.';

  // Back confirmation
  static const String leaveBottomSheetTitle = 'Discard changes?';
  static const String leaveDialogMessage =
      'Do you want to leave without saving your changes?';
  static const String leaveStay = 'No';
  static const String leaveDiscard = 'Leave';

  // Location permission sheet
  static const String locationPermissionTitle = 'Allow location access';
  static const String locationPermissionMessage =
      'We need your location to mark it on the map and improve delivery accuracy.';
  static const String locationPermissionContinue = 'Continue';

  // Generic fallback messages (mirror Android no_results_try_later)
  static const String genericTryLater = 'No results. Please try again later.';
  static const String errorSelectingAddress = 'Failed to select address.';

  // Pincode
  static const String enterPincodeHint = 'Enter A Pincode Instead';
  static const String deliverTo = 'Deliver To';
  static const String proceed = 'Proceed';
}
