import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_info_entity.freezed.dart';

@freezed
abstract class OrderInfoEntity with _$OrderInfoEntity {
  const factory OrderInfoEntity({
    String? barCode,
    String? orderId,
    String? iconStatus,
    @Default(0) int productId,
    String? hsBrandLabel,
    @Default('') String productName,
    String? productImageUrl,
    String? productSize,
    @Default(0) int orderItemId,
    @Default(0) int itemCounts,
    @Default(0.0) double amount,
    DeliveryMessageInfoEntity? deliveryMessage,
    ReturnInfoMessageEntity? returnTagMessage,
    @Default(false) bool isGift,
  }) = _OrderInfoEntity;
}

@freezed
abstract class DeliveryMessageInfoEntity with _$DeliveryMessageInfoEntity {
  const factory DeliveryMessageInfoEntity({
    String? deliveryMessage,
    String? orderItemActionMessage,
    String? secondaryMessage,
    String? delayedDeliveryMessage,
    String? previousEstimatedDeliveryDate,
    String? color,
  }) = _DeliveryMessageInfoEntity;
}

@freezed
abstract class ReturnInfoMessageEntity with _$ReturnInfoMessageEntity {
  const factory ReturnInfoMessageEntity({
    @Default(false) bool qcAndWrTagSuccess,
    String? mobileNumber,
    String? message,
  }) = _ReturnInfoMessageEntity;
}
