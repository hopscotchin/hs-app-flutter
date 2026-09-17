import 'package:hs_app_flutter/core/navigation/nav_destination.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hs_app_flutter/core/analytics/constants/analytics_defaults.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_events.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_properties.dart';
import 'package:hs_app_flutter/core/analytics/events/modules/plp_events.dart';
import 'package:hs_app_flutter/core/analytics/events/modules/wishlist_events.dart';

import '../support/analytics_test_harness.dart';
import '../support/plp_fixture.dart';

/// Complete `from_location` matrix for the PLP surface, read off every write in
/// `hsplp/.../analytics/PLPAnalytics.kt`. There are exactly four in the whole
/// file — everything else omits the key:
///
/// | Event | Android | from_location |
/// |---|---|---|
/// | product_listing_viewed / boutique_viewed / products_searched / reco_products_viewed | `:779` common block | the intent extra |
/// | xl_product_card_scrolled | reuses the common block (`:522`) | the intent extra |
/// | search_clicked | `:427` | `Search icon` (constant) |
/// | product_added_to_wishlist | `:441` | `Wishlist button` (constant) |
/// | product_removed_from_wishlist | `:490` | `Wishlist button` (constant) |
/// | promo_products_viewed | `getPromotionProperties` early-returns 5 keys | **none** |
/// | filter_clicked / filter_applied / filter_cleared | own builders | **none** |
/// | sorting_applied | own builder | **none** |
/// | notification_permission_accepted / _rejected | `:552` | **none** |
/// | plp_scrolled | `saveScrollMetaData` | **none** |
void main() {
  late AnalyticsTestHarness h;
  late PlpFixture fixture;

  setUp(() async {
    h = await AnalyticsTestHarness.build();
    fixture = PlpFixture.load();
  });
  tearDown(() => h.tearDown());

  String? locOf(String event) =>
      h.singleEvent(event)[AnalyticsProperties.fromLocation] as String?;

  group('carries from_location', () {
    test('listing viewed — passed through from the entry args', () async {
      await h.analytics.logListingViewed(
        plpType: PlpType.productListing,
        trackingMeta: fixture.plpAnalyticsMeta,
        fromLocation: FromLocations.customTile,
      );
      expect(locOf(AnalyticsEvents.productListingViewed), 'Custom tile');
    });

    test('xl_product_card_scrolled — same shared builder', () async {
      await h.analytics.logXlProductCardScrolled(
        trackingMeta: fixture.plpAnalyticsMeta,
        fromLocation: FromLocations.customTile,
        cardIndex: 2,
      );
      expect(locOf(AnalyticsEvents.xlProductCardScrolled), 'Custom tile');
    });

    test('search_clicked — the constant, not the entry args', () async {
      await h.analytics.logSearchClicked(
        source: const SourcePage(
          fromScreen: FromScreens.productListPage,
          fromLocation: FromLocations.searchIcon,
        ),
      );
      expect(locOf(AnalyticsEvents.searchClicked), 'Search icon');
    });

    test('product_added_to_wishlist — Wishlist button', () async {
      await h.analytics.logProductAddedToWishlist(
        productId: '1',
        fromScreen: 'Dresses',
      );
      expect(locOf(AnalyticsEvents.productAddedToWishlist), 'Wishlist button');
    });

    test('product_removed_from_wishlist — Wishlist button', () async {
      await h.analytics.logProductRemovedFromWishlist(
        productId: '1',
        fromScreen: 'Dresses',
      );
      expect(
        locOf(AnalyticsEvents.productRemovedFromWishlist),
        'Wishlist button',
      );
    });
  });

  group('never carries from_location', () {
    test('filter_clicked', () async {
      await h.analytics.logFilterClicked(
        trackingMeta: fixture.plpAnalyticsMeta,
        clickSource: FilterClickSource.standardFilter,
      );
      expect(locOf(AnalyticsEvents.filterClicked), isNull);
    });

    test('filter_applied and filter_cleared', () async {
      await h.analytics.logFilterApplied(
        isFilterCleared: false,
        trackingMeta: fixture.plpAnalyticsMeta,
        clickSource: FilterClickSource.standardFilter,
      );
      expect(locOf(AnalyticsEvents.filterApplied), isNull);

      h.clear();
      await h.analytics.logFilterApplied(
        isFilterCleared: true,
        trackingMeta: fixture.plpAnalyticsMeta,
        clickSource: FilterClickSource.standardFilter,
      );
      expect(locOf(AnalyticsEvents.filterCleared), isNull);
    });

    test('sorting_applied', () async {
      await h.analytics.logSortingApplied(
        trackingMeta: fixture.plpAnalyticsMeta,
        fromSort: 'Popular',
        newSort: 'Price low to high',
      );
      expect(locOf(AnalyticsEvents.sortingApplied), isNull);
    });

    test('notification_permission_accepted / _rejected', () async {
      await h.analytics.logNotificationPermission(
        accepted: true,
        plpType: PlpType.productListing,
      );
      expect(locOf(AnalyticsEvents.notificationPermissionAccepted), isNull);
    });

    test('plp_scrolled', () async {
      await h.analytics.logPlpScrolled(
        scrollDepthParams: const {AnalyticsProperties.fromRow: 1},
        trackingMeta: fixture.plpAnalyticsMeta,
      );
      expect(locOf(AnalyticsEvents.plpScrolled), isNull);
    });

    test('products_searched after a query correction', () async {
      await h.analytics.logProductsSearchedAfterQueryCorrection(
        trackingMeta: fixture.plpAnalyticsMeta,
        queryCorrection: QueryCorrection.suggestionUsed,
      );
      expect(locOf(AnalyticsEvents.productsSearched), isNull);
    });
  });
}
