import 'package:equatable/equatable.dart';

class PromotionDataEntity extends Equatable {
  final String? sectionTitle;
  final String? promoCode;
  final String? message;
  final int? discountAmount;
  final bool isApplied;

  /// Backend-authored "<CODE> applied" label + its color — preferred over
  /// building `'$promoCode applied'` locally.
  final String? appliedCouponText;
  final String? appliedCouponTextColor;

  /// Backend-authored "Your savings ₹X" label + its color — preferred over
  /// building `'Your savings ₹$discountAmount'` locally.
  final String? savingsText;
  final String? savingsTextColor;

  /// The applied promo's analytics block: the entry's own fields overlaid with
  /// its `trackingMeta`, flattened into one map.
  ///
  /// Merged because the backend splits these across the two levels differently
  /// per response — `applied` on the entry, `isMerchRule` in the block, `code`
  /// / `discount` on either. See [PromotionDataModel.fromJson]. Readers below
  /// therefore look a name up without caring which level it came on.
  ///
  /// **Single, not a list**: `orderPromocodes` carries at most one entry today
  /// and the cart card renders one, so the applied entry (falling back to the
  /// first) becomes this block.
  ///
  /// Kept raw rather than typed so a new backend field needs no app release.
  /// Unlike the cart's and the item's blocks it is **mapped, not forwarded** —
  /// its keys are the backend's own names and share none with the promo
  /// events' payload; `CartPromoPayload` names every property it emits.
  final Map<String, dynamic>? promoTrackingMeta;

  /// How many entries `orderPromocodes` actually held — `promo_applied_count`.
  ///
  /// Read from the array's length rather than derived from
  /// [promoTrackingMeta], which would pin it to 0-or-1 forever. If a response
  /// ever carries two codes this still reports 2, so the count cannot quietly
  /// go wrong the day the backend starts sending more; [allPromoCodes] is the
  /// part that would then need the list back, and its doc says so.
  final int promoAppliedCount;

  /// The three block keys the client reads for its own decisions.
  ///
  /// Named here rather than at the read sites so the coupling is in one place:
  /// these are the only names a backend rename would break, and everything else
  /// in the block flows through untouched. (`code` is read once, at parse time,
  /// into [promoCode].)
  static const String _keyApplied = 'applied';
  static const String _keyAutoApplied = 'autoApplied';
  static const String _keyForceRemove = 'forceRemove';
  static const String _keyDiscount = 'discount';
  static const String _keyIsMerchRule = 'isMerchRule';

  /// Whether [block] reports its promo as currently applied to the cart.
  static bool isPromoApplied(Map<String, dynamic> block) => block[_keyApplied] == true;

  /// Whether the backend applied [block]'s code without the user asking.
  static bool isPromoAutoApplied(Map<String, dynamic> block) => block[_keyAutoApplied] == true;

  /// Whether the backend dropped [block]'s code without the user asking.
  static bool isPromoForceRemoved(Map<String, dynamic> block) => block[_keyForceRemove] == true;

  /// [block]'s discount as a number, 0 when it carries none.
  ///
  /// Feeds both `item_discount` and `promotion_discount` — two analytics keys
  /// off one backend field, which is part of why this block cannot be
  /// forwarded the way the cart's and the item's are. Its keys are the
  /// backend's own names (`discount`, `isMerchRule`, `merchRuleType`), sharing
  /// not one name with the payload the promo events must emit, so every field
  /// is mapped or dropped.
  static num promoDiscountOf(Map<String, dynamic> block) {
    final value = block[_keyDiscount];
    if (value is num) return value;
    if (value is String) return num.tryParse(value) ?? 0;
    return 0;
  }

  /// Whether [block] is a merchandising-rule promo — `merch_promo`.
  ///
  /// Accepts the analytics string the block sends (`"Yes"`) as well as a plain
  /// bool: the field is a `Boolean isMerchRule` on Android's DTO but arrives
  /// as `"Yes"` inside `trackingMeta`, and a response may carry either.
  static bool isMerchPromo(Map<String, dynamic> block) {
    final value = block[_keyIsMerchRule];
    if (value is bool) return value;
    if (value is String) {
      final normalised = value.toLowerCase();
      return normalised == 'yes' || normalised == 'true';
    }
    return false;
  }

  /// The applied promo's discount — `item_discount`, and
  /// `promotion_discount` when above zero.
  num get appliedPromoDiscount {
    final block = promoTrackingMeta;
    return block == null ? 0 : promoDiscountOf(block);
  }

  /// `merch_promo` for the applied promo.
  bool get isMerchPromoApplied {
    final block = promoTrackingMeta;
    return block != null && isMerchPromo(block);
  }

  /// The `promo_code` array — every applied code.
  ///
  /// An array of one, because there is one code. It stays an array because the
  /// wire key is plural on both platforms (Android sends
  /// `orderPromoCodes.mapNotNull { it.code }`) and dashboards already group on
  /// it that way; sending a bare string would break them.
  ///
  /// ⚠️ If the backend starts sending more than one entry, this reports only
  /// the applied one while [promoAppliedCount] correctly reports the total —
  /// restore the list here at that point.
  List<String> get allPromoCodes =>
      (promoCode != null && promoCode!.isNotEmpty) ? <String>[promoCode!] : const <String>[];

  const PromotionDataEntity({
    this.sectionTitle,
    this.promoCode,
    this.message,
    this.discountAmount,
    this.isApplied = false,
    this.appliedCouponText,
    this.appliedCouponTextColor,
    this.savingsText,
    this.savingsTextColor,
    this.promoTrackingMeta,
    this.promoAppliedCount = 0,
  });

  @override
  List<Object?> get props => [
    sectionTitle,
    promoCode,
    message,
    discountAmount,
    isApplied,
    appliedCouponText,
    appliedCouponTextColor,
    savingsText,
    savingsTextColor,
    promoTrackingMeta,
    promoAppliedCount,
  ];
}
