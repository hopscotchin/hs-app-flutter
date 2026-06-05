import 'package:json_annotation/json_annotation.dart';

import '../../../../../core/utils/json_parsers.dart';
import '../../../domain/entities/user_info/user_info_entity.dart';

part 'user_info_model.g.dart';

@JsonSerializable()
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
    this.profileImage,
  });

  @JsonKey(fromJson: parseToStringOrNull)
  final String? userId;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? mobile;
  @JsonKey(defaultValue: false)
  final bool isLoggedIn;
  @JsonKey(defaultValue: false)
  final bool isNewUser;
  final String? userName;
  final String? mobileStatus;
  @JsonKey(defaultValue: 0)
  final int cartItemCount;
  final String? profileImage;

  factory UserInfoModel.fromJson(Map<String, dynamic> json) => _$UserInfoModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserInfoModelToJson(this);

  factory UserInfoModel.fromEntity(UserInfoEntity entity) => UserInfoModel(
    userId: entity.userId,
    firstName: entity.firstName,
    lastName: entity.lastName,
    email: entity.email,
    mobile: entity.mobile,
    isLoggedIn: entity.isLoggedIn,
    isNewUser: entity.isNewUser,
    userName: entity.userName,
    mobileStatus: entity.mobileStatus,
    cartItemCount: entity.cartItemCount,
    profileImage: entity.profileImage,
  );
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
    profileImage: profileImage,
  );
}
