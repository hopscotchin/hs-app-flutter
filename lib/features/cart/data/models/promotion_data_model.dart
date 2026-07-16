import '../../domain/entities/promotion_data_entity.dart';

class PromotionDataModel extends PromotionDataEntity {
  const PromotionDataModel({
    super.sectionTitle,
    super.promoCode,
    super.message,
    super.discountAmount,
    super.isApplied,
  });

  factory PromotionDataModel.fromJson(Map<String, dynamic> json) {
    final code = json['promoCode'] as String?;
    return PromotionDataModel(
      sectionTitle: json['sectionTitle'] as String?,
      promoCode: code,
      message: json['message'] as String?,
      discountAmount: json['discountAmount'] as int?,
      isApplied: code != null && code.isNotEmpty,
    );
  }
}
