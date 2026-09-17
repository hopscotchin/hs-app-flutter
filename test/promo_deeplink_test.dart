import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/core/navigation/action_url_handler.dart';
import 'package:hs_app_flutter/core/navigation/nav_destination.dart';

void main() {
  int? promoIdOf(String url) {
    final d = ActionUrlHandler.parse(url);
    return d is PromoDetailsDestination ? d.promoId : null;
  }

  group('promo-details deeplinks', () {
    test('app link — offers alias with query id', () {
      expect(promoIdOf('hopscotch://offers?id=12345'), 12345);
    });

    // Pre-existing, app-wide: `Uri.host` is lowercased by Dart, so every
    // camelCase constant in `_parseAppLink`'s switch is unreachable —
    // `offersFromPdp` arrives as `offersfrompdp` and falls through to Home.
    // 43 of the 59 hosts in that switch have the same defect. Asserted as-is
    // so the day someone lowercases the constants, this test fails loudly and
    // gets flipped to the expected value.
    test('KNOWN BUG: camelCase app-link hosts never match', () {
      expect(promoIdOf('hopscotch://offersFromPdp?id=12345'), isNull);
    });

    test('app link — promo-details with id in the path', () {
      expect(promoIdOf('hopscotch://promo-details/12345'), 12345);
      // Lowercased by Dart to `promodetails`, which we accept explicitly.
      expect(promoIdOf('hopscotch://promoDetails/12345'), 12345);
    });

    test('app link — promo-details with id in the query', () {
      expect(promoIdOf('hopscotch://promo-details?id=12345'), 12345);
    });

    test('web link — /promo-details/<id>', () {
      expect(promoIdOf('https://www.hopscotch.in/promo-details/12345'), 12345);
      expect(promoIdOf('/promo-details/12345'), 12345);
    });

    test('web link — query-id form', () {
      expect(promoIdOf('https://www.hopscotch.in/promo-details?id=12345'), 12345);
    });

    test('invalid or missing id never reaches the details page', () {
      expect(promoIdOf('hopscotch://promo-details'), isNull);
      expect(promoIdOf('hopscotch://promo-details/abc'), isNull);
      expect(promoIdOf('hopscotch://offers?id=0'), isNull);
      expect(promoIdOf('/promo-details/'), isNull);
    });
  });
}
