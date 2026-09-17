import 'package:hs_app_flutter/core/navigation/nav_destination.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hs_app_flutter/core/analytics/constants/analytics_defaults.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_events.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_properties.dart';
import 'package:hs_app_flutter/core/analytics/events/modules/plp_events.dart';
import 'package:hs_app_flutter/features/plp/domain/helpers/plp_filter_segment.dart';

import '../support/analytics_test_harness.dart';
import '../support/common_props_matchers.dart';
import '../support/plp_fixture.dart';

/// PLP-event parity tests. Fixture: `test/analytics/fixtures/plp/product_listing_page.json`.
///
/// Cross-referenced against Android's `PLPAnalytics.kt`:
///   - `logListingViewed`            → :278
///   - `addPropertiesAfterQueryCorrection` → :923
///   - `logFilterCLicked`            → :316
///   - `logFilterApplied`            → :347 (fires filter_applied OR filter_cleared)
///   - `logSortingApplied`           → :392
///   - `logXLProductCardScrolled`    → :514
///   - `logSearchClicked`            → hsapp `AnalyticsHelper:1562` / `ProductListPageActivity:3654`
///   - `logNotificationPermission`   → :550
///   - `sendScrollData`              → :745
///
/// Every event flows through `AnalyticsHelper.logEvent`/`logScrollEvent`, so
/// `putAnalyticsKey` (drops null / empty / <=0) applies uniformly — the
/// per-event assertions below verify that plus each event's specific shape.
void main() {
  late AnalyticsTestHarness h;
  late PlpFixture fixture;

  setUp(() async {
    h = await AnalyticsTestHarness.build();
    fixture = PlpFixture.load();
  });

  tearDown(() => h.tearDown());

  // ─── logListingViewed — five event names, one payload builder ──────

  group('logListingViewed', () {
    test(
      'Product listing → product_listing_viewed with page blob + APP nav keys',
      () async {
        await h.analytics.logListingViewed(
          plpType: PlpType.productListing,
          trackingMeta: fixture.plpAnalyticsMeta,
          fromScreen: 'Discover',
          fromLocation: 'Homepage',
          position: 3,
          addFromDetails: 'Hero',
        );

        final e = h.singleEvent(AnalyticsEvents.productListingViewed);
        expectTimeBuckets(e);
        expectTimestamp(e);

        // BE — every backend-authored key from the merged page blob is spread.
        expect(e[AnalyticsProperties.plpType], PlpType.productListing);
        expect(e[AnalyticsProperties.feedSize], 3583);
        expect(e['is_page_xl_tile_eligible'], 'No');
        expect(e['page_eligible_for_clustered_plp'], 'No');
        expect(e['sort_order'], 'Popular');
        expect(e['product_listing_id'], 12038);
        expect(e['product_listing_name'], 'TestDoorwas15');
        expect(e['product_id'], ['939690', '939592', '939694', '939738']);
        expect(e['plp'], 'P12038');
        expect(e['redirected_from_cluster_eligible_plp'], 'No');

        // APP — nav context supplied at the call site.
        expect(e[AnalyticsProperties.fromScreen], 'Discover');
        expect(e[AnalyticsProperties.fromLocation], 'Homepage');
        expect(e[AnalyticsProperties.position], 3);
        expect(e[AnalyticsProperties.addFromDetails], 'Hero');

        // `row` / `from_feed_size` are boutique-only — the caller withholds them
        // for a Product listing, so nothing to assert beyond their absence.
        expect(e.containsKey(AnalyticsProperties.row), isFalse);
        expect(e.containsKey(AnalyticsProperties.fromFeedSize), isFalse);
        expectNoNullFields(e);
      },
    );

    test('row / from_feed_size ship only for a Boutique', () async {
      await h.analytics.logListingViewed(
        plpType: PlpType.boutique,
        trackingMeta: {
          ...fixture.plpAnalyticsMeta,
          AnalyticsProperties.plpType: PlpType.boutique,
        },
        row: 2,
        fromFeedSize: 40,
      );

      final e = h.singleEvent(AnalyticsEvents.boutiqueViewed);
      expect(e[AnalyticsProperties.row], 2);
      expect(e[AnalyticsProperties.fromFeedSize], 40);
    });

    test(
      'the builder ships whatever the caller passes — gating is theirs',
      () async {
        // `row` / `from_feed_size` are boutique-only on the wire, but that call
        // is `PlpBloc`'s: it knows the page kind. The payload builder stays a
        // dumb translator so there is one place to look for the rule.
        await h.analytics.logListingViewed(
          plpType: PlpType.productListing,
          trackingMeta: {AnalyticsProperties.plpType: PlpType.boutique},
          row: 5,
        );

        final e = h.singleEvent(AnalyticsEvents.productListingViewed);
        expect(e[AnalyticsProperties.row], 5);
      },
    );

    test('plpType=Boutique → boutique_viewed', () async {
      await h.analytics.logListingViewed(
        plpType: PlpType.boutique,
        trackingMeta: fixture.plpAnalyticsMeta,
      );

      expect(h.hasEvent(AnalyticsEvents.boutiqueViewed), isTrue);
      expect(h.hasEvent(AnalyticsEvents.productListingViewed), isFalse);
    });

    test('plpType=Search → products_searched', () async {
      await h.analytics.logListingViewed(
        plpType: PlpType.search,
        trackingMeta: fixture.plpAnalyticsMeta,
      );

      expect(h.hasEvent(AnalyticsEvents.productsSearched), isTrue);
    });

    test(
      'search entry keys reach the wire — keyword, derived length, suggestion_index',
      () async {
        await h.analytics.logListingViewed(
          plpType: PlpType.search,
          trackingMeta: fixture.plpAnalyticsMeta,
          fromScreen: PlpType.search,
          keyword: 'red dress',
          suggestionIndex: 3,
        );

        final e = h.singleEvent(AnalyticsEvents.productsSearched);
        expect(e[AnalyticsProperties.fromScreen], PlpType.search);
        expect(e[AnalyticsProperties.keyword], 'red dress');
        // Derived from the keyword, never accepted separately — matches Android
        // `PLPAnalytics.kt:877`.
        expect(e[AnalyticsProperties.length], 9);
        expect(e[AnalyticsProperties.suggestionIndex], 3);
      },
    );

    test('no keyword → neither keyword nor length ships', () async {
      await h.analytics.logListingViewed(
        plpType: PlpType.search,
        trackingMeta: fixture.plpAnalyticsMeta,
      );

      final e = h.singleEvent(AnalyticsEvents.productsSearched);
      expect(e.containsKey(AnalyticsProperties.keyword), isFalse);
      expect(e.containsKey(AnalyticsProperties.length), isFalse);
    });

    test(
      'suggestion trackingData is spread but loses to explicit client keys',
      () async {
        await h.analytics.logListingViewed(
          plpType: PlpType.search,
          trackingMeta: fixture.plpAnalyticsMeta,
          suggestionTrackingData: const <String, dynamic>{
            'section': 'Suggested brand',
            AnalyticsProperties.keyword: 'server keyword',
          },
          keyword: 'typed keyword',
        );

        final e = h.singleEvent(AnalyticsEvents.productsSearched);
        expect(e['section'], 'Suggested brand');
        expect(e[AnalyticsProperties.keyword], 'typed keyword');
      },
    );

    test('isPromo overrides plpType → promo_products_viewed', () async {
      await h.analytics.logListingViewed(
        plpType: PlpType.productListing,
        isPromo: true,
        trackingMeta: fixture.plpAnalyticsMeta,
      );

      expect(h.hasEvent(AnalyticsEvents.promoProductsViewed), isTrue);
    });

    test('isReco overrides plpType → reco_products_viewed', () async {
      await h.analytics.logListingViewed(
        plpType: PlpType.productListing,
        isReco: true,
        trackingMeta: fixture.plpAnalyticsMeta,
      );

      expect(h.hasEvent(AnalyticsEvents.recoProductsViewed), isTrue);
    });

    test('putAnalyticsKey keeps zeros and drops only empties', () async {
      await h.analytics.logListingViewed(
        plpType: PlpType.productListing,
        trackingMeta: fixture.plpAnalyticsMeta,
        // A 0 is a fact — the first row, a listing with no results. Only values
        // carrying no dimension are dropped.
        position: 0,
        row: 0,
        fromFeedSize: 0,
        fromScreen: '',
      );

      final e = h.singleEvent(AnalyticsEvents.productListingViewed);
      expect(e[AnalyticsProperties.position], 0);
      expect(e[AnalyticsProperties.row], 0);
      expect(e[AnalyticsProperties.fromFeedSize], 0);
      expect(e.containsKey(AnalyticsProperties.fromScreen), isFalse);
    });
  });

  // ─── logProductsSearchedAfterQueryCorrection ─────────────────────

  group('logProductsSearchedAfterQueryCorrection', () {
    test('re-fires products_searched with query_correction stamp', () async {
      await h.analytics.logProductsSearchedAfterQueryCorrection(
        trackingMeta: fixture.plpAnalyticsMeta,
        queryCorrection: QueryCorrection.suggestionUsed,
        addFromDetails: 'search-bar',
      );

      final e = h.singleEvent(AnalyticsEvents.productsSearched);
      expect(
        e[AnalyticsProperties.queryCorrection],
        QueryCorrection.suggestionUsed,
      );
      // from_screen is hard-coded to PlpType.search on this path (Android :928).
      expect(e[AnalyticsProperties.fromScreen], PlpType.search);
      expect(e[AnalyticsProperties.addFromDetails], 'search-bar');
      // BE blob still spread — plp is one of the sentinel keys we can pin.
      expect(e['plp'], 'P12038');
      expectTimestamp(e);
    });
  });

  // ─── logFilterClicked ─────────────────────────────────────────────

  group('logFilterClicked', () {
    test('stamps click_source and forwards the page blob', () async {
      await h.analytics.logFilterClicked(
        trackingMeta: fixture.plpAnalyticsMeta,
        clickSource: FilterClickSource.stickyFilter,
      );

      final e = h.singleEvent(AnalyticsEvents.filterClicked);
      expect(
        e[AnalyticsProperties.clickSource],
        FilterClickSource.stickyFilter,
      );
      expect(e[AnalyticsProperties.plpType], PlpType.productListing);
      expect(e[AnalyticsProperties.feedSize], 3583);
      expect(e['plp'], 'P12038');
      expectTimestamp(e);
    });
  });

  // ─── logFilterApplied / logFilterCleared ─────────────────────────

  group('logFilterApplied', () {
    Map<String, Object?> _mergedFilterMeta() => <String, Object?>{
      ...fixture.plpAnalyticsMeta,
      ...fixture.filtersTrackingMeta, // filter response wins on collision.
    };

    test(
      'filter_applied merges page + /v2/filter blob, applies attribution',
      () async {
        final filterSegment = PlpFilterSegment.buildFromLeaves(const [
          PlpSelectedLeaf(
            label: '3-6 months',
            sectionTracking: 'age',
            isAttribute: false,
          ),
          PlpSelectedLeaf(
            label: '6-9 months',
            sectionTracking: 'age',
            isAttribute: false,
          ),
        ]);

        await h.analytics.logFilterApplied(
          isFilterCleared: false,
          trackingMeta: _mergedFilterMeta(),
          clickSource: FilterClickSource.standardFilter,
          filterSegment: filterSegment,
          fromScreen: fixture.pageTitle,
        );

        final e = h.singleEvent(AnalyticsEvents.filterApplied);
        // Page blob keys spread.
        expect(e[AnalyticsProperties.plpType], PlpType.productListing);
        expect(e[AnalyticsProperties.feedSize], 3583);
        // Filter-response blob keys spread.
        expect(e[AnalyticsProperties.filterSection], ['age']);
        expect(e['filter_section_count'], 1);
        // Filter-segment dynamic key + counts.
        expect(e['age_filter'], ['3-6 months', '6-9 months']);
        // APP.
        expect(
          e[AnalyticsProperties.clickSource],
          FilterClickSource.standardFilter,
        );
        expect(e[AnalyticsProperties.fromScreen], fixture.pageTitle);
      },
    );

    test(
      'filter_cleared fires under filter_cleared event name, attribution off',
      () async {
        await h.analytics.logFilterApplied(
          isFilterCleared: true,
          trackingMeta: _mergedFilterMeta(),
          clickSource: FilterClickSource.standardFilter,
          filterSegment: const {},
          fromScreen: fixture.pageTitle,
        );

        expect(h.hasEvent(AnalyticsEvents.filterCleared), isTrue);
        expect(
          h.hasEvent(AnalyticsEvents.filterApplied),
          isFalse,
          reason: 'Android :378 vs :386 — clear path uses filter_cleared name',
        );
      },
    );
  });

  // ─── logSortingApplied ────────────────────────────────────────────

  group('logSortingApplied', () {
    test(
      'stamps from_sort/new_sort (eventSortName, not display label)',
      () async {
        // Fixture ships options: Popular, PriceHighLow, PriceLowHigh — pass the
        // eventSortName pair the bloc derives.
        await h.analytics.logSortingApplied(
          trackingMeta: fixture.plpAnalyticsMeta,
          fromSort: 'Popular',
          newSort: 'PriceHighLow',
        );

        final e = h.singleEvent(AnalyticsEvents.sortingApplied);
        expect(e[AnalyticsProperties.fromSort], 'Popular');
        expect(e[AnalyticsProperties.newSort], 'PriceHighLow');
        expect(e[AnalyticsProperties.plpType], PlpType.productListing);
        expect(e['product_listing_name'], 'TestDoorwas15');
      },
    );
  });

  // ─── logXlProductCardScrolled ─────────────────────────────────────

  group('logXlProductCardScrolled', () {
    test(
      'carries the listing-viewed common set + card_index + swipe_direction',
      () async {
        await h.analytics.logXlProductCardScrolled(
          trackingMeta: fixture.plpAnalyticsMeta,
          cardIndex: 2,
          swipeDirection: 'left',
          fromScreen: 'PLP',
          position: 5,
        );

        final e = h.singleEvent(AnalyticsEvents.xlProductCardScrolled);
        expect(e[AnalyticsProperties.cardIndex], 2);
        expect(e[AnalyticsProperties.swipeDirection], 'left');
        expect(e[AnalyticsProperties.fromScreen], 'PLP');
        expect(e[AnalyticsProperties.position], 5);
        // Page blob still present.
        expect(e[AnalyticsProperties.feedSize], 3583);
        expect(e['product_listing_id'], 12038);
      },
    );

    test('a 0 would report, though callers send 1-based indices', () async {
      await h.analytics.logXlProductCardScrolled(
        trackingMeta: fixture.plpAnalyticsMeta,
        cardIndex: 0,
        swipeDirection: 'left',
      );

      final e = h.singleEvent(AnalyticsEvents.xlProductCardScrolled);
      expect(
        e[AnalyticsProperties.cardIndex],
        0,
        reason:
            'Android drops it (:516), which makes a swipe from the first card '
            'indistinguishable from one that reported no card at all',
      );
    });
  });

  // ─── logSearchClicked ─────────────────────────────────────────────

  group('logSearchClicked', () {
    // Two Android implementations disagree: hsplp's PLPAnalytics (`:426`)
    // sends the plp_type, hsapp's ProductListPageActivity (`:3654`) sends the
    // constant page name. Production payloads carry "Search Plp", so the
    // constant wins — and it is a constant, never the page or plp_type.
    test(
      'listing: from_screen = "Search Plp", from_location = "Search icon"',
      () async {
        await h.analytics.logSearchClicked(
          source: const SourcePage(
            fromScreen: FromScreens.productListPage,
            fromLocation: FromLocations.searchIcon,
          ),
        );

        final e = h.singleEvent(AnalyticsEvents.searchClicked);
        expect(e[AnalyticsProperties.fromScreen], 'Search Plp');
        expect(e[AnalyticsProperties.fromLocation], 'Search icon');
      },
    );

    test('boutique reports the Flutter-only "Search Boutique"', () async {
      // Android's boutique has no search control at all
      // (`boutique_plp_menu.xml` inflates favorite / reminder / cart /
      // wishlist only), so there is no Android string to reuse: "Search Plp"
      // would fold it into the listing's numbers and "Boutique Plp" would
      // collide with the wishlist events Android *does* send from there.
      await h.analytics.logSearchClicked(
        source: const SourcePage(
          fromScreen: FromScreens.searchBoutique,
          fromLocation: FromLocations.searchIcon,
        ),
      );

      final e = h.singleEvent(AnalyticsEvents.searchClicked);
      expect(e[AnalyticsProperties.fromScreen], 'Search Boutique');
      expect(e[AnalyticsProperties.fromLocation], 'Search icon');
    });

    test('the boutique search value is distinct from both screen names', () {
      // Guards the reason it exists — if it ever collapses onto either, the
      // surface becomes invisible in the funnel again.
      expect(FromScreens.searchBoutique, isNot(FromScreens.boutique));
      expect(FromScreens.searchBoutique, isNot(FromScreens.productListPage));
    });
  });

  // ─── logNotificationPermission ────────────────────────────────────

  group('logNotificationPermission', () {
    test('accepted → notification_permission_accepted', () async {
      await h.analytics.logNotificationPermission(
        accepted: true,
        plpType: PlpType.productListing,
      );

      expect(
        h.hasEvent(AnalyticsEvents.notificationPermissionAccepted),
        isTrue,
      );
      expect(
        h.hasEvent(AnalyticsEvents.notificationPermissionRejected),
        isFalse,
      );
    });

    test('rejected → notification_permission_rejected', () async {
      await h.analytics.logNotificationPermission(
        accepted: false,
        plpType: PlpType.productListing,
      );

      expect(
        h.hasEvent(AnalyticsEvents.notificationPermissionRejected),
        isTrue,
      );
    });

    test(
      'empty plp_type still ships the key (raw put, matches Android :552)',
      () async {
        await h.analytics.logNotificationPermission(
          accepted: true,
          plpType: '',
        );

        final e = h.singleEvent(AnalyticsEvents.notificationPermissionAccepted);
        expect(
          e.containsKey(AnalyticsProperties.fromScreen),
          isTrue,
          reason: 'Android :552 uses raw put; empty must NOT be dropped',
        );
        expect(e[AnalyticsProperties.fromScreen], '');
      },
    );
  });

  // ─── logPlpScrolled ───────────────────────────────────────────────

  group('logPlpScrolled', () {
    test(
      'spreads scroll depth + page blob + viewed-range lists, NO timestamp',
      () async {
        // Use non-zero fromRow — putAnalyticsKey drops numbers <= 0, so a
        // fromRow of 0 legitimately vanishes from the wire (Android parity).
        final scrollDepth = <String, Object?>{
          AnalyticsProperties.fromRow: 3,
          AnalyticsProperties.scrolledRow: 8,
          AnalyticsProperties.scrolledHeight: 1200,
        };

        await h.analytics.logPlpScrolled(
          scrollDepthParams: scrollDepth,
          trackingMeta: fixture.plpAnalyticsMeta,
          screenHeight: 2400,
          totalRows: 1792,
          brand: const ['Buddsbuddy', 'Himalaya'],
          productIds: const ['939690', '939592'],
          category: const ['Baby Care'],
          subCategory: const ['Bottles & Accessories'],
          productType: const ['Feeding Bottles'],
          merchType: const ['normal'],
        );

        final e = h.singleEvent(AnalyticsEvents.plpScrolled);
        expect(e[AnalyticsProperties.fromRow], 3);
        expect(e[AnalyticsProperties.scrolledRow], 8);
        expect(e[AnalyticsProperties.scrolledHeight], 1200);
        expect(e[AnalyticsProperties.screenHeight], 2400);
        expect(e[AnalyticsProperties.totalRows], 1792);
        expect(e[AnalyticsProperties.brand], ['Buddsbuddy', 'Himalaya']);
        expect(e[AnalyticsProperties.productId], ['939690', '939592']);
        expect(e[AnalyticsProperties.category], ['Baby Care']);
        expect(e[AnalyticsProperties.subCategory], ['Bottles & Accessories']);
        expect(e[AnalyticsProperties.productType], ['Feeding Bottles']);
        // Page blob spread through the same builder.
        expect(e[AnalyticsProperties.plpType], PlpType.productListing);
        expect(e['plp'], 'P12038');
        // logScrollEvent path — NO timestamp (Android's scroll contract).
        expect(e.containsKey(AnalyticsProperties.timestamp), isFalse);
      },
    );

    test('empty range lists dropped by putAnalyticsKey', () async {
      await h.analytics.logPlpScrolled(
        scrollDepthParams: const <String, Object?>{
          AnalyticsProperties.scrolledRow: 4,
        },
        // Deliberately omit the page blob so `product_id` from the backend
        // fixture doesn't mask the drop assertion — the backend blob ships
        // product_id and would falsely satisfy the containsKey check.
        brand: const [],
        productIds: const [],
      );

      final e = h.singleEvent(AnalyticsEvents.plpScrolled);
      expect(e.containsKey(AnalyticsProperties.brand), isFalse);
      expect(e.containsKey(AnalyticsProperties.productId), isFalse);
    });
  });

  // ─── logPlpTileClicked — no event, pushes to product-attribution stack ──

  group('logPlpTileClicked', () {
    test('with an active PLP scope, top-of-stack becomes segmentParams', () {
      // Simulate the observer opening a PLP scope (didPush('plp')).
      h.productAttribution.beginPlpScope();

      h.analytics.logPlpTileClicked(
        trackingMeta: fixture.recordTrackingMeta(0),
        pageMeta: fixture.plpAnalyticsMeta,
      );

      final top = h.productAttribution.segmentParams;
      // Product wins on collision — position is only on the record blob.
      expect(top[AnalyticsProperties.position], 1);
      // Page keys are present, spread from pageMeta.
      expect(top['plp'], 'P12038');
      expect(top[AnalyticsProperties.plpType], PlpType.productListing);
      // No event fired.
      expect(h.captured, isEmpty);
    });

    test('no active scope → push no-ops (Discover home-grid case)', () {
      h.analytics.logPlpTileClicked(
        trackingMeta: fixture.recordTrackingMeta(0),
        pageMeta: fixture.plpAnalyticsMeta,
      );

      expect(h.productAttribution.entries, isEmpty);
    });

    test('empty merged blob → no push', () {
      h.productAttribution.beginPlpScope();

      h.analytics.logPlpTileClicked();

      expect(h.productAttribution.entries, isEmpty);
    });

    test(
      'endPlpScope drops every entry pushed inside — Android LP-visit parity',
      () {
        h.productAttribution.beginPlpScope();
        h.analytics.logPlpTileClicked(
          trackingMeta: fixture.recordTrackingMeta(0),
          pageMeta: fixture.plpAnalyticsMeta,
        );
        h.analytics.logPlpTileClicked(
          trackingMeta: fixture.recordTrackingMeta(1),
          pageMeta: fixture.plpAnalyticsMeta,
        );
        expect(h.productAttribution.entries.length, 2);

        h.productAttribution.endPlpScope();
        expect(h.productAttribution.entries, isEmpty);
      },
    );
  });

  // ─── Attribution merge — every PLP event carries productAttribution top ──

  group('productAttribution.segmentParams on downstream events', () {
    test(
      'top of stack flows into logFilterClicked payload after a tile push',
      () async {
        h.productAttribution.beginPlpScope();
        h.analytics.logPlpTileClicked(
          trackingMeta: fixture.recordTrackingMeta(1),
          pageMeta: fixture.plpAnalyticsMeta,
        );

        await h.analytics.logFilterClicked(
          trackingMeta: fixture.plpAnalyticsMeta,
          clickSource: FilterClickSource.standardFilter,
        );

        final e = h.singleEvent(AnalyticsEvents.filterClicked);
        // Position from the click's per-record trackingMeta — proves the top
        // entry got spread onto a subsequent event via _commonEventProperties.
        expect(e[AnalyticsProperties.position], 2);
      },
    );
  });
}
