import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/features/wishlist/data/models/move_to_cart_response_model.dart';

MoveToCartResponseModel parse(String body) =>
    MoveToCartResponseModel.fromJson(jsonDecode(body) as Map<String, dynamic>);

void main() {
  group('MoveToCartResponseModel', () {
    test('maps the success response', () {
      final model = parse('{"action": "success", "cartItemQty": 3}');

      expect(model.isSuccess, isTrue);
      expect(model.toEntity().cartItemQty, 3);
      expect(model.failureMessage, isNull);
    });

    test('treats a non-success action as failure and keeps popUpMessage', () {
      final model = parse(
        '{"action": "failure", "popUpMessage": "This size just sold out"}',
      );

      expect(model.isSuccess, isFalse);
      expect(model.failureMessage, 'This size just sold out');
    });

    test('reports no failure message when popUpMessage is absent or empty', () {
      expect(parse('{"action": "failure"}').failureMessage, isNull);
      expect(
        parse('{"action": "failure", "popUpMessage": ""}').failureMessage,
        isNull,
      );
    });

    test('a missing action is not success', () {
      expect(parse('{"cartItemQty": 3}').isSuccess, isFalse);
    });

    test('tolerates a missing cartItemQty', () {
      expect(parse('{"action": "success"}').toEntity().cartItemQty, isNull);
    });
  });
}
