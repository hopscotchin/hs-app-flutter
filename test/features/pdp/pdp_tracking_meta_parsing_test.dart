import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/features/pdp/data/models/product_detail_model.dart';
import 'package:hs_app_flutter/features/pdp/domain/entities/product_detail_entity.dart';

/// Parses the two captured staging PDP responses and asserts the analytics
/// metadata lands correctly.
///
/// `trackingMeta` reaches the entity as a plain `Map<String, dynamic>` — there is
/// no model or entity class for it, so these assertions are about the **parsed
/// map**. What the analytics layer derives from it, and the filters applied before
/// forwarding, are observable only in the emitted payload and belong to
/// `test/analytics/pdp/`.
///
/// These fixtures are the ground truth for the PDP analytics port — every
/// assertion here encodes a real observation from staging, including the
/// Android quirks Flutter must reproduce.
ProductDetailEntity _load(String name) {
  final raw = File('test/analytics/fixtures/$name').readAsStringSync();
  final json = jsonDecode(raw) as Map<String, dynamic>;
  return ProductDetailModel.fromJson(json).toEntity();
}

void main() {
  group('PID 945499 — flat price, discounted, has styleCode', () {
    late ProductDetailEntity detail;
    late Map<String, dynamic> meta;

    setUp(() {
      detail = _load('pdp_product_945499.json');
      meta = detail.product!.trackingMeta!;
    });

    test('trackingMeta is parsed', () {
      expect(detail.product, isNotNull);
      expect(detail.product!.trackingMeta, isNotNull);
    });

    test('product fields arrive under their wire keys, ready to forward', () {
      // snake_case, matching the deployed v3 payload. There is no rename table any
      // more: what the server sends is what reaches Segment, so the key here IS the
      // property name.
      expect(meta['category'], 'Apparel - Children');
      expect(meta['subcategory'], 'Sets');
      expect(meta['product_type'], 'Formal Sets');
      expect(meta['subproduct_type'], 'TestTop');
      expect(meta['brand'], 'Whaou');
      expect(meta['gender'], "Girl's");
      expect(meta['from_age'], 36);
      expect(meta['to_age'], 96);
      expect(meta['delivery_days'], 4);
      expect(meta['style_code'], 'udf1');
      // STRING on the wire, unlike the int the older camelCase field carried.
      expect(meta['count_of_pids_in_style_code'], '9');
    });

    test('sale is the "Yes"/"No" string, under its final key', () {
      // The older field was `onSale: 0`, a number that the `num <= 0` rule then
      // dropped. v3 sends a string, so "No" survives to the wire.
      // BE sends the wire key directly — the client maps nothing.
      expect(meta['sale'], 'No');
    });

    test('isPidAplus is no longer sent at all', () {
      // BE dropped it from §1, as asked. Nothing filters it client-side, so keeping
      // it out of the block is what keeps it off the wire: it is a bool, which the
      // drop rules keep, and a reappearance would be forwarded like any other key.
      expect(meta.containsKey('isPidAplus'), isFalse);
      expect(meta.containsKey('slug'), isFalse);
    });

    test('product attributes arrive flat, keeping their mixed case', () {
      // BE flattens what used to be `product_attrs: [{name, value}]`. Mixed case
      // is intentional — the name IS the wire key, so `HBT` stays `HBT`.
      expect(meta['HBT'], 'T2');
      expect(meta['Season'], 'Autumn Winter');
      expect(
        meta.containsKey('product_attrs'),
        isFalse,
        reason:
            'the client no longer expands the array, so sending both shapes '
            'would put one dimension on the wire twice',
      );
    });

    test('country_of_origin is absent — per-product data, not a gap', () {
      expect(meta['country_of_origin'], isNull);
    });

    test('every sku carries its own trackingMeta block', () {
      // The per-SKU block, now shipped. `sku` is the single id for THAT size — not
      // the product block's
      // `sku`, which is the product's whole size list.
      final skus = detail.product!.skus;
      expect(skus, hasLength(5));
      for (final sku in skus) {
        final m = sku.trackingMeta;
        expect(m, isNotNull, reason: '${sku.skuId} has no trackingMeta');
        expect(m!['sku'], sku.skuId);
        expect(m['low_inventory'], isIn(const ['Yes', 'No', 'Sold out']));
      }
    });

    test('coupon_applicable arrives on offersList.trackingMeta', () {
      // Nothing reads it by name any more — it reaches `product_viewed` through the
      // offers passthrough like every other key on that block. What the parse layer
      // owes analytics is the block itself, with the value and type intact.
      expect(detail.offersTrackingMeta?['coupon_applicable'], 2);
      expect(detail.offersTrackingMeta?['coupon_applicable'], isA<int>());
    });

    test('price has no mrp or discount', () {
      final price = detail.product!.priceInfo!;
      expect(price.absoluteValue, 349.0);
      expect(price.mrp, isNull);
      expect(price.discountLabel, isNull);
    });
  });

  group('PID 924925 — range price, no styleCode, isPidAplus true', () {
    late ProductDetailEntity detail;
    late Map<String, dynamic> meta;

    setUp(() {
      detail = _load('pdp_product_924925_range_price.json');
      meta = detail.product!.trackingMeta!;
    });

    test('range price: absoluteValue is already the SKU minimum', () {
      // SKUs are 449 (x5) and 499 (x4). The server resolves the minimum, which
      // is why Flutter does not port Android's min-priced-SKU rule.
      final skuPrices = detail.product!.skus
          .map((s) => s.priceInfo?.absoluteValue)
          .whereType<double>()
          .toList();
      expect(skuPrices, isNotEmpty);
      expect(detail.product!.priceInfo!.absoluteValue, 449.0);
      expect(
        detail.product!.priceInfo!.absoluteValue,
        skuPrices.reduce((a, b) => a < b ? a : b),
      );
    });

    test('sellingPrice carries the range as a display string only', () {
      // There is no `priceInfo.type` field to branch on — the hyphen is the
      // only range signal, and it is not machine-readable.
      expect(detail.product!.priceInfo!.sellingPrice, '₹449-₹499');
    });

    test('style_code absent but the count is "0" — an Android quirk', () {
      // The count is a STRING on the wire, so `"0"` ships while `style_code` is
      // omitted — the numeric 0 would have been discarded by the `num <= 0` rule.
      // The pair is not co-present.
      expect(meta['style_code'], isNull);
      expect(meta['count_of_pids_in_style_code'], '0');
    });

    test('subproduct_type is optional — absent here, present on 945499', () {
      expect(meta['subproduct_type'], isNull);
    });

    test('isPidAplus is parsed but never emitted — A+ is out of scope', () {
      // Retained on the entity because it is part of the server contract; the
      // analytics layer ignores it entirely.
      expect(meta['isPidAplus'], isTrue);
    });
  });
}
