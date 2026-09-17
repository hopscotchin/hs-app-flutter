import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/features/pdp/data/models/pincode_check_model.dart';
import 'package:hs_app_flutter/features/pdp/data/models/product_detail_model.dart';

/// A pincode change has to move `from_pincode` and `delivery_days` on **every
/// later event**, and move nothing else.
///
/// Both keys live in `product.trackingMeta`, which is chained on all 23 events, so
/// the endpoint's job is to return the pincode-scoped slice and the client's job is
/// to merge it. Replacing the node instead would silently drop the 23 keys the
/// pincode never touched — the event would still fire, just without `brand`,
/// `category` or `price`, which no payload test would notice because they would be
/// absent rather than wrong.
///
/// Contract: `docs/analytics/pdp/contract/passthrough-spec.md` §5.
void main() {
  late Map<String, dynamic> productJson;

  setUpAll(() {
    productJson =
        jsonDecode(
              File(
                'test/analytics/fixtures/pdp_product_945499.json',
              ).readAsStringSync(),
            )
            as Map<String, dynamic>;
  });

  /// Applies the same merge the bloc's success branch performs.
  Map<String, dynamic>? mergeOf(Map<String, dynamic> pincodeResponse) {
    final product = ProductDetailModel.fromJson(
      jsonDecode(jsonEncode(productJson)) as Map<String, dynamic>,
    ).toEntity().product!;
    final check = PincodeCheckModel.fromJson(pincodeResponse).toEntity();
    final slice = check.trackingMeta;
    if (slice == null || slice.isEmpty) return product.trackingMeta;
    return <String, dynamic>{...?product.trackingMeta, ...slice};
  }

  test('the model parses the trackingMeta slice', () {
    final check = PincodeCheckModel.fromJson(const {
      'action': 'success',
      'isServiceable': true,
      'trackingMeta': {'from_pincode': '400001', 'delivery_days': 3},
    }).toEntity();
    expect(check.trackingMeta, {
      'from_pincode': '400001',
      'delivery_days': 3,
    });
  });

  test('a pincode change moves both pincode-scoped keys', () {
    final before = ProductDetailModel.fromJson(
      jsonDecode(jsonEncode(productJson)) as Map<String, dynamic>,
    ).toEntity().product!.trackingMeta!;
    expect(before['from_pincode'], 'standard');

    final after = mergeOf(const {
      'action': 'success',
      'isServiceable': true,
      'trackingMeta': {'from_pincode': '400001', 'delivery_days': 3},
    })!;
    expect(after['from_pincode'], '400001');
    expect(after['delivery_days'], 3);
  });

  test('everything the pincode did not touch survives the merge', () {
    final before = ProductDetailModel.fromJson(
      jsonDecode(jsonEncode(productJson)) as Map<String, dynamic>,
    ).toEntity().product!.trackingMeta!;

    final after = mergeOf(const {
      'action': 'success',
      'isServiceable': true,
      'trackingMeta': {'from_pincode': '400001', 'delivery_days': 3},
    })!;

    // The whole point: a replace would leave 2 keys where there were 25.
    expect(after.length, before.length);
    for (final key in before.keys) {
      expect(
        after.containsKey(key),
        isTrue,
        reason: '$key was dropped — the slice replaced the node instead of '
            'merging over it',
      );
    }
    expect(after['brand'], before['brand']);
    expect(after['category'], before['category']);
    expect(after['price'], before['price']);
  });

  // The tests above pin the CONTRACT by reproducing the merge. They cannot catch
  // the bloc doing something else, and there is no PdpBloc test harness to drive
  // it through — so the one regression that matters is asserted against the
  // source: someone "simplifying" the merge into a replace.
  test('the bloc merges the slice rather than replacing the node', () {
    const source = 'lib/features/pdp/presentation/bloc/pdp_bloc.dart';
    final src = File(source).readAsStringSync();

    expect(
      src,
      contains('...?product.trackingMeta'),
      reason:
          'the pincode slice must be spread OVER the existing node. A bare '
          '`trackingMeta: pincodeCheck.trackingMeta` would drop the 23 keys the '
          'pincode never touched, and every later event would lose brand, '
          'category and price',
    );
    expect(
      src,
      contains('trackingMeta: mergedMeta'),
      reason: 'the merged node must reach product.copyWith',
    );
  });

  test('a response with no slice leaves the node untouched', () {
    // What BE sends on failure: the pincode was not accepted, so the old
    // from_pincode is still the truth.
    final after = mergeOf(const {'action': 'failure', 'message': 'not serviceable'});
    expect(after!['from_pincode'], 'standard');
  });
}
