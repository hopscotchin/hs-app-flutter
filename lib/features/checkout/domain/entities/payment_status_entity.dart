import 'package:equatable/equatable.dart';

import '../../../../core/network/models/action_response.dart';

enum PaymentState { success, failure, pending }

enum ActionState { success, failure, pending, retryPayment }

/// Response from `GET /v1/{orderId}/payment-status`.
class PaymentStatusEntity extends ActionResponse {
  final PaymentState? paymentStatusEnum;
  final ActionState? actionStatus;
  final String? redirectionUrl;
  final int? retryTime;
  final int? totalTime;
  final int? orderId;
  final String? paymentMethod;
  final PaymentNotificationEntity? paymentNotification;

  const PaymentStatusEntity({
    super.action,
    super.message,
    super.actionURI,
    super.messageBars,
    this.paymentStatusEnum,
    this.actionStatus,
    this.redirectionUrl,
    this.retryTime,
    this.totalTime,
    this.orderId,
    this.paymentMethod,
    this.paymentNotification,
  });

  PaymentStatusEntity.fromJson(
    super.json, {
    this.paymentStatusEnum,
    this.actionStatus,
    this.redirectionUrl,
    this.retryTime,
    this.totalTime,
    this.orderId,
    this.paymentMethod,
    this.paymentNotification,
  }) : super.fromJson();

  @override
  List<Object?> get props => [
    action,
    paymentStatusEnum,
    actionStatus,
    orderId,
    paymentMethod,
    retryTime,
    totalTime,
  ];
}

class PaymentNotificationEntity extends Equatable {
  final String? title;
  final String? subtitle;

  const PaymentNotificationEntity({this.title, this.subtitle});

  @override
  List<Object?> get props => [title, subtitle];
}
