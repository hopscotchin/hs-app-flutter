import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/core/theme/typography/typography_v1.dart';
import 'package:hs_app_flutter/features/pdp/domain/entities/sku_entity.dart';
import 'package:hs_app_flutter/features/pdp/presentation/widgets/pdp_size_selector.dart';

/// The size chip used to be pinned at 89px, so footwear labels like
/// "Euro 26 (2.5 UK/US)" ellipsised and the selected size was unreadable.
/// These lock in that the chip instead sizes to its label, clamped to [89, 180].
///
/// Widths are asserted against the label's *measured* width rather than
/// literals: the test environment substitutes a monospace fallback font whose
/// glyphs are far wider than the shipping one, so any hardcoded pixel figure
/// would be testing the test font, not the layout.
void main() {
  const minWidth = 89.0;
  const maxWidth = 180.0;
  const hPadding = 10.0;
  const borderWidth = 1.0;
  // Horizontal chrome around the label: padding plus the (always-present,
  // transparent when unselected) border, both of which inset the text.
  const chrome = 2 * (hPadding + borderWidth);

  /// Width the title needs when nothing constrains it. Measured by rendering
  /// the same `Text` the chip builds — a standalone `TextPainter` would miss
  /// the `DefaultTextStyle` that `Text` merges in, and come out a few px short.
  Future<double> measure(WidgetTester tester, String label) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Align(
            alignment: Alignment.topLeft,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                label,
                style: AppTypographyV1.bodySmall.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    return tester.getSize(find.text(label)).width;
  }

  /// What the chip *should* measure for [label] under whatever font is active.
  Future<double> expectedWidth(WidgetTester tester, String label) async =>
      ((await measure(tester, label)) + chrome).clamp(minWidth, maxWidth);

  Future<Size> pumpChip(
    WidgetTester tester,
    SkuEntity sku, {
    bool isSelected = false,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Align(
            alignment: Alignment.topLeft,
            // Unbounded horizontally, like the selector's own scroll view —
            // the chip has to size itself, nothing upstream will do it.
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: PdpSizeChip(
                key: const ValueKey('chip'),
                sku: sku,
                isSelected: isSelected,
                onTap: () {},
              ),
            ),
          ),
        ),
      ),
    );
    return tester.getSize(
      find.descendant(
        of: find.byKey(const ValueKey('chip')),
        matching: find.byType(Container),
      ),
    );
  }

  bool titleIsTruncated(WidgetTester tester, String label) =>
      tester.renderObject<RenderParagraph>(find.text(label)).didExceedMaxLines;

  testWidgets('a short label keeps the 89px design width', (tester) async {
    const sku = SkuEntity(skuId: 's1', title: '3-6Y', enable: true);
    expect(await measure(tester, '3-6Y') + chrome, lessThan(minWidth));
    expect((await pumpChip(tester, sku)).width, minWidth);
  });

  testWidgets('a short label keeps the 47px design height', (tester) async {
    const sku = SkuEntity(skuId: 's1', title: '3-6Y', enable: true);
    expect((await pumpChip(tester, sku)).height, 47.0);
  });

  testWidgets('a label wider than 89px grows the chip to fit it', (
    tester,
  ) async {
    const label = 'Euro 26';
    const sku = SkuEntity(skuId: 's2', title: label, enable: true);
    final natural = await measure(tester, label) + chrome;
    expect(natural, greaterThan(minWidth), reason: 'precondition');
    expect(natural, lessThan(maxWidth), reason: 'precondition');

    expect((await pumpChip(tester, sku)).width, natural);
    expect(titleIsTruncated(tester, label), isFalse);
  });

  testWidgets('a label past 180px is capped, not allowed to run away', (
    tester,
  ) async {
    const label = 'Euro 26 (2.5 UK/US) / India 9 / Japan 15.5cm';
    const sku = SkuEntity(skuId: 's3', title: label, enable: true);
    expect(await measure(tester, label) + chrome, greaterThan(maxWidth));

    expect((await pumpChip(tester, sku)).width, maxWidth);
  });

  testWidgets('selecting a chip does not change its width', (tester) async {
    const label = 'Euro 26';
    const sku = SkuEntity(skuId: 's2', title: label, enable: true);
    final unselected = await pumpChip(tester, sku);
    final selected = await pumpChip(tester, sku, isSelected: true);
    expect(selected.width, unselected.width);
    expect(selected.height, unselected.height);
  });

  // The subtitle is chip content too, so it may widen the chip — what it must
  // not do is squeeze the title into an ellipsis.
  testWidgets('a subtitle never truncates the title', (tester) async {
    const label = 'Euro 26';
    const sku = SkuEntity(
      skuId: 's4',
      title: label,
      subTitle: 'Foot: 15.5cm',
      enable: true,
    );
    final titleOnly = await expectedWidth(tester, label);
    final size = await pumpChip(tester, sku);
    expect(size.width, greaterThanOrEqualTo(titleOnly));
    expect(size.height, 47.0);
    expect(titleIsTruncated(tester, label), isFalse);
  });

  testWidgets('the stock label does not stretch or overflow the chip', (
    tester,
  ) async {
    const sku = SkuEntity(skuId: 's5', title: '3-6Y', enable: false);
    expect((await pumpChip(tester, sku)).width, minWidth);
    expect(tester.takeException(), isNull);
  });

  testWidgets('chips in a row size independently of one another', (
    tester,
  ) async {
    const short = SkuEntity(skuId: 'a', title: '3-6Y', enable: true);
    const long = SkuEntity(skuId: 'b', title: 'Euro 26', enable: true);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PdpSizeSelector(
            skus: const [short, long],
            selectedSku: long,
            onSizeSelected: (_) {},
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    final widths = tester
        .widgetList<PdpSizeChip>(find.byType(PdpSizeChip))
        .map((chip) => tester.getSize(find.byKey(chip.key!)).width)
        .toList();
    expect(widths, [
      await expectedWidth(tester, '3-6Y'),
      await expectedWidth(tester, 'Euro 26'),
    ]);
  });
}
