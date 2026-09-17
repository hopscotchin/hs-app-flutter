import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_defaults.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_events.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_properties.dart';
import 'package:hs_app_flutter/features/discover/domain/entities/home_page_entity.dart';
import 'package:hs_app_flutter/features/pdp/data/models/product_detail_model.dart';
import 'package:hs_app_flutter/features/pdp/domain/entities/product_detail_entity.dart';
import 'package:hs_app_flutter/core/analytics/pdp/pdp_analytics_tracker.dart';
import 'package:hs_app_flutter/features/plp/domain/entities/listing_product_entity.dart';

import '../../support/analytics_test_harness.dart';
import 'package:hs_app_flutter/features/pdp/domain/entities/tile_entity.dart';
import '../support/node_fixtures.dart';

/// The PDP reco grid and recently-viewed rail render with the **shared homepage
/// components** (`ProductGridWidget`, `PageCarouselWidget`), which log
/// `tile_clicked` and write HP attribution by default. On PDP that is wrong on
/// three counts, so both widgets pass an `onTileTapLog` override.
///
/// Android's rule is the same: share the view, never the analytics. Its shared
/// `CarouselView` has no analytics of its own — the host injects the handler
/// (`RecentlyViewedProductsView.kt:69-81`) — and the reco grid goes further,
/// with a PDP-owned adapter taking `pdpAnalytics` in
/// (`ProductListAdapter.kt:14-27`).
///
/// These tests pin the *outcome* of the override at the tracker boundary: the
/// PDP event fires, the homepage event does not, and no attribution is written.
ProductDetailEntity _fixture() {
  final raw = File('test/analytics/fixtures/pdp_product_945499.json').readAsStringSync();
  return ProductDetailModel.fromJson(jsonDecode(raw) as Map<String, dynamic>).toEntity();
}

