import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/components/buttons/app_button.dart';
import 'package:hs_app_flutter/components/buttons/button_enums.dart';
import 'package:hs_app_flutter/core/constants/strings/auto_test_strings.dart';
import 'package:hs_app_flutter/core/constants/strings/pdp_strings.dart';
import 'package:hs_app_flutter/features/pdp/presentation/widgets/pdp_add_to_bag_bar.dart';

// A sold-out product keeps the same two CTAs it has when in stock. Only the
// enabled/disabled state tracks inventory — the label never becomes "SOLD OUT".
void main() {
  const buyNowKey = ValueKey(PdpTestStrings.buyNowButton);
  const addToBagKey = ValueKey(PdpTestStrings.addToBagButton);

  Future<void> pump(WidgetTester tester, {required bool soldOut}) => tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: PdpAddToBagBar(
          soldOut: soldOut,
          buyNowKey: buyNowKey,
          addToBagKey: addToBagKey,
          onBuyNow: () {},
          onAddToBag: () {},
        ),
      ),
    ),
  );

  AppButton buttonAt(WidgetTester tester, Key key) =>
      tester.widget<AppButton>(find.byKey(key).first);

  testWidgets('a sold-out product still reads "Buy Now"', (tester) async {
    await pump(tester, soldOut: true);
    expect(buttonAt(tester, buyNowKey).text, PdpStrings.buyNow);
    expect(find.text(PdpStrings.soldOut), findsNothing);
  });

  testWidgets('both CTAs are disabled when sold out', (tester) async {
    await pump(tester, soldOut: true);
    expect(buttonAt(tester, buyNowKey).state, ButtonState.disabled);
    expect(buttonAt(tester, addToBagKey).state, ButtonState.disabled);
  });

  testWidgets('an in-stock product shows the same labels, enabled', (tester) async {
    await pump(tester, soldOut: false);
    expect(buttonAt(tester, buyNowKey).text, PdpStrings.buyNow);
    expect(buttonAt(tester, buyNowKey).state, ButtonState.enabled);
    expect(buttonAt(tester, addToBagKey).state, ButtonState.enabled);
  });
}
