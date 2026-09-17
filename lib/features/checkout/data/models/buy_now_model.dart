import '../../domain/entities/buy_now_entity.dart';

class BuyNowModel extends BuyNowEntity {
  const BuyNowModel({
    super.action,
    super.message,
    super.actionURI,
    super.messageBars,
    super.address,
    super.orderSummary,
    super.userCredits,
    super.paymentDetails,
    super.paymentModeMessages,
    super.mobileNumber,
    super.isMobileVerified,
    super.hasAddress,
    super.hasEmail,
    super.showMobileScreen,
    super.isPhoneVerifiedForCod,
    super.refreshCartForRemovedItem,
    super.removedItemCount,
    super.redirectPath,
  });

  BuyNowModel.fromJson(super.json)
    : super.fromJson(
        address: _parseAddress(json),
        orderSummary: _parseOrderSummary(json),
        userCredits: _parseUserCredits(json),
        paymentDetails: _parsePaymentDetails(json),
        paymentModeMessages: _parsePaymentModeMessages(json),
        mobileNumber:
            (json['mobile'] as Map<String, dynamic>?)?['number'] as String?,
        isMobileVerified:
            (json['mobile'] as Map<String, dynamic>?)?['isVerified'] as bool?,
        hasAddress: json['hasAddress'] as bool?,
        hasEmail: json['hasEmail'] as bool?,
        showMobileScreen: json['showMobileScreen'] as bool?,
        isPhoneVerifiedForCod: json['isPhoneVerifiedForCod'] as bool?,
        refreshCartForRemovedItem: json['refreshCartForRemovedItem'] as bool?,
        removedItemCount: json['removedItemCount'] as int?,
        redirectPath: json['redirectPath'] as String?,
      );

  // ─── Parsers ──────────────────────────────────────────────────────────────

  static CheckoutAddressModel? _parseAddress(Map<String, dynamic> json) {
    final data = json['address'] as Map<String, dynamic>?;
    return data != null ? CheckoutAddressModel.fromJson(data) : null;
  }

  static CheckoutOrderSummaryModel? _parseOrderSummary(
    Map<String, dynamic> json,
  ) {
    final data = json['orderSummary'] as Map<String, dynamic>?;
    return data != null ? CheckoutOrderSummaryModel.fromJson(data) : null;
  }

  static UserCreditsModel? _parseUserCredits(Map<String, dynamic> json) {
    final data = json['userCredits'] as Map<String, dynamic>?;
    return data != null ? UserCreditsModel.fromJson(data) : null;
  }

  static PaymentDetailsModel? _parsePaymentDetails(Map<String, dynamic> json) {
    final data = json['paymentDetails'] as Map<String, dynamic>?;
    return data != null ? PaymentDetailsModel.fromJson(data) : null;
  }

