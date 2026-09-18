// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'child_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChildModel _$ChildModelFromJson(Map<String, dynamic> json) => ChildModel(
  id: parseToInt(json['id']),
  name: json['name'] as String? ?? '',
  gender: ChildGenderX.fromWire(json['gender'] as String?),
  dob: _dobFromJson(json['dob']),
  imageUrl: json['imageUrl'] as String?,
  consent: json['consent'] as bool? ?? false,
);
