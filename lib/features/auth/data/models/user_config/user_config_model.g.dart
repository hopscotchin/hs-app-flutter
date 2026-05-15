// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_config_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserConfigModel _$UserConfigModelFromJson(Map<String, dynamic> json) =>
    UserConfigModel(
      continueBrowsingEligibleVisitor:
          json['continueBrowsingEligibleVisitor'] as bool? ?? false,
      productImageConfig: json['productImageConfig'] == null
          ? null
          : ProductImageConfigModel.fromJson(
              json['productImageConfig'] as Map<String, dynamic>,
            ),
    );
