import 'package:equatable/equatable.dart';

import 'address_entity.dart';

class AddressInput extends Equatable {
  const AddressInput({
    required this.name,
    required this.mobile,
    required this.pincode,
    required this.city,
    required this.state,
    required this.address1,
    required this.streetAddress,
    this.country = 'India',
    this.landmark = '',
    this.alternateMobile = '',
    this.isDefault = false,
    this.location,
    this.deliveryAction,
  });

  final String name;
  final String country;
  final String state;
  final String city;
  final String pincode;
  final String streetAddress;
  final String landmark;
  final String mobile;
  final String alternateMobile;
  final String address1;
  final bool isDefault;
  final AddressLocationEntity? location;

  /// Only set for the Exchange flow (Android sets `deliveryAction=EXCHANGE`).
  final String? deliveryAction;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'name': name,
      'country': country,
      'state': state,
      'city': city,
      'pincode': pincode,
      'streetAddress': streetAddress,
      'mobile': mobile,
      'address1': address1,
      'defaultAddress': isDefault.toString(),
    };
    if (landmark.isNotEmpty) map['landmark'] = landmark;
    if (alternateMobile.isNotEmpty) {
      map['alternateMobile'] = alternateMobile;
    }
    if (location != null &&
        location!.latitude > 0 &&
        location!.longitude > 0) {
      map['location'] = {
        'longitude': location!.longitude,
        'latitude': location!.latitude,
      };
    }
    if (deliveryAction != null && deliveryAction!.isNotEmpty) {
      map['deliveryAction'] = deliveryAction;
    }
    return map;
  }

  @override
  List<Object?> get props => [
    name,
    country,
    state,
    city,
    pincode,
    streetAddress,
    landmark,
    mobile,
    alternateMobile,
    address1,
    isDefault,
    location,
    deliveryAction,
  ];
}