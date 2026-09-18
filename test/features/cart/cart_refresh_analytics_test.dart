import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_defaults.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_events.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_properties.dart';
import 'package:hs_app_flutter/core/entities/message_bar_entity.dart';
import 'package:hs_app_flutter/core/error/failures.dart';
import 'package:hs_app_flutter/core/navigation/nav_destination.dart';
import 'package:hs_app_flutter/core/usecases/usecase.dart';
import 'package:hs_app_flutter/features/cart/data/models/cart_model.dart';
import 'package:hs_app_flutter/features/cart/domain/entities/cart_entity.dart';
import 'package:hs_app_flutter/features/cart/domain/entities/cart_item_entity.dart';
import 'package:hs_app_flutter/features/cart/domain/entities/cart_item_media_entity.dart';
import 'package:hs_app_flutter/features/cart/domain/entities/cart_item_price_info_entity.dart';
import 'package:hs_app_flutter/features/cart/domain/usecases/get_cart_usecase.dart';
import 'package:hs_app_flutter/features/cart/domain/usecases/get_static_message_bars_usecase.dart';
import 'package:hs_app_flutter/features/cart/domain/usecases/merge_cart_usecase.dart';
import 'package:hs_app_flutter/features/cart/domain/usecases/move_to_wishlist_usecase.dart';
import 'package:hs_app_flutter/features/cart/domain/usecases/order_now_usecase.dart';
import 'package:hs_app_flutter/features/cart/domain/usecases/remove_cart_item_usecase.dart';
import 'package:hs_app_flutter/features/cart/domain/usecases/update_cart_item_usecase.dart';
import 'package:hs_app_flutter/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:hs_app_flutter/features/promos_offers/domain/entities/promo_action_result_entity.dart';
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

