import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_defaults.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_events.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_properties.dart';
import 'package:hs_app_flutter/core/analytics/events/modules/cart_events.dart';
import 'package:hs_app_flutter/core/analytics/events/modules/wishlist_events.dart';
import 'package:hs_app_flutter/features/cart/data/models/promotion_data_model.dart';
import 'package:hs_app_flutter/features/cart/domain/entities/promotion_data_entity.dart';

import '../support/analytics_test_harness.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ⚠️ PARTIALLY RECONSTRUCTED — 2026-09-17
//
// The original file was destroyed by a bad scripted edit and was untracked, so
// there was nothing to restore from. What follows is only the portion that
// could be recovered verbatim from the session that read it. It compiles and
// passes, but it is NOT the original: roughly half the file is missing and the
// coverage below is thinner than what shipped before.
//
// Recovered: the fixtures, the promo-event group, the attribution-key sweep,
// and the from_location constants.
//
// KNOWN LOST — restore from a colleague's checkout or rewrite:
//   * the `cartViewed()` helper and the `cart_viewed` group around it,
//     including the `first_load` flips-exactly-once tests
//   * `from_location values match Android verbatim` →
//     `a quantity step reports Update cart on both its events`
//   * `product_update_clicked reports intent from the item block`
//   * `shipping_info_viewed names the affordance that was opened`
//   * the tail of `no backend field name reaches the wire`
//   * `the rest of the funnel is kept`
// ─────────────────────────────────────────────────────────────────────────────

