import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/core/analytics/constants/funnel.dart';
import 'package:hs_app_flutter/core/constants/route_names.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_defaults.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_events.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_properties.dart';
import 'package:hs_app_flutter/core/entities/message_bar_entity.dart';
import 'package:hs_app_flutter/core/error/failures.dart';
import 'package:hs_app_flutter/core/usecases/usecase.dart';
import 'package:hs_app_flutter/features/cart/data/models/cart_model.dart';
import 'package:hs_app_flutter/features/cart/domain/entities/cart_entity.dart';
import 'package:hs_app_flutter/features/cart/domain/usecases/get_cart_usecase.dart';
import 'package:hs_app_flutter/features/cart/domain/usecases/get_static_message_bars_usecase.dart';
import 'package:hs_app_flutter/features/cart/domain/usecases/merge_cart_usecase.dart';
import 'package:hs_app_flutter/features/cart/domain/usecases/move_to_wishlist_usecase.dart';
import 'package:hs_app_flutter/features/cart/domain/usecases/order_now_usecase.dart';
import 'package:hs_app_flutter/features/cart/domain/usecases/remove_cart_item_usecase.dart';
import 'package:hs_app_flutter/features/cart/domain/usecases/update_cart_item_usecase.dart';
import 'package:hs_app_flutter/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:hs_app_flutter/features/promos_offers/domain/usecases/apply_promo_usecase.dart';
import 'package:hs_app_flutter/features/promos_offers/domain/usecases/remove_promo_usecase.dart';
import 'package:mocktail/mocktail.dart';

import '../../analytics/support/analytics_test_harness.dart';

class _MockGetCart extends Mock implements GetCartUseCase {}

class _MockRemoveCartItem extends Mock implements RemoveCartItemUseCase {}

class _MockUpdateCartItem extends Mock implements UpdateCartItemUseCase {}

class _MockMoveToWishlist extends Mock implements MoveToWishlistUseCase {}

class _MockApplyPromo extends Mock implements ApplyPromoUseCase {}

class _MockRemovePromo extends Mock implements RemovePromoUseCase {}

class _MockMergeCart extends Mock implements MergeCartUseCase {}

class _MockOrderNow extends Mock implements OrderNowUseCase {}

class _MockStaticBars extends Mock implements GetStaticMessageBarsUseCase {}

