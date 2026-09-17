import 'package:flutter_test/flutter_test.dart';

import 'package:hs_app_flutter/core/analytics/constants/analytics_defaults.dart';
import 'package:hs_app_flutter/core/navigation/nav_destination.dart';
import 'package:hs_app_flutter/features/pdp/domain/entities/pdp_entry_args.dart';
import 'package:hs_app_flutter/features/plp/domain/entities/page_type.dart';
import 'package:hs_app_flutter/features/plp/domain/entities/plp_entry_args.dart';

/// A tile states its page once; each destination takes what it needs. See
/// [SourcePage] for the per-destination table and its Android sources.
void main() {
  const discover = SourcePage(
    fromScreen: 'Discover',
    fromPage: FromPage.homepage,
  );

  group('navExtra', () {
    test('omits what was not supplied', () {
      expect(navExtra(sourcePage: discover), {sourcePageKey: discover});
    });

    test('carries both contexts when a tile could land on either', () {
      const pdp = PdpEntryArgs(fromScreen: 'Discover');
      expect(navExtra(sourcePage: discover, pdpEntryArgs: pdp), {
        sourcePageKey: discover,
        pdpEntryArgsKey: pdp,
      });
    });

    test('nothing supplied is null, not an empty map', () {
      // An empty map would read as "context supplied, but blank".
      expect(navExtra(), isNull);
    });
  });

  group('every listing type takes from_screen', () {
    PlpEntryArgs? argsFor(PageType type, Map<String, dynamic>? extra) =>
        PlpDestination(pageType: type, plpId: 1).entryArgsFrom(extra);

    // Boutique included: it is the same PlpPage as a plain listing, differing
    // only by its banner, so it reports the same entry context. It used to be
    // excluded by comparing against Android's boutique *deeplink hosts*, which
    // open a list of boutiques rather than a listing of products.
    for (final type in PageType.values) {
      test('${type.name}: from_screen only — not from_page', () {
        // The PDP gets both; the PLP's `FROM_PAGE` sits in the
        // `HomePageActivity` block that does not fire.
        final args = argsFor(type, navExtra(sourcePage: discover))!;
        expect(args.fromScreen, 'Discover');
        expect(args.fromLocation, isNull);
        expect(args.row, isNull);
        expect(args.position, isNull);
      });
    }

    test('a boutique is not a special case', () {
      final args = argsFor(PageType.boutique, navExtra(sourcePage: discover))!;
      expect(args.fromScreen, 'Discover');
      final plp = argsFor(PageType.plp, navExtra(sourcePage: discover))!;
      expect(args, plp, reason: 'boutique and plp report identical entry args');
    });

    test('explicit args win over the page', () {
      const explicit = PlpEntryArgs(
        fromScreen: 'water yellowA',
        fromLocation: 'Custom product tile',
        position: 4,
      );
      final args = argsFor(
        PageType.boutique,
        navExtra(sourcePage: discover, plpEntryArgs: explicit),
      );
      expect(args, explicit, reason: 'a caller that built the whole payload '
          'knows more than the origin page does');
    });
  });

  group('PDP takes from_screen too', () {
    PdpEntryArgs? argsFor(Map<String, dynamic>? extra) =>
        const PdpDestination(productId: '1').entryArgsFrom(extra);

    test('takes both parts of the page', () {
      // Android passes the same pair — `buildIntentExtras(fromScreen,
      // fromPage, …)` in the `deepLinkProductPage` branch (`TileAction:209`).
      final args = argsFor(navExtra(sourcePage: discover))!;
      expect(args.fromScreen, 'Discover');
      expect(args.fromPage, 'homepage');
    });

    test('explicit args win — a PLP tile knows more than the page', () {
      const explicit = PdpEntryArgs(
        fromScreen: 'Dresses',
        fromPage: 'plp',
        fromFeedSize: 164,
      );
      expect(
        argsFor(navExtra(sourcePage: discover, pdpEntryArgs: explicit)),
        explicit,
      );
    });

    test('no context at all yields nothing', () {
      expect(argsFor(null), isNull);
    });
  });
}