/// The cart events forward the backend's `trackingMeta` blocks and add only the
/// facts the server cannot see.
///
/// **This file imports no cart entities**, which is the point: the events take
/// `Map`s, so there is no per-surface mapper to get wrong. What is left to pin
/// is that the blocks arrive unchanged, that client-owned keys cannot be
/// overwritten from the server, and that attribution reaches the wire.
void main() {
  late AnalyticsTestHarness h;

  setUp(() async {
    h = await AnalyticsTestHarness.build();
  });
  tearDown(() => h.tearDown());

  /// The cart-level block, copied from the `GET /shopping-cart` sample the
  /// backend contract was written against. Real rather than invented: the
  /// list-valued `quantity_status` / `price_status` / `image_url` and the
  /// already-resolved `atc_user` are exactly what these assertions are about.
  const cartBlock = <String, dynamic>{
    'total_item_price': 748,
    'total_amount': 598,
    'shipping': 50,
    'net_amount': 662,
    'sku_count': 2,
    'total_quantity': 2,
    'message_bar': 'none',
    'cart_filler_reco': 'Yes',
    'quantity_status': ['Available', 'Available'],
    'price_status': ['Same', 'Same'],
    'image_url': ['https://q/a_medium.jpg', 'https://q/b_medium.jpg'],
    'shipping_minimum': 10000,
    'atc_user': 'GU',
  };

  /// An item's `wishlistInfo.trackingMeta` — the finished move-to-wishlist
  /// payload, merchandising attributes already resolved.
  const itemBlock = <String, dynamic>{
    'product_id': 950568,
    'sku': 'GBN-3068884',
    'discount_percentage': '20% off',
    'quantity': 1,
    'gender': "Girl's",
    'from_age': 48,
    'to_age': 60,
    'colour': 'Mint',
    'size': '4-5 years',
    'price': 199,
    'mrp': 249,
    'brand': 'Game Begins',
    'name': 'Mint Sleeveless Floral With Text Printed Dress',
    'image_url': 'https://q/b_medium.jpg',
    'preorder': 'No',
    'sale': 'No',
    'atc_user': 'RB',
    'taste': 'none',
    'merch_type': 'Catalog',
  };

  group('cart_viewed forwards the block and adds the client facts', () {
    test('every trackingMeta key reaches the wire under its own name', () async {
      await h.analytics.logCartViewed(
        fromScreen: AnalyticsDefaults.productDetails,
        fromLocation: FromLocations.cartIconButton,
        cartViewState: CartViewStates.cartLoad,
        isFirstLoad: true,
        trackingMeta: cartBlock,
      );
      final e = h.singleEvent(AnalyticsEvents.cartViewed);
      for (final entry in cartBlock.entries) {
        expect(e[entry.key], entry.value, reason: '`${entry.key}` did not survive');
      }
    });

    test('the client facts the server cannot know', () async {
      await h.analytics.logCartViewed(
        fromScreen: AnalyticsDefaults.productDetails,
        fromLocation: FromLocations.cartIconButton,
        cartViewState: CartViewStates.cartLoad,
        isFirstLoad: true,
        tti: 1200,
        trackingMeta: cartBlock,
      );
      final e = h.singleEvent(AnalyticsEvents.cartViewed);
      expect(e[AnalyticsProperties.fromScreen], AnalyticsDefaults.productDetails);
      expect(e[AnalyticsProperties.fromLocation], FromLocations.cartIconButton);
      expect(e[AnalyticsProperties.cartViewState], CartViewStates.cartLoad);
      expect(e[AnalyticsProperties.tti], 1200);
      expect(e[AnalyticsProperties.firstLoad], AnalyticsDefaults.yes);
    });

    test('first_load is written raw, so No is never dropped', () async {
      // A Yes/No dimension where "No" is the meaningful majority case — it must
      // reach the wire rather than being filtered as a falsy value.
      await h.analytics.logCartViewed(
        fromScreen: AnalyticsDefaults.productDetails,
        fromLocation: FromLocations.cartIconButton,
        cartViewState: CartViewStates.cartReload,
        isFirstLoad: false,
        trackingMeta: cartBlock,
      );
      final e = h.singleEvent(AnalyticsEvents.cartViewed);
      expect(e[AnalyticsProperties.firstLoad], AnalyticsDefaults.no);
    });

    test('an empty cart sends only the client keys', () async {
      // The backend sends no trackingMeta for an empty bag, so that shape falls
      // out of the passthrough rather than needing a branch.
      await h.analytics.logCartViewed(
        fromScreen: AnalyticsDefaults.productDetails,
        fromLocation: FromLocations.cartIconButton,
        cartViewState: CartViewStates.cartLoad,
        isFirstLoad: false,
      );
      final e = h.singleEvent(AnalyticsEvents.cartViewed);
      expect(e[AnalyticsProperties.fromScreen], AnalyticsDefaults.productDetails);
      expect(e.containsKey('total_item_price'), isFalse);
      expect(e.containsKey('sku_count'), isFalse);
    });

    test('a server key cannot overwrite a client-owned one', () async {
      // The caller's map is merged after the server node, so `from_screen`
      // stays the app's.
      await h.analytics.logCartViewed(
        fromScreen: AnalyticsDefaults.productDetails,
        fromLocation: FromLocations.cartIconButton,
        cartViewState: CartViewStates.cartLoad,
        isFirstLoad: false,
        trackingMeta: {...cartBlock, AnalyticsProperties.fromScreen: 'HIJACKED'},
      );
      final e = h.singleEvent(AnalyticsEvents.cartViewed);
      expect(e[AnalyticsProperties.fromScreen], AnalyticsDefaults.productDetails);
    });
  });

  group('product_added_to_wishlist, cart variant', () {
    test('forwards the item block and stamps the cart-level promo context', () async {
      await h.analytics.logProductMovedToWishlistFromCart(
        trackingMeta: itemBlock,
        promoCodes: const ['TESTP5'],
        promoAppliedCount: 1,
      );
      final e = h.singleEvent(AnalyticsEvents.productAddedToWishlist);
      for (final entry in itemBlock.entries) {
        expect(e[entry.key], entry.value, reason: '`${entry.key}` did not survive');
      }
      expect(e[AnalyticsProperties.fromScreen], FromScreens.shoppingCart);
      expect(e[AnalyticsProperties.fromLocation], FromLocations.moveToWishlist);
      // Plural here, against the singular `promo_code` the promo events send
      // for the same array — Android's naming, preserved.
      expect(e[AnalyticsProperties.promoCodes], ['TESTP5']);
      expect(e[AnalyticsProperties.promoAppliedCount], 1);
    });

    test('a cart with no promo still reports the count as 0', () async {
      await h.analytics.logProductMovedToWishlistFromCart(trackingMeta: itemBlock);
      final e = h.singleEvent(AnalyticsEvents.productAddedToWishlist);
      expect(e[AnalyticsProperties.promoAppliedCount], 0);
    });
  });

  group('attribution keys reach every cart payload', () {
    // These four used to be stripped from cart events via `logEvent`'s
    // `excludeKeys`. Android strips nothing — `getOrderAttributionSegmentParams`
    // puts `funnel_row` whenever it is set and the two `redirected_from_*`
    // flags unconditionally, on every event with `isAttributionDataRequired`,
    // cart events included. `redirected_from_tab_page` comes from
    // `TabPageAttributionHelper` the same way.
    //
    // Asserted over EVERY cart event, so a reintroduced filter fails here.
    const attributionKeys = <String>[
      'funnel_row',
      'redirected_from_tab_page',
      'redirected_from_cluster_eligible_plp',
      'redirected_from_continue_browsing_widget',
    ];

    setUp(() {
      // Seed live attribution as a tile click on a PLP would leave it.
      h.orderAttribution.replaceTrackingMeta(const <String, dynamic>{
        'funnel_tile': 'CT1443',
        'funnel_row': 2,
        'redirected_from_tab_page': 'No',
        'redirected_from_cluster_eligible_plp': 'No',
        'redirected_from_continue_browsing_widget': 'No',
      });
    });

    /// The cart events that merge attribution (`attribution: true`).
    final withAttribution = <String, Future<void> Function()>{
      AnalyticsEvents.cartViewed: () => h.analytics.logCartViewed(
        fromScreen: AnalyticsDefaults.productDetails,
        fromLocation: FromLocations.cartIconButton,
        cartViewState: CartViewStates.cartLoad,
        isFirstLoad: true,
        trackingMeta: cartBlock,
      ),
      AnalyticsEvents.productAddedToWishlist: () =>
          h.analytics.logProductMovedToWishlistFromCart(trackingMeta: itemBlock),
      AnalyticsEvents.promoCodeApplied: () => h.analytics.logPromoCodeApplied(
        promo: const CartPromoPayload(promoCodes: ['TESTP5'], promoAppliedCount: 1),
      ),
      AnalyticsEvents.promoCodeRemoved: () => h.analytics.logPromoCodeRemoved(
        promo: const CartPromoPayload(),
        removedPromoCode: 'TESTP5',
      ),
      AnalyticsEvents.promoCodeFailed: () => h.analytics.logPromoCodeFailed(
        promo: const CartPromoPayload(),
        failedPromoCode: 'NOPE',
        promoError: 'Invalid',
      ),
    };

    /// The cart events Android fires with `isAttributionDataRequired = false`,
    /// which therefore merge no attribution at all.
    final withoutAttribution = <String, Future<void> Function()>{
      AnalyticsEvents.productUpdateClicked: () => h.analytics.logProductUpdateClicked(
        fromLocation: FromLocations.updateCart,
        sku: 'WHA-3053453',
      ),
      AnalyticsEvents.productUpdated: () => h.analytics.logProductUpdated(
        fromScreen: AnalyticsDefaults.productDetails,
        fromLocation: FromLocations.updateCart,
        sku: 'WHA-3053453',
        quantity: 1,
        newQuantity: 2,
      ),
      AnalyticsEvents.pincodeCheckClicked: () =>
          h.analytics.logPincodeCheckClicked(fromScreen: FromScreens.shoppingCart),
      AnalyticsEvents.pincodeChecked: () =>
          h.analytics.logPincodeChecked(fromScreen: FromScreens.shoppingCart, pincode: '560037'),
      AnalyticsEvents.shippingInfoViewed: () =>
          h.analytics.logShippingInfoViewed(fromLocation: FromLocations.orderSummary),
      AnalyticsEvents.platformFeeInfoViewed: () =>
          h.analytics.logPlatformFeeInfoViewed(fromLocation: FromLocations.orderSummary),
    };

    for (final entry in withAttribution.entries) {
      test('${entry.key} carries all four', () async {
        await entry.value();
        final e = h.singleEvent(entry.key);
        for (final key in attributionKeys) {
          expect(e.containsKey(key), isTrue, reason: '`$key` was stripped from ${entry.key}');
        }
      });
    }

    for (final entry in withoutAttribution.entries) {
      test('${entry.key} merges no attribution', () async {
        await entry.value();
        final e = h.singleEvent(entry.key);
        for (final key in attributionKeys) {
          expect(
            e.containsKey(key),
            isFalse,
            reason: '`$key` reached ${entry.key}, which sets attribution: false',
          );
        }
      });
    }

    test('a server block can still override one', () async {
      // The caller's map wins over attribution, so a backend `trackingMeta`
      // value reaches the wire rather than being dropped.
      await h.analytics.logCartViewed(
        fromScreen: AnalyticsDefaults.productDetails,
        fromLocation: FromLocations.cartIconButton,
        cartViewState: CartViewStates.cartLoad,
        isFirstLoad: true,
        trackingMeta: {...cartBlock, 'funnel_row': 7},
      );
      final e = h.singleEvent(AnalyticsEvents.cartViewed);
      expect(e['funnel_row'], 7);
    });

    test('non-cart surfaces carry them too', () async {
      // They were always sent here; the cart now matches.
      await h.analytics.logProductAddedToWishlist(
        productId: '904219',
        fromScreen: FromScreens.product,
        trackingMeta: const <String, dynamic>{'sku': 'FCA-2998686'},
      );
      final e = h.singleEvent(AnalyticsEvents.productAddedToWishlist);
      for (final key in attributionKeys) {
        expect(e.containsKey(key), isTrue, reason: '`$key` missing');
      }
    });

    test('the rest of the funnel is kept', () async {
      // `funnel_tile`, `section`, `plp` and the sort keys describe the journey
      // the cart was opened from.
      await h.analytics.logCartViewed(
        fromScreen: AnalyticsDefaults.productDetails,
        fromLocation: FromLocations.cartIconButton,
        cartViewState: CartViewStates.cartLoad,
        isFirstLoad: true,
        trackingMeta: cartBlock,
      );
      final e = h.singleEvent(AnalyticsEvents.cartViewed);
      expect(e['funnel_tile'], 'CT1443');
    });
  });

  group('promo events', () {
    /// One promo entry's analytics block, in the shape the backend sends.
    const block = <String, dynamic>{
      'code': 'TESTCART10',
      'discount': 60.0,
      'applied': true,
      'action': 'success',
      'isMerchRule': 'No',
      'autoApplied': false,
      'forceRemove': false,
      'merchRuleType': 'ORDER',
    };

    /// The cart the three events report against, matching the target payloads.
    PromotionDataEntity promotion({Map<String, dynamic>? promo = block}) =>
        PromotionDataModel.fromJson({
          'orderPromocodes': [
            if (promo != null) {'trackingMeta': promo},
          ],
        });

    CartPromoPayload payload({
      Map<String, dynamic>? promo = block,
      num? itemDiscount = 60.0,
      num? promotionDiscount = 60.0,
    }) {
      final data = promotion(promo: promo);
      return CartPromoPayload(
        totalItemPrice: 748,
        totalAmount: 598,
        fromShipping: 50,
        fromNetAmount: 602,
        itemDiscount: itemDiscount,
        promotionDiscount: promotionDiscount,
        merchPromo: data.isMerchPromoApplied,
        promoCodes: data.allPromoCodes,
        promoAppliedCount: data.promoAppliedCount,
      );
    }

    /// The eleven properties all three events share.
    void expectSharedBody(Map<String, Object?> e, {required int count}) {
      expect(e[AnalyticsProperties.fromScreen], FromScreens.shoppingCart);
      expect(e[AnalyticsProperties.totalItemPrice], 748);
      expect(e[AnalyticsProperties.totalAmount], 598);
      expect(e[AnalyticsProperties.fromShipping], 50);
      expect(e[AnalyticsProperties.fromNetAmount], 602);
      expect(e[AnalyticsProperties.itemDiscount], 60.0);
      expect(e[AnalyticsProperties.merchPromo], 'No');
      expect(e[AnalyticsProperties.promoAppliedCount], count);
    }

    test('applied matches the target payload', () async {
      await h.analytics.logPromoCodeApplied(promo: payload());
      final e = h.singleEvent(AnalyticsEvents.promoCodeApplied);
      expectSharedBody(e, count: 1);
      expect(e[AnalyticsProperties.promotionDiscount], 60.0);
      // Singular key, array value — Android's naming.
      expect(e[AnalyticsProperties.promoCode], ['TESTCART10']);
    });

    test('removed adds the code that is already gone from the list', () async {
      await h.analytics.logPromoCodeRemoved(promo: payload(), removedPromoCode: 'TESTCART10');
      final e = h.singleEvent(AnalyticsEvents.promoCodeRemoved);
      expectSharedBody(e, count: 1);
      expect(e[AnalyticsProperties.removedPromoCode], 'TESTCART10');
      expect(e[AnalyticsProperties.promotionDiscount], 60.0);
    });

    test('failed adds the rejected code and the reason', () async {
      // A rejection leaves the cart untouched, so the price context still
      // stands — and `item_discount` still reports the bag's own saving,
      // while `promotion_discount` is absent because none was applied now.
      await h.analytics.logPromoCodeFailed(
        promo: payload(promo: null, itemDiscount: 150.0, promotionDiscount: null),
        failedPromoCode: 'TESTCART10',
        promoError: 'Verify your mobile to avail promotion.',
      );
      final e = h.singleEvent(AnalyticsEvents.promoCodeFailed);
      expect(e[AnalyticsProperties.failedPromoCode], 'TESTCART10');
      expect(e[AnalyticsProperties.promoError], 'Verify your mobile to avail promotion.');
      expect(e[AnalyticsProperties.itemDiscount], 150.0);
      expect(e.containsKey(AnalyticsProperties.promotionDiscount), isFalse);
      // An empty cart still reports the dimension rather than dropping it.
      expect(e[AnalyticsProperties.promoCode], <String>[]);
      expect(e[AnalyticsProperties.promoAppliedCount], 0);
    });

    test('no backend field name reaches the wire', () async {
      // The bug this replaced: the block was spread raw, putting all eight of
      // its keys on the payload and producing none of the three the events
      // owe. Asserted across all three, since each assembles the same body.
      const backendKeys = [
        'code',
        'discount',
        'applied',
        'action',
        'isMerchRule',
        'autoApplied',
        'forceRemove',
        'merchRuleType',
      ];
      await h.analytics.logPromoCodeApplied(promo: payload());
      await h.analytics.logPromoCodeRemoved(promo: payload(), removedPromoCode: 'X');
      await h.analytics.logPromoCodeFailed(promo: payload(), failedPromoCode: 'X');
      expect(h.captured, hasLength(3));
      for (final captured in h.captured) {
        for (final key in backendKeys) {
          expect(
            captured.props.containsKey(key),
            isFalse,
            reason: '`$key` leaked onto ${captured.name}',
          );
        }
      }
    });

    test('merch_promo accepts both wire shapes', () async {
      expect(PromotionDataEntity.isMerchPromo(const {'isMerchRule': 'Yes'}), isTrue);
      expect(PromotionDataEntity.isMerchPromo(const {'isMerchRule': true}), isTrue);
      expect(PromotionDataEntity.isMerchPromo(const {}), isFalse);
    });

    test('promoDiscountOf reads the block', () async {
      expect(PromotionDataEntity.promoDiscountOf(block), 60.0);
    });
  });

  group('from_location values match Android verbatim', () {
    // These are dashboard keys, so a drifted string does not fail anywhere: it
    // silently opens a new bucket and empties the old one.
    test('the cart reload reasons', () {
      expect(FromLocations.updateCart, 'Update cart');
      expect(FromLocations.deleteCart, 'Delete cart');
      expect(FromLocations.moveToWishlist, 'Move to wishlist');
      expect(FromLocations.mergeCart, 'Merge cart');
      expect(FromLocations.removePromo, 'Remove promo');
      // ⚠️ Coined here, not mirrored — Android's apply-path reload is labelled
      // "Mobile verify from message bar". Needs analytics sign-off.
      expect(FromLocations.applyPromo, 'Apply promo');
      // The two promo directions must stay distinguishable. They were the same
      // string, so applying a code reported itself as removing one.
      expect(FromLocations.applyPromo, isNot(FromLocations.removePromo));
      expect(FromLocations.pincodeSelection, 'Pincode selection');
      expect(FromLocations.refreshCartForRemovedItem, 'Refresh cart for RemoveItem');
    });

    test('the price-summary info location', () {
      // One value for both fee sheets — Android's only value for this slot.
      // Which fee was opened is carried by the event name instead.
      expect(FromLocations.orderSummary, 'Order Summary');
    });
  });
}
