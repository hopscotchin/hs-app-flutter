import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/address_entity.dart';

part 'address_model.g.dart';

@JsonSerializable(createToJson: false)
class AddressModel {
  const AddressModel({
    this.id = 0,
    this.name = '',
    this.country = '',
    this.state = '',
    this.city = '',
    this.pincode = '',
    this.streetAddress = '',
    this.landmark = '',
    this.mobile = '',
    this.alternateMobile = '',
    this.isDefault = false,
    this.canCod = false,
    this.canPol = false,
    this.isServicable = false,
    this.simpleStreetAddress = '',
    this.displayAddress = '',
    this.address1 = '',
    this.location,
    this.pinCodeLocation,
  });

  @JsonKey(defaultValue: 0) final int id;
  @JsonKey(defaultValue: '') final String name;
  @JsonKey(defaultValue: '') final String country;
  @JsonKey(defaultValue: '') final String state;
  @JsonKey(defaultValue: '') final String city;
  @JsonKey(defaultValue: '') final String pincode;
  @JsonKey(defaultValue: '') final String streetAddress;
  @JsonKey(defaultValue: '') final String landmark;
  @JsonKey(defaultValue: '') final String mobile;
  @JsonKey(defaultValue: '') final String alternateMobile;
  @JsonKey(defaultValue: false) final bool isDefault;
  @JsonKey(defaultValue: false) final bool canCod;
  @JsonKey(defaultValue: false) final bool canPol;
  @JsonKey(defaultValue: false) final bool isServicable;
  @JsonKey(defaultValue: '') final String simpleStreetAddress;
  @JsonKey(defaultValue: '') final String displayAddress;
  @JsonKey(defaultValue: '') final String address1;
  final AddressLocationModel? location;
  final AddressLocationModel? pinCodeLocation;

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);
}

extension AddressModelX on AddressModel {
  AddressEntity toEntity() => AddressEntity(
    id: id,
    name: name,
    country: country,
    state: state,
    city: city,
    pincode: pincode,
    streetAddress: streetAddress,
    landmark: landmark,
    mobile: mobile,
    alternateMobile: alternateMobile,
    isDefault: isDefault,
    canCod: canCod,
    canPol: canPol,
    isServicable: isServicable,
    simpleStreetAddress: simpleStreetAddress,
    displayAddress: displayAddress,
    address1: address1,
    location: location?.toEntity(),
    pinCodeLocation: pinCodeLocation?.toEntity(),
  );
}

@JsonSerializable(createToJson: false)
class AddressLocationModel {
  const AddressLocationModel({this.latitude = 0.0, this.longitude = 0.0});

  @JsonKey(defaultValue: 0.0) final double latitude;
  @JsonKey(defaultValue: 0.0) final double longitude;

  factory AddressLocationModel.fromJson(Map<String, dynamic> json) =>
      _$AddressLocationModelFromJson(json);
}

extension AddressLocationModelX on AddressLocationModel {
  AddressLocationEntity toEntity() =>
      AddressLocationEntity(latitude: latitude, longitude: longitude);
}