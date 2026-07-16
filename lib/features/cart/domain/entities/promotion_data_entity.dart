import 'package:equatable/equatable.dart';

class PromotionDataEntity extends Equatable {
  final String? sectionTitle;
  final String? promoCode;
  final String? message;
  final int? discountAmount;
  final bool isApplied;

  const PromotionDataEntity({
    this.sectionTitle,
    this.promoCode,
    this.message,
    this.discountAmount,
    this.isApplied = false,
  });

  @override
  List<Object?> get props => [
    sectionTitle,
    promoCode,
    message,
    discountAmount,
    isApplied,
  ];
}
