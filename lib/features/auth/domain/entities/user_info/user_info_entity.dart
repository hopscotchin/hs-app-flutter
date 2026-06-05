import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_info_entity.freezed.dart';

@freezed
abstract class UserInfoEntity with _$UserInfoEntity {
  const factory UserInfoEntity({
    String? userId,
    String? firstName,
    String? lastName,
    String? email,
    String? mobile,
    @Default(false) bool isLoggedIn,
    @Default(false) bool isNewUser,
    String? userName,
    String? mobileStatus,
    @Default(0) int cartItemCount,
    String? profileImage,
  }) = _UserInfoEntity;
}
