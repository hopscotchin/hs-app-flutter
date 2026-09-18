import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/features/cart/data/models/promotion_data_model.dart';
import 'package:hs_app_flutter/features/cart/domain/entities/promotion_data_entity.dart';

/// `promotionData.orderPromocodes` is parsed down to **one raw analytics block
/// plus the few display strings the UI needs** — there is no typed mirror of
/// the block, so these tests are where the shape is written down.
void main() {
  /// The current response: display strings at the entry's top level, every
  /// analytics value inside `trackingMeta`.
  Map<String, dynamic> currentShape() => {
    'orderPromocodes': [
      {
        'appliedCouponText': 'JOY5 applied',
        'appliedCouponTextColor': '#000000',
        'savingsText': 'Your savings Rs.225',
        'savingsTextColor': '#6D59D7',
        'trackingMeta': {
          'code': 'TESTP5',
          'discount': 500.0,
          'applied': true,
          'action': 'success',
          'isMerchRule': 'Yes',
          'autoApplied': false,
          'forceRemove': false,
          'merchRuleType': 'ORDER',
        },
      },
    ],
  };

  group('every key survives into the flat block, under its own name', () {
    test('every trackingMeta key survives, under its own name', () {
      final promo = PromotionDataModel.fromJson(currentShape());
      final block = promo.promoTrackingMeta!;
      expect(block['code'], 'TESTP5');
      expect(block['discount'], 500.0);
      expect(block['applied'], true);
      expect(block['action'], 'success');
      // A string, not a bool — nothing re-types it on the way through, which is
      // the whole reason there is no typed mirror.
      expect(block['isMerchRule'], 'Yes');
      expect(block['merchRuleType'], 'ORDER');
    });

    test('a brand-new backend key needs no app release', () {
      final json = currentShape();
      (json['orderPromocodes'] as List).first['trackingMeta']['promo_tier'] = 'gold';
      final promo = PromotionDataModel.fromJson(json);
      expect(promo.promoTrackingMeta!['promo_tier'], 'gold');
    });

    test('display strings are read from the entry, not the block', () {
      // They are never moved into trackingMeta, which carries analytics only.
      // They land in the merged block too, harmlessly — it is mapped
      // field-by-field, never spread onto the wire.
      final promo = PromotionDataModel.fromJson(currentShape());
      expect(promo.appliedCouponText, 'JOY5 applied');
      expect(promo.savingsText, 'Your savings Rs.225');
      expect(promo.savingsTextColor, '#6D59D7');
    });
  });

  group('the keys the client reads', () {
    test('the applied entry is the one resolved, not just the first', () {
      // The array holds one entry today, so this is about not *assuming* index
      // 0: a stale unapplied code sitting first would otherwise be rendered and
      // reported instead of the live one.
      final promo = PromotionDataModel.fromJson({
        'orderPromocodes': [
          {
            'trackingMeta': {'code': 'OLD', 'applied': false},
          },
          {
            'trackingMeta': {'code': 'LIVE', 'applied': true},
          },
        ],
      });
      expect(promo.promoCode, 'LIVE');
      expect(promo.isApplied, isTrue);
      expect(promo.promoTrackingMeta!['code'], 'LIVE');
    });

    test('promo_applied_count is the array length, not always 1', () {
      // Guards the count against the day the backend sends more than one:
      // deriving it from the single block would pin it to 0-or-1 forever.
      final promo = PromotionDataModel.fromJson({
        'orderPromocodes': [
          {
            'trackingMeta': {'code': 'A', 'applied': true},
          },
          {
            'trackingMeta': {'code': 'B', 'applied': false},
          },
        ],
      });
      expect(promo.promoAppliedCount, 2);
    });

    test('with nothing applied it falls back to the first entry', () {
      final promo = PromotionDataModel.fromJson({
        'orderPromocodes': [
          {
            'trackingMeta': {'code': 'FIRST', 'applied': false},
          },
        ],
      });
      expect(promo.promoCode, 'FIRST');
      expect(promo.isApplied, isFalse);
    });

    test('promo_code stays an array of one, never a bare string', () {
      // The wire key is plural on both platforms and dashboards group on it as
      // a list; a bare string would break them.
      final promo = PromotionDataModel.fromJson(currentShape());
      expect(promo.allPromoCodes, <String>['TESTP5']);
    });

    test('a codeless entry yields no promo_code at all', () {
      // Android's `mapNotNull { promoItem.code }` — an empty string would read
      // as a real code named "".
      final promo = PromotionDataModel.fromJson({
        'orderPromocodes': [
          {
            'trackingMeta': {'code': '', 'applied': true},
          },
        ],
      });
      expect(promo.allPromoCodes, isEmpty);
      expect(promo.promoCode, isNull);
      // Still counted — the cart does have a promo entry.
      expect(promo.promoAppliedCount, 1);
    });

    test('the server-driven flags read off the block', () {
      final block = {'code': 'AUTO', 'autoApplied': true, 'forceRemove': false};
      expect(PromotionDataEntity.isPromoAutoApplied(block), isTrue);
      expect(PromotionDataEntity.isPromoForceRemoved(block), isFalse);
    });

    test('a missing flag is false, not an error', () {
      const block = <String, dynamic>{'code': 'X'};
      expect(PromotionDataEntity.isPromoApplied(block), isFalse);
      expect(PromotionDataEntity.isPromoAutoApplied(block), isFalse);
      expect(PromotionDataEntity.isPromoForceRemoved(block), isFalse);
    });
  });

  group('the older flat shape still parses', () {
    test('an entry with no trackingMeta is itself the block', () {
      // Old responses put code/discount/applied at the entry's top level under
      // the same names, so the entry doubles as its own analytics block. This
      // is what lets the parse work on both shapes without per-field fallbacks.
      final promo = PromotionDataModel.fromJson({
        'orderPromocodes': [
          {'code': 'FLAT10', 'discount': 60.0, 'applied': true},
        ],
      });
      expect(promo.promoCode, 'FLAT10');
      expect(promo.isApplied, isTrue);
      expect(promo.promoTrackingMeta!['code'], 'FLAT10');
      expect(promo.promoTrackingMeta!['discount'], 60.0);
    });

    test('the single flat object shape is untouched', () {
      final promo = PromotionDataModel.fromJson({
        'sectionTitle': 'Offers',
        'promoCode': 'LEGACY',
        'message': 'Applied',
        'discountAmount': 50,
      });
      expect(promo.promoCode, 'LEGACY');
      expect(promo.isApplied, isTrue);
      expect(promo.discountAmount, 50);
      // No `trackingMeta` in this shape, so there is no block to forward…
      expect(promo.promoTrackingMeta, isNull);
      // …but the code itself still reaches the wire, and the count agrees with
      // it. Reporting 0 here while `promo_code` carried "LEGACY" would say the
      // cart has no promo while naming one.
      expect(promo.allPromoCodes, <String>['LEGACY']);
      expect(promo.promoAppliedCount, 1);
    });

    test('an empty list falls through to the flat branch', () {
      final promo = PromotionDataModel.fromJson({
        'orderPromocodes': <dynamic>[],
        'promoCode': 'FALLBACK',
      });
      expect(promo.promoCode, 'FALLBACK');
    });

    test('no promo at all reports nothing rather than zero-ish values', () {
      final promo = PromotionDataModel.fromJson(<String, dynamic>{});
      expect(promo.promoCode, isNull);
      expect(promo.isApplied, isFalse);
      expect(promo.promoTrackingMeta, isNull);
      expect(promo.allPromoCodes, isEmpty);
      expect(promo.promoAppliedCount, 0);
    });
  });

  group('the entry/trackingMeta split is read per field, not per level', () {
    // The backend is mid-migration, moving fields from the entry into
    // `trackingMeta` one at a time, so a parser that picks a side reads the
    // other shapes as empty — silently, since the entry still parses.
    //
    // `applied` is the one to watch: it is on the entry in every shape, so a
    // block-only read reports a live promo as unapplied, emptying the promo
    // events *and* un-applying the cart's coupon card.

    test('current: code/discount/applied on the entry, flags in the block', () {
      // Captured from `/shopping-cart` on QA, 2026-09-16.
      final data = PromotionDataModel.fromJson({
        'orderPromocodes': [
          {
            'code': 'TESTCART10',
            'appliedCouponText': 'TESTCART10 applied',
            'appliedCouponTextColor': '#000000',
            'savingsText': 'Your savings Rs.401',
            'savingsTextColor': '#6D59D7',
            'discount': 401.0,
            'action': 'success',
            'trackingMeta': {
              'merchRuleType': 'ORDER',
              'isMerchRule': false,
              'autoApplied': false,
              'forceRemove': false,
            },
            'applied': true,
          },
        ],
      });

      expect(data.promoCode, 'TESTCART10');
      expect(data.isApplied, isTrue);
      expect(data.appliedPromoDiscount, 401.0);
      expect(data.discountAmount, 401);
      expect(data.allPromoCodes, ['TESTCART10']);
      expect(data.promoAppliedCount, 1);
      // A real `false` from the block, not a missing key read as false.
      expect(data.isMerchPromoApplied, isFalse);
      expect(data.appliedCouponText, 'TESTCART10 applied');
      expect(data.savingsText, 'Your savings Rs.401');
    });

    test('target: only applied on the entry, everything else in the block', () {
      final data = PromotionDataModel.fromJson({
        'orderPromocodes': [
          {
            'appliedCouponText': 'JOY5 applied',
            'appliedCouponTextColor': '#000000',
            'savingsText': 'Your savings Rs.225',
            'savingsTextColor': '#6D59D7',
            'applied': true,
            'trackingMeta': {
              'code': 'TESTP5',
              'discount': 500.0,
              'action': 'success',
              'isMerchRule': 'Yes',
              'autoApplied': false,
              'forceRemove': false,
              'merchRuleType': 'ORDER',
            },
          },
        ],
      });

      expect(data.promoCode, 'TESTP5');
      // What the old parser failed: `applied` never moved into the block.
      expect(data.isApplied, isTrue);
      expect(data.appliedPromoDiscount, 500.0);
      expect(data.allPromoCodes, ['TESTP5']);
      // The analytics spelling, not a bool.
      expect(data.isMerchPromoApplied, isTrue);
      expect(data.appliedCouponText, 'JOY5 applied');
    });

    test('legacy: everything on the entry, no block at all', () {
      final data = PromotionDataModel.fromJson({
        'orderPromocodes': [
          {'code': 'OLD10', 'discount': 99.0, 'applied': true, 'isMerchRule': true},
        ],
      });

      expect(data.promoCode, 'OLD10');
      expect(data.isApplied, isTrue);
      expect(data.appliedPromoDiscount, 99.0);
      expect(data.isMerchPromoApplied, isTrue);
    });

    test('the block wins a field both levels carry', () {
      // Mid-migration only. The block is the analytics-owned copy.
      final data = PromotionDataModel.fromJson({
        'orderPromocodes': [
          {
            'code': 'STALE',
            'discount': 1.0,
            'applied': true,
            'trackingMeta': {'code': 'FRESH', 'discount': 250.0},
          },
        ],
      });

      expect(data.promoCode, 'FRESH');
      expect(data.appliedPromoDiscount, 250.0);
    });

    test('the applied entry is picked out of several', () {
      // `applied` drives the pick, so it must be found wherever it lives — a
      // block-only read saw none applied and fell back to index 0.
      final data = PromotionDataModel.fromJson({
        'orderPromocodes': [
          {
            'code': 'STALE',
            'applied': false,
            'trackingMeta': {'discount': 10.0},
          },
          {
            'code': 'LIVE',
            'applied': true,
            'discount': 401.0,
            'trackingMeta': {'isMerchRule': false},
          },
        ],
      });

      expect(data.promoCode, 'LIVE');
      expect(data.appliedPromoDiscount, 401.0);
      // Both entries counted, not just the applied one.
      expect(data.promoAppliedCount, 2);
    });

    test('server-driven flags are found in either shape', () {
      // These drive `_trackServerDrivenPromoChanges`, which fires events
      // nobody tapped for.
      Map<String, dynamic> block(Map<String, dynamic> entry) => PromotionDataModel.fromJson({
        'orderPromocodes': [entry],
      }).promoTrackingMeta!;

      expect(
        PromotionDataEntity.isPromoAutoApplied(
          block({
            'code': 'A',
            'applied': true,
            'trackingMeta': {'autoApplied': true},
          }),
        ),
        isTrue,
      );
      expect(
        PromotionDataEntity.isPromoForceRemoved(
          block({'code': 'A', 'applied': true, 'forceRemove': true}),
        ),
        isTrue,
      );
    });

    test('the nested trackingMeta key is not left inside the flat block', () {
      final data = PromotionDataModel.fromJson({
        'orderPromocodes': [
          {
            'code': 'A',
            'applied': true,
            'trackingMeta': {'discount': 5.0},
          },
        ],
      });
      expect(data.promoTrackingMeta!.containsKey('trackingMeta'), isFalse);
    });
  });
}
