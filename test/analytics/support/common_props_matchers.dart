import 'package:flutter_test/flutter_test.dart';

import 'package:hs_app_flutter/core/analytics/constants/analytics_properties.dart';

// ─── Required-key lists per event, per context ───────────────────────
//
// Each event has an authoritative list of keys that MUST be present + non-
// null + non-empty on the wire. Sources of truth for these lists live here
// so a single edit ripples across every component test.
//
// **Home vs LP separation** — the two contexts belong to two DIFFERENT
// response fixtures:
//   • Home context (`_Home` lists) → home_page_all.json → `banner_impression`
//     / `tile_impression` events. Homepage response MUST NOT contain
//     `lp_*`-prefixed keys inside any component's trackingMeta.
//   • LP context (`_Lp` lists)     → *future* landing_page_*.json
//     → `lp_banner_impression` / `lp_tile_impression` events. LP-page
//     response is the ONLY place `lp_*`-prefixed keys are allowed.

// property_type is a leaf-level backend attribute, not a component-root one —
// so it's only guaranteed on Hero (per-tile banner_impression). Non-Hero
// components emit one banner_impression at the root, where property_type is
// absent by backend contract.
const requiredKeysBannerImpressionHome = <String>[
  AnalyticsProperties.funnel,
  AnalyticsProperties.bannerName,
  AnalyticsProperties.funnelRow,
  AnalyticsProperties.position,
];

// LP-variant required key lists — reserved for a future
// `landing_page_response_test` that consumes a Landing-Page JSON fixture.
// NOT used against homepage tests: LP-page events (lp_banner_impression /
// lp_tile_impression) only fire on the LP screen where `extraData.fromHomePage
// == false`. The homepage response must NEVER carry `lp_*`-prefixed keys in
// its trackingMeta — see `expectNoLpPrefixedTrackingMetaKeys` below.
const requiredKeysBannerImpressionLp = <String>[
  AnalyticsProperties.bannerName,
  AnalyticsProperties.funnelRow,
  AnalyticsProperties.position,
  AnalyticsProperties.propertyType,
  LandingPageProperties.lpId,
  LandingPageProperties.lpName,
];

const requiredKeysTileImpressionHome = <String>[
  AnalyticsProperties.funnel,
  AnalyticsProperties.funnelTile,
  AnalyticsProperties.bannerName,
  AnalyticsProperties.funnelRow,
  AnalyticsProperties.position,
  AnalyticsProperties.sliceId,
  AnalyticsProperties.propertyType,
];

const requiredKeysTileImpressionLp = <String>[
  AnalyticsProperties.funnelTile,
  AnalyticsProperties.bannerName,
  AnalyticsProperties.funnelRow,
  AnalyticsProperties.position,
  AnalyticsProperties.sliceId,
  AnalyticsProperties.propertyType,
  LandingPageProperties.lpId,
  LandingPageProperties.lpName,
];

/// Time buckets stamped by `AnalyticsHelper.logEvent` — every event MUST have
/// them. Asserts presence + type; values are time-dependent so we don't pin.
void expectTimeBuckets(Map<String, Object?> payload) {
  expect(payload[AnalyticsProperties.hourOfDay], isA<int>());
  expect(payload[AnalyticsProperties.dayOfWeek], isA<int>());
  expect(payload[AnalyticsProperties.dayOfMonth], isA<int>());
  expect(payload[AnalyticsProperties.monthOfYear], isA<int>());
  expect(payload[AnalyticsProperties.weekOfYear], isA<String>());
}

/// `timestamp` is added by `logEvent` only (NOT `logScrollEvent`). Use for
/// standard-track events.
void expectTimestamp(Map<String, Object?> payload) {
  expect(payload[AnalyticsProperties.timestamp], isA<String>());
  expect(payload[AnalyticsProperties.timestamp], isNotEmpty);
}

