import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/core/constants/strings/auto_test_strings.dart';
import 'package:hs_app_flutter/features/cart/domain/entities/cart_item_detail_entity.dart';
import 'package:hs_app_flutter/features/cart/domain/entities/cart_item_entity.dart';
import 'package:hs_app_flutter/features/cart/domain/entities/cart_item_price_info_entity.dart';
import 'package:hs_app_flutter/features/cart/presentation/widgets/cart_item_widget.dart';

/// A cart line's detail rows each need their own automation key.
///
/// The keys are `cart_item_<i>_detail_<j>` — `<i>` the row, `<j>` the detail's
/// position within it. Both halves matter: `<i>` is applied by the widget's own
/// `_key` helper, and `<j>` has to come from the detail's index in
/// `cartItemDetails`. Passing the row index for `<j>` compiles, reads
/// plausibly, and gives every detail on a row the same key — which Flutter
/// throws on as "Duplicate keys found" the moment an item carries more than
/// one.
///
/// Two or three details on a line is ordinary, not an edge case: a price drop,
/// a returns note and a coupon-savings line commonly appear together.
void main() {
  CartItemEntity itemWith(int detailCount) => CartItemEntity(
    sku: 'KDL-3046118',
    productId: 944379,
    productName: 'Passion Petals Self Design Clogs- Pink',
    brandName: 'PASSION PETALS',
    size: 'Euro 30 (3.5-4 years)',
    quantity: 1,
    selectMaxValue: 3,
    priceInfo: const CartItemPriceInfoEntity(
      sellingPrice: '₹599',
      absoluteValue: 599,
    ),
    cartItemDetails: [
      for (var i = 0; i < detailCount; i++)
        CartItemDetailEntity(title: 'Detail $i', titleColor: '#10900B'),
    ],
  );

  Future<void> pump(WidgetTester tester, CartItemEntity item) =>
      tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: CartItemWidget(testIndex: 0, item: item),
            ),
          ),
        ),
      );

  testWidgets('three detail rows get three distinct keys', (tester) async {
    // The shape from the reported payload: "Price dropped by ₹100", a
    // non-returnable tooltip note, and "₹199 saved from BUY5 coupon".
    await pump(tester, itemWith(3));

    // No "Duplicate keys found" — an assertion failure surfaces here.
    expect(tester.takeException(), isNull);

    for (var j = 0; j < 3; j++) {
      expect(
        find.byKey(
          ValueKey('${CartTestStrings.item}_0_${CartTestStrings.itemDetailSuffix}_$j'),
        ),
        findsOneWidget,
        reason: 'detail $j is missing, or shares a key with another row',
      );
    }
  });

  testWidgets('a single detail row still keys as _detail_0', (tester) async {
    // The case that always passed, even with the bug — pinned so a fix that
    // reindexed from 1 would be caught.
    await pump(tester, itemWith(1));
    expect(tester.takeException(), isNull);
    expect(
      find.byKey(
        const ValueKey(
          '${CartTestStrings.item}_0_${CartTestStrings.itemDetailSuffix}_0',
        ),
      ),
      findsOneWidget,
    );
  });

  testWidgets('detail keys are scoped to their row', (tester) async {
    // Two rows each carrying two details: the row index has to stay in the key
    // as well, or rows 0 and 1 would collide with each other.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                CartItemWidget(testIndex: 0, item: itemWith(2)),
                CartItemWidget(testIndex: 1, item: itemWith(2)),
              ],
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    for (var i = 0; i < 2; i++) {
      for (var j = 0; j < 2; j++) {
        expect(
          find.byKey(
            ValueKey(
              '${CartTestStrings.item}_${i}_${CartTestStrings.itemDetailSuffix}_$j',
            ),
          ),
          findsOneWidget,
          reason: 'row $i detail $j collided',
        );
      }
    }
  });
}
