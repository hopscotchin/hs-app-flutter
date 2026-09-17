import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/components/atoms/custom_image.dart';
import 'package:hs_app_flutter/components/page_components/size_chart_bottom_sheet.dart';
import 'package:hs_app_flutter/components/page_components/size_selection_bottom_sheet.dart';
import 'package:hs_app_flutter/core/constants/image_constants.dart';
import 'package:hs_app_flutter/features/pdp/domain/entities/edd_info_entity.dart';
import 'package:hs_app_flutter/features/pdp/domain/entities/sku_entity.dart';

const _kSkus = [
  SkuEntity(
    skuId: 'SKU-1',
    title: '2-3 years',
    enable: true,
    eddInfo: EddInfoEntity(edd: 'Get it in 4-5 days'),
  ),
  SkuEntity(skuId: 'SKU-2', title: '3-4 years', enable: true),
];

void main() {
  late List<String> confirmed;

  Widget harness() {
    confirmed = [];
    return MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () => showSizeSelectionBottomSheet(
              context,
              skus: _kSkus,
              ctaLabel: 'Move to Bag',
              showSizeChart: true,
              onSizeChartTap: () => showSizeChartSheet(
                context,
                productName: 'Test Product',
                bodyBuilder: (_) => const Text('CHART BODY'),
              ),
              onConfirm: confirmed.add,
            ),
            child: const Text('open'),
          ),
        ),
      ),
    );
  }

  Future<void> openSheet(WidgetTester tester) async {
    await tester.pumpWidget(harness());
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  group('size selection sheet + size chart', () {
    testWidgets('shows the chart link only when asked', (tester) async {
      await openSheet(tester);
      expect(find.text('Select Size'), findsOneWidget);
      expect(find.text('Size Chart'), findsOneWidget);
    });

    testWidgets('shows the EDD bar only for a size that carries one', (
      tester,
    ) async {
      await openSheet(tester);
      // Nothing selected yet — no delivery estimate to show.
      expect(find.text('Get it in 4-5 days'), findsNothing);

      await tester.tap(find.text('2-3 years'));
      await tester.pumpAndSettle();
      expect(find.text('Get it in 4-5 days'), findsOneWidget);

      // Nearest Container ancestor of the text is the bar itself.
      final bar = tester.widget<Container>(
        find
            .ancestor(
              of: find.text('Get it in 4-5 days'),
              matching: find.byType(Container),
            )
            .first,
      );
      expect((bar.decoration! as BoxDecoration).color, const Color(0xFFD3EDE0));

      // Info icon sits in front of the text, 6px apart.
      final icon = find.descendant(
        of: find.byWidget(bar),
        matching: find.byType(CustomImage),
      );
      expect(icon, findsOneWidget);
      expect(
        tester.widget<CustomImage>(icon).path,
        ImageConstants.pdpPincodeInfo,
      );
      final row = tester.widget<Row>(
        find.descendant(of: find.byWidget(bar), matching: find.byType(Row)),
      );
      final gap = row.children[1] as SizedBox;
      expect(gap.width, 6);
      expect(row.children.first, isA<CustomImage>());

      // The other size has no eddInfo — the bar goes away.
      await tester.tap(find.text('3-4 years'));
      await tester.pumpAndSettle();
      expect(find.text('Get it in 4-5 days'), findsNothing);
    });

    testWidgets('the chart stacks over the size sheet', (tester) async {
      await openSheet(tester);

      await tester.tap(find.text('Size Chart'));
      await tester.pumpAndSettle();

      expect(find.text('CHART BODY'), findsOneWidget);
      // The size sheet is still mounted underneath, not replaced.
      expect(find.text('Select Size'), findsOneWidget);
    });

    testWidgets('closing the chart reveals the sheet with the selection kept', (
      tester,
    ) async {
      await openSheet(tester);

      // Pick a size, then go to the chart and back.
      await tester.tap(find.text('3-4 years'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Size Chart'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(find.text('CHART BODY'), findsNothing);
      expect(find.text('Select Size'), findsOneWidget);

      // The CTA is still enabled for the size chosen before the chart opened.
      await tester.tap(find.text('Move to Bag'));
      await tester.pumpAndSettle();
      expect(confirmed, ['SKU-2']);
      expect(find.text('Select Size'), findsNothing);
    });
  });
}
