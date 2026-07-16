import 'package:equatable/equatable.dart';

class ShippingFeeInfoEntity extends Equatable {
  final String? message;
  final double? shippingMinimum;
  final String? action;
  final String? actionLabel;
  final int? freeShippingThreshold;

  const ShippingFeeInfoEntity({
    this.message,
    this.shippingMinimum,
    this.action,
    this.actionLabel,
    this.freeShippingThreshold,
  });

  @override
  List<Object?> get props => [
    message,
    shippingMinimum,
    action,
    actionLabel,
    freeShippingThreshold,
  ];
}
