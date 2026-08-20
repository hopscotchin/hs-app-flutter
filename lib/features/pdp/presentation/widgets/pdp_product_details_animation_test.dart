import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/features/pdp/domain/entities/detail_entity.dart';
import 'package:hs_app_flutter/features/pdp/presentation/widgets/pdp_product_details.dart';

// Guards the expand/collapse motion, which mirrors Android's
// View.expand()/collapse(): a 300ms height reveal in BOTH directions.
void main() {
  const details = [
    DetailEntity(
      tabName: 'Product Info',
      items: [
        DetailItemEntity(displayKey: 'Fabric', values: ['Cotton']),
        DetailItemEntity(displayKey: 'Fit', values: ['Regular']),
        DetailItemEntity(type: 'text', span: 2, values: ['Line A', 'Line B']),
      ],
    ),
    DetailEntity(
      tabName: 'Care',
      items: [DetailItemEntity(displayKey: 'Wash', values: ['Machine wash'])],
    ),
  ];

  // Mirrors the bloc: tapping the open tab toggles it shut (index -1).
  Future<int Function()> pumpSection(
    WidgetTester tester, {
    required int initialTab,
  }) async {
    var expanded = initialTab;
    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (context, setState) => Scaffold(
            body: SingleChildScrollView(
              child: PdpProductDetails(
                details: details,
                expandedTabIndex: expanded,
                onTabTapped: (i) =>
                    setState(() => expanded = expanded == i ? -1 : i),
              ),
            ),
          ),
        ),
      ),
    );
    return () => expanded;
  }

  double sectionHeight(WidgetTester tester) =>
      tester.getSize(find.byType(PdpProductDetails)).height;

  testWidgets('an already-open tab does not animate on first build', (
    tester,
  ) async {
    await pumpSection(tester, initialTab: 0);
    final onMount = sectionHeight(tester);
    await tester.pumpAndSettle();
    expect(sectionHeight(tester), onMount);
  });

  testWidgets('expanding animates the body height open', (tester) async {
    await pumpSection(tester, initialTab: -1);
    final collapsed = sectionHeight(tester);

    await tester.tap(find.text('Product Info'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));
    final midway = sectionHeight(tester);

    await tester.pumpAndSettle();
    final expandedHeight = sectionHeight(tester);

    expect(expandedHeight, greaterThan(collapsed));
    // Mid-flight the body is only partly revealed — the proof it isn't snapping.
    expect(midway, greaterThan(collapsed));
    expect(midway, lessThan(expandedHeight));
  });

  testWidgets('collapsing animates the body height shut', (tester) async {
    await pumpSection(tester, initialTab: 0);
    await tester.pumpAndSettle();
    final expandedHeight = sectionHeight(tester);

    await tester.tap(find.text('Product Info'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));
    final midway = sectionHeight(tester);

    await tester.pumpAndSettle();
    final collapsed = sectionHeight(tester);

    expect(collapsed, lessThan(expandedHeight));
    expect(midway, greaterThan(collapsed));
    expect(midway, lessThan(expandedHeight));
  });
}
