import 'package:equatable/equatable.dart';

class PriceEntity extends Equatable {
  final String? callout;
  final String? discount;
  final String? mrp;
  final String? type;
  final String? displayValue;
  final double? absoluteValue;

  const PriceEntity({
    this.callout,
    this.discount,
    this.mrp,
    this.type,
    this.displayValue,
    this.absoluteValue,
  });

  @override
  List<Object?> get props => [
    callout,
    discount,
    mrp,
    type,
    displayValue,
    absoluteValue,
  ];
}
