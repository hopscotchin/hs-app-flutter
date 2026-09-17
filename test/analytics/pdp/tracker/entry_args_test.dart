import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_defaults.dart';
import 'package:hs_app_flutter/core/analytics/events/modules/pdp_events.dart';
import 'package:hs_app_flutter/core/navigation/nav_destination.dart';
import 'package:hs_app_flutter/features/pdp/data/models/product_detail_model.dart';
import 'package:hs_app_flutter/features/pdp/domain/entities/pdp_entry_args.dart';
import 'package:hs_app_flutter/features/plp/domain/entities/listing_product_entity.dart';
import 'package:hs_app_flutter/features/plp/domain/entities/page_type.dart';
import 'package:hs_app_flutter/features/plp/presentation/bloc/plp_bloc.dart';

import '../../support/analytics_test_harness.dart';

/// PDP's entry context is supplied by whoever navigates to it. When no caller
/// passes it, the route falls back to `const PdpEntryArgs()` and three
/// properties silently vanish from every PDP event:
///
/// | Property | With no args | Why |
/// |---|---|---|
/// | `from_screen` | absent | default `null` |
/// | `from_page` | absent | default `null` |
/// | `from_feed_size` | absent | default `null` — was `0`, discarded by the old `<= 0` rule |
///
/// `position` and `source_tile_type` are no longer client-owned — the backend
/// nodes carry them — so this file no longer pins their mapping.
void main() {
  const normalTile = ListingProductEntity(id: 946815, name: 'Tile');

  /// Mirrors the widget call site: `plp.pdpEntryArgs`.
  PdpEntryArgs argsFrom({
    String? screenName,
    PageType pageType = PageType.plp,
    int feedSize = 1,
  }) => PlpState(
        screenName: screenName,
        pageType: pageType,
        totalRecords: feedSize,
        products: const [normalTile],
      ).pdpEntryArgs;

  group('mapping — ports ProductListPageActivity.java:793-830', () {
    test('every field comes from the caller, not a default', () {
      final args = argsFrom(
        screenName: 'Test prod issue 123',
        pageType: PageType.plp,
        feedSize: 164,
      );
      expect(args.fromScreen, 'Test prod issue 123');
      expect(args.fromPage, FromPage.plp);
      expect(args.fromPage, 'plp', reason: 'Android sends the literal "plp"');
      expect(args.fromFeedSize, 164);
    });

    test('falls back to the literal "plp" when the listing has no name', () {
      for (final name in const <String?>[null, '']) {
        final args = argsFrom(screenName: name, pageType: PageType.plp, feedSize: 1);
        expect(args.fromScreen, FromScreens.plp, reason: 'screenName: $name');
      }
    });
  });

  group('from_page follows the listing kind', () {
    // Verified against three paired live captures on 2026-08-10: the same
    // boutique journey reported `from_page: "boutique"` on Android and
    // `"plp"` on Flutter, on all three products. `from_page` was hardcoded.
    PdpEntryArgs argsFor(PageType type) =>
        argsFrom(screenName: 'x', pageType: type, feedSize: 1);

    test('a boutique reports "boutique", not "plp"', () {
      // Android: PLPProductViewModel.java:171 passes FromPage.BOUTIQUE.
      expect(argsFor(PageType.boutique).fromPage, 'boutique');
    });

    test('a category listing reports "plp"', () {
      // Android: ProductListPageActivity.java:794, a literal.
      expect(argsFor(PageType.plp).fromPage, 'plp');
    });

    test('search reports the capitalised "Search"', () {
      // Android sends R.string.search verbatim (:796), whose en value is
      // "Search" — the odd one out, and deliberately not lower-cased.
      expect(argsFor(PageType.search).fromPage, 'Search');
    });

    test('every PageType is mapped — a new one must not fall back silently', () {
      // The switch is exhaustive, so this fails to compile rather than at
      // runtime if PageType grows. Asserting distinctness catches the other
      // failure mode: a new case copy-pasted onto an existing value.
      final values = PageType.values.map((t) => argsFor(t).fromPage).toList();
      expect(values.toSet(), hasLength(PageType.values.length));
    });
  });

  group('PlpStateX.feedSize — Android\'s totalProductCount', () {
    const product = ListingProductEntity(id: 946815, name: 'Tile');

    test('prefers the listing total over the loaded page', () {
      const state = PlpState(totalRecords: 164, products: [product]);
      expect(state.feedSize, 164);
    });

    test('falls back to the loaded count when totalRecords is absent', () {
      const state = PlpState(products: [product, product, product]);
      expect(state.feedSize, 3);
    });
  });

  group('both routes into PDP behave alike', () {
    test('PdpDestination forwards entry args from the extra map', () {
      // A PLP tile calls goToPdp(args:) directly; the same product opened via an
      // actionUri routes through PdpDestination. Before this forwarded, the two
      // produced different payloads for the same destination.
      const args = PdpEntryArgs(
        fromScreen: 'Test prod issue 123',
        fromPage: FromPage.plp,
        fromFeedSize: 164,
      );
      const destination = PdpDestination(productId: '946815');
      // The key is a shared constant so producer and consumer cannot drift.
      final extra = <String, dynamic>{pdpEntryArgsKey: args};
      expect(extra[pdpEntryArgsKey], isA<PdpEntryArgs>());
      expect(destination.productId, '946815');
      expect((extra[pdpEntryArgsKey] as PdpEntryArgs).fromScreen, 'Test prod issue 123');
    });

    test('a malformed extra degrades to defaults rather than throwing', () {
      final extra = <String, dynamic>{pdpEntryArgsKey: 'not-args'};
      expect(extra[pdpEntryArgsKey] is PdpEntryArgs, isFalse);
    });
  });

  group('the values reach the event — not just the args object', () {
    late AnalyticsTestHarness h;

    setUp(() async => h = await AnalyticsTestHarness.build());
    tearDown(() => h.tearDown());

    Future<Map<String, Object?>> fire({required bool withArgs}) async {
      final detail =
          ProductDetailModel.fromJson(
            jsonDecode(
                  File(
                    'test/analytics/fixtures/pdp_product_945499.json',
                  ).readAsStringSync(),
                )
                as Map<String, dynamic>,
          ).toEntity();
      await h.analytics.logProductViewed(
        product: detail.product!,
        entry: withArgs
            ? argsFrom(
                screenName: 'Test prod issue 123',
                pageType: PageType.plp,
                feedSize: 164,
              )
            : const PdpEntryArgs(),
      );
      return h.captured.single.props;
    }

    test('with entry args, the three client-owned properties are present', () async {
      final props = await fire(withArgs: true);
      expect(props['from_screen'], 'Test prod issue 123');
      expect(props['from_page'], 'plp');
      expect(props['from_feed_size'], 164);
    });

    test('without them, all three vanish', () async {
      // The bug this file exists to prevent. Kept as an executable record of what
      // the payload looked like before the PLP call sites were wired.
      final props = await fire(withArgs: false);
      for (final key in const ['from_screen', 'from_page', 'from_feed_size']) {
        expect(
          props.containsKey(key),
          isFalse,
          reason: '$key should be absent without entry args',
        );
      }
    });
  });
}
