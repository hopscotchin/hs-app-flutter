import 'package:flutter_test/flutter_test.dart';

import 'package:hs_app_flutter/core/analytics/attribution/attribution_data.dart';

/// Pure data-model tests. HP-attribution slice only — LP click chain lives
/// in [LpAttributionHelper] and is covered in `lp_attribution_helper_test.dart`.
void main() {
  group('mergeTrackingMeta', () {
    test('empty state', () {
      expect(AttributionData.empty().trackingMeta, isEmpty);
    });

    test('accumulates keys across calls', () {
      final result = AttributionData.empty()
          .mergeTrackingMeta({'banner_name': 'HP1', 'funnel_row': 1})
          .mergeTrackingMeta({'slice_id': 'x', 'property_type': 'CT'});

      expect(result.trackingMeta, {
        'banner_name': 'HP1',
        'funnel_row': 1,
        'slice_id': 'x',
        'property_type': 'CT',
      });
    });

    test('new key wins on same-name collision, other keys persist', () {
      final result = AttributionData.empty()
          .mergeTrackingMeta({'banner_name': 'HP1', 'funnel_row': 1})
          .mergeTrackingMeta({'banner_name': 'HP2'});

      expect(result.trackingMeta['banner_name'], 'HP2');
      expect(result.trackingMeta['funnel_row'], 1);
    });

    test('empty partial short-circuits (returns same instance)', () {
      final base = AttributionData.empty()
          .mergeTrackingMeta({'banner_name': 'HP1'});
      expect(identical(base.mergeTrackingMeta(const {}), base), isTrue);
    });
  });

  group('applyFunnel', () {
    test('updates funnel identity but preserves trackingMeta + sortBar', () {
      final base = AttributionData.empty()
          .mergeTrackingMeta({'banner_name': 'HP', 'funnel_row': 1})
          .applySortBar('Girl');

      final switched = base.applyFunnel('Categories');

      expect(switched.funnel, 'Categories');
      expect(switched.trackingMeta, {'banner_name': 'HP', 'funnel_row': 1});
      expect(switched.sortBar, 'Girl');
    });
  });
}