/// A mutation that silently re-reads the cart must still report the read.
///
/// Remove, move-to-wishlist and a quantity step all answer with `{action,
/// message}` and no cart, so each drops the overlay immediately and re-fetches
/// in the background. That background read is a real `cart_viewed` — Android
/// fires one for it too (`getCartData(DELETE_CART / UPDATE_CART,
/// startLoading = false)`) — and because it is silent there is nothing on
/// screen to reveal a missing event. Only a test catches it.
///
/// These assert the wiring end to end: the mutation's own event, then the
/// `cart_viewed` of the refresh it queues, each with the `from_location` that
/// separates one reload cause from another.
void main() {
  late AnalyticsTestHarness h;
  late _MockGetCart getCart;
  late _MockRemoveCartItem removeItem;
  late _MockUpdateCartItem updateItem;
  late _MockMoveToWishlist moveToWishlist;
  late _MockApplyPromo applyPromo;
  late _MockMergeCart mergeCart;
  late _MockStaticBars staticBars;
  late CartBloc bloc;

  CartEntity cartWith({int items = 2}) => CartEntity(
    action: 'success',
    items: [
      for (var i = 0; i < items; i++)
        CartItemEntity(
          sku: 'SKU-$i',
          productId: 100 + i,
          brandName: 'Brand $i',
          quantity: 1,
          selectMaxValue: 3,
          priceInfo: CartItemPriceInfoEntity(absoluteValue: 399 + i),
          media: [CartItemMediaEntity(mimeType: 'IMAGE', url: 'https://img/$i.jpg')],
        ),
    ],
  );

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(const GetCartParams());
    registerFallbackValue(const RemoveCartItemParams(sku: ''));
    registerFallbackValue(const UpdateCartItemParams(sku: '', quantity: 1));
    registerFallbackValue(const MoveToWishlistParams(sku: ''));
    registerFallbackValue(const ApplyPromoParams(promoCode: ''));
    registerFallbackValue(const MergeCartParams());
  });

  /// A cart whose analytics block reports [total] — so a payload built from
  /// the pre-mutation cart and one built from the refreshed cart are
  /// distinguishable.
  CartEntity cartBlockWith({required int total, required int skuCount}) => CartModel.fromJson({
    'trackingMeta': {
      'total_amount': total,
      'sku_count': skuCount,
      'price_status': ['Same', 'Same'],
    },
    'cartItems': [
      for (var i = 0; i < skuCount; i++)
        {
          'sku': 'SKU-$i',
          'productId': 100 + i,
          'brandName': 'Brand $i',
          'quantity': 1,
          'selectMaxValue': 3,
          'priceInfo': {'absoluteValue': 399 + i},
        },
    ],
  });

  setUp(() async {
    h = await AnalyticsTestHarness.build();
    getCart = _MockGetCart();
    removeItem = _MockRemoveCartItem();
    updateItem = _MockUpdateCartItem();
    moveToWishlist = _MockMoveToWishlist();
    applyPromo = _MockApplyPromo();
    mergeCart = _MockMergeCart();
    staticBars = _MockStaticBars();

    when(
      () => staticBars(any()),
    ).thenAnswer((_) async => const Right<Failure, List<MessageBarEntity>>([]));
    when(() => getCart(any())).thenAnswer((_) async => Right<Failure, CartEntity>(cartWith()));

    bloc = CartBloc(
      getCartUseCase: getCart,
      removeCartItemUseCase: removeItem,
      updateCartItemUseCase: updateItem,
      moveToWishlistUseCase: moveToWishlist,
      applyPromoUseCase: applyPromo,
      removePromoUseCase: _MockRemovePromo(),
      mergeCartUseCase: mergeCart,
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

  /// Loads the cart and clears the resulting `cart_viewed`, so each test starts
  /// from a loaded screen with an empty event log.
  Future<void> loadCart() async {
    bloc.add(const LoadCart());
    await bloc.stream.firstWhere((s) => s.isLoaded);
    h.clear();
  }

  /// Waits for the silent refresh's `cart_viewed` to arrive. It is queued as a
  /// second event, so the mutation's own emission is not the end of the work.
  Future<Map<String, Object?>> awaitCartViewed() async {
    for (var tick = 0; tick < 40; tick++) {
      await Future<void>.delayed(const Duration(milliseconds: 5));
      final events = h.eventsNamed(AnalyticsEvents.cartViewed);
      if (events.isNotEmpty) return events.first;
    }
    fail(
      'no cart_viewed fired for the refresh. Events seen: '
      '${h.captured.map((e) => e.name).toList()}',
    );
  }

  test('removing an item reports the removal, then the refresh', () async {
    await loadCart();
    when(
      () => removeItem(any()),
    ).thenAnswer((_) async => const Right<Failure, CartEntity>(CartEntity(action: 'success')));

    bloc.add(const RemoveCartItem(sku: 'SKU-0'));
    final viewed = await awaitCartViewed();

    final updated = h.singleEvent(AnalyticsEvents.productUpdated);
    // The control the user touched — Flutter's ✕, not Android's swipe.
    expect(updated[AnalyticsProperties.fromLocation], FromLocations.removeCartItem);
    // The line that was removed — sourced from the cart item, not from
    // `wishlistInfo.trackingMeta`, which describes a different product.
    expect(updated[AnalyticsProperties.sku], 'SKU-0');
    expect(updated[AnalyticsProperties.productId], 100);
    expect(updated[AnalyticsProperties.brand], 'Brand 0');
    expect(updated[AnalyticsProperties.imageUrl], 'https://img/0.jpg');
    // Line totals: unit 399 × quantity 1. `new_price` is sent on a removal too
    // and equals `price` — the line's quantity never changed, only its
    // presence. Android writes it unguarded (`CartAnalytics:17`); the payload
    // captured from the live app shows 399/399 for exactly this case.
    expect(updated[AnalyticsProperties.price], 399);
    expect(updated[AnalyticsProperties.newPrice], 399);
    // Only `new_quantity` is conditional, so its absence is what marks a
    // removal — alongside `from_location`.
    expect(updated.containsKey(AnalyticsProperties.newQuantity), isFalse);
    expect(updated[AnalyticsProperties.quantityStatus], ['Available']);
    expect(updated[AnalyticsProperties.priceStatus], ['Same']);
    // The refetch it triggered, under Android's reload reason.
    expect(viewed[AnalyticsProperties.fromLocation], FromLocations.deleteCart);
    expect(viewed[AnalyticsProperties.cartViewState], CartViewStates.cartReload);
    // Not the session's first load — that was consumed by `loadCart`.
    expect(viewed[AnalyticsProperties.firstLoad], AnalyticsDefaults.no);
  });

  test('a quantity step reports the update, then the refresh', () async {
    await loadCart();
    when(
      () => updateItem(any()),
    ).thenAnswer((_) async => const Right<Failure, CartEntity>(CartEntity(action: 'success')));

    bloc.add(const UpdateCartItemQuantity(sku: 'SKU-0', quantity: 3, itemIndex: 0));
    final viewed = await awaitCartViewed();

    final updated = h.singleEvent(AnalyticsEvents.productUpdated);
    expect(updated[AnalyticsProperties.fromLocation], FromLocations.updateCart);
    // Before and after, which only the client knows.
    expect(updated[AnalyticsProperties.quantity], 1);
    expect(updated[AnalyticsProperties.newQuantity], 3);
    // Line totals, not unit prices: 399 × 1 then 399 × 3.
    expect(updated[AnalyticsProperties.price], 399);
    expect(updated[AnalyticsProperties.newPrice], 1197);
    expect(updated[AnalyticsProperties.sku], 'SKU-0');

    expect(viewed[AnalyticsProperties.fromLocation], FromLocations.updateCart);
    expect(viewed[AnalyticsProperties.cartViewState], CartViewStates.cartReload);
  });

  test('move to wishlist reports the move, then the refresh', () async {
    await loadCart();
    when(
      () => moveToWishlist(any()),
    ).thenAnswer((_) async => const Right<Failure, CartEntity>(CartEntity(action: 'success')));

    bloc.add(const MoveToWishlist(sku: 'SKU-0', productId: 100, price: 599));
    final viewed = await awaitCartViewed();

    final wishlisted = h.singleEvent(AnalyticsEvents.productAddedToWishlist);
    expect(wishlisted[AnalyticsProperties.fromLocation], FromLocations.moveToWishlist);
    expect(wishlisted[AnalyticsProperties.fromScreen], FromScreens.shoppingCart);
    // Cart-level promo context, read off the cart rather than the item block.
    expect(wishlisted[AnalyticsProperties.promoAppliedCount], 0);
    expect(viewed[AnalyticsProperties.fromLocation], FromLocations.moveToWishlist);
  });

  test('from_screen is the cart on the tap, the origin on the outcome', () async {
    // Two different rules on two events of the same gesture:
    //   product_update_clicked → always "Cart"; the tap happened there.
    //   product_updated        → where the user came from, so the outcome is
    //                            attributable to the journey that led to it.
    //   cart_viewed            → same origin as product_updated.
    // Android does the same: `fireProductUpdateClicked` hardcodes
    // `FromScreens.SHOPPING_CART`, while `logProductUpdatedEvent` and
    // `fireCartViewedEvent` both read `CartFragment.fromScreen`.
    bloc.sourcePage = const SourcePage(
      fromScreen: FromScreens.account,
      fromLocation: FromLocations.cartIconButton,
    );
    await loadCart();
    when(
      () => removeItem(any()),
    ).thenAnswer((_) async => const Right<Failure, CartEntity>(CartEntity(action: 'success')));

    bloc.add(const CartItemControlTapped(sku: 'SKU-0', fromLocation: FromLocations.removeCartItem));
    bloc.add(const RemoveCartItem(sku: 'SKU-0'));
    final viewed = await awaitCartViewed();

    expect(
      h.singleEvent(AnalyticsEvents.productUpdateClicked)[AnalyticsProperties.fromScreen],
      FromScreens.shoppingCart,
    );
    expect(
      h.singleEvent(AnalyticsEvents.productUpdated)[AnalyticsProperties.fromScreen],
      FromScreens.account,
    );
    expect(viewed[AnalyticsProperties.fromScreen], FromScreens.account);
  });

  group('the refresh reports the cart it just fetched, not the one it left', () {
    // The bug this guards is invisible in the app: every mutation emits an
    // optimistic local state first (the row filtered out, the quantity
    // stepped), so a `cart_viewed` built from that snapshot still looks
    // plausible — right item count, wrong totals. It would report the bag as
    // it was *before* the server recalculated shipping, promos and the item
    // discount.
    //
    // Each case loads a 2-item / 1000 cart, then has the refresh return a
    // 1-item / 500 one, and asserts the event carries the second.
    Future<Map<String, Object?>> mutateAndRead(CartEvent event) async {
      when(() => getCart(any())).thenAnswer(
        (_) async => Right<Failure, CartEntity>(cartBlockWith(total: 1000, skuCount: 2)),
      );
      await loadCart();
      when(
        () => getCart(any()),
      ).thenAnswer((_) async => Right<Failure, CartEntity>(cartBlockWith(total: 500, skuCount: 1)));
      bloc.add(event);
      return awaitCartViewed();
    }

    test('after a removal', () async {
      when(
        () => removeItem(any()),
      ).thenAnswer((_) async => const Right<Failure, CartEntity>(CartEntity(action: 'success')));
      final e = await mutateAndRead(const RemoveCartItem(sku: 'SKU-0'));
      expect(e['total_amount'], 500);
      expect(e['sku_count'], 1);
    });

    test('after a move to wishlist', () async {
      when(
        () => moveToWishlist(any()),
      ).thenAnswer((_) async => const Right<Failure, CartEntity>(CartEntity(action: 'success')));
      final e = await mutateAndRead(const MoveToWishlist(sku: 'SKU-0', productId: 100, price: 599));
      expect(e['total_amount'], 500);
      expect(e['sku_count'], 1);
      expect(e[AnalyticsProperties.fromLocation], FromLocations.moveToWishlist);
    });

    test('after a promo is applied', () async {
      // A different code path from the three above: promo and merge go through
      // `_refreshAfterMutation` rather than `RefreshCart`, so it needs its own
      // proof that the fresh cart — not `previousState.cart` — is reported.
      // This is the path where a stale read would matter most: applying a
      // promo exists precisely to change the totals.
      when(() => applyPromo(any())).thenAnswer(
        (_) async => const Right<Failure, PromoActionResultEntity>(
          PromoActionResultEntity(success: true, message: 'Applied'),
        ),
      );
      final e = await mutateAndRead(const ApplyPromoCode(promoCode: 'JOY5'));
      expect(e['total_amount'], 500);
      // `Apply promo`, not `Remove promo` — an apply used to report the
      // removal's reason, so this reload was indistinguishable from undoing it.
      expect(e[AnalyticsProperties.fromLocation], FromLocations.applyPromo);
    });

    test('after a cart merge', () async {
      when(
        () => mergeCart(any()),
      ).thenAnswer((_) async => const Right<Failure, CartEntity>(CartEntity(action: 'success')));
      final e = await mutateAndRead(const MergeCart());
      expect(e['total_amount'], 500);
      expect(e['sku_count'], 1);
      expect(e[AnalyticsProperties.fromLocation], FromLocations.mergeCart);
    });

    test('after a quantity step', () async {
      when(
        () => updateItem(any()),
      ).thenAnswer((_) async => const Right<Failure, CartEntity>(CartEntity(action: 'success')));
      final e = await mutateAndRead(
        const UpdateCartItemQuantity(sku: 'SKU-0', quantity: 3, itemIndex: 0),
      );
      expect(e['total_amount'], 500);
      expect(e['sku_count'], 1);
    });
  });

  test('move to wishlist carries the mapped merchandising attributes', () async {
    // End to end: the backend's per-SKU block reaches the event under the wire
    // names, not its own. Sourced from `orderAttributionData` — the shape the
    // live response uses while `wishlistInfo.trackingMeta` is still empty.
    when(() => getCart(any())).thenAnswer(
      (_) async => Right<Failure, CartEntity>(
        CartModel.fromJson({
          'cartItems': [
            {'sku': 'SKU-0', 'productId': 100, 'brandName': 'Brand 0', 'quantity': 1},
          ],
          'orderAttributionData': {
            'itemLevelTrackingData': {
              'SKU-0': {
                'atcUser': 'NB',
                'hbt': 'T3',
                'merchType': 'Catalog',
                'atcSite': 'ios',
                'country': 'India',
                'taste': 'Classic',
                'season': 'Autumn Winter',
                'style': 'Half sleeves',
                'pattern': 'Typography',
                'weave': 'Woven',
              },
            },
          },
        }),
      ),
    );
    await loadCart();
    when(
      () => moveToWishlist(any()),
    ).thenAnswer((_) async => const Right<Failure, CartEntity>(CartEntity(action: 'success')));

    bloc.add(const MoveToWishlist(sku: 'SKU-0', productId: 100, price: 599));
    await awaitCartViewed();

    final e = h.singleEvent(AnalyticsEvents.productAddedToWishlist);
    expect(e[AnalyticsProperties.weave], 'Woven');
    expect(e[AnalyticsProperties.country], 'India');
    expect(e[AnalyticsProperties.merchType], 'Catalog');
    expect(e[AnalyticsProperties.taste], 'Classic');
    expect(e[AnalyticsProperties.hbt], 'T3');
    // Backend spellings must not reach the wire alongside them.
    expect(e.containsKey('merchType'), isFalse);
    expect(e.containsKey('atcSite'), isFalse);
    expect(e.containsKey('country'), isFalse);
  });

  test('a SKU with no tracking block still reports the move', () async {
    // The old call site indexed the map directly and threw here.
    await loadCart();
    when(
      () => moveToWishlist(any()),
    ).thenAnswer((_) async => const Right<Failure, CartEntity>(CartEntity(action: 'success')));

    bloc.add(const MoveToWishlist(sku: 'SKU-0', productId: 100, price: 599));
    await awaitCartViewed();

    final e = h.singleEvent(AnalyticsEvents.productAddedToWishlist);
    expect(e[AnalyticsProperties.fromLocation], FromLocations.moveToWishlist);
    expect(e.containsKey(AnalyticsProperties.weave), isFalse);
  });

  group('a price row picks its own info event', () {
    // Driven through the real bloc, not a mirror of its matcher — the mapping
    // is the thing under test.
    Future<void> open(String? priceType) async {
      await loadCart();
      bloc.add(PriceRowInfoOpened(priceType: priceType));
      await pumpEventQueue();
    }

    test('platform fee fires its own event', () async {
      await open('Platform fee');
      final e = h.singleEvent(AnalyticsEvents.platformFeeInfoViewed);
      expect(e[AnalyticsProperties.fromScreen], FromScreens.shoppingCart);
      expect(e[AnalyticsProperties.fromLocation], FromLocations.orderSummary);
      expect(h.eventsNamed(AnalyticsEvents.shippingInfoViewed), isEmpty);
    });

    test('shipping fee keeps the Android event', () async {
      await open('Shipping fee');
      expect(h.singleEvent(AnalyticsEvents.shippingInfoViewed), isNotNull);
      expect(h.eventsNamed(AnalyticsEvents.platformFeeInfoViewed), isEmpty);
    });

    test('casing and whitespace still match', () async {
      await open('  PLATFORM fee ');
      expect(h.singleEvent(AnalyticsEvents.platformFeeInfoViewed), isNotNull);
    });

    test('an unmapped row falls back to the Android event', () async {
      // Never the coined one — a row nobody mapped must not open a bucket
      // Android never writes to.
      await open('Convenience fee');
      expect(h.singleEvent(AnalyticsEvents.shippingInfoViewed), isNotNull);
      expect(h.eventsNamed(AnalyticsEvents.platformFeeInfoViewed), isEmpty);
    });

    test('a null priceType falls back too', () async {
      await open(null);
      expect(h.singleEvent(AnalyticsEvents.shippingInfoViewed), isNotNull);
    });
  });

  test('a failed refresh reports nothing rather than a stale cart', () async {
    // The refresh is deliberately silent on failure — the previous cart stays
    // on screen. Reporting a `cart_viewed` there would claim the user saw a
    // fresh bag they never received.
    await loadCart();
    when(
      () => removeItem(any()),
    ).thenAnswer((_) async => const Right<Failure, CartEntity>(CartEntity(action: 'success')));
    when(
      () => getCart(any()),
    ).thenAnswer((_) async => const Left<Failure, CartEntity>(ServerFailure(message: 'offline')));

    bloc.add(const RemoveCartItem(sku: 'SKU-0'));
    await Future<void>.delayed(const Duration(milliseconds: 80));

    expect(h.eventsNamed(AnalyticsEvents.cartViewed), isEmpty);
    // The removal itself still reported — it did happen.
    expect(h.eventsNamed(AnalyticsEvents.productUpdated), hasLength(1));
  });
}
