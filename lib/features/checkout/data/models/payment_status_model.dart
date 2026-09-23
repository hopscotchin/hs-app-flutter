import '../../domain/entities/payment_status_entity.dart';

class PaymentStatusModel extends PaymentStatusEntity {
  const PaymentStatusModel({
    super.action,
    super.message,
    super.actionURI,
    super.messageBars,
    super.paymentStatusEnum,
    super.actionStatus,
    super.redirectionUrl,
    super.retryTime,
    super.totalTime,
    super.orderId,
    super.paymentMethod,
    super.paymentNotification,
  });

  PaymentStatusModel.fromJson(super.json)
    : super.fromJson(
        paymentStatusEnum: _parsePaymentState(json['paymentStatus']),
        actionStatus: _parseActionState(json['actionStatus']),
        redirectionUrl: json['redirectionUrl'] as String?,
        retryTime: (json['retryTime'] as num?)?.toInt(),
        totalTime: (json['totalTime'] as num?)?.toInt(),
        orderId: (json['orderId'] as num?)?.toInt(),
        paymentMethod: json['paymentMethod'] as String?,
        paymentNotification: _parseNotification(json['paymentNotification']),
        error: _parseError(json['error']),
      );

  static PaymentErrorEntity? _parseError(dynamic data) {
    if (data is! Map<String, dynamic>) return null;
    return PaymentErrorEntity(
      amount: (data['amount'] as num?)?.toDouble(),
      errorTitle: data['errorTitle'] as String?,
      errorMessage: data['errorMessage'] as String?,
    );
  }

  static PaymentState? _parsePaymentState(dynamic value) {
    if (value == null) return null;
    final str = value.toString().toLowerCase();
    switch (str) {
      case 'success':
        return PaymentState.success;
      case 'failure':
        return PaymentState.failure;
      case 'pending':
        return PaymentState.pending;
      default:
        return null;
    }
  }

  static ActionState? _parseActionState(dynamic value) {
    if (value == null) return null;
    final str = value.toString().toLowerCase();
    switch (str) {
      case 'success':
        return ActionState.success;
      case 'failure':
        return ActionState.failure;
      case 'pending':
        return ActionState.pending;
      case 'retry_payment':
      case 'retrypayment':
        return ActionState.retryPayment;
      default:
        return null;
    }
  }

  static PaymentNotificationModel? _parseNotification(dynamic data) {
    if (data is Map<String, dynamic>) {
      return PaymentNotificationModel.fromJson(data);
    }
    return null;
  }
}

class PaymentNotificationModel extends PaymentNotificationEntity {
  const PaymentNotificationModel({super.title, super.subtitle});

  factory PaymentNotificationModel.fromJson(Map<String, dynamic> json) {
    return PaymentNotificationModel(
      title: json['title'] as String?,
      // Server sends `subTitle` (capital T) — the lowercase key was
      // never populated, and the fallback banner relied on this.
      subtitle: (json['subTitle'] ?? json['subtitle']) as String?,
    );
  }
}
