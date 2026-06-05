part of 'manage_address_bloc.dart';

enum ManageAddressStatus { idle, submitting, success, returnReady, dismissed }

class ManageAddressState extends Equatable {
  const ManageAddressState({
    this.status = ManageAddressStatus.idle,
    this.flow = ManageAddressFlow.account,
    this.mode = ManageAddressMode.create,
    this.fromScreen,
    this.popUpStyle = false,
    this.addressId,
    this.addressToEdit,
    this.values = const {},
    this.errors = const {},
    this.errorMessages = const {},
    this.isDefault = false,
    this.location,
    this.pinCodeLocation,
    this.knownPincode,
    this.knownPincodeCity = '',
    this.knownPincodeState = '',
    this.pincodeChecking = false,
    this.messageBar,
    this.toastMessage,
    this.submittedAddress,
    this.shipmentResult,
  });

  final ManageAddressStatus status;
  final ManageAddressFlow flow;
  final ManageAddressMode mode;
  final String? fromScreen;
  final bool popUpStyle;
  final int? addressId;
  final AddressEntity? addressToEdit;

  /// Raw text value per field.
  final Map<ManageAddressField, String> values;

  /// Whether the field currently shows an error (true = error visible).
  final Map<ManageAddressField, bool> errors;

  /// Optional per-field error message (from API, e.g. pincode unservicable).
  final Map<ManageAddressField, String?> errorMessages;

  final bool isDefault;
  final AddressLocationEntity? location;
  final AddressLocationEntity? pinCodeLocation;

  /// Cached pincode for which city/state are known. Mirrors Android
  /// `address.pincode` cache so we don't re-hit the API when the user
  /// retypes the same 6-digit pin.
  final String? knownPincode;
  final String knownPincodeCity;
  final String knownPincodeState;

  final bool pincodeChecking;

  /// Inline message bar (e.g. server-side validation banner).
  final MessageBarEntity? messageBar;

  /// One-shot toast message; cleared after consumption.
  final String? toastMessage;

  /// On successful create/update — the resulting address. For cart flow we
  /// then call selectAddress with this id.
  final AddressEntity? submittedAddress;

  /// For RETURN flow: the built shipment address returned to caller.
  final ShipmentAddressEntity? shipmentResult;

  bool get isCartFlow =>
      flow == ManageAddressFlow.cart || flow == ManageAddressFlow.cartLogin;

  bool get hasErrors => errors.values.any((v) => v);

  String valueOf(ManageAddressField f) => values[f] ?? '';

  /// Mobile/pincode normalized to digits.
  String get mobileDigits =>
      AddressValidators.stripWhitespace(valueOf(ManageAddressField.mobile));

  String get alternateMobileDigits => AddressValidators.stripWhitespace(
    valueOf(ManageAddressField.alternateMobile),
  );

  String get pincodeDigits =>
      valueOf(ManageAddressField.pincode).replaceAll(' ', '');

  ManageAddressState copyWith({
    ManageAddressStatus? status,
    ManageAddressFlow? flow,
    ManageAddressMode? mode,
    String? fromScreen,
    bool? popUpStyle,
    int? addressId,
    AddressEntity? addressToEdit,
    Map<ManageAddressField, String>? values,
    Map<ManageAddressField, bool>? errors,
    Map<ManageAddressField, String?>? errorMessages,
    bool? isDefault,
    AddressLocationEntity? location,
    bool clearLocation = false,
    AddressLocationEntity? pinCodeLocation,
    bool clearPinCodeLocation = false,
    String? knownPincode,
    bool clearKnownPincode = false,
    String? knownPincodeCity,
    String? knownPincodeState,
    bool? pincodeChecking,
    MessageBarEntity? messageBar,
    bool clearMessageBar = false,
    String? toastMessage,
    bool clearToast = false,
    AddressEntity? submittedAddress,
    bool clearSubmittedAddress = false,
    ShipmentAddressEntity? shipmentResult,
    bool clearShipmentResult = false,
  }) {
    return ManageAddressState(
      status: status ?? this.status,
      flow: flow ?? this.flow,
      mode: mode ?? this.mode,
      fromScreen: fromScreen ?? this.fromScreen,
      popUpStyle: popUpStyle ?? this.popUpStyle,
      addressId: addressId ?? this.addressId,
      addressToEdit: addressToEdit ?? this.addressToEdit,
      values: values ?? this.values,
      errors: errors ?? this.errors,
      errorMessages: errorMessages ?? this.errorMessages,
      isDefault: isDefault ?? this.isDefault,
      location: clearLocation ? null : (location ?? this.location),
      pinCodeLocation: clearPinCodeLocation
          ? null
          : (pinCodeLocation ?? this.pinCodeLocation),
      knownPincode: clearKnownPincode
          ? null
          : (knownPincode ?? this.knownPincode),
      knownPincodeCity: knownPincodeCity ?? this.knownPincodeCity,
      knownPincodeState: knownPincodeState ?? this.knownPincodeState,
      pincodeChecking: pincodeChecking ?? this.pincodeChecking,
      messageBar: clearMessageBar ? null : (messageBar ?? this.messageBar),
      toastMessage: clearToast ? null : (toastMessage ?? this.toastMessage),
      submittedAddress: clearSubmittedAddress
          ? null
          : (submittedAddress ?? this.submittedAddress),
      shipmentResult: clearShipmentResult
          ? null
          : (shipmentResult ?? this.shipmentResult),
    );
  }

  @override
  List<Object?> get props => [
    status,
    flow,
    mode,
    fromScreen,
    popUpStyle,
    addressId,
    addressToEdit,
    values,
    errors,
    errorMessages,
    isDefault,
    location,
    pinCodeLocation,
    knownPincode,
    knownPincodeCity,
    knownPincodeState,
    pincodeChecking,
    messageBar,
    toastMessage,
    submittedAddress,
    shipmentResult,
  ];
}
