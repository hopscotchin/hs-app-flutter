part of 'manage_address_bloc.dart';

enum ManageAddressField {
  name,
  mobile,
  alternateMobile,
  pincode,
  city,
  state,
  address1,
  streetAddress,
  landmark,
}

sealed class ManageAddressEvent extends Equatable {
  const ManageAddressEvent();
  @override
  List<Object?> get props => const [];
}

class ManageAddressInitialized extends ManageAddressEvent {
  const ManageAddressInitialized(this.args);
  final ManageAddressArgs args;
  @override
  List<Object?> get props => [args];
}

class ManageAddressFieldChanged extends ManageAddressEvent {
  const ManageAddressFieldChanged(this.field, this.value);
  final ManageAddressField field;
  final String value;
  @override
  List<Object?> get props => [field, value];
}

class ManageAddressDefaultToggled extends ManageAddressEvent {
  const ManageAddressDefaultToggled(this.isDefault);
  final bool isDefault;
  @override
  List<Object?> get props => [isDefault];
}

class ManageAddressLocationUpdated extends ManageAddressEvent {
  const ManageAddressLocationUpdated(this.location);
  final AddressLocationEntity? location;
  @override
  List<Object?> get props => [location];
}

class ManageAddressSubmitted extends ManageAddressEvent {
  const ManageAddressSubmitted();
}

class ManageAddressMessageBarCleared extends ManageAddressEvent {
  const ManageAddressMessageBarCleared();
}

class ManageAddressTransientConsumed extends ManageAddressEvent {
  const ManageAddressTransientConsumed();
}

/// Internal — dispatched when the pincode field reaches 6 digits, so the
/// network lookup runs inside a proper async event handler (the
/// `emit`-outside-handler rule).
class _PincodeLookupRequested extends ManageAddressEvent {
  const _PincodeLookupRequested(this.pincode);
  final String pincode;
  @override
  List<Object?> get props => [pincode];
}
