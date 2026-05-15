import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_credentials_entity.freezed.dart';

@freezed
abstract class AuthCredentialsEntity with _$AuthCredentialsEntity {
  const factory AuthCredentialsEntity({
    String? persistentTicket,
    String? uuid,
  }) = _AuthCredentialsEntity;
}
