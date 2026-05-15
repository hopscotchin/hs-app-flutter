// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginModel _$LoginModelFromJson(Map<String, dynamic> json) => LoginModel(
  userId: parseToStringOrNull(json['userId']),
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
  userName: json['userName'] as String?,
  persistentTicket: json['persistentTicket'] as String?,
  loginId: json['loginId'] as String?,
  timer: json['timer'] == null ? 0 : parseToInt(json['timer']),
  email: json['email'] as String?,
  phoneNumber: json['phoneNumber'] as String?,
  otpLength: json['otpLength'] == null ? 6 : parseToInt(json['otpLength']),
  profileImage: json['profileImage'] as String?,
  isLoggedIn: json['isLoggedIn'] == null
      ? false
      : parseToBool(json['isLoggedIn']),
  isRegister: json['isRegister'] == null
      ? false
      : parseToBool(json['isRegister']),
  cartItemQty: json['cartItemQty'] == null
      ? 0
      : parseToInt(json['cartItemQty']),
  mobileStatus: json['mobileStatus'] as String?,
  popUpMessage: json['popUpMessage'] as String?,
  action: json['action'] as String?,
);
