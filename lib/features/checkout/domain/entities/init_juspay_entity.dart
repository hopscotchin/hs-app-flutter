import '../../../../core/network/models/action_response.dart';

/// Response from `POST /v2/init-payment`.
class InitJusPayEntity extends ActionResponse {
  final String? status;
  final String? id;
  final String? orderId;
  final dynamic sdkPayload;

  const InitJusPayEntity({
    super.action,
    super.message,
    super.actionURI,
    super.messageBars,
    this.status,
    this.id,
    this.orderId,
    this.sdkPayload,
  });

  InitJusPayEntity.fromJson(
    super.json, {
    this.status,
    this.id,
    this.orderId,
    this.sdkPayload,
  }) : super.fromJson();

  @override
  List<Object?> get props => [action, status, id, orderId];
}
