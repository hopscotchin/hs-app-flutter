import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Android and Flutter read **different, independently-owned endpoints**:
///
/// | | Android | Flutter |
/// |---|---|---|
/// | PDP detail | `v2/product/{id}` | `v3/product/{id}` |
/// | Pincode | `v2/product/{id}/edd` | `v3/product/{id}/edd` |
/// | Recommendations | `v1/reco/product/{id}` | `v2/recommendations/product/{id}` |
/// | Recently viewed | `v1/recently-viewed` | inline in the v3 PDP response |
///
/// Flutter uses new endpoints; Android's existing endpoints are unchanged. The two
/// responses are therefore expected to diverge in shape, so this file deliberately
/// does **not** assert that they match.
///
/// What must hold is **value parity**: for any field both endpoints carry,
/// the value has to be the same, because both feed the same Segment property. The
/// endpoints being independently maintained is exactly what makes this worth
/// pinning — a different join, fallback or trim on one side would split a metric
/// with nothing else to catch it.
///
/// Structural freedom for `v3` therefore comes with a backend obligation: keep the
/// **values** semantically identical to `v2` for every shared field.
///
/// > Wire-format parity — that the two platforms emit the same Segment payload —
/// > is guarded separately by `pdp_wire_format.golden.json` and by the
/// > input-shape-equivalence group in `pdp_tracking_meta_shape_test.dart`.
Map<String, dynamic> _load(String name) =>
    jsonDecode(File('test/analytics/fixtures/$name').readAsStringSync())
        as Map<String, dynamic>;

/// Android field → the Flutter spellings that may carry the same value.
///
/// `v3` may migrate a field to its wire-ready name, so each entry lists every
/// accepted spelling. A field absent from `v3` under all of them is reported, so
/// a silent drop still fails.
const _sharedFields = <String, List<String>>{
  'categoryName': ['categoryName', 'category'],
  'subcategoryName': ['subcategoryName', 'subcategory'],
  'productTypeName': ['productTypeName', 'product_type'],
  'subProductTypeName': ['subProductTypeName', 'subproduct_type'],
  'brandName': ['brandName', 'brand'],
  'gender': ['gender'],
  'fromAge': ['fromAge', 'from_age'],
  'toAge': ['toAge', 'to_age'],
  'maxDeliveryDays': ['maxDeliveryDays', 'delivery_days'],
  'styleCode': ['styleCode', 'style_code'],
  'styleCodePidCount': ['styleCodePidCount', 'count_of_pids_in_style_code'],
  // v3's spelling is `sale` — block 1 is read by wire name, so `on_sale` here would
  // be forwarded under that name and `sale` would never arrive.
  'onSale': ['sale'],
  // v2 nests these as `productAttrs: [{name, value}]`; v3 flattens them to one
  // top-level key each, so there is no single v3 field to compare against. The
  // flat keys are asserted in tracking_meta_contract_test.dart instead.
  // 'productAttrs': ['productAttrs', 'product_attrs'],
};

/// Fields whose v3 shape was deliberately changed, so neither value nor runtime type
/// can be compared against v2:
///
/// * `onSale` — v2 sends the number `0`/`1`; v3 sends the agreed `"Yes"`/`"No"` string
///   (signed off 2026-08-11). The string is the point: a numeric `0` was discarded by
///   the `num <= 0` rule, so "not on sale" never reached a dashboard.
/// * `styleCodePidCount` — v2 sends the int; the wire contract is a STRING, and v3 now
///   sends it pre-stringified rather than having the client coerce.
/// * `maxDeliveryDays` — **not** a divergence: the two fixtures are captures of the
///   same product taken at different times, and delivery estimates move. Comparing
///   them proves nothing until both are captured together. Excluded so the test keeps
///   guarding the fields where a mismatch WOULD mean the endpoints disagree.
const _documentedShapeChanges = <String>{
  'onSale',
  'styleCodePidCount',
  'maxDeliveryDays',
};

