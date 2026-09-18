import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/components/atoms/price_summary_widget.dart';
import 'package:hs_app_flutter/core/entities/backend_action_entity.dart';
import 'package:hs_app_flutter/core/entities/order_summary_entity.dart';
import 'package:hs_app_flutter/core/entities/pricing_item_entity.dart';

/// `shipping_info_viewed` reports the price summary's ⓘ sheets — nothing else.
///
/// It previously fired from "See all offers" instead, so every promos-sheet
/// open landed in the shipping-info bucket while the sheet the event is named
/// for went unreported. These pin the trigger at the widget level.
void main() {
  /// A "Shipping fee" row with the backend's info action, as the cart sends it.
  const shippingRow = PricingItemEntity(
    label: 'Shipping fee',
    value: 'FREE',
    originalValue: '₹50',
    subText: 'Free shipping on orders of ₹10000 or more.',
    action: BackendActionEntity(
      type: 'bottomSheet',
      content: BackendActionContentEntity(
        title: 'Shipping fee',
        description:
            'Shipping charges are calculated based on delivery location and '
            'order weight.',
        leftAction: BackendActionButtonEntity(label: 'Got It'),
      ),
    ),
  );

  /// The other half of the pair this event has to tell apart.
  const platformRow = PricingItemEntity(
    label: 'Platform fee',
    value: '₹14',
    action: BackendActionEntity(
      type: 'bottomSheet',
      content: BackendActionContentEntity(
        title: 'Platform fee',
        description:
            'A platform fee may be applied to your order. It helps us ensure '
            'secure payments, smooth updates, and a seamless shopping '
            'experience for you.',
        leftAction: BackendActionButtonEntity(label: 'Got It'),
      ),
    ),
  );

  /// A row with no action at all — most rows are this shape.
  const plainRow = PricingItemEntity(label: 'Total item price', value: '₹3363');

  Future<void> pumpSummary(
    WidgetTester tester, {
    required List<PricingItemEntity> rows,
    required void Function(PricingItemEntity) onOpened,
  }) => tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: PriceSummaryWidget(
            summary: OrderSummaryEntity(pricingData: rows),
            onRowActionOpened: onOpened,
          ),
        ),
      ),
    ),
  );

  testWidgets('opening a row\'s info sheet reports that row', (tester) async {
    final opened = <String?>[];
    await pumpSummary(
      tester,
      rows: const [plainRow, shippingRow],
      onOpened: (row) => opened.add(row.label),
    );

    // Rendering reports nothing; only opening does.
    expect(opened, isEmpty);

    await tester.tap(find.byIcon(Icons.info_outline));
    await tester.pumpAndSettle();

    expect(find.text('Shipping fee'), findsWidgets);
    expect(opened, ['Shipping fee']);
  });

  testWidgets('a row with no action reports nothing', (tester) async {
    final opened = <String?>[];
    await pumpSummary(tester, rows: const [plainRow], onOpened: (row) => opened.add(row.label));

    expect(find.byIcon(Icons.info_outline), findsNothing);
    await tester.tap(find.text('Total item price'));
    await tester.pumpAndSettle();
    expect(opened, isEmpty);
  });

  testWidgets('a host that passes no callback still renders the sheet', (tester) async {
    // Order confirmation renders the same summary with no callback — the
    // affordance must keep working there.
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: PriceSummaryWidget(summary: OrderSummaryEntity(pricingData: [shippingRow])),
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.info_outline));
    await tester.pumpAndSettle();
    expect(find.text('Got It'), findsOneWidget);
  });

  testWidgets('shipping and platform rows are reported separately', (tester) async {
    // They shared one event before: Android has only `shipping_info_viewed`
    // and fires it with no idea which row was tapped, so a platform-fee view
    // was counted as a shipping-fee one.
    final reported = <String?>[];
    await pumpSummary(
      tester,
      rows: const [platformRow, shippingRow],
      onOpened: (row) => reported.add(row.label),
    );

    final icons = find.byIcon(Icons.info_outline);
    expect(icons, findsNWidgets(2));

    await tester.tap(icons.first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Got It'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.info_outline).last);
    await tester.pumpAndSettle();

    // The widget hands the row up verbatim; CartBloc maps it to the event.
    expect(reported, ['Platform fee', 'Shipping fee']);
  });
}
