import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/account_entity.dart';

part 'account_model.g.dart';

@JsonSerializable()
class AccountModel {
  const AccountModel({this.email, this.credit});

  final String? email;
  final double? credit;

  factory AccountModel.fromJson(Map<String, dynamic> json) =>
      _$AccountModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccountModelToJson(this);

  AccountEntity toEntity() => AccountEntity(email: email, credit: credit);
}
