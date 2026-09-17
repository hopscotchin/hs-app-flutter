import 'package:equatable/equatable.dart';

import '../../../../core/network/models/action_response.dart';

/// Response from `GET /re-attempt/detail/{orderId}`.
class PaymentRetryEntity extends ActionResponse {
  final String? imageUrl;
  final String? title;
  final String? subtitle;
  final String? instruction;
  final AmountSummaryEntity? amountSummary;
  final PaymentFailureActionsEntity? actions;

  const PaymentRetryEntity({
    super.action,
    super.message,
    super.actionURI,
    super.messageBars,
    this.imageUrl,
    this.title,
    this.subtitle,
    this.instruction,
    this.amountSummary,
    this.actions,
  });

  PaymentRetryEntity.fromJson(
    super.json, {
    this.imageUrl,
    this.title,
    this.subtitle,
    this.instruction,
    this.amountSummary,
    this.actions,
  }) : super.fromJson();

  @override
  List<Object?> get props => [
    action,
    imageUrl,
    title,
    subtitle,
    instruction,
    amountSummary,
    actions,
  ];
}

class AmountSummaryEntity extends Equatable {
  final String? label;
  final String? value;

  const AmountSummaryEntity({this.label, this.value});

  @override
  List<Object?> get props => [label, value];
}

class PaymentFailureActionsEntity extends Equatable {
  final FailureActionEntity? primary;
  final FailureActionEntity? secondary;
  final FailureActionEntity? tertiary;

  const PaymentFailureActionsEntity({
    this.primary,
    this.secondary,
    this.tertiary,
  });

  @override
  List<Object?> get props => [primary, secondary, tertiary];
}

class FailureActionEntity extends Equatable {
  final String? label;
  final PaymentActionEntity? action;

  const FailureActionEntity({this.label, this.action});

  @override
  List<Object?> get props => [label, action];
}

class PaymentActionEntity extends Equatable {
  final String? type;
  final String? paymentMode;
  final String? url;

  const PaymentActionEntity({this.type, this.paymentMode, this.url});

  @override
  List<Object?> get props => [type, paymentMode, url];
}
