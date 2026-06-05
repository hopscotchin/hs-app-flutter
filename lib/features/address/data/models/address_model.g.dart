// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressModel _$AddressModelFromJson(Map<String, dynamic> json) => AddressModel(
  id: (json['id'] as num?)?.toInt() ?? 0,
  name: json['name'] as String? ?? '',
  country: json['country'] as String? ?? '',
  state: json['state'] as String? ?? '',
  city: json['city'] as String? ?? '',
  pincode: json['pincode'] as String? ?? '',
  streetAddress: json['streetAddress'] as String? ?? '',
  landmark: json['landmark'] as String? ?? '',
  mobile: json['mobile'] as String? ?? '',
  alternateMobile: json['alternateMobile'] as String? ?? '',
  isDefault: json['isDefault'] as bool? ?? false,
  canCod: json['canCod'] as bool? ?? false,
  canPol: json['canPol'] as bool? ?? false,
  isServicable: json['isServicable'] as bool? ?? false,
  simpleStreetAddress: json['simpleStreetAddress'] as String? ?? '',
  displayAddress: json['displayAddress'] as String? ?? '',
  address1: json['address1'] as String? ?? '',
  location: json['location'] == null
      ? null
      : AddressLocationModel.fromJson(json['location'] as Map<String, dynamic>),
  pinCodeLocation: json['pinCodeLocation'] == null
      ? null
      : AddressLocationModel.fromJson(
          json['pinCodeLocation'] as Map<String, dynamic>,
        ),
);

AddressLocationModel _$AddressLocationModelFromJson(
  Map<String, dynamic> json,
) => AddressLocationModel(
  latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
  longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
);
