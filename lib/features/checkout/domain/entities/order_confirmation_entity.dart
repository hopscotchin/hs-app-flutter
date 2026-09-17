import 'package:equatable/equatable.dart';

import '../../../../core/entities/order_summary_entity.dart';
import '../../../../core/entities/pricing_item_entity.dart';
import '../../../../core/network/models/action_response.dart';
import 'order_confirmation_item_entity.dart';

/// Response from `GET /v2/checkout/{orderId}/confirmation`.
class OrderConfirmationEntity extends ActionResponse {
  final String? userId;
  final OrderConfirmationHeaderEntity? header;
  final OrderConfirmationDetailsEntity? orderDetails;
  final OrderSummaryEntity? orderSummary;
  final ConfirmationAddressEntity? address;
  final ConfirmationPaymentEntity? paymentDetails;

  const OrderConfirmationEntity({
    super.action,
    super.message,
    super.actionURI,
    super.messageBars,
    super.popUpMessage,
    this.userId,
    this.header,
    this.orderDetails,
    this.orderSummary,
    this.address,
    this.paymentDetails,
  });

  OrderConfirmationEntity.fromJson(
    super.json, {
    this.userId,
    this.header,
    this.orderDetails,
    this.orderSummary,
    this.address,
    this.paymentDetails,
  }) : super.fromJson();

  @override
  List<Object?> get props => [
    action,
    userId,
    header,
    orderDetails,
    orderSummary,
    address,
    paymentDetails,
  ];
}

// ─── Header ──────────────────────────────────────────────────────────────────

class OrderConfirmationHeaderEntity extends Equatable {
  final String? title;
  final String? subtitle;
  final String? imageUrl;
  final List<HeaderItemEntity> items;

  const OrderConfirmationHeaderEntity({
    this.title,
    this.subtitle,
    this.imageUrl,
    this.items = const [],
  });

  @override
  List<Object?> get props => [title, subtitle, imageUrl, items];
}

class HeaderItemEntity extends Equatable {
  final String? imageUrl;
  final String? action;

  const HeaderItemEntity({this.imageUrl, this.action});

  @override
  List<Object?> get props => [imageUrl, action];
}

// ─── Order Details ───────────────────────────────────────────────────────────

class OrderConfirmationDetailsEntity extends Equatable {
  final String? sectionTitle;
  final String? title;
  final String? subtitle;
  final String? orderId;
  final String? orderBarCode;
  final String? orderDate;
  final String? deliveryDate;
  final String? orderStatusCode;
  final bool? firstOrder;
  final int? itemCount;
  final int? totalQuantity;
  final double? productAmount;
  final double? totalAmount;
  final double? discount;
  final double? shipping;
  final double? payAmount;
  final double? totalCredit;
  final List<OrderConfirmationItemEntity> items;

  const OrderConfirmationDetailsEntity({
    this.sectionTitle,
    this.title,
    this.subtitle,
    this.orderId,
    this.orderBarCode,
    this.orderDate,
    this.deliveryDate,
    this.orderStatusCode,
    this.firstOrder,
    this.itemCount,
    this.totalQuantity,
    this.productAmount,
    this.totalAmount,
    this.discount,
    this.shipping,
    this.payAmount,
    this.totalCredit,
    this.items = const [],
  });

  @override
  List<Object?> get props => [
    sectionTitle,
    title,
    subtitle,
    orderId,
    orderBarCode,
    orderDate,
    deliveryDate,
    orderStatusCode,
    firstOrder,
    itemCount,
    totalQuantity,
    productAmount,
    totalAmount,
    discount,
    shipping,
    payAmount,
    totalCredit,
    items,
  ];
}

// ─── Address ─────────────────────────────────────────────────────────────────

class ConfirmationAddressEntity extends Equatable {
  final String? sectionTitle;
  final String? name;
  final String? addressLine;
  final String? displayAddress;
  final String? city;
  final String? state;
  final String? zipCode;
  final String? phone;
  final String? alternativePhone;

  const ConfirmationAddressEntity({
    this.sectionTitle,
    this.name,
    this.addressLine,
    this.displayAddress,
    this.city,
    this.state,
    this.zipCode,
    this.phone,
    this.alternativePhone,
  });

  String get formattedAddress {
    if (displayAddress != null && displayAddress!.isNotEmpty) {
      return displayAddress!;
    }
    return [
      addressLine,
      city,
      state,
      zipCode,
    ].where((s) => s != null && s.isNotEmpty).join(', ');
  }

  String get formattedPhone {
    final phones = <String>[];
    if (phone != null && phone!.isNotEmpty) phones.add(phone!);
    if (alternativePhone != null && alternativePhone!.isNotEmpty) {
      phones.add(alternativePhone!);
    }
    return phones.join(', ');
  }

  @override
  List<Object?> get props => [
    sectionTitle,
    name,
    addressLine,
    displayAddress,
    city,
    state,
    zipCode,
    phone,
    alternativePhone,
  ];
}

// ─── Payment Details ─────────────────────────────────────────────────────────

class ConfirmationPaymentEntity extends Equatable {
  final String? sectionTitle;
  final String? paymentMethod;
  final List<PayByEntity> payBy;

  const ConfirmationPaymentEntity({
    this.sectionTitle,
    this.paymentMethod,
    this.payBy = const [],
  });

  /// Converts payBy entries to pricing rows for the price summary.
  List<PricingItemEntity> get payByRows =>
      payBy.map((p) => PricingItemEntity(label: p.label, value: p.amount)).toList();

  @override
  List<Object?> get props => [sectionTitle, paymentMethod, payBy];
}

class PayByEntity extends Equatable {
  final String? label;
  final String? amount;

  const PayByEntity({this.label, this.amount});

  @override
  List<Object?> get props => [label, amount];
}
