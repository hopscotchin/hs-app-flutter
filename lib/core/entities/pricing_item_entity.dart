import 'package:equatable/equatable.dart';

class PricingItemEntity extends Equatable {
  final String? label;
  final String? value;
  final String? type;
  final String? textColor;
  final String? subText;
  final String? actionTextToolTip;
  final bool hasInfoIcon;

  const PricingItemEntity({
    this.label,
    this.value,
    this.type,
    this.textColor,
    this.subText,
    this.actionTextToolTip,
    this.hasInfoIcon = false,
  });

  @override
  List<Object?> get props => [
    label,
    value,
    type,
    textColor,
    subText,
    actionTextToolTip,
    hasInfoIcon,
  ];
}
