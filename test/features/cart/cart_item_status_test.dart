import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/features/cart/data/models/cart_model.dart';
import 'package:hs_app_flutter/features/cart/domain/entities/cart_entity.dart';
import 'package:hs_app_flutter/features/cart/domain/entities/cart_item_entity.dart';
import 'package:hs_app_flutter/features/cart/domain/helpers/cart_item_analytics.dart';

/// `quantity_status` and `price_status` for one cart line.
///
/// The two are sourced differently and fail differently, so they are pinned
/// separately: the first is computed from the line and has three branches, the
/// second is read positionally out of the backend block and fails by drifting
/// out of alignment with the cart.
void main() {
  CartItemEntity line({
    int? quantity = 1,
    int? selectMaxValue = 3,
    bool isSoldOut = false,
    bool isSizeSoldOut = false,
  }) => CartItemEntity(
    sku: 'SKU-1',
    quantity: quantity,
    selectMaxValue: selectMaxValue,
    isSoldOut: isSoldOut,
    isSizeSoldOut: isSizeSoldOut,
  );

  group('quantity_status', () {
    test('an in-stock line within its cap is Available', () {
      expect(line().quantityStatus, 'Available');
    });

    test('a sold-out line is the string "0"', () {
      // The string, not the number — a numeric 0 is dropped by Android's
      // `putAnalyticsKey`, which would empty the sold-out bucket there.
      expect(line(isSoldOut: true).quantityStatus, '0');
      expect(line(isSoldOut: true).quantityStatus, isA<String>());
    });

    test('a sold-out *size* is "0" as well', () {
      expect(line(isSizeSoldOut: true).quantityStatus, '0');
    });

    test('sold-out wins over an over-cap quantity', () {
      // Order matters: both conditions hold here, and "0" is the more urgent
      // fact — the line cannot be bought at any quantity.
      expect(
        line(isSoldOut: true, quantity: 5, selectMaxValue: 3).quantityStatus,
        '0',
      );
    });

    test('holding more than is available is Lower', () {
      expect(line(quantity: 5, selectMaxValue: 3).quantityStatus, 'Lower');
    });

    test('exactly at the cap is still Available', () {
      // Strictly greater-than, matching Android's `quantity > selectMaxValue`.
      // An off-by-one here would report every maxed-out line as short.
      expect(line(quantity: 3, selectMaxValue: 3).quantityStatus, 'Available');
    });

    test('a missing cap reads as zero, so any quantity is Lower', () {
      // Android's `zeroIfNull()`. A line with stock but no stated maximum
      // reports Lower rather than silently passing as available.
      expect(line(quantity: 1, selectMaxValue: null).quantityStatus, 'Lower');
    });

    test('no quantity and no cap is Available, not Lower', () {
      // 0 > 0 is false — the degenerate case must not report a shortage.
      expect(
        line(quantity: null, selectMaxValue: null).quantityStatus,
        'Available',
      );
    });
  });

  group('price_status', () {
    CartEntity cartWithBlock(Object? priceStatus, {int items = 2}) =>
        CartModel.fromJson({
          'trackingMeta': {'price_status': priceStatus},
          'cartItems': [
            for (var i = 0; i < items; i++) {'sku': 'SKU-$i', 'quantity': 1},
          ],
        });

    test('reads the backend value at the line position', () {
      final cart = cartWithBlock(['Same', 'Lower']);
      expect(cart.priceStatusAt(0), 'Same');
      expect(cart.priceStatusAt(1), 'Lower');
    });

    test('resolves through the sku, so it survives a reorder', () {
      final cart = cartWithBlock(['Same', 'Higher']);
      expect(cart.priceStatusAt(cart.indexOfSku('SKU-1')), 'Higher');
    });

    test('a shorter block than the cart falls back to Same', () {
      // The alignment is the backend's to keep. When it slips, reporting the
      // neighbouring line's status would be worse than reporting none.
      final cart = cartWithBlock(['Same']);
      expect(cart.priceStatusAt(1), 'Same');
    });

    test('a missing block falls back to Same', () {
      // What the old client-side derivation produced for "no price message",
      // so a response without the block says what the app would have said.
      final cart = cartWithBlock(null);
      expect(cart.priceStatusAt(0), 'Same');
    });

    test('a non-list block falls back rather than throwing', () {
      final cart = cartWithBlock('Same');
      expect(cart.priceStatusAt(0), 'Same');
    });

    test('an out-of-range or unknown sku falls back', () {
      final cart = cartWithBlock(['Same', 'Lower']);
      expect(cart.priceStatusAt(-1), 'Same');
      expect(cart.priceStatusAt(9), 'Same');
      expect(cart.indexOfSku('NOPE'), -1);
      expect(cart.indexOfSku(null), -1);
    });

    test('a non-string entry falls back', () {
      final cart = cartWithBlock([42, 'Lower']);
      expect(cart.priceStatusAt(0), 'Same');
      expect(cart.priceStatusAt(1), 'Lower');
    });

    test('an unrecognised backend value is forwarded, not normalised', () {
      // The client does not own this vocabulary any more. A fourth value the
      // backend introduces must reach the wire rather than be folded into Same.
      final cart = cartWithBlock(['Unchanged']);
      expect(cart.priceStatusAt(0), 'Unchanged');
    });
  });
}
