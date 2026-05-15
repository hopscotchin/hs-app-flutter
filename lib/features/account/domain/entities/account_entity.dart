import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_entity.freezed.dart';

@freezed
abstract class AccountEntity with _$AccountEntity {
  const factory AccountEntity({
    String? customerId,
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
    @Default(false) bool isLoggedIn,
    @Default(false) bool hasGuestData,
    double? credit,
  }) = _AccountEntity;
}
