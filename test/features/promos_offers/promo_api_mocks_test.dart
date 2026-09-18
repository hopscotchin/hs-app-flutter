import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/features/promos_offers/data/models/promo_action_response_model.dart';
import 'package:hs_app_flutter/features/promos_offers/data/models/promo_details_response_model.dart';
import 'package:hs_app_flutter/features/promos_offers/data/models/promos_offers_response_model.dart';
import 'package:hs_app_flutter/features/promos_offers/domain/entities/promo_action_result_entity.dart';

/// The promo mocks parse through the real models.
///
/// A hand-written fixture is only useful if it round-trips the parsers it is
/// meant to stand in for — otherwise it mocks a response the app cannot read,
/// and the bug shows up as an empty screen with no error. These assert the
/// fields the UI actually renders, so a key typo'd in the fixture fails here
/// rather than in someone's manual QA.
void main() {
  late Map<String, dynamic> mocks;

  setUpAll(() {
    final file = File('test/fixtures/promos/promo_api_mocks.json');
    mocks = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
  });

  Map<String, dynamic> node(String key) => mocks[key]! as Map<String, dynamic>;

  test('the offer list parses into both sections', () {
    final response = PromosOffersResponseModel.fromJson(
      node('GET /v2/promotion/cart/offer-list?fromLocation=cart&productId=0'),
    ).toEntity();

    expect(response.applicable!.offers, hasLength(2));
    expect(response.nonApplicable!.offers, hasLength(1));

    final first = response.applicable!.offers.first;
    expect(first.promoId, 4821);
    expect(first.code, 'JOY5');
    expect(first.title, 'Extra 5% off');
    expect(first.savingsText, 'You save ₹225');
    expect(first.actionLabel, 'APPLY');
    expect(first.termsLink, 'hopscotch://promo-details/4821');

    // Derived from the section, not the item JSON — the thing most easily got
    // wrong when hand-building a mock.
    expect(first.isApplicable, isTrue);
    expect(response.nonApplicable!.offers.first.isApplicable, isFalse);

    // An applied code drives the card's state.
    expect(response.applicable!.offers[1].isApplied, isTrue);
  });

  test('the promo id survives — a 0 here would hide "See terms"', () {
    // The offer list keys it `id`, the terms endpoint `promotionId`. The
    // models read either, but a fixture sending neither silently yields 0.
    final offers = PromosOffersResponseModel.fromJson(
      node('GET /v2/promotion/cart/offer-list?fromLocation=cart&productId=0'),
    ).toEntity();
    final details = PromoDetailsResponseModel.fromJson(
      node('GET /v2/promotion/offerterms/4821'),
    ).toEntity();

    expect(offers.applicable!.offers.first.promoId, isNot(0));
    expect(details.item.promoId, 4821);
  });

  test('the details page parses its block, terms and FAQs', () {
    final details = PromoDetailsResponseModel.fromJson(
      node('GET /v2/promotion/offerterms/4821'),
    ).toEntity();

    expect(details.item.code, 'JOY5');
    expect(details.item.showCode, isTrue);
    expect(details.about, startsWith('Save an extra 5%'));
    // `tnc` entries are keyed `term`, and blank ones are dropped rather than
    // rendered as empty bullets — so a wrong key yields an empty list, not a
    // parse error.
    expect(details.terms, hasLength(4));
    expect(details.terms.first, 'Valid on orders above ₹1999.');
    expect(details.faqs, hasLength(2));
    expect(details.faqs.first.question, isNotEmpty);
  });

  group('apply', () {
    Map<String, dynamic> apply(String variant) =>
        node('POST /v3/promotion/apply?fromLocation=cart')[variant]!
            as Map<String, dynamic>;

    test('a success reads as applied', () {
      final result = PromoActionResponseModel.fromJson(
        apply('success'),
      ).toEntity();
      expect(result.success, isTrue);
      expect(result.promoCode, 'JOY5');
      expect(result.message, 'Promo applied. You saved ₹225');
    });

    test('a rejection is a 200 that reads as failure', () {
      // The branch `promo_code_failed` reports, and the one a mock most needs
      // to get right: an HTTP error would take a different path entirely.
      final result = PromoActionResponseModel.fromJson(
        apply('failure_not_verified'),
      ).toEntity();
      expect(result.success, isFalse);
      expect(result.message, 'Verify your mobile to avail promotion.');
    });

    test('a backend sheet parses, including its button action', () {
      final result = PromoActionResponseModel.fromJson(
        apply('failure_with_sheet'),
      ).toEntity();
      expect(result.success, isFalse);
      expect(result.hasBottomSheet, isTrue);
      expect(result.bottomSheet!.title, 'Invalid Promo Code');
      // `action` on the button becomes `actionUrl` — the rename is in the
      // parser, so a fixture using `actionUrl` would leave it null.
      expect(result.bottomSheet!.leftAction!.actionUrl, 'DISMISS');
      expect(result.bottomSheet!.leftAction!.label, 'Got It');
    });

    test('a singular messageBar is folded into the list', () {
      final result = PromoActionResponseModel.fromJson(
        apply('failure_with_message_bar'),
      ).toEntity();
      expect(result.messageBars, hasLength(1));
      expect(result.messageBars.first.message, 'Add ₹400 more to unlock this offer');
    });
  });

  group('remove', () {
    Map<String, dynamic> remove(String variant) =>
        node('DELETE /v3/promotion/remove?promoCode=JOY5')[variant]!
            as Map<String, dynamic>;

    test('a success reads as removed', () {
      // `action: "success"` alone is enough — the parser accepts it or the
      // `success` boolean, and a remove that read as a failure would show the
      // fallback error over a promo that did come off.
      final result = PromoActionResponseModel.fromJson(
        remove('success'),
      ).toEntity();
      expect(result.success, isTrue);
      expect(result.message, 'Promo removed');
    });

    test('a failure keeps the promo on the cart', () {
      final result = PromoActionResponseModel.fromJson(
        remove('failure'),
      ).toEntity();
      expect(result.success, isFalse);
      expect(result.message, isNotEmpty);
    });
  });

  test('action alone, with no success flag, still reads as success', () {
    // Documented in the fixture as interchangeable, so it is pinned.
    final result = PromoActionResponseModel.fromJson(const {
      'action': 'success',
      'message': 'Promo applied',
    }).toEntity();
    expect(result.success, isTrue);
  });
}
