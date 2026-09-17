import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_defaults.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_events.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_properties.dart';
import 'package:hs_app_flutter/features/pdp/data/models/product_detail_model.dart';
import 'package:hs_app_flutter/features/pdp/domain/entities/pdp_entry_args.dart';
import 'package:hs_app_flutter/features/pdp/domain/entities/pincode_check_entity.dart';
import 'package:hs_app_flutter/features/pdp/domain/entities/product_detail_entity.dart';
import 'package:hs_app_flutter/features/pdp/domain/entities/sku_entity.dart';
import 'package:hs_app_flutter/core/analytics/pdp/pdp_analytics_tracker.dart';
import 'package:hs_app_flutter/features/plp/domain/entities/listing_product_entity.dart';

import '../../support/analytics_test_harness.dart';
import 'package:hs_app_flutter/features/pdp/domain/entities/tile_entity.dart';
import 'package:hs_app_flutter/features/pdp/domain/entities/color_variants_entity.dart';
import 'package:hs_app_flutter/features/pdp/domain/entities/detail_entity.dart';
import '../support/node_fixtures.dart';

/// Tests the **suppression logic** — the reason this class exists.
///
/// The event payloads themselves are covered by `pdp_events_test.dart`; here we
/// only care about *whether* an event fires and *how many times*. Every guard
/// mirrors a specific Android behaviour, cited inline.
ProductDetailEntity _fixture(String name) {
  final raw = File('test/analytics/fixtures/$name').readAsStringSync();
  return ProductDetailModel.fromJson(jsonDecode(raw) as Map<String, dynamic>).toEntity();
}

