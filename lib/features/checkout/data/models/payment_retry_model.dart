import '../../domain/entities/payment_retry_entity.dart';

class PaymentRetryModel extends PaymentRetryEntity {
  const PaymentRetryModel({
    super.action,
    super.message,
    super.actionURI,
    super.messageBars,
    super.imageUrl,
    super.title,
    super.subtitle,
    super.instruction,
    super.amountSummary,
    super.actions,
  });

  PaymentRetryModel.fromJson(super.json)
    : super.fromJson(
        imageUrl: _parseImageUrl(json),
        title: json['title'] as String?,
        subtitle: json['subtitle'] as String?,
        instruction: json['instruction'] as String?,
        amountSummary: _parseAmountSummary(json['amountSummary']),
        actions: _parseActions(json['actions']),
      );

  /// Server sends the retry hero image as `media.url`; older/CDN paths
  /// used a flat `imageUrl`. Read both.
  static String? _parseImageUrl(Map<String, dynamic> json) {
    final media = json['media'];
    if (media is Map<String, dynamic>) {
      final url = media['url'];
      if (url is String) return url;
    }
    return json['imageUrl'] as String?;
  }

  static AmountSummaryModel? _parseAmountSummary(dynamic data) {
    if (data is Map<String, dynamic>) {
      return AmountSummaryModel.fromJson(data);
    }
    return null;
  }

  static PaymentFailureActionsModel? _parseActions(dynamic data) {
    if (data is Map<String, dynamic>) {
      return PaymentFailureActionsModel.fromJson(data);
    }
    return null;
  }
}

class AmountSummaryModel extends AmountSummaryEntity {
  const AmountSummaryModel({super.label, super.value});

  factory AmountSummaryModel.fromJson(Map<String, dynamic> json) {
    // Server sends `value` as a nested object
    // `{amount, currency, displayValue}` — the raw String cast this used
    // to do threw and aborted the whole retry-detail parse. Read the
    // display string; fall back to the raw value if the server ever
    // reverts to a flat string.
    final raw = json['value'];
    final String? display;
    if (raw is Map<String, dynamic>) {
      display = raw['displayValue'] as String?;
    } else if (raw is String) {
      display = raw;
    } else {
      display = null;
    }
    return AmountSummaryModel(
      label: json['label'] as String?,
      value: display,
    );
  }
}

class PaymentFailureActionsModel extends PaymentFailureActionsEntity {
  const PaymentFailureActionsModel({
    super.primary,
    super.secondary,
    super.tertiary,
  });

  factory PaymentFailureActionsModel.fromJson(Map<String, dynamic> json) {
    return PaymentFailureActionsModel(
      primary: _parseAction(json['primary']),
      secondary: _parseAction(json['secondary']),
      tertiary: _parseAction(json['tertiary']),
    );
  }

  static FailureActionModel? _parseAction(dynamic data) {
    if (data is Map<String, dynamic>) {
      return FailureActionModel.fromJson(data);
    }
    return null;
  }
}

class FailureActionModel extends FailureActionEntity {
  const FailureActionModel({super.label, super.action});

  factory FailureActionModel.fromJson(Map<String, dynamic> json) {
    return FailureActionModel(
      label: json['label'] as String?,
      action: _parsePaymentAction(json['action']),
    );
  }

  static PaymentActionModel? _parsePaymentAction(dynamic data) {
    if (data is Map<String, dynamic>) {
      return PaymentActionModel.fromJson(data);
    }
    return null;
  }
}

class PaymentActionModel extends PaymentActionEntity {
  const PaymentActionModel({super.type, super.paymentMode, super.url});

  factory PaymentActionModel.fromJson(Map<String, dynamic> json) {
    return PaymentActionModel(
      type: json['type'] as String?,
      paymentMode: json['paymentMode'] as String?,
      url: json['url'] as String?,
    );
  }
}