/// The offers sheet reports its apply/remove/rejection to [CartBloc], which
/// owns the cart the promo events describe.
///
/// What these guard is the **ordering**: an apply must report the refreshed
/// bag, a remove the bag it is giving up. The pre/post carts are deliberately
/// different so a stale read shows up as a wrong number, not a plausible one.
void main() {
  late AnalyticsTestHarness h;
  late _MockGetCart getCart;
  late CartBloc bloc;

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(const GetCartParams());
  });

  /// A cart shaped like the `/shopping-cart` sample: the promo in
  /// `orderPromocodes[].trackingMeta`, the prices in `orderDetails`.
  CartEntity cartWith({
    String? promoCode,
    num discount = 0,
    required num productAmount,
    required num totalAmount,
    required num shipping,
    required num payAmount,
  }) => CartModel.fromJson({
    'action': 'success',
    'orderDetails': {
      'productAmount': productAmount,
      'totalAmount': totalAmount,
      'shipping': shipping,
      'payAmount': payAmount,
      // What `item_discount` reports on a rejection. See `_promoPayload`.
      'discount': productAmount - totalAmount,
    },
    'promotionData': {
      'orderPromocodes': [
        if (promoCode != null)
          {
            'trackingMeta': {
              'code': promoCode,
              'discount': discount,
              'applied': true,
              'action': 'success',
              'isMerchRule': 'No',
              'autoApplied': false,
              'forceRemove': false,
              'merchRuleType': 'ORDER',
            },
          },
      ],
    },
    'cartItems': [
      {
        'sku': 'SKU-0',
        'productId': 100,
        'brandName': 'Brand 0',
        'quantity': 1,
        'selectMaxValue': 3,
        'priceInfo': {'absoluteValue': 399},
      },
    ],
  });

  /// The bag before any offer is touched — the rejection payload's figures.
  CartEntity noPromoCart() =>
      cartWith(productAmount: 748, totalAmount: 598, shipping: 50, payAmount: 662);

  /// The bag after `TESTCART10` lands.
  CartEntity promoAppliedCart() => cartWith(
    promoCode: 'TESTCART10',
    discount: 60.0,
    productAmount: 748,
    totalAmount: 598,
    shipping: 50,
    payAmount: 602,
  );

  setUp(() async {
    h = await AnalyticsTestHarness.build();
    getCart = _MockGetCart();
    final staticBars = _MockStaticBars();

    when(
      () => staticBars(any()),
    ).thenAnswer((_) async => const Right<Failure, List<MessageBarEntity>>([]));
    when(() => getCart(any())).thenAnswer((_) async => Right<Failure, CartEntity>(noPromoCart()));

    bloc = CartBloc(
      getCartUseCase: getCart,
      removeCartItemUseCase: _MockRemoveCartItem(),
      updateCartItemUseCase: _MockUpdateCartItem(),
      moveToWishlistUseCase: _MockMoveToWishlist(),
      applyPromoUseCase: _MockApplyPromo(),
      removePromoUseCase: _MockRemovePromo(),
      mergeCartUseCase: _MockMergeCart(),
      orderNowUseCase: _MockOrderNow(),
      getStaticMessageBarsUseCase: staticBars,
      analytics: h.analytics,
      cartTimer: h.cartTimer,
    );
  });

  tearDown(() async {
    await bloc.close();
    h.tearDown();
  });

  /// Loads the cart and clears its `cart_viewed`, so each test starts from a
  /// loaded screen with an empty log. The route is pushed through the real
  /// observer first — that is what stamps `funnel: "Cart"`.
  Future<void> loadCart() async {
    h.navObserver.didPush(
      MaterialPageRoute<Object?>(
        settings: const RouteSettings(name: RouteNames.cartName),
        builder: (_) => const SizedBox(),
      ),
      null,
    );
    await pumpEventQueue();
    bloc.add(const LoadCart());
    await bloc.stream.firstWhere((s) => s.isLoaded);
    h.clear();
  }

  /// Waits for [event] — the handler re-reads the cart first.
  Future<Map<String, Object?>> awaitEvent(String event) async {
    for (var tick = 0; tick < 40; tick++) {
      await Future<void>.delayed(const Duration(milliseconds: 5));
      final events = h.eventsNamed(event);
      if (events.isNotEmpty) return events.first;
    }
    fail(
      'no $event fired. Events seen: '
      '${h.captured.map((e) => e.name).toList()}',
    );
  }

  /// Lets the bloc settle so "nothing fired" can be asserted honestly.
  Future<void> settle() async {
    for (var tick = 0; tick < 10; tick++) {
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
  }

  test('an apply in the sheet reports the bag the promo produced', () async {
    await loadCart();
    // The apply already landed; the cart now answers with the promo on it.
    when(
      () => getCart(any()),
    ).thenAnswer((_) async => Right<Failure, CartEntity>(promoAppliedCart()));

    bloc.add(
      const OffersSheetPromoActionCompleted(
        outcome: OffersSheetPromoOutcome.applied,
        promoCode: 'TESTCART10',
      ),
    );

    final e = await awaitEvent(AnalyticsEvents.promoCodeApplied);
    expect(e[AnalyticsProperties.fromScreen], FromScreens.shoppingCart);
    expect(e[AnalyticsProperties.totalItemPrice], 748);
    expect(e[AnalyticsProperties.totalAmount], 598);
    expect(e[AnalyticsProperties.fromShipping], 50);
    // The post-apply figure — the assertion the whole ordering exists for.
    expect(e[AnalyticsProperties.fromNetAmount], 602);
    expect(e[AnalyticsProperties.itemDiscount], 60.0);
    expect(e[AnalyticsProperties.promotionDiscount], 60.0);
    expect(e[AnalyticsProperties.merchPromo], AnalyticsDefaults.no);
    // Singular key, array value — Android's naming.
    expect(e[AnalyticsProperties.promoCode], ['TESTCART10']);
    expect(e[AnalyticsProperties.promoAppliedCount], 1);
    // From the route's attribution, not the payload.
    expect(e[AnalyticsProperties.funnel], Funnel.cart.wire);

    // Reported under the apply's own reason, not the removal's.
    final viewed = h.eventsNamed(AnalyticsEvents.cartViewed).single;
    expect(viewed[AnalyticsProperties.fromLocation], FromLocations.applyPromo);
    expect(viewed[AnalyticsProperties.cartViewState], CartViewStates.cartReload);
  });

  test('a remove in the sheet reports the bag it is giving up', () async {
    // Mirror of the apply: every property this event owes describes the promo
    // being removed, and all are gone once the refresh lands.
    when(
      () => getCart(any()),
    ).thenAnswer((_) async => Right<Failure, CartEntity>(promoAppliedCart()));
    await loadCart();
    // The refresh returns the bag without the promo — if the event were built
    // after it, every assertion below would read the empty cart.
    when(() => getCart(any())).thenAnswer((_) async => Right<Failure, CartEntity>(noPromoCart()));

    bloc.add(
      const OffersSheetPromoActionCompleted(
        outcome: OffersSheetPromoOutcome.removed,
        promoCode: 'TESTCART10',
      ),
    );

    final e = await awaitEvent(AnalyticsEvents.promoCodeRemoved);
    expect(e[AnalyticsProperties.fromScreen], FromScreens.shoppingCart);
    expect(e[AnalyticsProperties.totalItemPrice], 748);
    expect(e[AnalyticsProperties.totalAmount], 598);
    expect(e[AnalyticsProperties.fromShipping], 50);
    // Pre-removal — the promo is still on the bag.
    expect(e[AnalyticsProperties.fromNetAmount], 602);
    expect(e[AnalyticsProperties.itemDiscount], 60.0);
    expect(e[AnalyticsProperties.promotionDiscount], 60.0);
    expect(e[AnalyticsProperties.merchPromo], AnalyticsDefaults.no);
    expect(e[AnalyticsProperties.promoCode], ['TESTCART10']);
    expect(e[AnalyticsProperties.promoAppliedCount], 1);
    expect(e[AnalyticsProperties.removedPromoCode], 'TESTCART10');
    expect(e[AnalyticsProperties.funnel], Funnel.cart.wire);

    // The refresh still happens — just after the event, not before it.
    await settle();
    final viewed = h.eventsNamed(AnalyticsEvents.cartViewed).single;
    expect(viewed[AnalyticsProperties.fromLocation], FromLocations.removePromo);
    expect(viewed[AnalyticsProperties.cartViewState], CartViewStates.cartReload);
  });

  test('the two directions report different reload reasons', () async {
    // They shared `Remove promo`, so an apply and its undo were one dashboard
    // row — invisible in the app, since `cart_viewed` looks fine either way.
    when(
      () => getCart(any()),
    ).thenAnswer((_) async => Right<Failure, CartEntity>(promoAppliedCart()));
    await loadCart();

    bloc.add(
      const OffersSheetPromoActionCompleted(
        outcome: OffersSheetPromoOutcome.applied,
        promoCode: 'TESTCART10',
      ),
    );
    await settle();
    bloc.add(
      const OffersSheetPromoActionCompleted(
        outcome: OffersSheetPromoOutcome.removed,
        promoCode: 'TESTCART10',
      ),
    );
    await settle();

    final reasons = h
        .eventsNamed(AnalyticsEvents.cartViewed)
        .map((e) => e[AnalyticsProperties.fromLocation])
        .toList();
    expect(reasons, [FromLocations.applyPromo, FromLocations.removePromo]);
  });

  test('the remove event is fired before the refresh, not after', () async {
    // Stated directly, so moving the track call below the refresh fails here
    // rather than silently emptying the event.
    when(
      () => getCart(any()),
    ).thenAnswer((_) async => Right<Failure, CartEntity>(promoAppliedCart()));
    await loadCart();
    when(() => getCart(any())).thenAnswer((_) async => Right<Failure, CartEntity>(noPromoCart()));

    bloc.add(
      const OffersSheetPromoActionCompleted(
        outcome: OffersSheetPromoOutcome.removed,
        promoCode: 'TESTCART10',
      ),
    );
    await settle();

    expect(h.captured.map((e) => e.name).toList(), [
      AnalyticsEvents.promoCodeRemoved,
      AnalyticsEvents.cartViewed,
    ]);
  });

  test('the apply event is fired after the refresh, not before', () async {
    await loadCart();
    when(
      () => getCart(any()),
    ).thenAnswer((_) async => Right<Failure, CartEntity>(promoAppliedCart()));

    bloc.add(
      const OffersSheetPromoActionCompleted(
        outcome: OffersSheetPromoOutcome.applied,
        promoCode: 'TESTCART10',
      ),
    );
    await settle();

    expect(h.captured.map((e) => e.name).toList(), [
      AnalyticsEvents.cartViewed,
      AnalyticsEvents.promoCodeApplied,
    ]);
  });

  test('a rejected apply matches the contract payload', () async {
    await loadCart();

    bloc.add(
      const OffersSheetPromoActionCompleted(
        outcome: OffersSheetPromoOutcome.failed,
        promoCode: 'TESTCART10',
        error: 'Verify your mobile to avail promotion.',
      ),
    );

    final e = await awaitEvent(AnalyticsEvents.promoCodeFailed);

    // Field-for-field against the agreed rejection payload.
    expect(e[AnalyticsProperties.fromScreen], FromScreens.shoppingCart);
    expect(e[AnalyticsProperties.funnel], Funnel.cart.wire);
    expect(e[AnalyticsProperties.failedPromoCode], 'TESTCART10');
    expect(e[AnalyticsProperties.promoError], 'Verify your mobile to avail promotion.');
    expect(e[AnalyticsProperties.totalItemPrice], 748);
    expect(e[AnalyticsProperties.totalAmount], 598);
    expect(e[AnalyticsProperties.fromShipping], 50);
    expect(e[AnalyticsProperties.fromNetAmount], 662);
    // 748 - 598: the bag's own discount, not the promo's. Android's
    // `PromosActivity:456` passes `orderDetails.discount` into this slot.
    expect(e[AnalyticsProperties.itemDiscount], 150);
    expect(e[AnalyticsProperties.merchPromo], AnalyticsDefaults.no);
    expect(e[AnalyticsProperties.promoCode], <String>[]);
    expect(e[AnalyticsProperties.promoAppliedCount], 0);
    // Never on a rejection: nothing was applied.
    expect(e.containsKey(AnalyticsProperties.promotionDiscount), isFalse);

    // No refetch, so no `cart_viewed`.
    await settle();
    expect(h.eventsNamed(AnalyticsEvents.cartViewed), isEmpty);
    verify(() => getCart(any())).called(1);
  });

  test('a rejection does not borrow the applied promo\'s merch flag or '
      'discount', () async {
    // Android resolves these by matching the entered code against the cart's
    // promo list, so a rejected code — never in that list — reports neither,
    // even with a different valid promo on the bag. Reading them off
    // "whatever promo the cart carries" attributed a live promo's discount to
    // the code that just got rejected.
    when(
      () => getCart(any()),
    ).thenAnswer((_) async => Right<Failure, CartEntity>(promoAppliedCart()));
    await loadCart();

    bloc.add(
      const OffersSheetPromoActionCompleted(
        outcome: OffersSheetPromoOutcome.failed,
        promoCode: 'SOMEOTHERCODE',
        error: 'This promo code is invalid or expired.',
      ),
    );

    final e = await awaitEvent(AnalyticsEvents.promoCodeFailed);
    expect(e[AnalyticsProperties.failedPromoCode], 'SOMEOTHERCODE');
    expect(e[AnalyticsProperties.merchPromo], AnalyticsDefaults.no);
    expect(e.containsKey(AnalyticsProperties.promotionDiscount), isFalse);
    // The cart's promo state is still reported — it describes the bag.
    expect(e[AnalyticsProperties.promoCode], ['TESTCART10']);
    expect(e[AnalyticsProperties.promoAppliedCount], 1);
    // And `item_discount` is the bag's own saving (748 - 598), not the live
    // promo's 60.
    expect(e[AnalyticsProperties.itemDiscount], 150.0);
  });

  test('a successful apply still resolves its own promo despite casing', () async {
    // Case-insensitive where Android uses `equals`: the cart's promo field
    // carries user-typed input, and a lowercase entry would otherwise zero
    // both keys on a *successful* apply.
    await loadCart();
    when(
      () => getCart(any()),
    ).thenAnswer((_) async => Right<Failure, CartEntity>(promoAppliedCart()));

    bloc.add(
      const OffersSheetPromoActionCompleted(
        outcome: OffersSheetPromoOutcome.applied,
        promoCode: '  testcart10 ',
      ),
    );

    final e = await awaitEvent(AnalyticsEvents.promoCodeApplied);
    expect(e[AnalyticsProperties.promotionDiscount], 60.0);
    expect(e[AnalyticsProperties.itemDiscount], 60.0);
  });

  test('a failed remove reports nothing', () async {
    // Android declares `promo_removed_failed` but never fires it. The widget
    // filters this out; this pins that the bloc invents nothing either.
    await loadCart();

    bloc.add(
      const OffersSheetPromoActionCompleted(
        outcome: OffersSheetPromoOutcome.failed,
        promoCode: 'TESTCART10',
        error: 'Could not remove this offer',
      ),
    );

    await settle();
    expect(h.eventsNamed(AnalyticsEvents.promoCodeRemoved), isEmpty);
    expect(h.eventsNamed(AnalyticsEvents.promoCodeApplied), isEmpty);
  });

  test('a remove then an apply each report their own bag', () async {
    // One session, two mutations — the case the old refresh-on-close got
    // wrong: both events carried whichever change was last.
    when(
      () => getCart(any()),
    ).thenAnswer((_) async => Right<Failure, CartEntity>(promoAppliedCart()));
    await loadCart();

    // Reports the bag it is giving up, then refreshes into the empty one.
    when(() => getCart(any())).thenAnswer((_) async => Right<Failure, CartEntity>(noPromoCart()));
    bloc.add(
      const OffersSheetPromoActionCompleted(
        outcome: OffersSheetPromoOutcome.removed,
        promoCode: 'TESTCART10',
      ),
    );
    final removed = await awaitEvent(AnalyticsEvents.promoCodeRemoved);

    // Refreshes into the promo'd bag, then reports it.
    when(
      () => getCart(any()),
    ).thenAnswer((_) async => Right<Failure, CartEntity>(promoAppliedCart()));
    bloc.add(
      const OffersSheetPromoActionCompleted(
        outcome: OffersSheetPromoOutcome.applied,
        promoCode: 'TESTCART10',
      ),
    );
    final applied = await awaitEvent(AnalyticsEvents.promoCodeApplied);

    // Each names the bag its own event is about, not the session's last.
    expect(removed[AnalyticsProperties.fromNetAmount], 602);
    expect(removed[AnalyticsProperties.promoAppliedCount], 1);
    expect(applied[AnalyticsProperties.fromNetAmount], 602);
    expect(applied[AnalyticsProperties.promoAppliedCount], 1);
  });
}