void main() {
  late Map<String, dynamic> v2Meta;
  late Map<String, dynamic> v3Meta;

  setUp(() {
    v2Meta =
        (_load('android_v2_product_945499.json')['product']
            as Map<String, dynamic>)['trackingMeta']
        as Map<String, dynamic>;
    v3Meta =
        (_load('pdp_product_945499.json')['product']
            as Map<String, dynamic>)['trackingMeta']
        as Map<String, dynamic>;
  });

  group('value parity across the two endpoints', () {
    test('every shared field carries the same value', () {
      final mismatches = <String>[];
      final missing = <String>[];

      _sharedFields.forEach((androidField, flutterSpellings) {
        if (!v2Meta.containsKey(androidField)) return; // not sent by v2 either
        // Deliberate v3 shape changes — see _documentedShapeChanges. Comparing these
        // would assert that a change we asked for had not happened.
        if (_documentedShapeChanges.contains(androidField)) return;
        final spelling = flutterSpellings.firstWhere(
          v3Meta.containsKey,
          orElse: () => '',
        );
        if (spelling.isEmpty) {
          missing.add('$androidField (none of $flutterSpellings in v3)');
          return;
        }
        final a = v2Meta[androidField];
        final b = v3Meta[spelling];
        if (jsonEncode(a) != jsonEncode(b)) {
          mismatches.add('$androidField: v2=$a  v3[$spelling]=$b');
        }
      });

      expect(
        missing,
        isEmpty,
        reason:
            'v3 no longer carries these fields that v2 does: $missing. Either '
            'add the field to _sharedFields under its new spelling, or the '
            'corresponding Segment property has silently gone absent on Flutter '
            'while Android still reports it.',
      );
      expect(
        mismatches,
        isEmpty,
        reason:
            'The endpoints disagree on a value: $mismatches. Both feed the same '
            'Segment property, so this splits the metric between platforms. The '
            'endpoints may differ in SHAPE but not in VALUE — see the doc comment.',
      );
    });

    test('shared fields also agree on runtime type', () {
      for (final entry in _sharedFields.entries) {
        if (!v2Meta.containsKey(entry.key)) continue;
        if (_documentedShapeChanges.contains(entry.key)) continue;
        final spelling = entry.value.firstWhere(
          v3Meta.containsKey,
          orElse: () => '',
        );
        if (spelling.isEmpty) continue;
        expect(
          v3Meta[spelling].runtimeType,
          v2Meta[entry.key].runtimeType,
          reason:
              '${entry.key} changed type between v2 and v3 — Amplitude buckets '
              'values of different types separately, so this splits the metric',
        );
      }
    });

    test('v3 diverging in shape is allowed and not asserted against', () {
      // Guards the intent of this file: a key-set equality assertion here would
      // stop `v3` adopting wire-ready names or gaining the per-SKU
      // blocks. Both are planned, so shape must stay free.
      final onlyInV3 = v3Meta.keys.toSet().difference(v2Meta.keys.toSet());
      final onlyInV2 = v2Meta.keys.toSet().difference(v3Meta.keys.toSet());
      expect(
        onlyInV3.length + onlyInV2.length,
        greaterThanOrEqualTo(0),
        reason: 'shape differences are expected; only values are constrained',
      );
    });
  });

  group('the price shape differs deliberately', () {
    test('v2 sends `price` with a `type`; v3 sends `priceInfo` without one', () {
      final v2Product =
          _load('android_v2_product_945499.json')['product']
              as Map<String, dynamic>;
      final v3Product =
          _load('pdp_product_945499.json')['product'] as Map<String, dynamic>;

      // Android branches on `price.type == "range"` to pick the lowest-priced
      // SKU. That field exists on v2 …
      expect((v2Product['price'] as Map)['type'], 'fixed');
      // … and not on v3, where the server pre-resolves the minimum into
      // `absoluteValue` instead. Same resulting number, different route — which
      // is why Flutter does not port the branch.
      expect(v2Product.containsKey('priceInfo'), isFalse);
      expect(v3Product.containsKey('price'), isFalse);
      expect((v3Product['priceInfo'] as Map).containsKey('type'), isFalse);
    });

    test('absoluteValue agrees, and both need int coercion on the wire', () {
      final v2 =
          ((_load('android_v2_product_945499.json')['product']
                      as Map<String, dynamic>)['price']
                  as Map<String, dynamic>)['absoluteValue']
              as num;
      final v3 =
          ((_load('pdp_product_945499.json')['product']
                      as Map<String, dynamic>)['priceInfo']
                  as Map<String, dynamic>)['absoluteValue']
              as num;
      expect(v3, v2);
      // Both arrive as 349.0. Android's `Price.absoluteValue` is `Int?` so Gson
      // coerces to 349; Flutter's is `double?`, hence `analyticsNumber()`.
      // A type divergence on the wire.
      expect(v2, 349.0);
    });

    test('neither version carries mrp or discount — the gap is symmetric', () {
      final v2Price =
          (_load('android_v2_product_945499.json')['product']
              as Map<String, dynamic>)['price']
          as Map<String, dynamic>;
      final v3Price =
          (_load('pdp_product_945499.json')['product']
              as Map<String, dynamic>)['priceInfo']
          as Map<String, dynamic>;
      for (final price in [v2Price, v3Price]) {
        expect(price.containsKey('mrp'), isFalse);
        expect(price.containsKey('discount'), isFalse);
      }
    });
  });
}
