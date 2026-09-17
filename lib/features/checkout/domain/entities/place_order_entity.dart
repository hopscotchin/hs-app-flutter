import '../../../../core/network/models/action_response.dart';

/// Response from `POST /checkout/v4/place-order`.
class PlaceOrderEntity extends ActionResponse {
  final int? orderId;
  final int? recordId;
  final String? orderBarcode;
  final String? source;

  const PlaceOrderEntity({
    super.action,
    super.message,
    super.actionURI,
    super.messageBars,
    this.orderId,
    this.recordId,
    this.orderBarcode,
    this.source,
  });

  PlaceOrderEntity.fromJson(
    super.json, {
    this.orderId,
    this.recordId,
    this.orderBarcode,
    this.source,
  }) : super.fromJson();

  @override
  List<Object?> get props => [action, orderId, recordId, orderBarcode, source];
}