  static List<PaymentModeMessageModel> _parsePaymentModeMessages(
    Map<String, dynamic> json,
  ) {
    final list = json['paymentModeMessage'] as List<dynamic>? ?? [];
    return list
        .map((e) => PaymentModeMessageModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

// ─── Address Model ────────────────────────────────────────────────────────────

class CheckoutAddressModel extends CheckoutAddressEntity {
  const CheckoutAddressModel({
    super.id,
    super.name,
    super.firstName,
    super.displayAddress,
    super.streetAddress,
    super.landmark,
    super.city,
    super.state,
    super.country,
    super.zipCode,
    super.cellPhone,
    super.isPrimary,
    super.canCod,
    super.canPol,
    super.isServicable,
  });

  factory CheckoutAddressModel.fromJson(Map<String, dynamic> json) {
    return CheckoutAddressModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      firstName: json['firstName'] as String?,
      displayAddress: json['displayAddress'] as String?,
      streetAddress: json['streetAddress'] as String?,
      landmark: json['landmark'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String?,
      zipCode: json['zipCode'] as String?,
      cellPhone: json['cellPhone'] as String?,
      isPrimary: json['isPrimary'] as bool?,
      canCod: json['canCod'] as bool?,
      canPol: json['canPol'] as bool?,
      isServicable: json['isServicable'] as bool?,
    );
  }
}

// ─── Order Summary Model ──────────────────────────────────────────────────────

class CheckoutOrderSummaryModel extends CheckoutOrderSummaryEntity {
  const CheckoutOrderSummaryModel({
    super.payableAmount,
    super.sectionTitle,
    super.subText,
    super.pricingData,
    super.totalOrderAmount,
    super.payAmount,
    super.creditsAmount,
    super.hasGift,
  });

  factory CheckoutOrderSummaryModel.fromJson(Map<String, dynamic> json) {
    return CheckoutOrderSummaryModel(
      payableAmount: (json['payableAmount'] as num?)?.toInt(),
      sectionTitle: json['sectionTitle'] as String?,
      subText: json['subText'] as String?,
      pricingData: (json['pricingData'] as List<dynamic>? ?? [])
          .map((e) => PricingDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalOrderAmount: _parsePayAmount(json['totalOrderAmount']),
      payAmount: _parsePayAmount(json['payAmount']),
      creditsAmount: _parsePayAmount(json['creditsAmount']),
      hasGift: json['hasGift'] as bool?,
    );
  }

  static PayAmountModel? _parsePayAmount(dynamic data) {
    if (data is Map<String, dynamic>) return PayAmountModel.fromJson(data);
    return null;
  }
}

class PricingDataModel extends PricingDataEntity {
  const PricingDataModel({super.key, super.value, super.textColor});

  factory PricingDataModel.fromJson(Map<String, dynamic> json) {
    return PricingDataModel(
      key: json['key'] as String?,
      value: json['value'] as String?,
      textColor: json['textColor'] as String?,
    );
  }
}

class PayAmountModel extends PayAmountEntity {
  const PayAmountModel({super.label, super.value, super.textColor});

  factory PayAmountModel.fromJson(Map<String, dynamic> json) {
    return PayAmountModel(
      label: json['label'] as String?,
      value: json['value'] as String?,
      textColor: json['textColor'] as String?,
    );
  }
}

// ─── User Credits Model ───────────────────────────────────────────────────────

class UserCreditsModel extends UserCreditsEntity {
  const UserCreditsModel({
    super.sectionTitle,
    super.amount,
    super.displayText,
    super.active,
    super.applied,
    super.sign,
    super.creditType,
    super.creditName,
    super.displaySubText,
  });

  factory UserCreditsModel.fromJson(Map<String, dynamic> json) {
    return UserCreditsModel(
      sectionTitle: json['sectionTitle'] as String?,
      amount: (json['amount'] as num?)?.toInt(),
      displayText: json['displayText'] as String?,
      active: json['active'] as bool? ?? false,
      applied: json['applied'] as bool? ?? false,
      sign: json['sign'] as String?,
      creditType: json['creditType'] as String?,
      creditName: json['creditName'] as String?,
      displaySubText: json['displaySubText'] as String?,
    );
  }
}

// ─── Payment Details Model ────────────────────────────────────────────────────

class PaymentDetailsModel extends PaymentDetailsEntity {
  const PaymentDetailsModel({
    super.paymentMode,
    super.paymentLabel,
    super.isEnabled,
  });

  factory PaymentDetailsModel.fromJson(Map<String, dynamic> json) {
    return PaymentDetailsModel(
      paymentMode: json['paymentMode'] as String?,
      paymentLabel: json['paymentLabel'] as String?,
      isEnabled: json['isEnabled'] as bool?,
    );
  }
}

// ─── Payment Mode Message Model ───────────────────────────────────────────────

class PaymentModeMessageModel extends PaymentModeMessageEntity {
  const PaymentModeMessageModel({
    super.type,
    super.label,
    super.selected,
    super.activeMessage,
    super.activeColor,
    super.inActiveMessage,
    super.inActiveColor,
    super.ctaText,
    super.payableAmount,
    super.chargeAdjustment,
  });

  factory PaymentModeMessageModel.fromJson(Map<String, dynamic> json) {
    return PaymentModeMessageModel(
      type: json['type'] as String?,
      label: json['label'] as String?,
      selected: json['selected'] as bool? ?? false,
      activeMessage: json['activeMessage'] as String?,
      activeColor: json['activeColor'] as String?,
      inActiveMessage: json['inActiveMessage'] as String?,
      inActiveColor: json['inActiveColor'] as String?,
      ctaText: json['ctaText'] as String?,
      payableAmount: (json['payableAmount'] as num?)?.toInt(),
      chargeAdjustment: (json['chargeAdjustment'] as num?)?.toInt(),
    );
  }
}
