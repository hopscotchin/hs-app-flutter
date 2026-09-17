import '../../domain/entities/init_juspay_entity.dart';

class InitJusPayModel extends InitJusPayEntity {
  const InitJusPayModel({
    super.action,
    super.message,
    super.actionURI,
    super.messageBars,
    super.status,
    super.id,
    super.orderId,
    super.sdkPayload,
  });

  InitJusPayModel.fromJson(super.json)
    : super.fromJson(
        status: json['status'] as String?,
        id: json['id']?.toString(),
        orderId: json['order_id']?.toString() ?? json['orderId']?.toString(),
        sdkPayload: json['sdk_payload'] ?? json['sdkPayload'],
      );
}
