import 'package:equatable/equatable.dart';

class ShipmentAddressEntity extends Equatable {
  const ShipmentAddressEntity({
    required this.firstName,
    required this.lastName,
    required this.mobile,
    required this.alternateMobile,
    required this.pincode,
    required this.city,
    required this.state,
    required this.address1,
    required this.streetAddress,
    required this.landmark,
    required this.primary,
    required this.displayAddress,
    this.opa = false,
    this.available = true,
  });

  final String firstName;
  final String lastName;
  final String mobile;
  final String alternateMobile;
  final String pincode;
  final String city;
  final String state;
  final String address1;
  final String streetAddress;
  final String landmark;
  final bool primary;
  final String displayAddress;
  final bool opa;
  final bool available;

  String get fullName => '$firstName $lastName'.trim();

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    mobile,
    alternateMobile,
    pincode,
    city,
    state,
    address1,
    streetAddress,
    landmark,
    primary,
    displayAddress,
    opa,
    available,
  ];
}