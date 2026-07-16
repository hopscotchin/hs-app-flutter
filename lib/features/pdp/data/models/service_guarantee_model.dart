import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/service_guarantee_entity.dart';

part 'service_guarantee_model.g.dart';

@JsonSerializable(createToJson: false)
class ServiceGuaranteeModel {
  const ServiceGuaranteeModel({this.icon, this.label});

  @JsonKey(defaultValue: null) final String? icon;
  @JsonKey(defaultValue: null) final String? label;

  factory ServiceGuaranteeModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceGuaranteeModelFromJson(json);
}

extension ServiceGuaranteeModelX on ServiceGuaranteeModel {
  ServiceGuaranteeEntity toEntity() =>
      ServiceGuaranteeEntity(icon: icon, label: label);
}
