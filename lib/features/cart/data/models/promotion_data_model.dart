import '../../../../core/utils/json_parsers.dart';
import '../../domain/entities/promotion_data_entity.dart';

class PromotionDataModel extends PromotionDataEntity {
  const PromotionDataModel({
    super.sectionTitle,
    super.promoCode,
    super.message,
    super.discountAmount,
    super.isApplied,
    super.appliedCouponText,
    super.appliedCouponTextColor,
    super.savingsText,
    super.savingsTextColor,
  });

  factory PromotionDataModel.fromJson(Map<String, dynamic> json) {
    // New shape: a list of order-level promo codes, each with its own
    // `applied` flag — the cart UI only surfaces one "active" code at a
    // time, so prefer the applied one (falling back to the first entry).
    final codes = (json['orderPromocodes'] as List<dynamic>?)
        ?.whereType<Map<String, dynamic>>()
        .toList();
    if (codes != null && codes.isNotEmpty) {
      final active = codes.firstWhere(
        (c) => parseToBool(c['applied']),
        orElse: () => codes.first,
      );
      final discount = parseToDouble(active['discount']);
      return PromotionDataModel(
        promoCode: parseToStringOrNull(active['code']),
        discountAmount: discount == 0 ? null : discount.round(),
        isApplied: parseToBool(active['applied']),
        appliedCouponText: parseToStringOrNull(active['appliedCouponText']),
        appliedCouponTextColor: parseToStringOrNull(
          active['appliedCouponTextColor'],
        ),
        savingsText: parseToStringOrNull(active['savingsText']),
        savingsTextColor: parseToStringOrNull(active['savingsTextColor']),
      );
    }

    // Legacy shape: a single flat object.
    final code = json['promoCode'] as String?;
    return PromotionDataModel(
      sectionTitle: json['sectionTitle'] as String?,
      promoCode: code,
      message: json['message'] as String?,
      discountAmount: parseToIntOrNull(json['discountAmount']),
      isApplied: code != null && code.isNotEmpty,
    );
  }
}
