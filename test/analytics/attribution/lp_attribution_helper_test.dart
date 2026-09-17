import 'package:flutter_test/flutter_test.dart';

import 'package:hs_app_flutter/core/analytics/attribution/lp_attribution_helper.dart';

/// LP stack behaviors + wire-key contract. In-memory only — no prefs
/// setup needed.
///
/// Contract:
/// - `pushLp(name, id)` appends at the TOP of internal storage. On the
///   wire the mapping is **reverse-chronological**: top → `lp1_*`,
///   next → `lp2_*`, …, bottom → `lp{N}_*`.
/// - Stack capped at 5 — a sixth push evicts the OLDEST (bottom).
/// - `updateTopMeta` overwrites the top entry's meta (successive clicks
///   in the same LP replace, not accumulate).
/// - `updateTopIdentity` stamps name/id on the top entry (called once
///   the LP response arrives).
/// - `popTop` removes the top entry (on back nav out of an LP).
/// - `segmentParams` whitelists 5 attribution keys + name + id per entry.
/// - Non-attribution keys in `meta` (image_url, cbt_id, …) are ignored.
/// - `_pickLp` alias precedence: `lp_<key>` wins over plain `<key>`.
/// - `clear()` wipes the stack completely.
void main() {
  late LpAttributionHelper lp;

  setUp(() {
    lp = LpAttributionHelper();
  });

  group('pushLp + updateTopMeta', () {
    test('empty stack contributes no segmentParams', () {
      expect(lp.segmentParams, isEmpty);
    });

    test('single push + updateTopMeta emits lp1_* with 5 attribution '
        'keys + name + id', () {
      lp.pushLp(landingPageName: 'LP1', landingPageId: '100');
      lp.updateTopMeta(const {
        'slice_id': 'sl-1',
        'property_type': 'CT',
        'banner_name': 'LP banner',
        'funnel_row': '3',
        'funnel_tile': 'CT-5',
        // non-attribution — must NOT ride the wire.
        'image_url': 'https://…',
        'cbt_id': 42,
      });

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

    test('newest at lp1_, oldest at lpN_ (reverse-chronological wire)', () {
      lp.pushLp(landingPageName: 'LP1', landingPageId: '1');
      lp.updateTopMeta(const {'banner_name': 'LP1 banner'});
      lp.pushLp(landingPageName: 'LP2', landingPageId: '2');
      lp.updateTopMeta(const {'banner_name': 'LP2 banner'});

      // LP2 was pushed last (top of stack, most recent click) → lp1_*.
      expect(lp.segmentParams['lp1_banner_name'], 'LP2 banner');
      expect(lp.segmentParams['lp1_name'], 'LP2');
      // LP1 sits under LP2 → lp2_*.
      expect(lp.segmentParams['lp2_banner_name'], 'LP1 banner');
      expect(lp.segmentParams['lp2_name'], 'LP1');
    });

    test('capped at 5 — OLDEST evicted on 6th push', () {
      for (var i = 1; i <= 6; i++) {
        lp.pushLp(landingPageName: 'LP$i', landingPageId: '$i');
        lp.updateTopMeta({'banner_name': 'LP$i banner'});
      }

      final params = lp.segmentParams;
      // LP1 evicted; LP2..LP6 remain, newest first on the wire.
      expect(params['lp1_name'], 'LP6');
      expect(params['lp2_name'], 'LP5');
      expect(params['lp3_name'], 'LP4');
      expect(params['lp4_name'], 'LP3');
      expect(params['lp5_name'], 'LP2');
      expect(params.containsKey('lp6_name'), isFalse);
      expect(params.values.contains('LP1'), isFalse);
    });

    test('null identity → lp{n}_name / lp{n}_id omitted', () {
      lp.pushLp();
      lp.updateTopMeta(const {'banner_name': 'LP banner'});

      expect(lp.segmentParams['lp1_banner_name'], 'LP banner');
      expect(lp.segmentParams.containsKey('lp1_name'), isFalse);
      expect(lp.segmentParams.containsKey('lp1_id'), isFalse);
    });

    test('updateTopMeta with no push → no-op (empty stack, no keys)', () {
      lp.updateTopMeta(const {'banner_name': 'nowhere'});
      expect(lp.segmentParams, isEmpty);
    });

    test('successive updateTopMeta calls REPLACE (not merge) the top', () {
      lp.pushLp(landingPageName: 'LP1', landingPageId: '1');
      lp.updateTopMeta(const {'banner_name': 'first', 'slice_id': 'sl-a'});
      lp.updateTopMeta(const {'banner_name': 'second'}); // no slice_id

      expect(lp.segmentParams['lp1_banner_name'], 'second');
      expect(lp.segmentParams.containsKey('lp1_slice_id'), isFalse,
          reason: 'second updateTopMeta replaces the whole meta — the '
              'first call\'s slice_id must not leak.');
    });
  });

  group('updateTopIdentity', () {
    test('stamps name/id on the top entry — meta preserved', () {
      lp.pushLp();
      lp.updateTopMeta(const {'banner_name': 'LP tile'});
      lp.updateTopIdentity(landingPageName: 'LP1', landingPageId: '100');

      final params = lp.segmentParams;
      expect(params['lp1_banner_name'], 'LP tile');
      expect(params['lp1_name'], 'LP1');
      expect(params['lp1_id'], '100');
    });

    test('no-op when empty', () {
      lp.updateTopIdentity(landingPageName: 'LP1', landingPageId: '1');
      expect(lp.segmentParams, isEmpty);
    });
  });

  group('popTop (back nav)', () {
    test('LP1 → LP2 → LP3 → LP2, then back to LP3 refreshes lp1', () {
      // Forward journey — each LP tile click FILLS its own slot's meta
      // before the next LP is pushed (that's the click-in-LPn semantic).
      lp.pushLp(landingPageName: 'LP1', landingPageId: '1');
      lp.updateTopMeta(const {'banner_name': 'LP1 tile'});
      lp.pushLp(landingPageName: 'LP2', landingPageId: '2');
      lp.updateTopMeta(const {'banner_name': 'LP2 tile'});
      lp.pushLp(landingPageName: 'LP3', landingPageId: '3');
      lp.updateTopMeta(const {'banner_name': 'LP3 tile'});
      // Fourth push (second visit to LP2). No click has happened here yet —
      // the slot is reserved but its meta is empty, so it is SKIPPED from
      // numbering (compaction). The next activated slot from the top takes
      // `lp1_*`, so `lp1_*` always names the actual last click.
      lp.pushLp(landingPageName: 'LP2', landingPageId: '2');

      // Internal chronology: [LP1, LP2, LP3, LP2(empty)].
      // Wire (compacted reverse-chrono):
      //   lp1_*  = LP3 (most recent click; the empty LP2 top is skipped)
      //   lp2_*  = LP2 (second-most-recent click)
      //   lp3_*  = LP1 (oldest activated click)
      final beforeBack = lp.segmentParams;
      expect(beforeBack['lp1_name'], 'LP3',
          reason: 'the actual last click was made in LP3 → lp1_* even '
              'though a fresh LP2 visit sits on top of the stack');
      expect(beforeBack['lp1_banner_name'], 'LP3 tile');
      expect(beforeBack['lp2_name'], 'LP2');
      expect(beforeBack['lp2_banner_name'], 'LP2 tile');
      expect(beforeBack['lp3_name'], 'LP1');
      expect(beforeBack['lp3_banner_name'], 'LP1 tile');
      expect(beforeBack.containsKey('lp4_name'), isFalse,
          reason: 'fresh LP visit contributes 0 keys — compaction, not '
              'a hole');
      expect(beforeBack.containsKey('lp4_id'), isFalse);

      // Back to LP3 — the empty top LP2 visit gets popped. Internal:
      // [LP1, LP2, LP3]. Wire order stays the same as before-back because
      // the compacted view was already ignoring the popped slot.
      lp.popTop();

      final afterBack = lp.segmentParams;
      expect(afterBack.containsKey('lp4_name'), isFalse);
      expect(afterBack['lp1_name'], 'LP3');
      expect(afterBack['lp1_banner_name'], 'LP3 tile');
      expect(afterBack['lp2_name'], 'LP2');
      expect(afterBack['lp3_name'], 'LP1');

      // Click in LP3 refreshes the top slot's meta (still lp1_*, new payload).
      lp.updateTopMeta(const {'banner_name': 'LP3 fresh click'});
      expect(lp.segmentParams['lp1_banner_name'], 'LP3 fresh click');
      expect(lp.segmentParams['lp1_name'], 'LP3');
    });

    test('popTop on empty stack is a no-op', () {
      lp.popTop();
      expect(lp.segmentParams, isEmpty);
    });
  });

  group('activation gate (empty-meta entries do not emit)', () {
    test('fresh LP push with identity but no click contributes 0 keys', () {
      // Simulates production `didPush` + `setLandingPageContext` running
      // BEFORE any tile has been tapped in the newly-opened LP.
      lp.pushLp(landingPageName: 'LP1', landingPageId: '100');

      expect(lp.segmentParams, isEmpty,
          reason: 'the initial lp_banner_impression on a fresh LP must '
              'not ship `lp1_name` / `lp1_id` — `lp{n}_*` is the click '
              'chain that led here, not the current screen');
    });

    test('older filled entry emits as lp1_* while a fresh top is skipped', () {
      lp.pushLp(landingPageName: 'LP1', landingPageId: '1');
      lp.updateTopMeta(const {'banner_name': 'LP1 tile'});
      // Fresh LP2 push — no click yet. LP2 is on top but gated + skipped
      // from numbering, so LP1 (the actual last click) rides as lp1_*.
      // This is the "first click coming as lp1_*" contract.
      lp.pushLp(landingPageName: 'LP2', landingPageId: '2');

      final params = lp.segmentParams;
      expect(params['lp1_name'], 'LP1',
          reason: 'the LAST activated click sits at lp1_*, regardless of '
              'whether a fresh LP has landed on top without a click yet');
      expect(params['lp1_banner_name'], 'LP1 tile');
      expect(params.containsKey('lp2_name'), isFalse);
    });

    test('empty-meta entry starts emitting once a click fills its meta', () {
      lp.pushLp(landingPageName: 'LP1', landingPageId: '100');
      expect(lp.segmentParams, isEmpty);

      lp.updateTopMeta(const {'banner_name': 'now clicked'});
      final params = lp.segmentParams;
      expect(params['lp1_banner_name'], 'now clicked');
      expect(params['lp1_name'], 'LP1');
      expect(params['lp1_id'], '100');
    });
  });

  group('_pickLp alias precedence', () {
    test('lp_<key> wins when both aliases present in meta', () {
      lp.pushLp(landingPageName: 'LP1', landingPageId: '1');
      lp.updateTopMeta(const {
        'lp_banner_name': 'LP variant',
        'banner_name': 'plain', // shadowed
      });
      expect(lp.segmentParams['lp1_banner_name'], 'LP variant');
    });

    test('plain <key> used when no lp_-aliased value', () {
      lp.pushLp(landingPageName: 'LP1', landingPageId: '1');
      lp.updateTopMeta(const {'banner_name': 'plain only'});
      expect(lp.segmentParams['lp1_banner_name'], 'plain only');
    });

    test('missing both → key omitted from segmentParams', () {
      lp.pushLp(landingPageName: 'LP1', landingPageId: '1');
      lp.updateTopMeta(const {'banner_name': 'only banner'});
      expect(lp.segmentParams.containsKey('lp1_slice_id'), isFalse);
    });
  });

  group('clear', () {
    test('wipes stack — segmentParams empty afterwards', () {
      lp.pushLp(landingPageName: 'LP1', landingPageId: '1');
      lp.updateTopMeta(const {'banner_name': 'LP1'});
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
