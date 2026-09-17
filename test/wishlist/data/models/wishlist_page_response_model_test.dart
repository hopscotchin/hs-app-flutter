import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/features/wishlist/data/models/wishlist_page_response_model.dart';
import 'package:hs_app_flutter/features/wishlist/domain/entities/wishlist_product_entity.dart';

/// Trimmed `/api/v2/wishlist` response: one record whose every SKU is
/// unavailable, and one with several available sizes.
const _kResponse = '''
{
  "pageMeta": {"page": 1, "pageSize": 20, "totalCount": 8, "hasNextPage": false, "orderRule": 0},
  "records": [
    {
      "id": 943717,
      "name": "Pink Sleeveless Floral Printed Casual Dresses",
      "hasSizeChart": true,
      "media": [{"mimeType": "IMAGE", "url": "https://example.com/a_full.jpg"}],
      "wishlistInfo": {"id": 14940882, "canWishlist": true, "wishlisted": true},
      "priceInfo": {"sellingPrice": "₹599", "mrp": "MRP:₹1,349", "discount": "56% OFF", "absoluteValue": 599.0},
      "visualCue": {"uiType": "TEXT", "location": "BottomLeft", "text": "1 LEFT"},
      "trackingMeta": {"brandName": "Peaches"},
      "skus": [
        {"skuId": "0PT-3043732", "title": "2-3 years", "availableQuantity": 0, "enable": false,
         "info": {"text": "Out Of Stock", "textColor": "#80333333"}},
        {"skuId": "0PT-3043736", "title": "6-7 years", "availableQuantity": 1, "enable": false,
         "info": {"text": "Out Of Stock", "textColor": "#80333333"}}
      ]
    },
    {
      "id": 944042,
      "name": "Gray Cat Print Sleeveless Top And Shorts",
      "hasSizeChart": true,
      "media": [{"mimeType": "IMAGE", "url": "https://example.com/b_full.jpg"}],
      "wishlistInfo": {"id": 14938643, "canWishlist": true, "wishlisted": true},
      "priceInfo": {"sellingPrice": "₹320", "absoluteValue": 320.0},
      "trackingMeta": {"brandName": "Do Re Me"},
      "skus": [
        {"skuId": "DOP-3045211", "title": "1-1.5 years", "availableQuantity": 35, "enable": true,
         "eddInfo": {"edd": "Get it in 4-5 days"}},
        {"skuId": "DOP-3045212", "title": "1.5-2 years", "availableQuantity": 29, "enable": true},
        {"skuId": "DOP-3045217", "title": "0-4 years", "availableQuantity": 0, "enable": true,
         "info": {"text": "Out Of Stock", "textColor": "#80333333"}}
      ]
    }
  ],
  "action": "success"
}
''';

void main() {
  late List<WishlistProductEntity> items;

  setUp(() {
    final json = jsonDecode(_kResponse) as Map<String, dynamic>;
    items = WishlistPageResponseModel.fromJson(json).toEntity().items;
  });

  group('WishlistPageResponseModel.toEntity', () {
    test('maps page meta', () {
      final page = WishlistPageResponseModel.fromJson(
        jsonDecode(_kResponse) as Map<String, dynamic>,
      ).toEntity();

      expect(page.totalRecords, 8);
      expect(page.hasNextPage, isFalse);
      expect(page.items, hasLength(2));
    });

    test('reads the product id from `id`, not `productId`', () {
      expect(items.map((i) => i.id), [943717, 944042]);
    });

    test('maps display fields from the shared PLP product shape', () {
      final first = items.first.product;
      expect(first.name, 'Pink Sleeveless Floral Printed Casual Dresses');
      expect(first.brandName, 'Peaches');
      expect(first.imageUrls, ['https://example.com/a_full.jpg']);
      expect(first.price?.sellingPrice, '₹599');
      expect(first.price?.discountLabel, '56% OFF');
      expect(first.visualCues, hasLength(1));
      // The tile renders a delete action instead of the heart.
      expect(first.wishlistInfo.canWishlist, isFalse);
      expect(first.wishlistInfo.isWishlisted, isTrue);
    });

    test('exposes wishlistInfo.id as the removal id', () {
      expect(items.map((i) => i.wishlistId), ['14940882', '14938643']);
    });

    test('a SKU counts as available only when enabled AND in stock', () {
      // enable:false with availableQuantity > 0, and enable:true with 0 stock,
      // are both unavailable — the response uses either to mean out of stock.
      expect(items.first.selectableSkus, isEmpty);
      expect(items.first.isSoldOut, isTrue);
      expect(items.first.canMoveToBag, isFalse);

      expect(items.last.selectableSkus.map((s) => s.skuId), [
        'DOP-3045211',
        'DOP-3045212',
      ]);
      expect(items.last.isSoldOut, isFalse);
    });

    test('falls back to the first available SKU (no wishlistedSku in v2)', () {
      expect(items.last.moveToBagSku, 'DOP-3045211');
      expect(items.last.canMoveToBag, isTrue);
    });

    test('carries hasSizeChart so the sheet can offer the chart link', () {
      expect(items.map((i) => i.hasSizeChart), [true, true]);
    });

    test('needs size selection whenever any SKU is available', () {
      expect(items.first.needsSizeSelection, isFalse);
      expect(items.last.needsSizeSelection, isTrue);
    });

    test('maps SKU chip data for the size sheet', () {
      final skus = items.last.skus;
      expect(skus.map((s) => s.title), [
        '1-1.5 years',
        '1.5-2 years',
        '0-4 years',
      ]);
      expect(skus.last.enable, isFalse);
      expect(skus.last.info?.text, 'Out Of Stock');
    });

    test('maps per-SKU eddInfo for the delivery bar', () {
      expect(items.last.skus.first.eddInfo?.edd, 'Get it in 4-5 days');
      expect(items.last.skus[1].eddInfo, isNull);
    });
  });

  group('preselectedSkuId', () {
    /// Re-parses the fixture with `wishlistedSku` set on the second record.
    WishlistProductEntity itemWithWishlistedSku(String? sku) {
      final json = jsonDecode(_kResponse) as Map<String, dynamic>;
      final records = json['records'] as List<dynamic>;
      final record = records.last as Map<String, dynamic>;
      (record['wishlistInfo'] as Map<String, dynamic>)['wishlistedSku'] = sku;
      return WishlistPageResponseModel.fromJson(json).toEntity().items.last;
    }

    test('is null when the response carries no wishlistedSku', () {
      expect(items.last.wishlistedSku, isNull);
      expect(items.last.preselectedSkuId, isNull);
    });

    test('opens the sheet on the wishlisted size when it is selectable', () {
      final item = itemWithWishlistedSku('DOP-3045212');

      expect(item.wishlistedSku, 'DOP-3045212');
      expect(item.preselectedSkuId, 'DOP-3045212');
    });

    test('leaves the sheet unpicked when the wishlisted size is sold out', () {
      // DOP-3045217 has availableQuantity 0, so its chip is untappable.
      final item = itemWithWishlistedSku('DOP-3045217');

      expect(item.wishlistedSku, 'DOP-3045217');
      expect(item.preselectedSkuId, isNull);
    });

    test('leaves the sheet unpicked when the SKU is not in the list', () {
      expect(itemWithWishlistedSku('GONE-1').preselectedSkuId, isNull);
    });
  });
}
