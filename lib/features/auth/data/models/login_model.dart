import 'package:json_annotation/json_annotation.dart';

import '../../../../core/network/models/action_response.dart';
import '../../../../core/utils/json_parsers.dart';
import '../../domain/entities/login_entity.dart';

part 'login_model.g.dart';

@JsonSerializable(createToJson: false)
class LoginModel {
  const LoginModel({
    this.userId,
    this.firstName,
    this.lastName,
    this.userName,
    this.persistentTicket,
    this.loginId,
    this.timer = 0,
    this.email,
    this.phoneNumber,
    this.otpLength = 6,
    this.profileImage,
    this.isLoggedIn = false,
    this.isRegister = false,
    this.cartItemQty = 0,
    this.mobileStatus,
    this.popUpMessage,
    this.action,
  });

  @JsonKey(fromJson: parseToStringOrNull)
  final String? userId;
  final String? firstName;
  final String? lastName;
  final String? userName;
  final String? persistentTicket;
  final String? loginId;
  @JsonKey(fromJson: parseToInt, defaultValue: 0)
  final int timer;
  final String? email;
  final String? phoneNumber;
  @JsonKey(fromJson: parseToInt, defaultValue: 6)
  final int otpLength;
  final String? profileImage;
  @JsonKey(fromJson: parseToBool, defaultValue: false)
  final bool isLoggedIn;
  @JsonKey(fromJson: parseToBool, defaultValue: false)
  final bool isRegister;
  @JsonKey(fromJson: parseToInt, defaultValue: 0)
  final int cartItemQty;
  final String? mobileStatus;
  final String? popUpMessage;
  final String? action;

  /// [ActionResponse.validate] runs first — throws [ApiFailureException] on
  /// `action: "failure"`, which [SafeApiCall] maps to [Left(ApiFailure(...))].
  factory LoginModel.fromJson(Map<String, dynamic> json) =>
      _$LoginModelFromJson(ActionResponse.validate(json));
}

extension LoginModelX on LoginModel {
  LoginEntity toEntity() => LoginEntity(
    userId: userId,
    firstName: firstName,
    lastName: lastName,
    userName: userName,
    persistentTicket: persistentTicket,
    loginId: loginId,
    timer: timer,
    email: email,
    phoneNumber: phoneNumber,
    otpLength: otpLength,
    profileImage: profileImage,
    isLoggedIn: isLoggedIn,
    isRegister: isRegister,
    cartItemQty: cartItemQty,
    mobileStatus: mobileStatus,
    popUpMessage: popUpMessage,
    action: action,
  );
}
