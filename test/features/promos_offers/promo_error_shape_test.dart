import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/features/promos_offers/data/models/promo_action_response_model.dart';
import 'package:hs_app_flutter/features/promos_offers/domain/entities/promo_action_result_entity.dart';

void main() {
  group('promo failure shapes', () {
    test('single messageBar is collected', () {
      final e = PromoActionResponseModel.fromJson({
        'success': false,
        'messageBar': {'message': 'Coupon not applied, try again.', 'messageType': 'error'},
      }).toEntity();
      expect(e.messageBars.map((b) => b.displayText), ['Coupon not applied, try again.']);
      expect(e.hasMessageBars, isTrue);
    });

    test('messageBars array is collected', () {
      final e = PromoActionResponseModel.fromJson({
        'success': false,
        'messageBars': [
          {'message': 'first'},
          {'message': 'second'},
        ],
      }).toEntity();
      expect(e.messageBars.map((b) => b.displayText), ['first', 'second']);
    });

    test('both keys merge with messageBar leading', () {
      final e = PromoActionResponseModel.fromJson({
        'success': false,
        'messageBar': {'message': 'primary'},
        'messageBars': [{'message': 'extra'}],
      }).toEntity();
      expect(e.messageBars.map((b) => b.displayText), ['primary', 'extra']);
    });

    test('message-only failure carries no bars — widget synthesises one', () {
      final e = PromoActionResponseModel.fromJson({
        'success': false,
        'message': 'Minimum purchase not met.',
      }).toEntity();
      expect(e.messageBars, isEmpty);
      expect(e.message, 'Minimum purchase not met.');
    });

    test('message precedence matches ActionResponse.validate', () {
      String msg(Map<String, dynamic> j) =>
          PromoActionResponseModel.fromJson(j).toEntity().message;

      expect(msg({'message': 'a', 'errorMessage': 'b', 'errorMsg': 'c'}), 'a');
      expect(msg({'errorMessage': 'b', 'errorMsg': 'c'}), 'b');
      expect(msg({'errorMsg': 'c'}), 'c');
      // Empty when the server sends none, so the bloc's own fallback copy wins.
      expect(msg({'success': false}), '');
    });

    test('popUpMessage is NOT read — the promo endpoints do not send it', () {
      // Android's promo failure path reads `message` only. Guards against
      // someone reinstating a popupMessage fallback.
      final e = PromoActionResponseModel.fromJson({
        'success': false,
        'popUpMessage': 'should be ignored',
      }).toEntity();
      expect(e.message, '');
    });

    test('action:failure envelope is read as a rejection', () {
      final e = PromoActionResponseModel.fromJson({
        'action': 'failure',
        'message': 'nope',
        'messageBar': {'message': 'bar copy'},
      }).toEntity();
      expect(e.success, isFalse);
      expect(e.messageBars.single.displayText, 'bar copy');
    });

    test('malformed bar entries are skipped, not fatal', () {
      final e = PromoActionResponseModel.fromJson({
        'success': false,
        'messageBar': 'not-an-object',
        'messageBars': ['also-not', {'message': 'good'}],
      }).toEntity();
      expect(e.messageBars.map((b) => b.displayText), ['good']);
    });
  });
}
