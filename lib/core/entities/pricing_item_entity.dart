import 'package:equatable/equatable.dart';

import 'backend_action_entity.dart';

class PricingItemEntity extends Equatable {
  final String? label;
  final String? value;
  final String? textColor;
  final String? subText;
  final String? subTextColor;
  final BackendActionEntity? action;

  /// Original (pre-override) value + color — e.g. shipping fee showing a
  /// struck-through "₹50" before landing on a final "Free". Null when the
  /// backend has nothing to strike through.
  final String? originalValue;
  final String? originalColor;

  const PricingItemEntity({
    this.label,
    this.value,
    this.textColor,
    this.subText,
    this.subTextColor,
    this.action,
    this.originalValue,
    this.originalColor,
  });

  @override
  List<Object?> get props => [
    label,
    value,
    textColor,
    subText,
    subTextColor,
    action,
    originalValue,
    originalColor,
  ];
}