void main() {
  late AnalyticsTestHarness h;
  late PdpAnalyticsTracker tracker;

  const tapped = ListingProductEntity(
    id: 943726,
    name: 'Multi D-Stripes lace Top And Short Set',
    trackingMeta: {
      'category_name': 'Apparel - Children',
      'subcategory_name': 'Sets',
      'product_type_name': 'Pant set',
    },
  );

  setUp(() async {
    h = await AnalyticsTestHarness.build();
    tracker = PdpAnalyticsTracker(h.analytics);
    tracker.onProductLoaded(_fixture());
    h.clear();
  });
  tearDown(() => h.tearDown());

  group('reco tile tap', () {
    test('emits reco_product_clicked, never tile_clicked', () {
      tracker.onRecoTileTapped(TileEntity(product: tapped, trackingMeta: tileClickMeta(tapped)));
      expect(h.hasEvent(AnalyticsEvents.recoProductClicked), isTrue);
      expect(h.hasEvent(AnalyticsEvents.tileClicked), isFalse);
      expect(h.hasEvent(AnalyticsEvents.lpTileClicked), isFalse);
    });

    test('carries the tapped product, and the page product as context', () {
      tracker.onRecoTileTapped(TileEntity(product: tapped, trackingMeta: tileClickMeta(tapped)));
      final e = h.singleEvent(AnalyticsEvents.recoProductClicked);
      // The tapped tile.
      expect(e[AnalyticsProperties.clickedProductPid], '943726');
      expect(e[AnalyticsProperties.clickedCategory], 'Apparel - Children');
      // The page's own product — this event describes PDP A, not PDP B.
      expect(e[AnalyticsProperties.productId], '945499');
    });
  });

  group('recently-viewed tile tap', () {
    test('emits recently_viewed_products_clicked, never tile_clicked', () {
      tracker.onRecentlyViewedTileTapped(
        TileEntity(product: tapped, trackingMeta: tileClickMeta(tapped)),
      );
      expect(h.hasEvent(AnalyticsEvents.recentlyViewedProductsClicked), isTrue);
      expect(h.hasEvent(AnalyticsEvents.tileClicked), isFalse);
      expect(h.hasEvent(AnalyticsEvents.lpTileClicked), isFalse);
    });
  });

  group('rail wishlist — the tile, attributed to its rail', () {
    // Both rails carry a heart. The shared components have NO default wishlist
    // analytics (Android's home hides the control entirely), so without the
    // `onWishlistLog` override these taps would emit nothing at all — the failure
    // mode is silence, which no dashboard reports.
    const railTile = PageCarouselTile(id: 943726, product: tapped);

    test('reco reports the TILE, not the PDP being viewed', () {
      tracker.onRecoTileWishlisted(tapped, added: true);
      final e = h.singleEvent(AnalyticsEvents.productAddedToWishlist);
      // 943726 is the tile; 945499 is the page. A wishlist describes what the user
      // wishlisted, so the page's id must not appear.
      expect(e[AnalyticsProperties.productId], '943726');
      expect(e[AnalyticsProperties.fromLocation], FromLocations.recoSection);
      // The user is still on the PDP.
      expect(e[AnalyticsProperties.fromScreen], FromScreens.product);
    });

    test('recently-viewed reports its own rail', () {
      tracker.onRecentlyViewedTileWishlisted(railTile, added: true);
      final e = h.singleEvent(AnalyticsEvents.productAddedToWishlist);
      expect(e[AnalyticsProperties.productId], '943726');
      expect(e[AnalyticsProperties.fromLocation], FromLocations.recentlyViewedSection);
      expect(e[AnalyticsProperties.fromScreen], FromScreens.product);
    });

    test('the three PDP surfaces are separable by from_location alone', () {
      // They share one `from_screen`, so `from_location` is the only thing that
      // distinguishes them — the property Android's PDP payload omits (A12).
      tracker
        ..onWishlistAdded()
        ..onRecoTileWishlisted(tapped, added: true)
        ..onRecentlyViewedTileWishlisted(railTile, added: true);
      final locations = h
          .eventsNamed(AnalyticsEvents.productAddedToWishlist)
          .map((e) => e[AnalyticsProperties.fromLocation])
          .toList();
      expect(locations, [
        FromLocations.wishlistButton,
        FromLocations.recoSection,
        FromLocations.recentlyViewedSection,
      ]);
    });

    test('added: false emits the removal event instead', () {
      tracker
        ..onRecoTileWishlisted(tapped, added: false)
        ..onRecentlyViewedTileWishlisted(railTile, added: false);
      expect(h.eventsNamed(AnalyticsEvents.productRemovedFromWishlist), hasLength(2));
      expect(h.hasEvent(AnalyticsEvents.productAddedToWishlist), isFalse);
    });

    test('a rail heart still reports with no product loaded', () {
      // Unlike the tap events, these do not need the PDP payload — the tile is
      // self-describing. `onPidRefreshed` clears `_detail`, so a heart tapped
      // during a colour switch would otherwise be dropped.
      tracker.onPidRefreshed();
      tracker.onRecoTileWishlisted(tapped, added: true);
      expect(
        h.singleEvent(AnalyticsEvents.productAddedToWishlist)[AnalyticsProperties.productId],
        '943726',
      );
    });
  });

  group('no homepage side effects from PDP', () {
    test('a PDP tile tap writes NO attribution', () async {
      // Android's hspdp module makes zero attribution writes — verified by
      // grep. The legacy PDP had six; the rewrite dropped them all. If the
      // shared component's default logging ever leaks back in, this fails,
      // because `logTileClick` calls `mergeTrackingMeta`.
      final before = h.orderAttribution.getCurrent();
      tracker
        ..onRecoTileTapped(TileEntity(product: tapped, trackingMeta: tileClickMeta(tapped)))
        ..onRecentlyViewedTileTapped(
          TileEntity(product: tapped, trackingMeta: tileClickMeta(tapped)),
        );
      final after = h.orderAttribution.getCurrent();
      expect(after?.trackingMeta ?? const {}, before?.trackingMeta ?? const {});
    });

    test('no impression or carousel_scrolled events leak from PDP', () {
      tracker
        ..onContentScrolled(down: true)
        ..onRecoRailVisible(const {'feed_size': 10})
        ..onRecentlyViewedRailVisible(const {'feed_size': 6})
        ..onRecentlyViewedSettled(2)
        ..flushRecentlyViewedScrolled();
      for (final homeEvent in [
        AnalyticsEvents.tileImpression,
        AnalyticsEvents.bannerImpression,
        AnalyticsEvents.carouselScrolled,
        AnalyticsEvents.lpTileImpression,
        AnalyticsEvents.lpCarouselScrolled,
      ]) {
        expect(
          h.hasEvent(homeEvent),
          isFalse,
          reason: '$homeEvent is a homepage event and must not fire on PDP',
        );
      }
      // The PDP equivalents did fire.
      expect(h.hasEvent(AnalyticsEvents.recoViewed), isTrue);
      expect(h.hasEvent(AnalyticsEvents.recentlyViewedProductsLoaded), isTrue);
      expect(h.hasEvent(AnalyticsEvents.recentlyViewedProductsScrolled), isTrue);
    });
  });
}
