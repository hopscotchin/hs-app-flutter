import 'package:equatable/equatable.dart';

import '../../../../core/entities/backend_action_entity.dart';
import '../../../../core/network/models/action_response.dart';

/// Response from `GET /checkout/buy-now/v4`.
/// Mirrors Android's `BuyNowResponse`.
class BuyNowEntity extends ActionResponse {
  final CheckoutAddressEntity? address;
  final CheckoutOrderSummaryEntity? orderSummary;
  final UserCreditsEntity? userCredits;
  final PaymentDetailsEntity? paymentDetails;
  final List<PaymentModeMessageEntity> paymentModeMessages;
  final String? mobileNumber;
  final bool? isMobileVerified;
  final bool? hasAddress;
  final bool? hasEmail;
  final bool? showMobileScreen;
  final bool? isPhoneVerifiedForCod;
  final bool? refreshCartForRemovedItem;
  final int? removedItemCount;
  final String? redirectPath;

  /// Present when the server returns `action: "failure"` with a structured
  /// next step — e.g. "All sold out → Review bag". Rendered as an
  /// [AppBottomSheet] (dialog today, may be inline content next).
  final BackendActionContentEntity? content;

  const BuyNowEntity({
    super.action,
    super.message,
    super.actionURI,
    super.messageBars,
    this.address,
    this.orderSummary,
    this.userCredits,
    this.paymentDetails,
    this.paymentModeMessages = const [],
    this.mobileNumber,
    this.isMobileVerified,
    this.hasAddress,
    this.hasEmail,
    this.showMobileScreen,
    this.isPhoneVerifiedForCod,
    this.refreshCartForRemovedItem,
    this.removedItemCount,
    this.redirectPath,
    this.content,
  });

  BuyNowEntity.fromJson(
    super.json, {
    this.address,
    this.orderSummary,
    this.userCredits,
    this.paymentDetails,
    this.paymentModeMessages = const [],
    this.mobileNumber,
    this.isMobileVerified,
    this.hasAddress,
    this.hasEmail,
    this.showMobileScreen,
    this.isPhoneVerifiedForCod,
    this.refreshCartForRemovedItem,
    this.removedItemCount,
    this.redirectPath,
    this.content,
  }) : super.fromJson();

  @override
  List<Object?> get props => [
    action,
    message,
    address,
    orderSummary,
    userCredits,
    paymentDetails,
    paymentModeMessages,
    hasAddress,
    refreshCartForRemovedItem,
    removedItemCount,
    messageBars,
    content,
  ];
}

// ─── Address ──────────────────────────────────────────────────────────────────

class CheckoutAddressEntity extends Equatable {
  final int? id;
  final String? name;
  final String? firstName;
  final String? displayAddress;
  final String? streetAddress;
  final String? landmark;
  final String? city;
  final String? state;
  final String? country;
  final String? zipCode;
  final String? cellPhone;
  final bool? isPrimary;
  final bool? canCod;
  final bool? canPol;
  final bool? isServicable;

  const CheckoutAddressEntity({
    this.id,
    this.name,
    this.firstName,
    this.displayAddress,
    this.streetAddress,
    this.landmark,
    this.city,
    this.state,
    this.country,
    this.zipCode,
    this.cellPhone,
    this.isPrimary,
    this.canCod,
    this.canPol,
    this.isServicable,
  });

  @override
  List<Object?> get props => [id, name, displayAddress, zipCode, cellPhone];
}

// ─── Order Summary ────────────────────────────────────────────────────────────

class CheckoutOrderSummaryEntity extends Equatable {
  final int? payableAmount;
  final String? sectionTitle;
  final String? subText;
  final List<PricingDataEntity> pricingData;
  final PayAmountEntity? totalOrderAmount;
  final PayAmountEntity? payAmount;
  final PayAmountEntity? creditsAmount;
  final bool? hasGift;

  const CheckoutOrderSummaryEntity({
    this.payableAmount,
    this.sectionTitle,
    this.subText,
    this.pricingData = const [],
    this.totalOrderAmount,
    this.payAmount,
    this.creditsAmount,
    this.hasGift,
  });

  @override
  List<Object?> get props => [
    payableAmount,
    pricingData,
    totalOrderAmount,
    payAmount,
    creditsAmount,
  ];
}

class PricingDataEntity extends Equatable {
  final String? key;
  final String? value;
  final String? textColor;

  const PricingDataEntity({this.key, this.value, this.textColor});

  @override
  List<Object?> get props => [key, value];
}

class PayAmountEntity extends Equatable {
  final String? label;
  final String? value;
  final String? textColor;

  const PayAmountEntity({this.label, this.value, this.textColor});

  @override
  List<Object?> get props => [label, value];
}

// ─── User Credits ─────────────────────────────────────────────────────────────

class UserCreditsEntity extends Equatable {
  final String? sectionTitle;
  final int? amount;
  final String? displayText;
  final bool active;
  final bool applied;
  final String? sign;
  final String? creditType;
  final String? creditName;
  final String? displaySubText;

  const UserCreditsEntity({
    this.sectionTitle,
    this.amount,
    this.displayText,
    this.active = false,
    this.applied = false,
    this.sign,
    this.creditType,
    this.creditName,
    this.displaySubText,
  });

  @override
  List<Object?> get props => [amount, active, applied, creditType];
}

// ─── Payment Details ──────────────────────────────────────────────────────────

class PaymentDetailsEntity extends Equatable {
  final String? paymentMode;
  final String? paymentLabel;
  final bool? isEnabled;

  const PaymentDetailsEntity({
    this.paymentMode,
    this.paymentLabel,
    this.isEnabled,
  });

  @override
  List<Object?> get props => [paymentMode, paymentLabel, isEnabled];
}

// ─── Payment Mode Message ─────────────────────────────────────────────────────

class PaymentModeMessageEntity extends Equatable {
  final String? type;
  final String? label;
  final bool selected;
  final String? activeMessage;
  final String? activeColor;
  final String? inActiveMessage;
  final String? inActiveColor;
  final String? ctaText;
  final int? payableAmount;
  final int? chargeAdjustment;

  const PaymentModeMessageEntity({
    this.type,
    this.label,
    this.selected = false,
    this.activeMessage,
    this.activeColor,
    this.inActiveMessage,
    this.inActiveColor,
    this.ctaText,
    this.payableAmount,
    this.chargeAdjustment,
  });

  @override
  List<Object?> get props => [type, label, selected, payableAmount];
}
