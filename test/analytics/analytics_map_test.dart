import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/core/analytics/analytics_map.dart';

/// Tests for `putAnalyticsKey` — the filter every property write goes through
/// (`common/.../helper/Extentions.kt:146` on Android). It fails silently when
/// wrong: the payload still sends, just with a key more or fewer than the
/// dashboard expects.
void main() {
  group('putAnalyticsKey', () {
    test('keeps zero and negatives — a 0 is a fact, not an absence', () {
      // Android drops any number <= 0 (`Extentions.kt:150`), which loses
      // `from_age` for a newborn, `position` for the first tile and
      // `discount_percentage` for anything undiscounted. Reproducing it would
      // collapse "zero" and "unknown" into one dashboard value.
      final props = <String, Object?>{}
        ..putAnalyticsKey('feed_size', 0)
        ..putAnalyticsKey('position', 0)
        ..putAnalyticsKey('negative', -1)
        ..putAnalyticsKey('zero_double', 0.0);

      expect(props, {
        'feed_size': 0,
        'position': 0,
        'negative': -1,
        'zero_double': 0.0,
      });
    });

    test('keeps positive numbers, including fractions', () {
      final props = <String, Object?>{}
        ..putAnalyticsKey('feed_size', 42)
        ..putAnalyticsKey('ratio', 0.5);

      expect(props, {'feed_size': 42, 'ratio': 0.5});
    });

    test('drops null, empty strings and empty collections', () {
      final props = <String, Object?>{}
        ..putAnalyticsKey('a', null)
        ..putAnalyticsKey('b', '')
        ..putAnalyticsKey('c', <String>[])
        ..putAnalyticsKey('d', <String>{});

      expect(props, isEmpty);
    });

    test('drops an empty Map — beyond Android, which never sees one', () {
      // A call site never writes `{}`, but a backend `trackingMeta` node can,
      // and `{}` on the wire reports a dimension with nothing to group by.
      final props = <String, Object?>{}
        ..putAnalyticsKey('nested', <String, String>{})
        ..putAnalyticsKey('kept', 'x');

      expect(props, {'kept': 'x'});
    });

    test('keeps BOTH booleans — false is a real value on the wire', () {
      // Kotlin's `when` has no Boolean branch, so booleans bypass the filter.
      // This is why `redirected_from_doorway: false` legitimately ships.
      final props = <String, Object?>{}
        ..putAnalyticsKey('redirected_from_doorway', false)
        ..putAnalyticsKey('from_collection', true);

      expect(props, {
        'redirected_from_doorway': false,
        'from_collection': true,
      });
    });

    test('drops null/empty keys', () {
      final props = <String, Object?>{}
        ..putAnalyticsKey(null, 'v')
        ..putAnalyticsKey('', 'v');

      expect(props, isEmpty);
    });

    test('putAllAnalyticsKeys filters a backend blob entry-by-entry', () {
      // Only the shapes that carry no dimension are removed. A `feed_size: 0`
      // the backend chose to send is forwarded — it means the listing is empty,
      // which is not the same as the backend not reporting a size at all.
      final props = <String, Object?>{}
        ..putAllAnalyticsKeys({
          'plp_type': 'Product listing',
          'feed_size': 0,
          'is_page_xl_tile_eligible': 'Yes',
          'empty': '',
          'nothing': <String, String>{},
          'redirected_from_doorway': false,
        });

      expect(props, {
        'plp_type': 'Product listing',
        'feed_size': 0,
        'is_page_xl_tile_eligible': 'Yes',
        'redirected_from_doorway': false,
      });
    });

    test('putAllAnalyticsKeys tolerates a null blob', () {
      final props = <String, Object?>{}..putAllAnalyticsKeys(null);
      expect(props, isEmpty);
    });

    test('later writes overwrite earlier ones', () {
      final props = <String, Object?>{}
        ..putAnalyticsKey('from_screen', 'Discover')
        ..putAnalyticsKey('from_screen', 'Search');

      expect(props['from_screen'], 'Search');
    });

    test('a dropped value does not clobber an existing key', () {
      // Ordering guarantee the event builders rely on: spreading the backend
      // blob first and then applying client nav context must not let an
      // absent client value erase a good backend one.
      final props = <String, Object?>{}
        ..putAnalyticsKey('from_screen', 'Discover')
        ..putAnalyticsKey('from_screen', null)
        ..putAnalyticsKey('from_screen', '');

      expect(props['from_screen'], 'Discover');
    });

    test('analyticsProps builds a filtered map functionally', () {
      expect(analyticsProps({'a': 1, 'b': 0, 'c': 'x', 'd': ''}), {
        'a': 1,
        'b': 0,
        'c': 'x',
      });
    });
  });
}
