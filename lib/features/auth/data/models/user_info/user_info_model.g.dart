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
      isLoggedIn: json['isLoggedIn'] as bool? ?? false,
      isNewUser: json['isNewUser'] as bool? ?? false,
      userName: json['userName'] as String?,
      mobileStatus: json['mobileStatus'] as String?,
      cartItemCount: (json['cartItemCount'] as num?)?.toInt() ?? 0,
      profileImage: json['profileImage'] as String?,
    );

Map<String, dynamic> _$UserInfoModelToJson(UserInfoModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'mobile': instance.mobile,
      'isLoggedIn': instance.isLoggedIn,
      'isNewUser': instance.isNewUser,
      'userName': instance.userName,
      'mobileStatus': instance.mobileStatus,
      'cartItemCount': instance.cartItemCount,
      'profileImage': instance.profileImage,
    };
