// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerInfoModel _$CustomerInfoModelFromJson(Map<String, dynamic> json) =>
    CustomerInfoModel(
      actionURI: json['actionURI'] as String?,
      actionText: json['actionText'] as String?,
      cartItemCount: json['cartItemCount'] == null
          ? 0
          : parseToInt(json['cartItemCount']),
      isNewUser: json['isNewUser'] == null
          ? false
          : parseToBool(json['isNewUser']),
      isLoggedIn: json['isLoggedIn'] == null
          ? false
          : parseToBool(json['isLoggedIn']),
      hasGuestData: json['hasGuestData'] == null
          ? false
          : parseToBool(json['hasGuestData']),
      childCohorts: json['childCohorts'] as Map<String, dynamic>?,
      userConfig: _userConfigFromJson(json['userConfig']),
    );
