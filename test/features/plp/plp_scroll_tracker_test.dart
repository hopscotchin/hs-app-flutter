import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/features/plp/domain/helpers/plp_scroll_tracker.dart';

void main() {
  /// Every row 100px unless stated otherwise — keeps the arithmetic readable.
  PlpScrollTracker uniform([double h = 100]) =>
      PlpScrollTracker(rowHeight: (_) => h);

  group('depth accumulation', () {
    test('counts rows and heights as the deepest row advances', () {
      final t = uniform()..setScrolled();
      t.onScrolledItemChanged(5);

      expect(t.scrolledRow, 5);
      expect(t.scrolledHeight, 500);
    });

    test('sums per-row heights rather than multiplying, so a tall XL row '
        'is not undercounted on a fling', () {
      // Row 3 is an XL tile at 400px; everything else is a 100px product row.
      final t = PlpScrollTracker(rowHeight: (i) => i == 3 ? 400 : 100)
        ..setScrolled()
        // One jump over rows 1-5 — a fling, not five separate notifications.
        ..onScrolledItemChanged(5);

      expect(t.scrolledHeight, 800, reason: '4 x 100 + 1 x 400');
    });

    test('scrolling back up does not decrement — the event reports how far '
        'the user ever got', () {
      final t = uniform()..setScrolled();
      t.onScrolledItemChanged(20);
      t.onScrolledItemChanged(2);

      expect(t.scrolledRow, 20);
      expect(t.scrolledHeight, 2000);
    });
  });

  group('excluded rows', () {
    test('are left out of the count but still contribute height by default', () {
      final t = uniform()
        ..setScrolled()
        ..excludePosition(2)
        ..onScrolledItemChanged(4);

      expect(t.scrolledRow, 3, reason: 'row 2 excluded from the count');
      expect(t.scrolledHeight, 400, reason: 'but its height still counts');
    });

    test('drop their height too once countHeightForExcludedRows is off', () {
      final t = uniform()
        ..countHeightForExcludedRows = false
        ..setScrolled()
        ..excludePosition(2)
        ..onScrolledItemChanged(4);

      expect(t.scrolledRow, 3);
      expect(t.scrolledHeight, 300);
    });
  });

  group('consumeScrollDepthParams', () {
    test('reports once for a page the user never scrolled, then goes quiet', () {
      final t = uniform();

      final first = t.consumeScrollDepthParams();
      expect(first, isNotNull);
      expect(first!['from_row'], 1);
      expect(first['scrolled_row'], 0);
      expect(
        first['scrolled_height'],
        0,
        reason: 'the one place a genuine zero must ship',
      );

      expect(
        t.consumeScrollDepthParams(),
        isNull,
        reason: 'the unscrolled allowance is consumed by the first read',
      );
    });

    test('returns null when the window has not advanced since the last send', () {
      final t = uniform()..setScrolled();
      t.onScrolledItemChanged(6);

      expect(t.consumeScrollDepthParams(), isNotNull);
      t.resetStartScrollIndex();

      expect(t.consumeScrollDepthParams(), isNull);
    });

    test('reports the next stretch after a reset, not everything from row 1', () {
      final t = uniform()..setScrolled();
      t.onScrolledItemChanged(6);
      t.consumeScrollDepthParams();
      t.resetStartScrollIndex();

      t.onScrolledItemChanged(10);
      final second = t.consumeScrollDepthParams();

      expect(second, isNotNull);
      expect(second!['from_row'], 6, reason: 'window reopened at the old depth');
      expect(second['scrolled_row'], 10);
    });

    test('omits scrolled_height at zero on a normal send', () {
      // Advance the window with zero-height rows: there is something to report,
      // but no height, and the never-scrolled exemption no longer applies.
      final t = PlpScrollTracker(rowHeight: (_) => 0)..setScrolled();
      t.onScrolledItemChanged(3);
      t.consumeScrollDepthParams();
      t.resetStartScrollIndex();

      t.onScrolledItemChanged(7);
      final params = t.consumeScrollDepthParams();

      expect(params, isNotNull);
      expect(params!.containsKey('scrolled_height'), isFalse);
    });
  });

  group('extra rows', () {
    test('are folded into from_row, scrolled_row and scrolled_height', () {
      final t = uniform()
        ..setExtraRowData(rows: 2, height: 250)
        ..setScrolled();
      t.onScrolledItemChanged(4);

      expect(t.scrolledRow, 6, reason: '4 scrolled + 2 extra');
      expect(t.scrolledHeight, 650, reason: '400 + 250');
      expect(t.endScrollIndex, 6);
    });
  });

  test('recalculateViewHeight rebases after the list is replaced', () {
    final t = uniform()..setScrolled();
    t.onScrolledItemChanged(10);
    expect(t.scrolledHeight, 1000);

    // Filter reload: the rows at these indices are different products now.
    t.recalculateViewHeight(0, 3);

    expect(t.scrolledRow, 3);
    expect(t.scrolledHeight, 300);
  });
}
