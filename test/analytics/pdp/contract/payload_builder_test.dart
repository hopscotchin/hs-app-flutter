import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/core/analytics/analytics_payload_builder.dart';

void main() {
  group('buildAnalyticsPayload', () {
    test('merges root to leaf with deeper nodes winning', () {
      final props = buildAnalyticsPayload(
        nodes: [
          {'product_id': '945499', 'price': 349},
          {'sku_size': '4-5 Y'},
        ],
      );
      expect(props, {
        'product_id': '945499',
        'price': 349,
        'sku_size': '4-5 Y',
      });
    });

    // The one key two nodes share. product.trackingMeta sends the array of all
    // variants; the sku node sends the selected id. Android emits the string on
    // size_selected, so the sku node must be chained second.
    test(
      'sku: the deeper node replaces the array with the selected string',
      () {
        final props = buildAnalyticsPayload(
          nodes: [
            {
              'sku': const ['WHA-3049919', 'WHA-3049920', 'WHA-3049921'],
            },
            {'sku': 'WHA-3049920'},
          ],
        );
        expect(props['sku'], 'WHA-3049920');
      },
    );

    // Reversing the chain is silent, not an error — this is what the test exists
    // to catch.
    test('sku: reversing the chain reports every variant instead', () {
      final props = buildAnalyticsPayload(
        nodes: [
          {'sku': 'WHA-3049920'},
          {
            'sku': const ['WHA-3049919', 'WHA-3049920', 'WHA-3049921'],
          },
        ],
      );
      expect(props['sku'], isA<List<String>>());
    });

    test(
      'null nodes contribute nothing, so an absent rail needs no branch',
      () {
        final props = buildAnalyticsPayload(
          nodes: [
            {'product_id': '945499'},
            null,
            {'feed_size': 20},
          ],
        );
        expect(props, {'product_id': '945499', 'feed_size': 20});
      },
    );

    // The deeper node is the more specific description of the same thing, so it
    // wins the collision whatever it carries. A size reporting nothing for a key
    // is not a size inheriting the product's answer to it.
    test('a value carrying no dimension still wins the collision', () {
      final props = buildAnalyticsPayload(
        nodes: [
          {'brand': 'Whaou', 'low_inventory': 'Yes'},
          {'brand': null, 'low_inventory': '', 'sku_size': '4-5 Y'},
        ],
      );
      expect(props['brand'], isNull);
      expect(props['low_inventory'], '');
      expect(props['sku_size'], '4-5 Y');
    });

    test('interaction merges last and wins over a same-named server key', () {
      final props = buildAnalyticsPayload(
        nodes: [
          {'from_location': 'server value'},
        ],
        payload: {'from_location': 'Size list upfront'},
      );
      expect(props['from_location'], 'Size list upfront');
    });

    // Nothing is filtered here, unlike `putAnalyticsKey`, which drops these as an
    // app-side call site writes them. A node's contents reach the wire as sent, so
    // not sending an empty is the backend's job.
    test('empties are forwarded, not dropped', () {
      final props = buildAnalyticsPayload(
        nodes: [
          {
            'blank': '',
            'no_items': <String>[],
            'nested': <String, String>{},
            'kept': 'x',
          },
        ],
      );
      expect(props, {
        'blank': '',
        'no_items': <String>[],
        'nested': <String, String>{},
        'kept': 'x',
      });
    });

    test('a non-empty Map or Iterable is forwarded as-is', () {
      final props = buildAnalyticsPayload(
        nodes: [
          {
            'nested': {'k': 'v'},
            'tags': const {'a'},
          },
        ],
      );
      expect(props['nested'], {'k': 'v'});
      expect(props['tags'], {'a'});
    });

    // Call sites build `interaction` with `putAnalyticsKey`, which never writes a
    // null, so this shape does not arise in practice. Pinned because the merge
    // itself no longer guards it: a null here would overwrite a server key.
    test('an interaction value is forwarded as given, null included', () {
      final props = buildAnalyticsPayload(
        nodes: [
          {'atc_user': 'FROM SERVER'},
        ],
        payload: {'scroll_depth': null, 'atc_user': null},
      );
      expect(props.containsKey('scroll_depth'), isTrue);
      expect(props['scroll_depth'], isNull);
      expect(props['atc_user'], isNull);
    });

    test('zero survives — a genuine 0 is not "absent"', () {
      final props = buildAnalyticsPayload(
        nodes: [
          {'discount_percentage': 0, 'from_age': 0},
        ],
      );
      expect(props['discount_percentage'], 0);
      expect(props['from_age'], 0);
    });

    test('empty chain yields an empty map', () {
      expect(buildAnalyticsPayload(nodes: const []), isEmpty);
    });
  });
}
