import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_defaults.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_events.dart';
import 'package:hs_app_flutter/core/analytics/constants/funnel.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_properties.dart';
import 'package:hs_app_flutter/core/analytics/events/modules/cart_events.dart';
import 'package:hs_app_flutter/features/cart/data/models/cart_model.dart';

import '../support/analytics_test_harness.dart';

/// End-to-end wire contract for `cart_viewed`: the real `GET /shopping-cart`
/// response in, the exact Segment payload out.
///
/// The other cart test exercises the event builder with hand-made blocks. This
/// one starts from the response body itself, so it also covers the parse — and
/// it is the regression guard for the shape change that prompted it.
///
/// **What changed.** An earlier response put the per-SKU attribution inside
/// `trackingMeta`, and forwarding that whole block shipped a `cart_viewed`
/// carrying `atcUser`, a nested `orderDetails` map and a nested
/// `itemLevelTrackingData` map — three keys no dashboard can group on — while
/// carrying none of the dimensions the event is for. The new response splits
/// them: `trackingMeta` is the cart's analytics block, `orderAttributionData`
/// is the order-time attribution, and only the former reaches this event.
void main() {
  late AnalyticsTestHarness h;

  setUp(() async => h = await AnalyticsTestHarness.build());
  tearDown(() => h.tearDown());

  /// The response body, trimmed to the nodes this event reads. Values are
  /// verbatim from the captured payload.
  /// The live response body. The two nested objects sit **inside**
  /// `trackingMeta`, which is what made forwarding the node whole unsafe.
  Map<String, dynamic> response() => {
    'action': 'success',
    'trackingMeta': {
      // Flat analytics keys — these, and only these, are the event.
      'atc_user': 'GU',
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
      'image_url': [
        'https://qastatic.hopscotch.in/fstatic/product/202006/0b079ac3_medium.jpg',
        'https://qastatic.hopscotch.in/fstatic/product/202007/29bf27b2_medium.jpg',
      ],
      'shipping_minimum': 10000,
      // Nested, and belonging to other consumers.
      'orderDetails': {
        'payAmount': 2347.0,
        'shipping': 50.0,
        'totalCredit': 0.0,
        'discountPercentage': 32,
        'totalAmount': 2297.0,
        'itemCount': 3,
        'productAmount': 3363.0,
        'discount': 1066.0,
        'platformFee': 0.0,
      },
      'itemLevelTrackingData': {
        'NIB-3043512': {'atcUser': 'NB', 'hbt': 'T3', 'merchType': 'Catalog'},
        'JBC-2966186': {'atcUser': 'NB', 'hbt': 'T2', 'season': 'Summer'},
      },
    },
    'cartItems': <dynamic>[],
  };

  /// The block's flat keys — the exact set `cart_viewed` should carry from the
  /// server.
  Map<String, dynamic> flatBlock() {
    final block = Map<String, dynamic>.of(
      response()['trackingMeta']! as Map<String, dynamic>,
    )..removeWhere((_, v) => v is Map);
    return block;
  }

  Future<Map<String, Object?>> cartViewedFor(Map<String, dynamic> json) async {
    final cart = CartModel.fromJson(json);
    await h.analytics.logCartViewed(
      fromScreen: AnalyticsDefaults.productDetails,
      fromLocation: FromLocations.cartIconButton,
      cartViewState: CartViewStates.cartLoad,
      isFirstLoad: true,
      trackingMeta: cart.trackingMeta?.analyticsProps,
    );
    return h.singleEvent(AnalyticsEvents.cartViewed);
  }

  group('the backend block is the payload', () {
    test('every trackingMeta key reaches the wire unchanged', () async {
      final e = await cartViewedFor(response());
      for (final entry in flatBlock().entries) {
        expect(
          e[entry.key],
          entry.value,
          reason: '`${entry.key}` was renamed, converted or dropped',
        );
      }
    });

    test('the client-owned four are added on top', () async {
      final e = await cartViewedFor(response());
      expect(e[AnalyticsProperties.fromScreen], AnalyticsDefaults.productDetails);
      expect(e[AnalyticsProperties.fromLocation], FromLocations.cartIconButton);
      expect(e[AnalyticsProperties.cartViewState], CartViewStates.cartLoad);
      expect(e[AnalyticsProperties.firstLoad], AnalyticsDefaults.yes);
    });

    test('funnel is Cart, from attribution rather than the call site', () async {
      // `AppNavigationObserver` applies Funnel.cart on the route push, so the
      // event builder never sets it — asserted here so a change to that wiring
      // shows up as a cart failure rather than silently dropping the key.
      h.orderAttribution.setFunnel(Funnel.cart);
      final e = await cartViewedFor(response());
      expect(e[AnalyticsProperties.funnel], Funnel.cart.wire);
    });
  });

  group('the order-time attribution stays off the event', () {
    test('no atcUser, orderDetails or itemLevelTrackingData', () async {
      // The three keys the previous response shape leaked. `atcUser` is the
      // sharpest: the event does carry `atc_user` from the block, so a
      // regression here would put two spellings of the same dimension on one
      // payload.
      final e = await cartViewedFor(response());
      expect(e.containsKey('atcUser'), isFalse);
      expect(e.containsKey('orderDetails'), isFalse);
      expect(e.containsKey('itemLevelTrackingData'), isFalse);
      expect(e[AnalyticsProperties.atcUser], 'GU');
    });

    test('but both are parsed, for the consumers that do want them', () async {
      final cart = CartModel.fromJson(response());
      // Per-SKU attribution, for `product_ordered` at order time.
      expect(cart.trackingMeta!.trackingForSku('NIB-3043512'), {
        'atcUser': 'NB',
        'hbt': 'T3',
        'merchType': 'Catalog',
      });
      expect(cart.itemLevelTrackingData.keys, hasLength(2));
      // The nested orderDetails, typed — the promo events' price source.
      expect(cart.trackingMeta!.orderDetails!.productAmount, 3363.0);
      expect(cart.trackingMeta!.orderDetails!.payAmount, 2347.0);
    });

    test('no value on the payload is a nested map or list-of-maps', () async {
      // The failure mode this whole split exists to prevent: Segment cannot
      // group on a nested object, so it lands as an unqueryable blob.
      // `quantity_status` / `price_status` / `image_url` are lists of strings,
      // which are fine — it is maps that are not.
      final e = await cartViewedFor(response());
      for (final entry in e.entries) {
        expect(
          entry.value,
          isNot(isA<Map<dynamic, dynamic>>()),
          reason: '`${entry.key}` reached the wire as a nested object',
        );
        if (entry.value is Iterable) {
          expect(
            (entry.value! as Iterable).whereType<Map<dynamic, dynamic>>(),
            isEmpty,
            reason: '`${entry.key}` reached the wire as a list of objects',
          );
        }
      }
    });
  });

  test('the block the backend sends today yields no blobs', () async {
    // The live QA response still carries only `atcUser` alongside the two
    // nested objects — the derived dimensions have not shipped yet. The event
    // that used to produce is the one that prompted this split: three
    // unqueryable maps and none of the dimensions it exists to report.
    //
    // Pinned as its own case because it is the shape running in production
    // right now, and it must stay clean until the block fills out.
    final e = await cartViewedFor({
      'action': 'success',
      'trackingMeta': {
        'atcUser': 'NB',
        'orderDetails': {'payAmount': 4613.0, 'itemCount': 11},
        'itemLevelTrackingData': {
          'NIB-3043512': {'atcUser': 'NB', 'hbt': 'T3'},
        },
      },
      'cartItems': <dynamic>[],
    });

    expect(e.containsKey('orderDetails'), isFalse);
    expect(e.containsKey('itemLevelTrackingData'), isFalse);
    // `atcUser` is flat, so it is forwarded as sent — the rule is "drop the two
    // nested objects", not "rename what is left". It becomes `atc_user` when
    // the backend ships the finished block; nothing here needs to change.
    expect(e['atcUser'], 'NB');
    // The client-owned keys still land, so the event is useful meanwhile.
    expect(e[AnalyticsProperties.fromScreen], AnalyticsDefaults.productDetails);
    expect(e[AnalyticsProperties.cartViewState], CartViewStates.cartLoad);
    expect(e[AnalyticsProperties.firstLoad], AnalyticsDefaults.yes);
  });

  test('an empty cart sends the client keys and no price block', () async {
    // The backend sends no `trackingMeta` for an empty cart, so the shape falls
    // out of the passthrough rather than needing a branch.
    final e = await cartViewedFor({'action': 'success', 'cartItems': <dynamic>[]});
    expect(e[AnalyticsProperties.cartViewState], CartViewStates.cartLoad);
    expect(e[AnalyticsProperties.firstLoad], AnalyticsDefaults.yes);
    expect(e.containsKey('total_amount'), isFalse);
    expect(e.containsKey('atc_user'), isFalse);
  });
}
