import 'package:flutter_test/flutter_test.dart';

import 'package:hs_app_flutter/core/analytics/attribution/lp_attribution_helper.dart';

/// LP deque behaviors + wire-key contract. In-memory only — no prefs
/// setup needed.
///
/// Contract:
/// - `pushTileMeta(meta, name, id)` inserts at front (newest → `lp1_*`).
/// - Deque capped at 5 entries — a sixth push evicts the oldest.
/// - `segmentParams` whitelists 5 attribution keys + name + id per entry.
/// - Non-attribution keys in `meta` (image_url, cbt_id, …) are ignored.
/// - `_pickLp` alias precedence: `lp_<key>` wins over plain `<key>`; falls
///   back to plain when no alias.
/// - `clear()` wipes the deque completely; other stores are untouched.
void main() {
  late LpAttributionHelper lp;

  setUp(() {
    lp = LpAttributionHelper();
  });

  group('pushTileMeta', () {
    test('empty deque contributes no segmentParams', () {
      expect(lp.segmentParams, isEmpty);
    });

    test('single push emits lp1_* with 5 attribution keys + name + id', () {
      lp.pushTileMeta(
        meta: const {
          'slice_id': 'sl-1',
          'property_type': 'CT',
          'banner_name': 'LP banner',
          'funnel_row': '3',
          'funnel_tile': 'CT-5',
          // non-attribution — must NOT ride the wire.
          'image_url': 'https://…',
          'cbt_id': 42,
        },
        landingPageName: 'LP1',
        landingPageId: '100',
      );

      expect(lp.segmentParams, {
        'lp1_slice_id': 'sl-1',
        'lp1_property_type': 'CT',
        'lp1_banner_name': 'LP banner',
        'lp1_funnel_row': '3',
        'lp1_funnel_tile': 'CT-5',
        'lp1_name': 'LP1',
        'lp1_id': '100',
      });
    });

    test('nested push — newest at lp1_, older shifted to lp2_', () {
      lp.pushTileMeta(
        meta: const {'banner_name': 'LP1 banner'},
        landingPageName: 'LP1',
        landingPageId: '1',
      );
      lp.pushTileMeta(
        meta: const {'banner_name': 'LP2 banner'},
        landingPageName: 'LP2',
        landingPageId: '2',
      );

      expect(lp.segmentParams['lp1_banner_name'], 'LP2 banner');
      expect(lp.segmentParams['lp1_name'], 'LP2');
      expect(lp.segmentParams['lp2_banner_name'], 'LP1 banner');
      expect(lp.segmentParams['lp2_name'], 'LP1');
    });

    test('capped at 5 — oldest evicted on 6th push', () {
      for (var i = 1; i <= 6; i++) {
        lp.pushTileMeta(
          meta: {'banner_name': 'LP$i banner'},
          landingPageName: 'LP$i',
          landingPageId: '$i',
        );
      }

      final params = lp.segmentParams;
      expect(params['lp1_name'], 'LP6');
      expect(params['lp2_name'], 'LP5');
      expect(params['lp3_name'], 'LP4');
      expect(params['lp4_name'], 'LP3');
      expect(params['lp5_name'], 'LP2');
      expect(params.containsKey('lp6_name'), isFalse);
      expect(params.values.contains('LP1'), isFalse); // evicted
    });

    test('null identity → lp{n}_name / lp{n}_id omitted', () {
      lp.pushTileMeta(
        meta: const {'banner_name': 'LP banner'},
        landingPageName: null,
        landingPageId: null,
      );

      expect(lp.segmentParams['lp1_banner_name'], 'LP banner');
      expect(lp.segmentParams.containsKey('lp1_name'), isFalse);
      expect(lp.segmentParams.containsKey('lp1_id'), isFalse);
    });
  });

  group('_pickLp alias precedence', () {
    test('lp_<key> wins when both aliases present in meta', () {
      lp.pushTileMeta(
        meta: const {
          'lp_banner_name': 'LP variant',
          'banner_name': 'plain', // shadowed
        },
        landingPageName: 'LP1',
        landingPageId: '1',
      );
      expect(lp.segmentParams['lp1_banner_name'], 'LP variant');
    });

    test('plain <key> used when no lp_-aliased value', () {
      lp.pushTileMeta(
        meta: const {'banner_name': 'plain only'},
        landingPageName: 'LP1',
        landingPageId: '1',
      );
      expect(lp.segmentParams['lp1_banner_name'], 'plain only');
    });

    test('missing both → key omitted from segmentParams', () {
      lp.pushTileMeta(
        meta: const {'banner_name': 'only banner'}, // no slice_id at all
        landingPageName: 'LP1',
        landingPageId: '1',
      );
      expect(lp.segmentParams.containsKey('lp1_slice_id'), isFalse);
    });
  });

  group('clear', () {
    test('wipes deque — segmentParams empty afterwards', () {
      lp.pushTileMeta(
        meta: const {'banner_name': 'LP1'},
        landingPageName: 'LP1',
        landingPageId: '1',
      );
      expect(lp.segmentParams, isNotEmpty);

      lp.clear();

      expect(lp.segmentParams, isEmpty);
    });
  });

  group('fillWithTrackingData (order-time server enrichment)', () {
    test('reads lp{n}_* fields off server-response tracking blob', () {
      final result = lp.fillWithTrackingData(<String, Object?>{
        'lp1_id': '10',
        'lp1_name': 'LP-A',
        'lp1_banner_name': 'A banner',
        'lp1_slice_id': 'sl-a',
        'lp1_property_type': 'CT',
        'lp1_funnel_row': '1',
        'lp1_funnel_tile': 'CT-1',
        'lp2_id': '20',
        'lp2_name': 'LP-B',
        // lp3+ absent — must be skipped.
      });

      expect(result['lp1_id'], '10');
      expect(result['lp1_banner_name'], 'A banner');
      expect(result['lp2_id'], '20');
      expect(result['lp2_name'], 'LP-B');
      expect(result.containsKey('lp3_id'), isFalse);
    });

    test('skips entries with empty lp{n}_id', () {
      final result = lp.fillWithTrackingData(<String, Object?>{
        'lp1_id': '', // empty → skipped
        'lp1_name': 'LP-A',
      });
      expect(result, isEmpty);
    });
  });
}
