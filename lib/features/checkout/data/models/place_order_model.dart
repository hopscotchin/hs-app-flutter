import '../../domain/entities/place_order_entity.dart';

class PlaceOrderModel extends PlaceOrderEntity {
  const PlaceOrderModel({
    super.action,
    super.message,
    super.actionURI,
    super.messageBars,
    super.orderId,
    super.recordId,
    super.orderBarcode,
    super.source,
  });

  PlaceOrderModel.fromJson(super.json)
    : super.fromJson(
        orderId: (json['orderId'] as num?)?.toInt(),
        recordId: (json['recordId'] as num?)?.toInt(),
        orderBarcode: json['orderBarcode'] as String?,
        source: json['source'] as String?,
      );
}
