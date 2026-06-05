import 'package:freezed_annotation/freezed_annotation.dart';

part 'address_entity.freezed.dart';

@freezed
abstract class AddressEntity with _$AddressEntity {
  const factory AddressEntity({
    @Default(0) int id,
    @Default('') String name,
    @Default('') String country,
    @Default('') String state,
    @Default('') String city,
    @Default('') String pincode,
    @Default('') String streetAddress,
    @Default('') String landmark,
    @Default('') String mobile,
    @Default('') String alternateMobile,
    @Default(false) bool isDefault,
    @Default(false) bool canCod,
    @Default(false) bool canPol,
    @Default(false) bool isServicable,
    @Default('') String simpleStreetAddress,
    @Default('') String displayAddress,
    @Default('') String address1,
    AddressLocationEntity? location,
    AddressLocationEntity? pinCodeLocation,
  }) = _AddressEntity;
}

extension AddressEntityX on AddressEntity {
  String get allMobiles {
    final parts = <String>[
      _formatPhone(mobile),
      _formatPhone(alternateMobile),
    ].where((s) => s.isNotEmpty).toList();
    return parts.join(', ');
  }
}

String _formatPhone(String raw) {
  final digits = raw.replaceAll(RegExp(r'\D'), '');
  if (digits.isEmpty) return '';
  final last10 = digits.length > 10
      ? digits.substring(digits.length - 10)
      : digits;
  if (last10.length == 10) {
    return '+91 ${last10.substring(0, 5)} ${last10.substring(5)}';
  }
  return '+91 $last10';
}

@freezed
abstract class AddressLocationEntity with _$AddressLocationEntity {
  const factory AddressLocationEntity({
    @Default(0.0) double latitude,
    @Default(0.0) double longitude,
  }) = _AddressLocationEntity;
}