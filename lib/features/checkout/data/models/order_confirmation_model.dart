import '../../../../core/models/order_summary_model.dart';
import '../../domain/entities/order_confirmation_entity.dart';
import 'order_confirmation_item_model.dart';

class OrderConfirmationModel extends OrderConfirmationEntity {
  const OrderConfirmationModel({
    super.action,
    super.message,
    super.actionURI,
    super.messageBars,
    super.popUpMessage,
    super.userId,
    super.header,
    super.orderDetails,
    super.orderSummary,
    super.address,
    super.paymentDetails,
  });

  OrderConfirmationModel.fromJson(super.json)
    : super.fromJson(
        userId: json['userId']?.toString(),
        header: _parseHeader(json['header']),
        orderDetails: _parseOrderDetails(json['orderDetails']),
        orderSummary: _parseOrderSummary(json['orderSummary']),
        address: _parseAddress(json['address']),
        paymentDetails: _parsePaymentDetails(json['paymentDetails']),
      );

  static OrderConfirmationHeaderModel? _parseHeader(dynamic data) {
    if (data is Map<String, dynamic>) {
      return OrderConfirmationHeaderModel.fromJson(data);
    }
    return null;
  }

  static OrderConfirmationDetailsModel? _parseOrderDetails(dynamic data) {
    if (data is Map<String, dynamic>) {
      return OrderConfirmationDetailsModel.fromJson(data);
    }
    return null;
  }

  static OrderSummaryModel? _parseOrderSummary(dynamic data) {
    if (data is Map<String, dynamic>) {
      return OrderSummaryModel.fromJson(data);
    }
    return null;
  }

  static ConfirmationAddressModel? _parseAddress(dynamic data) {
    if (data is Map<String, dynamic>) {
      return ConfirmationAddressModel.fromJson(data);
    }
    return null;
  }

  static ConfirmationPaymentModel? _parsePaymentDetails(dynamic data) {
    if (data is Map<String, dynamic>) {
      return ConfirmationPaymentModel.fromJson(data);
    }
    return null;
  }
}

// ─── Header Model ────────────────────────────────────────────────────────────

class OrderConfirmationHeaderModel extends OrderConfirmationHeaderEntity {
  const OrderConfirmationHeaderModel({
    super.title,
    super.subtitle,
    super.imageUrl,
    super.items,
  });

  factory OrderConfirmationHeaderModel.fromJson(Map<String, dynamic> json) {
    return OrderConfirmationHeaderModel(
      title: json['title'] as String?,
      subtitle: json['subtitle'] as String?,
      imageUrl: json['imageUrl'] as String?,
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => HeaderItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }
}

class HeaderItemModel extends HeaderItemEntity {
  const HeaderItemModel({super.imageUrl, super.action});

  factory HeaderItemModel.fromJson(Map<String, dynamic> json) {
    return HeaderItemModel(
      imageUrl: json['imageUrl'] as String?,
      action: json['action'] as String?,
    );
  }
}

// ─── Order Details Model ─────────────────────────────────────────────────────

class OrderConfirmationDetailsModel extends OrderConfirmationDetailsEntity {
  const OrderConfirmationDetailsModel({
    super.sectionTitle,
    super.title,
    super.subtitle,
    super.orderId,
    super.orderBarCode,
    super.orderDate,
    super.deliveryDate,
    super.orderStatusCode,
    super.firstOrder,
    super.itemCount,
    super.totalQuantity,
    super.productAmount,
    super.totalAmount,
    super.discount,
    super.shipping,
    super.payAmount,
    super.totalCredit,
    super.items,
  });

  factory OrderConfirmationDetailsModel.fromJson(Map<String, dynamic> json) {
    return OrderConfirmationDetailsModel(
      sectionTitle: json['sectionTitle'] as String?,
      title: json['title'] as String?,
      subtitle: json['subtitle'] as String?,
      orderId: json['orderId']?.toString(),
      orderBarCode: json['orderBarCode'] as String?,
      orderDate: json['orderDate'] as String?,
      deliveryDate: json['deliveryDate'] as String?,
      orderStatusCode: json['orderStatusCode'] as String?,
      firstOrder: json['firstOrder'] as bool?,
      itemCount: (json['itemCount'] as num?)?.toInt(),
      totalQuantity: (json['totalQuantity'] as num?)?.toInt(),
      productAmount: (json['productAmount'] as num?)?.toDouble(),
      totalAmount: (json['totalAmount'] as num?)?.toDouble(),
      discount: (json['discount'] as num?)?.toDouble(),
      shipping: (json['shipping'] as num?)?.toDouble(),
      payAmount: (json['payAmount'] as num?)?.toDouble(),
      totalCredit: (json['totalCredit'] as num?)?.toDouble(),
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => OrderConfirmationItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }
}

// ─── Address Model ───────────────────────────────────────────────────────────

class ConfirmationAddressModel extends ConfirmationAddressEntity {
  const ConfirmationAddressModel({
    super.sectionTitle,
    super.name,
    super.addressLine,
    super.displayAddress,
    super.city,
    super.state,
    super.zipCode,
    super.phone,
    super.alternativePhone,
  });

  factory ConfirmationAddressModel.fromJson(Map<String, dynamic> json) {
    return ConfirmationAddressModel(
      sectionTitle: json['sectionTitle'] as String? ?? json['title'] as String?,
      name: json['name'] as String?,
      addressLine:
          json['addressLine'] as String? ?? json['streetAddress'] as String?,
      displayAddress: json['displayAddress'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      zipCode: json['zipCode'] as String?,
      phone: json['phone'] as String? ?? json['cellPhone'] as String?,
      alternativePhone: json['alternativePhoneNumber'] as String?,
    );
  }
}

// ─── Payment Details Model ───────────────────────────────────────────────────

class ConfirmationPaymentModel extends ConfirmationPaymentEntity {
  const ConfirmationPaymentModel({
    super.sectionTitle,
    super.paymentMethod,
    super.payBy,
  });

  factory ConfirmationPaymentModel.fromJson(Map<String, dynamic> json) {
    return ConfirmationPaymentModel(
      sectionTitle: json['sectionTitle'] as String?,
      paymentMethod: json['paymentMethod'] as String?,
      payBy:
          (json['payBy'] as List<dynamic>?)
              ?.map((e) => PayByModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }
}

class PayByModel extends PayByEntity {
  const PayByModel({super.label, super.amount});

  factory PayByModel.fromJson(Map<String, dynamic> json) {
    return PayByModel(
      label: json['value'] as String?,
      amount: json['amount'] as String?,
    );
  }
}
