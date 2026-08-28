import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/features/pdp/domain/entities/detail_entity.dart';
import 'package:hs_app_flutter/features/pdp/domain/entities/sku_entity.dart';
import 'package:hs_app_flutter/features/pdp/presentation/widgets/pdp_product_details.dart';
import 'package:hs_app_flutter/features/plp/domain/entities/product_price_entity.dart';

// Guards the pre-selection fallback for `skuValue` rows, which mirrors
// Android's GetDefaultSkuUseCase: before a size is picked the cheapest SKU's
// attributes stand in, except on range-priced products.
void main() {
  const details = [
    DetailEntity(
      tabName: 'Description',
      items: [
        DetailItemEntity(
          type: 'skuValue',
          span: 1,
          displayKey: 'MRP : ',
          displayStyle: 'inline',
          fieldPath: 'skuMrp',
        ),
      ],
    ),
  ];

  SkuEntity sku(String id, double price, String mrp) => SkuEntity(
    skuId: id,
    title: id,
    priceInfo: ProductPriceEntity(sellingPrice: '₹$price', absoluteValue: price),
    skuAttributes: {'skuMrp': mrp},
  );

  Future<void> pump(
    WidgetTester tester, {
    required List<SkuEntity> skus,
    required ProductPriceEntity productPriceInfo,
    SkuEntity? selectedSku,
  }) => tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: PdpProductDetails(
            details: details,
            expandedTabIndex: 0,
            onTabTapped: (_) {},
            skus: skus,
            selectedSku: selectedSku,
            productPriceInfo: productPriceInfo,
          ),
        ),
      ),
    ),
  );

  testWidgets('falls back to the cheapest SKU before a size is picked', (tester) async {
    await pump(
      tester,
      skus: [sku('A', 599, '₹799'), sku('B', 399, '₹499'), sku('C', 449, '₹599')],
      productPriceInfo: const ProductPriceEntity(sellingPrice: '₹399', absoluteValue: 399),
    );
    expect(find.text('₹499'), findsOneWidget);
  });

  testWidgets('a price tie keeps the first SKU listed', (tester) async {
    await pump(
      tester,
      skus: [sku('A', 399, '₹499'), sku('B', 399, '₹899')],
      productPriceInfo: const ProductPriceEntity(sellingPrice: '₹399', absoluteValue: 399),
    );
    expect(find.text('₹499'), findsOneWidget);
    expect(find.text('₹899'), findsNothing);
  });

  testWidgets('a range-priced product shows no row until a size is picked', (tester) async {
    await pump(
      tester,
      skus: [sku('A', 1199, '₹1,999'), sku('B', 1299, '₹1,999')],
      productPriceInfo: const ProductPriceEntity(
        sellingPrice: '₹1,199-₹1,299',
        absoluteValue: 1199,
      ),
    );
    expect(find.text('₹1,999'), findsNothing);
    expect(find.text('MRP : '), findsNothing);
  });

  testWidgets('a range-priced product shows the picked SKU', (tester) async {
    final picked = sku('B', 1299, '₹2,499');
    await pump(
      tester,
      skus: [sku('A', 1199, '₹1,999'), picked],
      selectedSku: picked,
      productPriceInfo: const ProductPriceEntity(
        sellingPrice: '₹1,199-₹1,299',
        absoluteValue: 1199,
      ),
    );
    expect(find.text('₹2,499'), findsOneWidget);
  });

  testWidgets('the picked SKU wins over the cheapest one', (tester) async {
    final picked = sku('C', 899, '₹1,299');
    await pump(
      tester,
      skus: [sku('A', 399, '₹499'), picked],
      selectedSku: picked,
      productPriceInfo: const ProductPriceEntity(sellingPrice: '₹399', absoluteValue: 399),
    );
    expect(find.text('₹1,299'), findsOneWidget);
    expect(find.text('₹499'), findsNothing);
  });
}
