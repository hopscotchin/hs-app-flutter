import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/auth_credentials/auth_credentials_entity.dart';

part 'auth_credentials_model.g.dart';

@JsonSerializable(createToJson: false)
class AuthCredentialsModel {
  const AuthCredentialsModel({this.persistentTicket, this.uuid});

  final String? persistentTicket;
  final String? uuid;

  factory AuthCredentialsModel.fromJson(Map<String, dynamic> json) =>
      _$AuthCredentialsModelFromJson(json);
}

extension AuthCredentialsModelX on AuthCredentialsModel {
  AuthCredentialsEntity toEntity() =>
      AuthCredentialsEntity(persistentTicket: persistentTicket, uuid: uuid);
}
