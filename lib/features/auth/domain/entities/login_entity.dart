import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/entities/message_bar_entity.dart';

part 'login_entity.freezed.dart';

@freezed
abstract class LoginEntity with _$LoginEntity {
  const factory LoginEntity({
    String? userId,
    String? firstName,
    String? lastName,
    String? userName,
    String? persistentTicket,
    String? loginId,
    @Default(0) int timer,
    String? email,
    String? phoneNumber,
    @Default(6) int otpLength,
    String? profileImage,
    @Default(false) bool isLoggedIn,
    @Default(false) bool isRegister,
    @Default(0) int cartItemQty,
    String? mobileStatus,
    String? popUpMessage,
    String? action,
    MessageBarEntity? messageBar,
  }) = _LoginEntity;
}
