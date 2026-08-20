import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_guarantee_entity.freezed.dart';

@freezed
abstract class ServiceGuaranteeEntity with _$ServiceGuaranteeEntity {
  const factory ServiceGuaranteeEntity({String? icon, String? label}) = _ServiceGuaranteeEntity;
}