/// Every listed key must be present AND non-null AND non-empty (for strings).
void expectRequiredNonEmpty(
  Map<String, Object?> payload,
  Iterable<String> keys,
) {
  for (final k in keys) {
    expect(payload.containsKey(k), isTrue, reason: 'missing key: $k');
    final value = payload[k];
    expect(value, isNotNull, reason: '$k is null');
    if (value is String) {
      expect(value, isNotEmpty, reason: '$k is empty string');
    }
  }
}

/// Analytics business rule: an event payload MUST NOT ship any key whose
/// value is `null`. `null`s on the wire poison downstream dashboards — they
/// bucket as "unknown" and silently distort funnels.
///
/// Fails with a full list of offending keys (not just the first) so a whole
/// fixture regresssion doesn't require running the test N times to enumerate.
void expectNoNullFields(Map<String, Object?> payload) {
  final nullKeys = payload.entries
      .where((e) => e.value == null)
      .map((e) => e.key)
      .toList();
  expect(nullKeys, isEmpty,
      reason: 'event payload has null-valued keys: $nullKeys — '
          'either backend is shipping nulls (fix the API) or the tracker '
          'must filter nulls before emit');
}

/// Homepage-response invariant: NO key inside any component's trackingMeta
/// should be `lp_*`-prefixed. `lp_*` keys are the Landing-Page-response
/// contract and never belong on the homepage feed. If a homepage component
/// ships them (e.g. an LP-variant CustomTiles leaked into the home feed),
/// this fails with a list of the offending keys so backend can fix.
///
/// [meta] is the raw trackingMeta blob (root, tile, or leaf level) — feed
/// each level from the fixture into this helper.
void expectNoLpPrefixedTrackingMetaKeys(Map<String, dynamic> meta) {
  final lpKeys = meta.keys.where((k) => k.startsWith('lp_')).toList();
  expect(lpKeys, isEmpty,
      reason: 'homepage trackingMeta contains lp_-prefixed keys: $lpKeys — '
          'lp_* keys are Landing-Page-response only and must never appear on '
          'the homepage feed. Backend should ship this component with the '
          'unprefixed variant.');
}

/// Attribution-owned keys that live in `OrderAttribution.segmentParams` and
/// override caller-seeded root trackingMeta. Callers checking "root
/// trackingMeta survived on the wire" must skip these — they intentionally
/// come from the attribution store, not the component's own blob.
const Set<String> attributionOwnedKeys = {
  AnalyticsProperties.funnel,
  AnalyticsProperties.sortbar,
};

/// For every non-null, non-attribution-owned key in [root], assert the
/// payload has the same value. Used by both banner_impression and
/// tile_clicked "root trackingMeta merged verbatim" assertions. Optional
/// [override] lets a caller exempt keys that a deeper level (tile / leaf)
/// intentionally overwrites.
void expectRootMerged(
  Map<String, Object?> payload,
  Map<String, dynamic> root, {
  Set<String> override = const <String>{},
}) {
  for (final entry in root.entries) {
    if (entry.value == null) continue;
    if (attributionOwnedKeys.contains(entry.key)) continue;
    if (override.contains(entry.key)) continue;
    expect(payload[entry.key], entry.value, reason: 'root.${entry.key} lost');
  }
}

/// For every non-null, non-attribution-owned key in [sourceMeta], assert
/// the payload of a downstream event (PDP viewed after a tile click)
/// carries the same value. Encapsulates the "attribution carries forward
/// home→PDP" invariant. Callers may pass [ignoreKeys] to exempt keys the
/// downstream event's own caller-seeded props override (e.g. product_id).
void expectAttributionCarriedForward(
  Map<String, Object?> payload,
  Map<String, dynamic> sourceMeta, {
  Set<String> ignoreKeys = const <String>{},
}) {
  for (final entry in sourceMeta.entries) {
    if (entry.value == null) continue;
    if (attributionOwnedKeys.contains(entry.key)) continue;
    if (ignoreKeys.contains(entry.key)) continue;
    expect(payload[entry.key], entry.value,
        reason: 'attribution.${entry.key} lost between click and downstream event');
  }
}
