// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfoModel _$UserInfoModelFromJson(Map<String, dynamic> json) =>
    UserInfoModel(
      userId: parseToStringOrNull(json['userId']),
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String?,
      mobile: json['mobile'] as String?,
      isLoggedIn: json['isLoggedIn'] == null
          ? false
          : parseToBool(json['isLoggedIn']),
      isNewUser: json['isNewUser'] == null
          ? false
          : parseToBool(json['isNewUser']),
      userName: json['userName'] as String?,
      mobileStatus: json['mobileStatus'] as String?,
      cartItemCount: json['cartItemCount'] == null
          ? 0
          : parseToInt(json['cartItemCount']),
    );
