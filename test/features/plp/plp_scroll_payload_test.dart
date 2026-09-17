import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/features/plp/domain/entities/listing_product_entity.dart';
import 'package:hs_app_flutter/features/plp/domain/helpers/plp_scroll_payload.dart';

ListingProductEntity _p(
  int id, {
  String? brand,
  bool xl = false,
  Map<String, dynamic>? meta,
}) => ListingProductEntity(
  id: id,
  name: 'p$id',
  brandName: brand,
  isXLTile: xl,
  trackingMeta: meta,
);

void main() {
  group('plpScrollRange', () {
    test('an untouched window covers the whole loaded list', () {
      expect(
        plpScrollRange(startRow: 0, endRow: 0, itemCount: 40),
        const PlpScrollRange(0, 40),
      );
    });

    test('converts rows to items by doubling while the window fits', () {
      expect(
        plpScrollRange(startRow: 3, endRow: 8, itemCount: 40),
        const PlpScrollRange(6, 16),
      );
    });

    test('keeps row 1 as 1 rather than doubling it, so the first product '
        'is not skipped', () {
      expect(
        plpScrollRange(startRow: 1, endRow: 5, itemCount: 40),
        const PlpScrollRange(1, 10),
      );
    });

    test('falls back to the raw start and the list end once the doubled row '
        'runs past what is loaded', () {
      // endRow 25 → 50 items, but only 40 are loaded.
      expect(
        plpScrollRange(startRow: 12, endRow: 25, itemCount: 40),
        const PlpScrollRange(12, 40),
      );
    });
  });

  group('productsIn', () {
    final products = List.generate(10, (i) => _p(i));

    test('maps a start of 1 back to index 0', () {
      final slice = productsIn(products, const PlpScrollRange(1, 4));
      expect(slice.map((p) => p.id), [0, 1, 2, 3]);
    });

    test('slices the half-open range', () {
      final slice = productsIn(products, const PlpScrollRange(4, 7));
      expect(slice.map((p) => p.id), [4, 5, 6]);
    });

    test('clamps an end past the list instead of throwing', () {
      final slice = productsIn(products, const PlpScrollRange(8, 999));
      expect(slice.map((p) => p.id), [8, 9]);
    });

    test('returns empty for an inverted or out-of-bounds range', () {
      expect(productsIn(products, const PlpScrollRange(7, 3)), isEmpty);
      expect(productsIn(products, const PlpScrollRange(50, 60)), isEmpty);
      expect(productsIn(const [], const PlpScrollRange(0, 5)), isEmpty);
    });
  });

  group('plpScrollLists', () {
    test('de-duplicates each list independently, so lists end up different '
        'lengths and must not be zipped', () {
      final lists = plpScrollLists([
        _p(1, brand: 'Nike'),
        _p(2, brand: 'Nike'),
        _p(3, brand: 'Puma'),
      ]);

      expect(lists.productIds, ['1', '2', '3']);
      expect(lists.brand, ['Nike', 'Puma']);
    });

    test('collects XL ids into their own list as well as product_id', () {
      final lists = plpScrollLists([_p(1), _p(2, xl: true), _p(3)]);

      expect(lists.productIds, ['1', '2', '3']);
      expect(lists.xlProductIds, ['2']);
    });

    test('skips null and empty brands rather than shipping blanks', () {
      final lists = plpScrollLists([_p(1), _p(2, brand: ''), _p(3, brand: 'X')]);
      expect(lists.brand, ['X']);
    });

    test('reads category and friends out of the per-product trackingMeta', () {
      final lists = plpScrollLists([
        _p(1, meta: {'category': 'Apparel', 'subcategory': 'Tops'}),
        _p(2, meta: {'category': 'Apparel', 'product_type': 'T-Shirt'}),
      ]);

      expect(lists.category, ['Apparel']);
      expect(lists.subCategory, ['Tops']);
      expect(lists.productType, ['T-Shirt']);
    });

    test('leaves those lists empty while the backend has not added the keys, '
        'so the event omits them instead of sending []', () {
      final lists = plpScrollLists([_p(1), _p(2)]);

      expect(lists.category, isEmpty);
      expect(lists.subCategory, isEmpty);
      expect(lists.productType, isEmpty);
      expect(lists.merchType, isEmpty);
    });

    test('ignores non-string trackingMeta values', () {
      final lists = plpScrollLists([
        _p(1, meta: {'category': 42, 'subcategory': null}),
      ]);

      expect(lists.category, isEmpty);
      expect(lists.subCategory, isEmpty);
    });
  });

  group('plpTotalRows', () {
    test('rounds a trailing odd product up into its own row', () {
      expect(plpTotalRows(totalRecords: 7, extraRowCount: 0), 4);
    });

    test('pairs an even count exactly', () {
      expect(plpTotalRows(totalRecords: 8, extraRowCount: 0), 4);
    });

    test('adds the extra rows above the list', () {
      expect(plpTotalRows(totalRecords: 375, extraRowCount: 2), 190);
    });
  });

  group('plpScaledRowHeight (Android width normalisation)', () {
    // ProductsListingAdapter:151
    //   viewHeight = ceil(375 * tileHeight / displayWidth)
    test('rescales a row to the 375-wide reference viewport', () {
      // 1080-wide device, 900px tall row → 375 * 900 / 1080 = 312.5 → 313
      expect(plpScaledRowHeight(900, 1080), 313);
    });

    test('ceils, matching Android (not round or truncate)', () {
      expect(plpScaledRowHeight(288, 1080), 100); // exactly 100.0
      expect(plpScaledRowHeight(289, 1080), 101); // 100.35 → 101
    });

    test('the unit cancels — logical and physical inputs agree', () {
      const dpr = 2.75;
      final logical = plpScaledRowHeight(330, 392);
      final physical = plpScaledRowHeight(330 * dpr, 392 * dpr);
      expect(logical, physical,
          reason: 'ratio-based, so no devicePixelRatio to thread through');
    });

    test('the same row on different-width devices reports the same depth', () {
      // A row is one screen-width wide over two columns, so its height scales
      // with the device width — the whole point of normalising.
      final narrow = plpScaledRowHeight(360 * 0.84, 360);
      final wide = plpScaledRowHeight(430 * 0.84, 430);
      expect(narrow, wide);
    });

    test('degenerate inputs contribute nothing rather than dividing by zero', () {
      expect(plpScaledRowHeight(900, 0), 0); // before first layout
      expect(plpScaledRowHeight(0, 1080), 0);
      expect(plpScaledRowHeight(-5, 1080), 0);
    });

    test('is far smaller than the raw pixel height it replaces', () {
      // The regression this fixes: Flutter was accumulating raw logical px.
      expect(plpScaledRowHeight(330, 392), lessThan(330));
    });
  });
}
