import '../../domain/entities/service_guarantee_entity.dart';

class ServiceGuaranteeModel extends ServiceGuaranteeEntity {
  const ServiceGuaranteeModel({super.icon, super.label});

  factory ServiceGuaranteeModel.fromJson(Map<String, dynamic> json) {
    return ServiceGuaranteeModel(
      icon: json['icon'] as String?,
      label: json['label'] as String?,
    );
  }
}
