import 'package:equatable/equatable.dart';

/// A single trust/assurance badge (icon + label) — e.g. "Genuine Products",
/// "Easy Returns", "Secure Payments". Shared shape used by both the Cart
/// ("serviceLevelGuarantee") and PDP ("serviceGuarantee") backend payloads.
class ServiceGuaranteeEntity extends Equatable {
  final String? icon;
  final String? label;

  const ServiceGuaranteeEntity({this.icon, this.label});

  @override
  List<Object?> get props => [icon, label];
}