void main() {
  late AnalyticsTestHarness h;
  late PdpAnalyticsTracker tracker;
  late ProductDetailEntity detail;

  setUp(() async {
    h = await AnalyticsTestHarness.build();
    tracker = PdpAnalyticsTracker(h.analytics);
    detail = _fixture('pdp_product_945499.json');
  });
  tearDown(() => h.tearDown());

  /// Loads the product and clears the resulting `product_viewed` so each test
  /// starts from a clean capture buffer.
  void loadProduct() {
    tracker.onProductLoaded(detail);
    h.clear();
  }

  group('lifecycle', () {
    test('onProductLoaded fires product_viewed once', () {
      tracker.onProductLoaded(detail);
      expect(h.eventsNamed(AnalyticsEvents.productViewed), hasLength(1));
    });

    test('no event fires before a product is loaded', () {
      tracker
        ..onShareTapped()
        ..onSizeChartOpened()
        ..onBuyNowTapped();
      expect(h.captured, isEmpty);
    });

    test('entry args survive a PID refresh', () {
      tracker.setEntryArgs(
        const PdpEntryArgs(fromScreen: FromScreens.plp, fromFeedSize: 40),
      );
      loadProduct();
      tracker.onPidRefreshed();
      tracker.onProductLoaded(detail);

      final e = h.singleEvent(AnalyticsEvents.productViewed);
      // The funnel that brought the user in still applies to the new PID.
      expect(e[AnalyticsProperties.fromScreen], FromScreens.plp);
      expect(e[AnalyticsProperties.fromFeedSize], 40);
    });
  });

  group('size_selected — change guard', () {
    test('first selection fires', () {
      loadProduct();
      tracker.onSizeSelected(
        sku: detail.product!.skus[0],
        fromLocation: FromLocations.sizeListUpfront,
      );
      expect(h.eventsNamed(AnalyticsEvents.sizeSelected), hasLength(1));
    });

    test('re-tapping the SAME size fires nothing', () {
      loadProduct();
      final sku = detail.product!.skus[0];
      tracker
        ..onSizeSelected(sku: sku, fromLocation: FromLocations.sizeListUpfront)
        ..onSizeSelected(sku: sku, fromLocation: FromLocations.sizeListUpfront)
        ..onSizeSelected(sku: sku, fromLocation: FromLocations.sizeListUpfront);
      expect(h.eventsNamed(AnalyticsEvents.sizeSelected), hasLength(1));
    });

    test('switching to a different size fires again', () {
      loadProduct();
      tracker
        ..onSizeSelected(sku: detail.product!.skus[0], fromLocation: FromLocations.sizeListUpfront)
        ..onSizeSelected(sku: detail.product!.skus[1], fromLocation: FromLocations.sizeListUpfront);
      expect(h.eventsNamed(AnalyticsEvents.sizeSelected), hasLength(2));
    });

    test('PID refresh clears the guard, so the same size fires again', () {
      loadProduct();
      final sku = detail.product!.skus[0];
      tracker.onSizeSelected(sku: sku, fromLocation: FromLocations.sizeListUpfront);
      tracker.onPidRefreshed();
      loadProduct();
      tracker.onSizeSelected(sku: sku, fromLocation: FromLocations.sizeListUpfront);
      expect(h.eventsNamed(AnalyticsEvents.sizeSelected), hasLength(1));
    });
  });

  group('reco_viewed — once per SCREEN, not per PID', () {
    test('fires once per screen', () {
      loadProduct();
      tracker
        ..onContentScrolled(down: true)
        ..onRecoRailVisible(const {'feed_size': 10})
        ..onRecoRailVisible(const {'feed_size': 10});
      expect(h.eventsNamed(AnalyticsEvents.recoViewed), hasLength(1));
    });

    test('does not fire when the rail arrives on an upward scroll', () {
      // Android returns early unless the scroll was downward
      // (`AnalyticsScrollHandler.kt:28` — `if (!scrolledDown) return`).
      loadProduct();
      tracker
        ..onContentScrolled(down: false)
        ..onRecoRailVisible(const {'feed_size': 10});
      expect(h.eventsNamed(AnalyticsEvents.recoViewed), isEmpty);
    });

    test('does not fire before any scroll has happened', () {
      // Android's handler only runs from a scroll callback, so a rail that is
      // somehow on screen without a scroll cannot fire there either.
      loadProduct();
      tracker.onRecoRailVisible(const {'feed_size': 10});
      expect(h.eventsNamed(AnalyticsEvents.recoViewed), isEmpty);
    });

    test('an upward scroll after a downward one does not re-open the gate', () {
      loadProduct();
      tracker
        ..onContentScrolled(down: true)
        ..onRecoRailVisible(const {'feed_size': 10})
        ..onContentScrolled(down: false)
        ..onRecoRailVisible(const {'feed_size': 10});
      expect(h.eventsNamed(AnalyticsEvents.recoViewed), hasLength(1));
    });

    test('does NOT fire again after a PID refresh', () {
      // Android's flag lives on the scroll handler, which refreshPID doesn't
      // touch — unlike the colour-widget flag above.
      //
      // The downward scroll matters: without it the second call would be
      // suppressed by the direction gate, and this would pass without proving
      // anything about the latch.
      loadProduct();
      tracker
        ..onContentScrolled(down: true)
        ..onRecoRailVisible(const {'feed_size': 10});
      expect(h.eventsNamed(AnalyticsEvents.recoViewed), hasLength(1));

      tracker.onPidRefreshed();
      loadProduct();
      tracker
        ..onContentScrolled(down: true)
        ..onRecoRailVisible(const {'feed_size': 10});
      expect(h.eventsNamed(AnalyticsEvents.recoViewed), isEmpty);
    });
  });

  group('pdp_images_scrolled', () {
    test('no swipe ⇒ no event', () {
      loadProduct();
      tracker.flushImagesScrolled();
      expect(h.hasEvent(AnalyticsEvents.pdpImagesScrolled), isFalse);
    });

    test('two settled pages ⇒ reports 3 (initial image added back)', () {
      loadProduct();
      tracker
        ..onImagePageSettled(1)
        ..onImagePageSettled(2)
        ..flushImagesScrolled();
      expect(
        h.singleEvent(AnalyticsEvents.pdpImagesScrolled)[AnalyticsProperties.uniqueImagesScrolled],
        3,
      );
    });

    test('revisiting a page does not inflate the count', () {
      loadProduct();
      tracker
        ..onImagePageSettled(1)
        ..onImagePageSettled(1)
        ..onImagePageSettled(1)
        ..flushImagesScrolled();
      expect(
        h.singleEvent(AnalyticsEvents.pdpImagesScrolled)[AnalyticsProperties.uniqueImagesScrolled],
        2,
      );
    });

    test('flushing twice with no new swipes emits once (high-water)', () {
      loadProduct();
      tracker
        ..onImagePageSettled(1)
        ..flushImagesScrolled()
        ..flushImagesScrolled()
        ..flushImagesScrolled();
      expect(h.eventsNamed(AnalyticsEvents.pdpImagesScrolled), hasLength(1));
    });

    test('a further swipe after a flush emits again with the higher count', () {
      loadProduct();
      tracker
        ..onImagePageSettled(1)
        ..flushImagesScrolled()
        ..onImagePageSettled(2)
        ..flushImagesScrolled();
      final counts = h
          .eventsNamed(AnalyticsEvents.pdpImagesScrolled)
          .map((e) => e[AnalyticsProperties.uniqueImagesScrolled])
          .toList();
      expect(counts, [2, 3]);
    });

    test('PID refresh resets the page set and the high-water mark', () {
      loadProduct();
      tracker
        ..onImagePageSettled(1)
        ..onImagePageSettled(2)
        ..flushImagesScrolled();
      h.clear();

      tracker.onPidRefreshed();
      loadProduct();
      tracker
        ..onImagePageSettled(1)
        ..flushImagesScrolled();
      // High-water back to 1, so a count of 2 still qualifies.
      expect(
        h.singleEvent(AnalyticsEvents.pdpImagesScrolled)[AnalyticsProperties.uniqueImagesScrolled],
        2,
      );
    });
  });

  group('recently viewed — visibility-gated load, exit-flushed scroll', () {
    test('loaded fires once per PID, only when the rail is visible', () {
      loadProduct();
      tracker
        ..onRecentlyViewedRailVisible(const {'feed_size': 6})
        ..onRecentlyViewedRailVisible(const {'feed_size': 6})
        ..onRecentlyViewedRailVisible(const {'feed_size': 6});
      expect(h.eventsNamed(AnalyticsEvents.recentlyViewedProductsLoaded), hasLength(1));
    });

    test('loaded skips a rail the backend sent no node for', () {
      // Android gated on a client-computed `feedSize > 0`. The client cannot read
      // feed_size any more, so the equivalent gate is the node itself: no rail
      // block means no rail. A node saying `feed_size: 0` would still fire — BE
      // does not render an empty rail, and the widget reports only when visible.
      loadProduct();
      tracker.onRecentlyViewedRailVisible(null);
      expect(h.hasEvent(AnalyticsEvents.recentlyViewedProductsLoaded), isFalse);
    });

    test('loaded fires again after a PID refresh', () {
      loadProduct();
      tracker.onRecentlyViewedRailVisible(const {'feed_size': 6});
      tracker.onPidRefreshed();
      loadProduct();
      tracker.onRecentlyViewedRailVisible(const {'feed_size': 6});
      expect(h.eventsNamed(AnalyticsEvents.recentlyViewedProductsLoaded), hasLength(1));
    });

    test('scrolled reports NOTHING during scrolling — only on flush', () {
      // Android reads `lastImagePositionAfterScroll` from a lifecycle onStop,
      // so nothing is emitted while the user is scrolling.
      loadProduct();
      tracker
        ..onRecentlyViewedRailVisible(const {'feed_size': 6})
        ..onRecentlyViewedSettled(1)
        ..onRecentlyViewedSettled(2)
        ..onRecentlyViewedSettled(3);
      expect(h.hasEvent(AnalyticsEvents.recentlyViewedProductsScrolled), isFalse);
    });

    test('flush reports position + 1 (the carousel getter, §CarouselView:50)', () {
      loadProduct();
      tracker
        ..onRecentlyViewedRailVisible(const {'feed_size': 6})
        ..onRecentlyViewedSettled(3)
        ..flushRecentlyViewedScrolled();
      final e = h.singleEvent(AnalyticsEvents.recentlyViewedProductsScrolled);
      expect(e[AnalyticsProperties.scrollDepth], 4);
      expect(e[AnalyticsProperties.feedSize], 6);
    });

    test('position is monotonic — scrolling back does not lower it', () {
      loadProduct();
      tracker
        ..onRecentlyViewedRailVisible(const {'feed_size': 6})
        ..onRecentlyViewedSettled(4)
        ..onRecentlyViewedSettled(1)
        ..onRecentlyViewedSettled(0)
        ..flushRecentlyViewedScrolled();
      expect(
        h.singleEvent(
          AnalyticsEvents.recentlyViewedProductsScrolled,
        )[AnalyticsProperties.scrollDepth],
        5,
      );
    });

    test('never scrolled ⇒ position 0 ⇒ no event (the != 0 branch)', () {
      // `get() = if (field != 0) field + 1 else field` yields 0, which then
      // fails the `scrollDepth > 0` guard.
      loadProduct();
      tracker
        ..onRecentlyViewedRailVisible(const {'feed_size': 6})
        ..flushRecentlyViewedScrolled();
      expect(h.hasEvent(AnalyticsEvents.recentlyViewedProductsScrolled), isFalse);
    });

    test('flushing twice at the same depth emits once', () {
      // The guard is `depth > highWater`, so a second flush that reports no
      // deeper scroll is suppressed — Android's `recentlyViewedMaxScrollCount`
      // does the same.
      loadProduct();
      tracker
        ..onRecentlyViewedRailVisible(const {'feed_size': 6})
        ..onRecentlyViewedSettled(2)
        ..flushRecentlyViewedScrolled()
        ..flushRecentlyViewedScrolled();
      expect(h.eventsNamed(AnalyticsEvents.recentlyViewedProductsScrolled), hasLength(1));
    });

    test('a deeper scroll after a flush emits again', () {
      // `scrollDepth > recentlyViewedMaxScrollCount` (`PDPAnalytics.kt:372`).
      // Background at depth 2, return, scroll to 7, pop: Android sends both.
      loadProduct();
      tracker
        ..onRecentlyViewedRailVisible(const {'feed_size': 20})
        ..onRecentlyViewedSettled(1)
        ..flushRecentlyViewedScrolled() // app paused
        ..onRecentlyViewedSettled(6)
        ..flushRecentlyViewedScrolled(); // route pop
      expect(
        h
            .eventsNamed(AnalyticsEvents.recentlyViewedProductsScrolled)
            .map((e) => e[AnalyticsProperties.scrollDepth])
            .toList(),
        [2, 7],
      );
    });

    test('the high-water mark resets on a PID refresh', () {
      // `refreshPID` zeroes `recentlyViewedMaxScrollCount` (`:109`), so the new
      // product reports its own depth from scratch.
      loadProduct();
      tracker
        ..onRecentlyViewedRailVisible(const {'feed_size': 20})
        ..onRecentlyViewedSettled(6)
        ..flushRecentlyViewedScrolled()
        // Not `loadProduct()` — that clears the harness, taking the first
        // flush's event with it.
        ..onPidRefreshed()
        ..onProductLoaded(detail)
        ..onRecentlyViewedRailVisible(const {'feed_size': 20})
        ..onRecentlyViewedSettled(1)
        ..flushRecentlyViewedScrolled();
      expect(
        h
            .eventsNamed(AnalyticsEvents.recentlyViewedProductsScrolled)
            .map((e) => e[AnalyticsProperties.scrollDepth])
            .toList(),
        [7, 2],
      );
    });

    test('a never-visible rail reports no scroll either', () {
      // feedSize is only known once the rail reports visible, so a user who
      // never reached it produces neither event.
      loadProduct();
      tracker
        ..onRecentlyViewedSettled(3)
        ..flushRecentlyViewedScrolled();
      expect(h.captured, isEmpty);
    });
  });

  group('pincode', () {
    test('serviceable true ⇒ success', () {
      loadProduct();
      tracker.onPincodeVerified(const PincodeCheckEntity(isServiceable: true));
      expect(
        h.singleEvent(AnalyticsEvents.pincodeChange)[AnalyticsProperties.pincodeCheckStatus],
        AnalyticsDefaults.success,
      );
    });

    test('serviceable false ⇒ failure', () {
      loadProduct();
      tracker.onPincodeVerified(const PincodeCheckEntity(isServiceable: false));
      expect(
        h.singleEvent(AnalyticsEvents.pincodeChange)[AnalyticsProperties.pincodeCheckStatus],
        AnalyticsDefaults.failure,
      );
    });

    test('serviceable NULL ⇒ no event at all', () {
      // Android's `isServiceable?.let { … }` skips entirely. A `?? false` here
      // would invent events Android never sends.
      loadProduct();
      tracker.onPincodeVerified(const PincodeCheckEntity(action: 'success', message: 'ok'));
      expect(h.hasEvent(AnalyticsEvents.pincodeChange), isFalse);
    });

    test('`action` does not drive the status — only isServiceable does', () {
      loadProduct();
      // action says success, the business fact says otherwise.
      tracker.onPincodeVerified(const PincodeCheckEntity(action: 'success', isServiceable: false));
      expect(
        h.singleEvent(AnalyticsEvents.pincodeChange)[AnalyticsProperties.pincodeCheckStatus],
        AnalyticsDefaults.failure,
      );
    });

    test('transport failure reports failure', () {
      loadProduct();
      tracker.onPincodeVerifyFailed();
      expect(
        h.singleEvent(AnalyticsEvents.pincodeChange)[AnalyticsProperties.pincodeCheckStatus],
        AnalyticsDefaults.failure,
      );
    });
  });

  group('detail tabs — event ordering', () {
    test('expanding fires expanded THEN tab_clicked, in that order', () async {
      loadProduct();
      await tracker.onDetailTabToggled(
        tabIndex: 0,
        tab: const DetailEntity(
          tabName: 'Specification',
          trackingMeta: {'tab_name': 'Specification'},
        ),
      );
      expect(h.captured.map((e) => e.name).toList(), [
        AnalyticsEvents.productDetailsExpanded,
        AnalyticsEvents.productDetailsTabClicked,
      ]);
    });

    test('switching tabs while open fires only tab_clicked', () async {
      loadProduct();
      await tracker.onDetailTabToggled(
        tabIndex: 0,
        tab: const DetailEntity(
          tabName: 'Specification',
          trackingMeta: {'tab_name': 'Specification'},
        ),
      );
      h.clear();
      await tracker.onDetailTabToggled(
        tabIndex: 1,
        tab: const DetailEntity(tabName: 'Description', trackingMeta: {'tab_name': 'Description'}),
      );
      expect(h.captured.map((e) => e.name).toList(), [AnalyticsEvents.productDetailsTabClicked]);
      expect(
        h.singleEvent(AnalyticsEvents.productDetailsTabClicked)[AnalyticsProperties.tabName],
        'Description',
      );
    });

    test('collapsing fires only collapsed', () async {
      loadProduct();
      await tracker.onDetailTabToggled(
        tabIndex: 0,
        tab: const DetailEntity(
          tabName: 'Specification',
          trackingMeta: {'tab_name': 'Specification'},
        ),
      );
      h.clear();
      await tracker.onDetailTabToggled(tabIndex: -1, tab: null);
      expect(h.captured.map((e) => e.name).toList(), [AnalyticsEvents.productDetailsCollapsed]);
    });
  });

  group('wishlist', () {
    test('add and removal are separate events, each fired once', () {
      // The old API took `isWishlisted` and swallowed the false case. Removal is a
      // real event now — Android's old PDP emits it too
      // (ProductDetailPageActivityNew.java:4966).
      loadProduct();
      tracker
        ..onWishlistAdded()
        ..onWishlistRemoved();
      expect(h.eventsNamed(AnalyticsEvents.productAddedToWishlist), hasLength(1));
      expect(h.eventsNamed(AnalyticsEvents.productRemovedFromWishlist), hasLength(1));
    });

    test('carries the attribution PDP alone used to omit', () {
      loadProduct();
      tracker.onWishlistAdded();
      final e = h.singleEvent(AnalyticsEvents.productAddedToWishlist);
      expect(e[AnalyticsProperties.fromScreen], FromScreens.product);
      expect(e[AnalyticsProperties.fromLocation], FromLocations.wishlistButton);
    });

    test('reports the selected sku passed in, not the size-guard field', () {
      // `_currentSku` only tracks size CHANGES, so it is null for a user who
      // wishlists without touching the selector. The call site owns the value.
      //
      // The id comes from the SKU's own trackingMeta block, not its `skuId` field —
      // trackingMeta is the only source the analytics layer reads.
      loadProduct();
      tracker.onWishlistAdded(
        selectedSku: const SkuEntity(skuId: 'WHA-1', trackingMeta: {'sku': 'WHA-1'}),
      );
      expect(
        h.singleEvent(AnalyticsEvents.productAddedToWishlist)[AnalyticsProperties.sku],
        'WHA-1',
      );
    });
  });

  group('colour variant switch', () {
    // The flag is no longer the client's to decide. `colorVariant=true` goes on
    // the PDP request and the response answers in `product.orderAttribution`, so
    // these tests drive it by loading a response that says "Yes" — which is what
    // the app receives after a swatch tap — rather than by setting a boolean.
    //
    // What the client still owns is the request: `_onSelectColorVariant` dispatches
    // `loadProductDetails(colorVariant: true)`, covered in the bloc.
    ProductDetailEntity withJourney(String value) => detail.copyWith(
      product: detail.product!.copyWith(orderAttribution: {'redirected_from_colour_widget': value}),
    );

    test('a directly-opened PID reports "No"', () {
      tracker.onProductLoaded(withJourney(AnalyticsDefaults.no));
      expect(
        h.singleEvent(AnalyticsEvents.productViewed)[AnalyticsProperties.redirectedFromColorWidget],
        AnalyticsDefaults.no,
      );
    });

    test('a PID a swatch led to reports "Yes" on product_viewed', () {
      tracker.onProductLoaded(withJourney(AnalyticsDefaults.yes));
      expect(
        h.singleEvent(AnalyticsEvents.productViewed)[AnalyticsProperties.redirectedFromColorWidget],
        AnalyticsDefaults.yes,
      );
    });

    test('and on every later event, without any client state surviving', () {
      // The old design carried a boolean across onPidRefreshed. Nothing carries
      // now: the node came with the response, so a reload cannot lose it.
      tracker
        ..onProductLoaded(withJourney(AnalyticsDefaults.yes))
        ..onPidRefreshed()
        ..onProductLoaded(withJourney(AnalyticsDefaults.yes));
      h.clear();
      tracker
        ..onBuyNowTapped()
        ..onShareTapped();
      for (final name in [
        AnalyticsEvents.buyNowClickedAlt,
        AnalyticsEvents.productShareClicked,
      ]) {
        expect(
          h.singleEvent(name)[AnalyticsProperties.redirectedFromColorWidget],
          AnalyticsDefaults.yes,
          reason: '$name lost the journey node',
        );
      }
    });

    test('new_color_selected describes the OUTGOING product', () {
      // Still true, and now for free: the outgoing product's own response
      // answered "No", and the next request has not happened yet.
      tracker.onProductLoaded(withJourney(AnalyticsDefaults.no));
      h.clear();
      tracker.onColourVariantSelected(
        const ColorVariantEntity(
          productId: 906575,
          trackingMeta: {'new_product_id_selected': '906575'},
        ),
      );
      final e = h.singleEvent(AnalyticsEvents.newColorSelected);
      expect(e[AnalyticsProperties.productId], '945499');
      expect(e[AnalyticsProperties.newProductIdSelected], '906575');
      expect(e[AnalyticsProperties.redirectedFromColorWidget], AnalyticsDefaults.no);
    });
  });

  group('cart', () {
    test('buy_now fires on tap, independent of any add-to-cart result', () {
      loadProduct();
      tracker.onBuyNowTapped();
      expect(h.hasEvent(AnalyticsEvents.buyNowClickedAlt), isTrue);
      expect(h.hasEvent(AnalyticsEvents.productAddedToCart), isFalse);
    });

    test('added_to_cart falls back to the tracked SKU when none is passed', () {
      loadProduct();
      tracker
        ..onSizeSelected(sku: detail.product!.skus[1], fromLocation: FromLocations.addToCartButton)
        ..onAddedToCart(null);
      expect(
        h.singleEvent(AnalyticsEvents.productAddedToCart)[AnalyticsProperties.productSize],
        '4-5 Y',
      );
    });

    // `pdpAtcRequestParams` was retired: the ATC request body is now assembled
    // in the cart layer from the product's own trackingMeta plus the global
    // attribution stores. PDP no longer exposes a slice; anything the server
    // needs is forwarded via `product.trackingMeta` on `product_added_to_cart`.
  });

  group('reco / recently-viewed taps', () {
    const clicked = ListingProductEntity(id: 943726, name: 'Some product');

    test('both tap handlers fire their event', () {
      loadProduct();
      tracker
        ..onRecoTileTapped(TileEntity(product: clicked, trackingMeta: tileClickMeta(clicked)))
        ..onRecentlyViewedTileTapped(
          TileEntity(product: clicked, trackingMeta: tileClickMeta(clicked)),
        );
      expect(h.hasEvent(AnalyticsEvents.recoProductClicked), isTrue);
      expect(h.hasEvent(AnalyticsEvents.recentlyViewedProductsClicked), isTrue);
    });
  });
}
