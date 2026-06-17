import 'package:equatable/equatable.dart';

class ServiceGuaranteeEntity extends Equatable {
  final String? icon;
  final String? label;

  const ServiceGuaranteeEntity({this.icon, this.label});

  @override
  List<Object?> get props => [icon, label];
}
