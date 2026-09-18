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
    super.promoTrackingMeta,
    super.promoAppliedCount,
  });

  factory PromotionDataModel.fromJson(Map<String, dynamic> json) {
    // New shape: a list of order-level promo codes. Each entry carries its
    // display strings at the top level and every analytics value inside its own
    // `trackingMeta`. The cart UI surfaces one "active" code at a time, so
    // prefer the applied one (falling back to the first entry).
    final entries = (json['orderPromocodes'] as List<dynamic>?)
        ?.whereType<Map<String, dynamic>>()
        .toList();

    if (entries != null && entries.isNotEmpty) {
      // One flat view of an entry: its own fields, overlaid with its
      // `trackingMeta`. Merged rather than one-or-the-other because the split
      // is per field and still moving — `applied` is always on the entry,
      // `isMerchRule` always in the block, and `code` / `discount` have been
      // on either. Returning the block *instead of* the entry hid every
      // entry-level field, reading `applied: false` for a live promo.
      //
      // The block wins a collision (it is the analytics-owned copy). Safe to
      // merge because this block is mapped, not forwarded — see
      // `CartPromoPayload`.
      Map<String, dynamic> blockOf(Map<String, dynamic> entry) {
        final meta = entry['trackingMeta'];
        if (meta is! Map<String, dynamic> || meta.isEmpty) return entry;
        return <String, dynamic>{...entry, ...meta}..remove('trackingMeta');
      }

      // The array holds one entry today, but which one is "active" is still
      // resolved rather than assumed — a response with a stale unapplied code
      // first would otherwise render and report the wrong one.
      final activeIndex = entries.indexWhere(
        (entry) => PromotionDataEntity.isPromoApplied(blockOf(entry)),
      );
      final resolved = activeIndex == -1 ? 0 : activeIndex;
      final activeEntry = entries[resolved];
      final activeBlock = blockOf(activeEntry);

      final code = activeBlock['code'];
      final discount = parseToDouble(activeBlock['discount']);

      return PromotionDataModel(
        promoCode: (code is String && code.isNotEmpty) ? code : null,
        discountAmount: discount == 0 ? null : discount.round(),
        isApplied: PromotionDataEntity.isPromoApplied(activeBlock),
        // Display strings stay on the promo object itself — they are never
        // moved into trackingMeta, which carries analytics values only.
        appliedCouponText: parseToStringOrNull(activeEntry['appliedCouponText']),
        appliedCouponTextColor: parseToStringOrNull(activeEntry['appliedCouponTextColor']),
        savingsText: parseToStringOrNull(activeEntry['savingsText']),
        savingsTextColor: parseToStringOrNull(activeEntry['savingsTextColor']),
        promoTrackingMeta: activeBlock,
        // The real length, not 1 — see PromotionDataEntity.promoAppliedCount.
        promoAppliedCount: entries.length,
      );
    }

    // Legacy shape: a single flat object, with no `trackingMeta` to forward.
    final code = json['promoCode'] as String?;
    final hasCode = code != null && code.isNotEmpty;
    return PromotionDataModel(
      sectionTitle: json['sectionTitle'] as String?,
      promoCode: code,
      message: json['message'] as String?,
      discountAmount: parseToIntOrNull(json['discountAmount']),
      isApplied: hasCode,
      // Counted from whether a code is present, so it agrees with
      // `allPromoCodes` — leaving it at 0 while `promo_code` carried the code
      // would report a cart with one promo as having none.
      promoAppliedCount: hasCode ? 1 : 0,
    );
  }
}
