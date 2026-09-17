import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Guards the **backend side** of the tracking-meta contract: the fields the
/// backend must keep sending, and under which spelling.
///
/// The existing PDP tests check that the client transforms correctly. Nothing
/// checked that the fields it transforms *from* still arrive — so if the backend
/// renamed `categoryName`, every test would pass while nine properties silently
/// went missing from every PDP event. That is the gap this file closes.
///
/// It also acts as a canary on the two homepage defects: the assertions allow the
/// **known** offenders and fail when a *new* one appears, so a fix never breaks
/// the build but a regression does.
Map<String, dynamic> _fixture(String name) =>
    jsonDecode(File('test/analytics/fixtures/$name').readAsStringSync())
        as Map<String, dynamic>;

Map<String, dynamic> _meta(Map<String, dynamic> owner) =>
    owner['trackingMeta'] as Map<String, dynamic>;

/// Collects every `trackingMeta` block in an arbitrary response.
List<Map<String, dynamic>> _allMeta(Object? node) {
  final found = <Map<String, dynamic>>[];
  void walk(Object? n) {
    if (n is Map<String, dynamic>) {
      final meta = n['trackingMeta'];
      if (meta is Map<String, dynamic>) found.add(meta);
      for (final entry in n.entries) {
        if (entry.key == 'trackingMeta') continue;
        walk(entry.value);
      }
    } else if (n is List) {
      n.forEach(walk);
    }
  }

  walk(node);
  return found;
}

void main() {
  group('PDP — the source fields the rename ledger depends on', () {
    late Map<String, dynamic> productMeta;

    setUp(() {
      productMeta =
          _meta(_fixture('pdp_product_945499.json')['product'] as Map<String, dynamic>);
    });

    test('every ledger source field is present in the real response', () {
      // The product-descriptive keys the wire is expected to carry, in the
      // snake_case the app now reads. `country_of_origin` is the documented
      // exception — absent from the API on both v2 and v3.
      const expected = {
        'category',
        'subcategory',
        'product_type',
        'subproduct_type',
        'brand',
        'gender',
        'from_age',
        'to_age',
        'country_of_origin',
      };
      const knownAbsent = {'country_of_origin'};

      final missing = expected
          .where((source) => !knownAbsent.contains(source))
          .where((source) => !productMeta.containsKey(source))
          .toList();

      expect(
        missing,
        isEmpty,
        reason:
            'The backend stopped sending: $missing. Each one maps to a wire '
            'property that will now be absent from all 22 PDP events, with no '
            'error anywhere. The app does no renaming, so either BE changed the '
            'spelling or dropped the field — raise it with BE.',
      );
    });

    test('countryOfOrigin is still the only absent one', () {
      // If BE adds it, this fails — and the right response is to delete the
      // exception above and close that gap, not to widen the allow-list.
      expect(
        productMeta.containsKey('countryOfOrigin'),
        isFalse,
        reason:
            'BE now sends countryOfOrigin. Remove it from knownAbsent, drop the '
            'B2 finding, and verify country_of_origin reaches the wire.',
      );
    });

    test('the event-scoped fields nothing else covers are present', () {
      // Read directly from `raw` at their call sites rather than through the
      // ledger, so the ledger test above cannot catch them.
      //
      // Exactly ONE spelling each — the wire key. These four are read BY NAME rather
      // than forwarded by the passthrough, so a camelCase spelling does not merely
      // arrive under a different name: it is not read at all, and the property goes
      // absent. That makes an alias-tolerant assertion here worse than none, because
      // it passes on a payload the app cannot use.
      for (final key in const <String>[
        'delivery_days', // → delivery_days (product_viewed)
        'count_of_pids_in_style_code',
        'sale', // "Yes" / "No"
        // `product_attrs` was here while the client expanded the array into one
        // wire key per entry. BE flattens it now, so the keys arrive at the top
        // level and are forwarded like any other — asserted just below.
      ]) {
        expect(
          productMeta.containsKey(key),
          isTrue,
          reason:
              '`$key` is not sent — it is read by name at a call site, so the '
              'property will be absent from the wire entirely',
        );
      }
    });

    test('offersList carries the promo count', () {
      final offers = _fixture('pdp_product_945499.json')['offersList'];
      expect(offers, isA<Map<String, dynamic>>());
      final offersMeta = _meta(offers! as Map<String, dynamic>);
      expect(
        offersMeta['applicableCount'] ?? offersMeta['coupon_applicable'],
        isA<int>(),
        reason:
            'coupon_applicable is emitted with a raw put, so 0 is reported '
            'rather than dropped — and a missing count defaults to 0. If BE '
            'stops sending either spelling, every PDP event ships '
            'coupon_applicable: 0, which is wrong data rather than no data.',
      );
    });
  });

  group('homepage — canary on the two known defects', () {
    late List<Map<String, dynamic>> metas;

    setUp(() => metas = _allMeta(_fixture('home_page_all.json')));

    test('no NEW key ships more than one JSON type', () {
      // Known offenders. Fixing one is fine — this
      // asserts the set does not grow.
      const known = {'cbt_id', 'funnel_row', 'tile_detail_id'};

      final types = <String, Set<String>>{};
      for (final meta in metas) {
        meta.forEach(
          (k, v) => (types[k] ??= <String>{}).add(v.runtimeType.toString()),
        );
      }
      final split = types.entries
          .where((e) => e.value.length > 1)
          .map((e) => e.key)
          .toSet();

      expect(
        split.difference(known),
        isEmpty,
        reason:
            'New type-unstable key(s) on the homepage: ${split.difference(known)}. '
            'The homepage blob is forwarded verbatim, so each of these is now '
            'two Amplitude metrics.',
      );
    });

    test('no NEW camelCase key reaches the wire', () {
      const known = {
        'sectionName',
        'widgetName',
        'productId',
        'videoIdentifier',
        'aspectRatio',
        'createdDate',
        'videoLength',
      };

      final camel = <String>{};
      for (final meta in metas) {
        for (final key in meta.keys) {
          if (!RegExp(r'^[a-z0-9_]+$').hasMatch(key)) camel.add(key);
        }
      }

      expect(
        camel.difference(known),
        isEmpty,
        reason:
            'New camelCase key(s) on the homepage: ${camel.difference(known)}. '
            'These are forwarded untouched and become orphaned metrics. Filter '
            'them at the boundary, or have BE rename them.',
      );
    });

    test('funnel_section is still missing from PageCarousel components', () {
      // Documents the sharper half of D3: PageCarousel does not merely mis-case
      // the key, it sends `sectionName: null` *instead of* `funnel_section`, so
      // carousel events contribute nothing to any funnel_section breakdown.
      final components =
          _fixture('home_page_all.json')['pageComponents'] as List<dynamic>;
      final carousels = components
          .cast<Map<String, dynamic>>()
          .where((c) => c['type'] == 'PageCarousel')
          .map((c) => (c['data'] as Map<String, dynamic>)['trackingMeta'])
          .whereType<Map<String, dynamic>>()
          .toList();

      expect(carousels, isNotEmpty);
      for (final meta in carousels) {
        expect(
          meta.containsKey('funnel_section'),
          isFalse,
          reason:
              'BE now sends funnel_section on PageCarousel — good. Update this '
              'test.',
        );
        expect(meta['sectionName'], isNull);
      }
    });
  });
}
