import 'package:json_annotation/json_annotation.dart';

import '../../../../../core/utils/json_parsers.dart';
import '../../../domain/entities/user_info/user_info_entity.dart';

part 'user_info_model.g.dart';

@JsonSerializable(createToJson: false)
class UserInfoModel {
  const UserInfoModel({
    this.userId,
    this.firstName,
    this.lastName,
    this.email,
    this.mobile,
    this.isLoggedIn = false,
    this.isNewUser = false,
    this.userName,
    this.mobileStatus,
    this.cartItemCount = 0,
  });

  @JsonKey(fromJson: parseToStringOrNull)
  final String? userId;
  @JsonKey(defaultValue: null)
  final String? firstName;
  @JsonKey(defaultValue: null)
  final String? lastName;
  @JsonKey(defaultValue: null)
  final String? email;
  @JsonKey(defaultValue: null)
  final String? mobile;
  @JsonKey(fromJson: parseToBool, defaultValue: false)
  final bool isLoggedIn;
  @JsonKey(fromJson: parseToBool, defaultValue: false)
  final bool isNewUser;
  @JsonKey(defaultValue: null)
  final String? userName;
  @JsonKey(defaultValue: null)
  final String? mobileStatus;
  @JsonKey(fromJson: parseToInt, defaultValue: 0)
  final int cartItemCount;

  factory UserInfoModel.fromJson(Map<String, dynamic> json) =>
      _$UserInfoModelFromJson(json);
}

extension UserInfoModelX on UserInfoModel {
  UserInfoEntity toEntity() => UserInfoEntity(
    userId: userId,
    firstName: firstName,
    lastName: lastName,
    email: email,
    mobile: mobile,
    isLoggedIn: isLoggedIn,
    isNewUser: isNewUser,
    userName: userName,
    mobileStatus: mobileStatus,
    cartItemCount: cartItemCount,
  );
}
