import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Guards two properties of the PDP wire format that the homepage lost:
///
/// 1. **Every wire key is `snake_case`.**
/// 2. **Every wire key has exactly one JSON type** across all 22 events.
///
/// Both matter because Amplitude keys on the exact property string *and* buckets
/// values of different types separately. A key that is `cbt_id: 2501` on one
/// event and `cbt_id: "1397"` on another is two metrics, and nothing errors.
///
/// This is not hypothetical — it is live on the Flutter homepage today, which
/// forwards backend `trackingMeta` verbatim with no validation:
///
/// | key | types observed in one response |
/// |---|---|
/// | `cbt_id` | `int` (PageCarousel) and `String` (CustomTiles) |
/// | `funnel_row` | `int` and `String` |
/// | `tile_detail_id` | `int` and `String` |
///
/// plus seven camelCase keys reaching the wire (`sectionName` — as `null` —
/// `widgetName`, `productId`, `videoLength`, `aspectRatio`, `createdDate`,
/// `videoIdentifier`).
///
/// PDP is currently immune because the client renames through an **allow-list**
/// and coerces types, so unknown or mistyped backend keys cannot reach the wire.
/// That protection is easy to lose when tracking meta moves server-side, so it is
/// pinned here rather than left as a property of the current implementation.
///
/// The two exceptions below are deliberate and each requires a reason. Adding a
/// third should be a conscious decision, which is the point of the test.
const _goldenPath = 'test/analytics/fixtures/pdp_wire_format.golden.json';

/// `productAttrs` entry names become wire keys verbatim, and the merchandising
/// team authors them in mixed case (`HBT`, `Season`). Renaming or lower-casing
/// them client-side would diverge from Android, which spreads them untouched.
/// Tracked as a backend convention issue, not fixable here.
const _allowedNonSnakeKeys = <String>{'HBT', 'Season'};

/// `sku` appears on exactly two events, with a different type on each:
///
/// | event | type | Android source |
/// |---|---|---|
/// | `product_viewed` | `List<String>` — every SKU id on the page | `PDPAnalytics.kt:126`, inside `sendProductViewedEvent()` |
/// | `size_selected` | `String` — the selected SKU id | `PDPAnalytics.kt:199` / `:209`, the two branches of `sendSizeSelected()` |
///
/// Note it is **not** part of `pdpPageProperties()`, so it does not reach
/// `product_added_to_cart` or `buy_now_clicked` on either platform.
///
/// It is a genuine metric split on **both** platforms, but Flutter must not
/// "fix" it unilaterally: doing so would diverge.
const _allowedMultiTypeKeys = <String>{'sku'};

void main() {
  late Map<String, Map<String, String>> golden;

  setUpAll(() {
    final raw =
        jsonDecode(File(_goldenPath).readAsStringSync()) as Map<String, dynamic>;
    golden = raw.map(
      (event, props) => MapEntry(
        event,
        (props as Map<String, dynamic>).cast<String, String>(),
      ),
    );
  });

  /// The golden renders each value as `"<Type> <value>"`.
  String typeOf(String rendered) => rendered.split(' ').first;

  test('every wire key is snake_case', () {
    final offenders = <String>{};
    for (final props in golden.values) {
      for (final key in props.keys) {
        if (_allowedNonSnakeKeys.contains(key)) continue;
        // Enrichment keys legitimately use the `[time] x` / `[bucket] x` shape.
        if (key.startsWith('[')) continue;
        if (!RegExp(r'^[a-z0-9_]+$').hasMatch(key)) offenders.add(key);
      }
    }
    expect(
      offenders,
      isEmpty,
      reason:
          'These keys are not snake_case: $offenders. Amplitude treats '
          '`subCategory` and `subcategory` as two metrics. If a key must stay '
          'mixed-case, add it to _allowedNonSnakeKeys with a reason.',
    );
  });

  test('every wire key has exactly one JSON type across all events', () {
    final typesByKey = <String, Set<String>>{};
    for (final props in golden.values) {
      props.forEach((key, rendered) {
        (typesByKey[key] ??= <String>{}).add(typeOf(rendered));
      });
    }

    final split = <String, Set<String>>{};
    typesByKey.forEach((key, types) {
      if (types.length > 1 && !_allowedMultiTypeKeys.contains(key)) {
        split[key] = types;
      }
    });

    expect(
      split,
      isEmpty,
      reason:
          'These keys ship more than one type, which silently splits each into '
          'multiple Amplitude metrics: $split. This is the failure mode already '
          'live on the homepage (cbt_id, funnel_row, tile_detail_id). Coerce to '
          'one type, or add to _allowedMultiTypeKeys with an Android reference.',
    );
  });

  test('the documented exceptions are still real, not stale', () {
    // A stale allow-list quietly stops guarding. If an exception no longer
    // occurs, it should be deleted rather than left as permanent permission.
    final allKeys = golden.values.expand((p) => p.keys).toSet();
    for (final key in {..._allowedNonSnakeKeys, ..._allowedMultiTypeKeys}) {
      expect(
        allKeys,
        contains(key),
        reason:
            '$key is allow-listed but no longer appears on any event — remove '
            'it from the exception set so the guard stays tight.',
      );
    }
  });

  test('sku ships as an array on most events and a string on the three with a selection', () {
    // The one key two nodes share, and the cost of a single product node.
    //
    // `product.trackingMeta` carries `sku` as the array of every variant and
    // rides every event. `product.skus[sel].trackingMeta` carries the selected id
    // as a String and is chained second on the three events that have a
    // selection, so it wins there. Android has the same conflict across 2 events;
    // passthrough widens it to 23. Accepted deliberately — section 6 of
    // `docs/analytics/pdp/contract/passthrough-spec.md`.
    //
    // Pinned because it is invisible at runtime: nothing errors, the warehouse
    // just types the column from whichever shape lands first.
    const selectionEvents = {
      'size_selected',
      'product_added_to_cart',
      'buy_now_clicked',
    };

    final carriers = golden.entries
        .where((e) => e.value.containsKey('sku'))
        .map((e) => e.key)
        .toSet();

    // The wishlist pair reaches `sku` through its own tile block rather than the
    // PDP chain, so its type is that channel's business, not this one's.
    const wishlistEvents = {
      'product_added_to_wishlist',
      'product_removed_from_wishlist',
    };

    for (final event in carriers) {
      if (wishlistEvents.contains(event)) continue;
      final type = typeOf(golden[event]!['sku']!);
      if (selectionEvents.contains(event)) {
        expect(type, 'String', reason: '$event chains the selected sku node');
      } else {
        expect(
          type,
          startsWith('List'),
          reason: '$event carries only the product node, whose sku is the array',
        );
      }
    }

    expect(
      carriers.intersection(selectionEvents),
      selectionEvents,
      reason: 'an event with a selected sku stopped chaining the sku node',
    );
    expect(
      carriers.difference(selectionEvents).difference(wishlistEvents),
      isNotEmpty,
      reason: 'the product node should put the array on the remaining events',
    );
  });
}
