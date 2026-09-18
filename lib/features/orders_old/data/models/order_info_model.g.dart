// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrderInfoModel _$OrderInfoModelFromJson(Map<String, dynamic> json) =>
    _OrderInfoModel(
      barCode: json['barCode'] as String?,
      orderId: json['orderId'] as String?,
      iconStatus: json['iconStatus'] as String?,
      productId: json['productId'] == null ? 0 : parseToInt(json['productId']),
      hsBrandLabel: json['hsBrandLabel'] as String?,
      productName: json['productName'] as String? ?? '',
      productImageUrl: json['productImageUrl'] as String?,
      productSize: json['productSize'] as String?,
      orderItemId: (json['orderItemId'] as num?)?.toInt() ?? 0,
      itemCounts: (json['itemCounts'] as num?)?.toInt() ?? 0,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      deliveryMessage: json['deliveryMessage'] == null
          ? null
          : DeliveryMessageInfoModel.fromJson(
              json['deliveryMessage'] as Map<String, dynamic>,
            ),
      returnTagMessage: json['returnTagMessage'] == null
          ? null
          : ReturnInfoMessageModel.fromJson(
              json['returnTagMessage'] as Map<String, dynamic>,
            ),
      isGift: json['isGift'] as bool? ?? false,
    );

Map<String, dynamic> _$OrderInfoModelToJson(_OrderInfoModel instance) =>
    <String, dynamic>{
      'barCode': instance.barCode,
      'orderId': instance.orderId,
      'iconStatus': instance.iconStatus,
      'productId': instance.productId,
      'hsBrandLabel': instance.hsBrandLabel,
      'productName': instance.productName,
      'productImageUrl': instance.productImageUrl,
      'productSize': instance.productSize,
      'orderItemId': instance.orderItemId,
      'itemCounts': instance.itemCounts,
      'amount': instance.amount,
      'deliveryMessage': instance.deliveryMessage,
      'returnTagMessage': instance.returnTagMessage,
      'isGift': instance.isGift,
    };

_DeliveryMessageInfoModel _$DeliveryMessageInfoModelFromJson(
  Map<String, dynamic> json,
) => _DeliveryMessageInfoModel(
  deliveryMessage: json['deliveryMessage'] as String?,
  orderItemActionMessage: json['orderItemActionMessage'] as String?,
  secondaryMessage: json['secondaryMessage'] as String?,
  delayedDeliveryMessage: json['delayedDeliveryMessage'] as String?,
  previousEstimatedDeliveryDate:
      json['previousEstimatedDeliveryDate'] as String?,
  color: json['color'] as String?,
);

Map<String, dynamic> _$DeliveryMessageInfoModelToJson(
  _DeliveryMessageInfoModel instance,
) => <String, dynamic>{
  'deliveryMessage': instance.deliveryMessage,
  'orderItemActionMessage': instance.orderItemActionMessage,
  'secondaryMessage': instance.secondaryMessage,
  'delayedDeliveryMessage': instance.delayedDeliveryMessage,
  'previousEstimatedDeliveryDate': instance.previousEstimatedDeliveryDate,
  'color': instance.color,
};

_ReturnInfoMessageModel _$ReturnInfoMessageModelFromJson(
  Map<String, dynamic> json,
) => _ReturnInfoMessageModel(
  qcAndWrTagSuccess: json['qcAndWrTagSuccess'] as bool? ?? false,
  mobileNumber: json['mobileNumber'] as String?,
  message: json['message'] as String?,
);

Map<String, dynamic> _$ReturnInfoMessageModelToJson(
  _ReturnInfoMessageModel instance,
) => <String, dynamic>{
  'qcAndWrTagSuccess': instance.qcAndWrTagSuccess,
  'mobileNumber': instance.mobileNumber,
  'message': instance.message,
};
