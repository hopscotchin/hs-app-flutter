import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/core/analytics/events/modules/pdp_events.dart';
import 'package:hs_app_flutter/features/pdp/data/models/product_detail_model.dart';
import 'package:hs_app_flutter/features/pdp/domain/entities/pdp_entry_args.dart';

import '../../support/analytics_test_harness.dart';

/// Pins the `sale` wire value.
///
/// BE sends the final key — `sale`, as the string `"Yes"` / `"No"` — so the client reads
/// nothing by another name and transforms nothing: `_passthrough` forwards the value
/// exactly as sent, and an absent key stays absent.
///
/// Why this key gets a file of its own: a client-side sale resolver fails SILENTLY. Any
/// shape it does not recognise falls through to a default of `false`, which reports every
/// on-sale product as not on sale — no error, no missing key, just a plausible constant
/// that no presence check can distinguish from a real "No". A defaulting read is also
/// invisible to the golden, whose fixture is not on sale, so the tests below deliberately
/// assert with `"Yes"`.
void main() {
  late AnalyticsTestHarness h;

  setUp(() async => h = await AnalyticsTestHarness.build());
  tearDown(() => h.tearDown());

  /// Fires `product_viewed` with `trackingMeta` overridden by [overrides], and
  /// returns what reached the wire as `sale` — or the sentinel when the key was
  /// dropped, which is itself a meaningful outcome here.
  Future<Object?> sale(Map<String, Object?> overrides) async {
    final raw =
        jsonDecode(
              File(
                'test/analytics/fixtures/pdp_product_945499.json',
              ).readAsStringSync(),
            )
            as Map<String, dynamic>;
    final meta =
        (raw['product'] as Map<String, dynamic>)['trackingMeta']
            as Map<String, dynamic>;
    meta
      ..remove('onSale')
      ..remove('on_sale')
      ..remove('sale')
      ..addAll(overrides);
    final detail = ProductDetailModel.fromJson(raw).toEntity();
    await h.analytics.logProductViewed(
      product: detail.product!,
      entry: const PdpEntryArgs(),
    );
    final props = h.captured.single.props;
    h.clear();
    return props.containsKey('sale') ? props['sale'] : '<absent>';
  }

  group('the value is forwarded, not resolved', () {
    test('"Yes" reaches the wire verbatim', () async {
      expect(await sale({'sale': 'Yes'}), 'Yes');
    });

    test('"No" reaches the wire verbatim — not dropped, not coerced', () async {
      // The old numeric shape (`onSale: 0`) was discarded by the `num <= 0` rule, so
      // "not on sale" never reached a dashboard. A string is not a num, and that rule
      // is gone besides.
      expect(await sale({'sale': 'No'}), 'No');
    });

    test('both values are Strings, so the metric has one type', () async {
      expect(await sale({'sale': 'Yes'}), isA<String>());
      expect(await sale({'sale': 'No'}), isA<String>());
    });

    test('a boolean is passed through as a boolean', () async {
      expect(await sale({'sale': false}), false);
    });

    test('a number is passed through as a number, including 0', () async {
      // Not the agreed contract, but the client does not police types — a wrong type
      // shows up in the dashboard as a wrong type rather than being repaired.
      expect(await sale({'sale': 0}), 0);
    });

    test('absent means absent — no invented default', () async {
      // A defaulted `false` here would invert the meaning: it would say "we had no
      // data" using the same value a real "not on sale" reports. Nothing is fabricated.
      expect(await sale({}), '<absent>');
    });

    test('the old on_sale spelling is no longer read', () async {
      // BE renamed it. If it ever came back, it would arrive as its own property
      // through passthrough rather than being mapped onto `sale`.
      expect(await sale({'on_sale': 'Yes'}), '<absent>');
    });
  });
}
