import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/analytics/constants/analytics_defaults.dart';
import '../../../../core/analytics/events/analytics_helper.dart';
import '../../../../core/analytics/events/modules/cart_events.dart';
import '../../../../core/analytics/state/cart_timer.dart';
import '../../../../core/base/base_bloc.dart';
import '../../../../core/constants/strings/cart_strings.dart';
import '../../../../core/entities/backend_action_entity.dart';
import '../../../../core/entities/message_bar_entity.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/extensions/string_extensions.dart';
import '../../../../core/navigation/nav_destination.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../checkout/domain/entities/buy_now_entity.dart';
import '../../../promos_offers/domain/entities/promo_action_result_entity.dart';
import '../../../promos_offers/domain/entities/promo_offers_source.dart';
import '../../../promos_offers/domain/usecases/apply_promo_usecase.dart';
import '../../../promos_offers/domain/usecases/remove_promo_usecase.dart';
import '../../domain/entities/cart_entity.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/entities/promotion_data_entity.dart';
import '../../domain/helpers/cart_item_analytics.dart';
import '../../domain/usecases/get_cart_usecase.dart';
import '../../domain/usecases/get_static_message_bars_usecase.dart';
import '../../domain/usecases/merge_cart_usecase.dart';
import '../../domain/usecases/move_to_wishlist_usecase.dart';
import '../../domain/usecases/order_now_usecase.dart';
import '../../domain/usecases/remove_cart_item_usecase.dart';
import '../../domain/usecases/update_cart_item_usecase.dart';

part 'cart_bloc.freezed.dart';
part 'cart_event.dart';
part 'cart_state.dart';

@injectable
class CartBloc extends BaseBloc<CartEvent, CartState> {
  final GetCartUseCase getCartUseCase;
  final RemoveCartItemUseCase removeCartItemUseCase;
  final UpdateCartItemUseCase updateCartItemUseCase;
  final MoveToWishlistUseCase moveToWishlistUseCase;

  /// Shared with the offers bottom sheet — the promo section and the sheet both
  /// go through `/v3/promotion/apply` and `/v3/promotion/remove`.
  final ApplyPromoUseCase applyPromoUseCase;
  final RemovePromoUseCase removePromoUseCase;
  final MergeCartUseCase mergeCartUseCase;
  final OrderNowUseCase orderNowUseCase;
  final GetStaticMessageBarsUseCase getStaticMessageBarsUseCase;
  final AnalyticsHelper analytics;

  /// Stamped on every cart-route push by `AppNavigationObserver`; read for
  /// `tti`. Shared rather than owned so no navigation path can skip it.
  final CartTimer cartTimer;

  CartBloc({
    required this.getCartUseCase,
    required this.removeCartItemUseCase,
    required this.updateCartItemUseCase,
    required this.moveToWishlistUseCase,
    required this.applyPromoUseCase,
    required this.removePromoUseCase,
    required this.mergeCartUseCase,
    required this.orderNowUseCase,
    required this.getStaticMessageBarsUseCase,
    required this.analytics,
    required this.cartTimer,
  }) : super(const CartState()) {
    on<LoadCart>(_onLoadCart);
    on<RefreshCart>(_onRefreshCart);
    on<RemoveCartItem>(_onRemoveCartItem);
    on<UpdateCartItemQuantity>(_onUpdateCartItem);
    on<MoveToWishlist>(_onMoveToWishlist);
    on<ApplyPromoCode>(_onApplyPromoCode);
    on<RemovePromoCode>(_onRemovePromoCode);
    on<MergeCart>(_onMergeCart);
    on<ProceedToCheckout>(_onProceedToCheckout);
    on<ClearToast>(_onClearToast);
    on<ClearCheckoutData>(_onClearCheckoutData);
    on<ClearPromoActionSheet>(_onClearPromoActionSheet);
    on<CartItemControlTapped>(_onCartItemControlTapped);
    on<PincodeCheckClicked>(_onPincodeCheckClicked);
    on<OffersSheetPromoActionCompleted>(_onOffersSheetPromoActionCompleted);
  }

  /// Buy-now mode. While set, every cart call carries `instantCheckout=true`
  /// and the backend answers with the buy-now line alone instead of the whole
  /// bag — mirroring Android's `CartViewModel.isFromBuyNow`, which feeds the
  /// same flag into its cart, remove, update and move-to-wishlist calls.
  ///
  /// The cart page sets it on entry and clears it via [exitBuyNowMode] when the
  /// user leaves the checkout flow, which is where Android clears its own flag
  /// (`CartFragment.onResume`, guarded by `exitedBuyNowFlow`).
  bool instantCheckout = false;

  /// Set once the user closes a message bar whose action is `dismiss`; every
  /// later cart fetch then carries `dismiss=true` so the backend stops sending
  /// that bar. Mirrors Android's `CartViewModel.isCartDismissible`, set in
  /// `CartFragment.handleActionLink` and never cleared for the cart's lifetime.
  bool cartDismissible = false;

  /// Query flags shared by every cart fetch — Android builds the same map in
  /// `CartViewModel.getCartData`.
  GetCartParams _getCartParams(CancelToken token, {bool isMergeCall = false}) => GetCartParams(
    isMergeCall: isMergeCall,
    instantCheckout: instantCheckout,
    dismiss: cartDismissible,
    cancelToken: token,
  );

  /// Android's `CartViewModel.getCartData` merges on its own when the fetched
  /// bag is empty but the server still holds items in the temp (guest) cart.
  /// Skipped for the fetch that follows a merge, so a merge that leaves the
  /// temp flag set cannot loop.
  void _autoMergeIfNeeded(CartEntity cart, {bool afterMerge = false}) {
    if (afterMerge) return;
    if (cart.items.isEmpty && cart.isCartItemExistInTemp) add(const MergeCart());
  }

  /// Where the user came from — `from_screen` for every cart event of this
  /// visit, and `from_location` for the `cart_viewed` of a fresh entry.
  /// Written by `CartPage.initState` from the route's `extra`.
  ///
  /// Ports Android's `CartFragment.fromScreen` / `fromLocation`, static fields
  /// the fragment fills from its launching intent and every cart event then
  /// reads. Passed in rather than derived because it cannot be derived: the PLP
  /// sends the *boutique's name* (`ProductListActivity:745`), which no router
  /// or navigation observer knows.
  ///
  /// Null when the route was pushed by path instead of through
  /// `AppNavigator.goToCart`; the reporting falls back per field below.
  SourcePage? sourcePage;

  /// Whether the next `cart_viewed` is this process's first, sent as
  /// `first_load: Yes` / `No`.
  ///
  /// Ports Android's `FirstCartLoad` singleton, read and flipped by
  /// `CartObserver` so exactly one `cart_viewed` per process reports `Yes`, no
  /// matter how many times the cart is opened or reloaded. Deliberately **not**
  /// persisted, and deliberately not cleared after an order — Android clears it
  /// only on cold start.
  ///
  /// Lives on the bloc rather than in the analytics layer because it is cart
  /// state, not analytics-transport state. That relies on this bloc being
  /// provided **once**, at `hs_app.dart` app root — the same invariant the
  /// post-login promo and move-to-wishlist resumes already depend on. Scoping a
  /// second `BlocProvider<CartBloc>` to the cart page would reset the flag on
  /// every visit and report `Yes` every time.
  bool firstCartLoad = true;

  /// Leaves buy-now mode so the next fetch returns the full bag again.
  /// Returns whether the mode was actually on, so the caller can skip a
  /// needless refetch.
  bool exitBuyNowMode() {
    if (!instantCheckout) return false;
    instantCheckout = false;
    return true;
  }

  /// Offer code captured when the user tapped Apply while logged out —
  /// [AppNavigator.redirectAfterLogin] replays it via [resumePendingPromo]
  /// once login completes, mirroring CartActionsCubit/WishlistCubit's
  /// setPending/resumePending pattern.
  String? _pendingPromoCode;

  void setPendingPromo(String promoCode) => _pendingPromoCode = promoCode;

  /// Move-to-wishlist captured when the user tapped it while logged out.
  /// Replayed by [AppNavigator.redirectAfterLogin] via
  /// [resumePendingMoveToWishlist]. The whole event is stashed rather than its
  /// three fields — it is already an immutable value object, so there is
  /// nothing to keep in sync.
  ///
  /// This is deliberately separate from `WishlistCubit`'s pending slot: the
  /// cart's move-to-wishlist is a different endpoint (it removes the line from
  /// the cart as well as adding to the wishlist), so it cannot be resumed
  /// through the wishlist store.
  MoveToWishlist? _pendingMoveToWishlist;

  void setPendingMoveToWishlist(MoveToWishlist event) => _pendingMoveToWishlist = event;

  void resumePendingMoveToWishlist() {
    final event = _pendingMoveToWishlist;
    _pendingMoveToWishlist = null;
    if (event == null) return;
    // Same post-login staleness as resumePendingPromo.
    add(
      MoveToWishlist(
        sku: event.sku,
        productId: event.productId,
        price: event.price,
        reloadCartFirst: true,
      ),
    );
  }

  void resumePendingPromo() {
    final code = _pendingPromoCode;
    _pendingPromoCode = null;
    if (code == null) return;
    // `reloadCartFirst` is what makes this work: login swaps the server-side
    // cart from anonymous to authenticated, and applying against the stale
    // one comes back as a validation failure even though the code is valid.
    // The two steps must share one event — bloc gives each event *type* its
    // own queue, so `add(LoadCart()); add(ApplyPromoCode());` would race.
    add(ApplyPromoCode(promoCode: code, reloadCartFirst: true));
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(const CartState(status: CartStatus.loading));
    final token = swapCancelToken();
    final staticBars = await _staticMessageBars();
    final result = await getCartUseCase(
      _getCartParams(token),
    );
    result.fold(
      (failure) {
        if (failure is RequestCancelledFailure) return;
        emit(CartState(status: CartStatus.error, errorMessage: failure.message));
      },
      (cart) {
        emit(CartState(status: CartStatus.loaded, cart: cart, staticMessageBars: staticBars));
        _trackCartViewed(cart, cartViewState: CartViewStates.cartLoad);
        _autoMergeIfNeeded(cart);
      },
    );
  }

  /// Silent refresh — keeps current UI visible while fetching fresh data.
  ///
  /// Every emission here copyWiths `state` as read at emit time, never a copy
  /// captured before the await. A mutation that hands off to this refresh (a
  /// quantity step, a remove, a move-to-wishlist) has usually just published a
  /// one-shot — a toast, a promo sheet — that the UI consumed and cleared while
  /// the request was in flight. Rebuilding from the stale snapshot would put
  /// that toast back on the state and show the snackbar a second time.
  Future<void> _onRefreshCart(RefreshCart event, Emitter<CartState> emit) async {
    final token = swapCancelToken();
    final staticBars = await _staticMessageBars();
    final result = await getCartUseCase(
      _getCartParams(token),
    );
    result.fold(
      // Silently ignore the failure — keep current cart data visible — but
      // still bump refreshTick so a pull-to-refresh spinner awaiting it stops.
      // A cancelled request is the exception: a newer load owns the UI now.
      (failure) {
        if (failure is RequestCancelledFailure) return;
        emit(state.copyWith(refreshTick: state.refreshTick + 1));
      },
      (cart) {
        emit(
          state.copyWith(
            status: CartStatus.loaded,
            cart: cart,
            staticMessageBars: staticBars,
            refreshTick: state.refreshTick + 1,
            // A refresh that recovers from an error state must drop the message
            // that state carried. Every other success path builds a fresh
            // CartState (so errorMessage starts null); this one copyWiths the
            // previous state to stay silent, and would otherwise carry a stale
            // message into a loaded cart.
            errorMessage: null,
          ),
        );
        _trackCartViewed(
          cart,
          cartViewState: CartViewStates.cartReload,
          reloadReason: event.reloadReason,
        );
        _autoMergeIfNeeded(cart);
      },
    );
  }

  /// The server's own copy when it sent any, the app's wording otherwise.
  /// Both remove and move-to-wishlist toast the API's `message` when present,
  /// the way Android does.
  static String _messageOr(String? message, String fallback) =>
      message.isNotNullOrEmpty ? message! : fallback;

  /// Position of [sku] in [items]. [hint] is the row index the tap came from —
  /// used directly when it still points at the right item, which it does in the
  /// common case. It can go stale: a background refresh landing between the tap
  /// and the response can reorder or shorten the list, and writing blindly to
  /// the index would then step the wrong product (or throw).
  static int _indexOfItem(List<CartItemEntity> items, {required String sku, int? hint}) {
    if (hint != null && hint >= 0 && hint < items.length && items[hint].sku == sku) {
      return hint;
    }
    return items.indexWhere((item) => item.sku == sku);
  }

  /// Settles a mutation that drops a line from the cart (remove,
  /// move-to-wishlist) without waiting on the follow-up cart read.
  ///
  /// Both endpoints answer with `{action, message}` and no cart, so the old
  /// flow held the user through a second round-trip — the overlay for a move,
  /// the confirmation sheet's spinner for a remove — purely to learn something
  /// the app already knows: that line is gone. The row is dropped locally and
  /// the authoritative totals (order summary, promo, EDD, message bars) are
  /// re-read silently, the same way the quantity change works.
  void _completeItemRemoval(
    Emitter<CartState> emit,
    CartState previous, {
    required String sku,
    required String? reloadReason,
    String? toastMessage,
  }) {
    emit(
      previous.copyWith(
        pendingItemAction: null,
        isCartUpdating: false,
        cart: previous.cart!.copyWith(
          items: previous.cart!.items.where((item) => item.sku != sku).toList(),
        ),
        toastMessage: toastMessage,
        toastIsError: false,
      ),
    );
    add(RefreshCart(reloadReason: reloadReason));
  }

  /// Static bars are decorative — a failed read just means none are shown.
  Future<List<MessageBarEntity>> _staticMessageBars() async {
    final result = await getStaticMessageBarsUseCase(NoParams());
    return result.fold((_) => const [], (bars) => bars);
  }

  /// Remove runs behind the confirmation sheet's own button spinner
  /// (`CartState.isRemoving`) rather than the full-screen overlay: the sheet
  /// stays up until the API answers, then closes and the outcome is toasted —
  /// success with the server's message, failure with the reason.
  Future<void> _onRemoveCartItem(RemoveCartItem event, Emitter<CartState> emit) async {
    final current = state;
    if (current.isLoaded) {
      emit(current.copyWith(pendingItemAction: (sku: event.sku, action: CartItemAction.remove)));
    }
    final token = swapCancelToken();
    final result = await removeCartItemUseCase(
      RemoveCartItemParams(sku: event.sku, instantCheckout: instantCheckout, cancelToken: token),
    );
    result.fold(
      (failure) {
        // Unlike the other mutations, a cancelled remove still has to clear the
        // pending action — the sheet would otherwise sit there spinning
        // forever, waiting for a call that will never answer.
        if (!current.isLoaded) {
          if (failure is! RequestCancelledFailure) {
            emit(current.copyWith(status: CartStatus.error, errorMessage: failure.message));
          }
          return;
        }
        if (failure is RequestCancelledFailure) {
          emit(current.copyWith(pendingItemAction: null));
          return;
        }
        emit(
          current.copyWith(
            pendingItemAction: null,
            toastMessage: _messageOr(failure.message, CartStrings.couldNotRemoveItem),
            toastIsError: true,
          ),
        );
      },
      // The sheet closes the moment this lands rather than after the refresh —
      // `message` is the server's own confirmation text (Android toasts
      // exactly this).
      (cart) {
        if (!current.isLoaded) return;
        // Read before the row is dropped — `product_updated` reports the state
        // the line was in when the user removed it, which no longer exists
        // once `_completeItemRemoval` has filtered it out.
        _trackProductUpdated(
          current.cart!,
          current.cart!.items.firstWhereOrNull((item) => item.sku == event.sku),
          fromLocation: FromLocations.removeCartItem,
        );
        _completeItemRemoval(
          emit,
          current,
          sku: event.sku,
          reloadReason: FromLocations.deleteCart,
          toastMessage: _messageOr(cart.message, CartStrings.itemRemoved),
        );
      },
    );
  }

  Future<void> _onUpdateCartItem(UpdateCartItemQuantity event, Emitter<CartState> emit) async {
    final current = state;
    if (current.isLoaded) {
      emit(
        current.copyWith(
          pendingItemAction: (sku: event.sku, action: CartItemAction.quantity),
          isCartUpdating: true,
        ),
      );
    }
    final token = swapCancelToken();
    final result = await updateCartItemUseCase(
      UpdateCartItemParams(
        sku: event.sku,
        quantity: event.quantity,
        instantCheckout: instantCheckout,
        cancelToken: token,
      ),
    );
    result.fold(
      (failure) {
        if (failure is RequestCancelledFailure) return;
        if (current.isLoaded) {
          emit(current.copyWith(pendingItemAction: null, isCartUpdating: false));
        } else {
          emit(current.copyWith(status: CartStatus.error, errorMessage: failure.message));
        }
      },
      (_) {
        if (!current.isLoaded) return;

        // `PUT /shopping-cart/v2/{sku}` answers with only
        // `{action, message, cartItemQty}` — no cart — so the overlay is
        // dropped the moment it lands, the tapped line is stepped locally, and
        // the authoritative totals (line price, order summary, EDD, message
        // bars) are re-read in the background. Blocking through that second
        // read is what made a single +/- tap feel slow: two round-trips to
        // show a number the app already knew. Android does the same —
        // `getCartData(UPDATE_CART, startLoading = false)`.
        //
        // (`cartItemQty` in the response is the cart-wide item count, not this
        // line's quantity, so the local step uses the requested quantity.)
        final items = List<CartItemEntity>.of(current.cart!.items);
        final index = _indexOfItem(items, sku: event.sku, hint: event.itemIndex);
        if (index != -1) {
          // Captured before the local step: `quantity`/`price` on
          // `product_updated` are the pre-tap values, which only exist here.
          _trackProductUpdated(
            current.cart!,
            items[index],
            fromLocation: FromLocations.updateCart,
            newQuantity: event.quantity,
          );
          items[index] = items[index].withQuantity(event.quantity);
        }

        emit(
          current.copyWith(
            pendingItemAction: null,
            isCartUpdating: false,
            cart: current.cart!.copyWith(items: items),
          ),
        );
        add(const RefreshCart(reloadReason: FromLocations.updateCart));
      },
    );
  }

  Future<void> _onMoveToWishlist(MoveToWishlist event, Emitter<CartState> emit) async {
    final current = event.reloadCartFirst ? await _reloadCartBeforeMutation(emit) : state;
    if (current.isLoaded) {
      emit(
        current.copyWith(
          pendingItemAction: (sku: event.sku, action: CartItemAction.moveToWishlist),
          isCartUpdating: true,
        ),
      );
    }
    final token = swapCancelToken();
    final result = await moveToWishlistUseCase(
      MoveToWishlistParams(
        sku: event.sku,
        productId: event.productId,
        price: event.price,
        instantCheckout: instantCheckout,
        cancelToken: token,
      ),
    );
    result.fold(
      (failure) {
        if (failure is RequestCancelledFailure) return;
        if (current.isLoaded) {
          // Feedback matters more here than on the other mutations: the row
          // stays put on failure, so without a toast the tap looks ignored.
          emit(
            current.copyWith(
              pendingItemAction: null,
              isCartUpdating: false,
              toastMessage: CartStrings.couldNotMoveToWishlist,
              toastIsError: true,
            ),
          );
        } else {
          emit(current.copyWith(status: CartStatus.error, errorMessage: failure.message));
        }
      },
      // The overlay lifts as soon as the move lands; the cart re-read that
      // follows is silent. Server message first, same as remove.
      (cart) {
        if (!current.isLoaded) return;
        // Same reason as remove: the block that describes the move lives on
        // the row, and the row is about to be dropped.
        final trackingMeta = current.cart!.items
            .firstWhereOrNull((item) => item.sku == event.sku)
            ?.wishlistInfo
            ?.trackingMeta;

        analytics.logProductMovedToWishlistFromCart(trackingMeta: trackingMeta);
        _completeItemRemoval(
          emit,
          current,
          sku: event.sku,
          reloadReason: FromLocations.moveToWishlist,
          toastMessage: _messageOr(cart.message, CartStrings.movedToWishlist),
        );
      },
    );
  }

  /// The offer-code field applies through `POST /v3/promotion/apply`, the same
  /// endpoint the offers bottom sheet uses. That endpoint answers with only
  /// `{success, message}` — no cart — so the cart is re-read afterwards to pick
  /// up the new totals.
  Future<void> _onApplyPromoCode(ApplyPromoCode event, Emitter<CartState> emit) async {
    // A second tap while the first apply is still running would run the call
    // twice and answer with two sheets stacked on top of each other. The Apply
    // button already ignores taps while `isPromoLoading`, but the button is not
    // the only way in (keyboard submit, the post-login replay), so the guard
    // belongs here too.
    if (state.isPromoLoading) return;
    final current = event.reloadCartFirst ? await _reloadCartBeforeMutation(emit) : state;
    if (current.isLoaded) {
      emit(current.copyWith(isPromoLoading: true, isCartUpdating: true));
    }

    final token = swapCancelToken();
    final result = await applyPromoUseCase(
      // Reached from the cart's own promo text field (and its post-login
      // replay), never from the offers sheet — that path goes through
      // PromosOffersBloc and reports `offer-list`.
      ApplyPromoParams(
        promoCode: event.promoCode,
        fromLocation: PromoOffersSource.cart,
        cancelToken: token,
      ),
    );

    await result.fold(
      (failure) async {
        if (failure is RequestCancelledFailure) return;
        _trackPromoFailed(current.cart, event.promoCode, failure.message);
        _emitPromoActionFailed(emit, current, failure.message);
      },
      (action) async {
        final sheet = action.hasBottomSheet ? action.bottomSheet : null;
        if (!action.success) {
          // A rejected code (mistyped, expired, cart not eligible) is still a
          // 200 — surface the server's reason instead of silently clearing the
          // spinner, which is how the old endpoint behaved. When the backend
          // doesn't send its own sheet, fall back to a client-authored one so
          // the user still sees the "Invalid Promo Code" sheet rather than a
          // toast.
          // A rejected code is a 200, so it never reaches the failure branch
          // above — this is the only place `promo_code_failed` can fire for the
          // common cases (mistyped, expired, mobile not verified).
          _trackPromoFailed(
            current.cart,
            event.promoCode,
            action.hasMessage ? action.message : null,
          );
          _emitPromoActionFailed(
            emit,
            current,
            action.hasMessage ? action.message : 'Could not apply this offer',
            sheet:
                sheet ??
                BackendActionContentEntity(
                  title: 'Invalid Promo Code',
                  description: action.hasMessage
                      ? action.message
                      : 'This promo code is invalid or expired. Try another',
                ),
          );
          return;
        }
        await _refreshAfterMutation(
          emit,
          current,
          reloadReason: FromLocations.applyPromo,
          toastMessage: action.hasMessage ? action.message : null,
          promoActionSheet: sheet,
        );
        // After the refresh: every price property describes the cart *with*
        // the promo on it, and the endpoint answers `{success, message}` only.
        _trackPromoApplied(state.cart);
      },
    );
  }

  /// Shared by apply and remove: keep the loaded cart visible, drop the
  /// spinner, and surface the reason — as the backend's sheet when it sent one,
  /// otherwise as a toast.
  void _emitPromoActionFailed(
    Emitter<CartState> emit,
    CartState previous,
    String? message, {
    BackendActionContentEntity? sheet,
  }) {
    if (previous.isLoaded) {
      emit(
        previous.copyWith(
          isPromoLoading: false,
          isCartUpdating: false,
          toastMessage: sheet != null ? null : message,
          promoActionSheet: sheet,
        ),
      );
    } else {
      emit(previous.copyWith(status: CartStatus.error, errorMessage: message));
    }
  }

  /// Removes through `DELETE /v3/promotion/remove`, pairing with the apply
  /// above. Same `{success, message}` shape, so the cart is re-read afterwards.
  Future<void> _onRemovePromoCode(RemovePromoCode event, Emitter<CartState> emit) async {
    if (state.isPromoLoading) return;
    final current = state;
    if (current.isLoaded) {
      emit(current.copyWith(isPromoLoading: true, isCartUpdating: true));
    }

    final token = swapCancelToken();
    final result = await removePromoUseCase(
      RemovePromoParams(promoCode: event.promoCode, cancelToken: token),
    );

    await result.fold(
      (failure) async {
        if (failure is RequestCancelledFailure) return;
        _emitPromoActionFailed(emit, current, failure.message);
      },
      (action) async {
        final sheet = action.hasBottomSheet ? action.bottomSheet : null;
        if (!action.success) {
          _emitPromoActionFailed(
            emit,
            current,
            action.hasMessage ? action.message : 'Could not remove this offer',
            sheet: sheet,
          );
          return;
        }
        // Before the refresh: `promo_code`, `promo_applied_count` and
        // `promotion_discount` all describe the promo being given up, and are
        // gone once the re-read lands. Mirror of the apply above.
        _trackPromoRemoved(current.cart, event.promoCode);
        await _refreshAfterMutation(
          emit,
          current,
          reloadReason: FromLocations.removePromo,
          toastMessage: action.hasMessage ? action.message : null,
          promoActionSheet: sheet,
        );
      },
    );
  }

  /// Android's `CartViewModel.mergeCart`: the cart is re-read whatever the
  /// merge outcome — with `isMergeCall=true` when it succeeded and `false`
  /// when it did not, so the backend knows whether the bag it returns is the
  /// merged one.
  Future<void> _onMergeCart(MergeCart event, Emitter<CartState> emit) async {
    if (event.showLoading) emit(const CartState(status: CartStatus.loading));
    final current = state;
    if (current.isLoaded) {
      emit(current.copyWith(isMerging: true, isCartUpdating: true));
    }
    final token = swapCancelToken();
    final result = await mergeCartUseCase(MergeCartParams(cancelToken: token));
    await result.fold(
      (failure) async {
        if (failure is RequestCancelledFailure) return;
        await _refreshAfterMutation(
          emit,
          current,
          afterMerge: true,
          reloadReason: FromLocations.mergeCart,
          toastMessage: failure.message,
        );
      },
      (_) async => _refreshAfterMutation(
        emit,
        current,
        isMergeCall: true,
        afterMerge: true,
        reloadReason: FromLocations.mergeCart,
      ),
    );
  }

  /// Matches Android CartViewModel.orderNow() logic:
  /// 1. refreshCartForRemovedItem → refresh cart with message
  /// 2. action == SUCCESS → open checkout bottom sheet
  /// 3. messageBars present → show them on cart
  /// 4. else → show error
  Future<void> _onProceedToCheckout(ProceedToCheckout event, Emitter<CartState> emit) async {
    final current = state;
    if (current.isLoaded) emit(current.copyWith(isCheckoutLoading: true));
    final token = swapCancelToken();
    final result = await orderNowUseCase(OrderNowParams(cancelToken: token));
    await result.fold(
      (failure) {
        if (failure is RequestCancelledFailure) return;
        // Server sent an `action != "success"` with a structured
        // `content` (buy-now's "All sold out" pattern) — thread it through
        // as checkoutData so the sheet renders it instead of a toast.
        if (failure is ApiFailure && failure.content != null && current.isLoaded) {
          emit(current.copyWith(
            isCheckoutLoading: false,
            checkoutData: BuyNowEntity(content: failure.content),
          ));
          return;
        }
        if (current.isLoaded) {
          emit(current.copyWith(isCheckoutLoading: false, toastMessage: failure.message));
        } else {
          emit(current.copyWith(status: CartStatus.error, errorMessage: failure.message));
        }
      },
      (data) async {
        // Case 1: Items removed during checkout validation — re-fetch cart
        if (data.refreshCartForRemovedItem == true) {
          await _refreshAfterMutation(
            emit,
            current,
            reloadReason: FromLocations.refreshCartForRemovedItem,
          );
          return;
        }

        // Case 2: Success — open checkout bottom sheet
        if (data.isSuccessful) {
          if (current.isLoaded) {
            emit(current.copyWith(isCheckoutLoading: false, checkoutData: data));
          }
          return;
        }

        // Case 3: Has messageBars — show them on cart page
        if (data.messageBars.isNotEmpty && current.isLoaded) {
          emit(
            current.copyWith(
              isCheckoutLoading: false,
              // Prepend API messageBars to existing cart messageBars
              cart: current.cart!.copyWith(
                messageBars: [...data.messageBars, ...current.cart!.messageBars],
              ),
              toastMessage: data.message,
            ),
          );
          return;
        }

        // Case 4: Other failure
        if (current.isLoaded) {
          emit(
            current.copyWith(
              isCheckoutLoading: false,
              toastMessage: data.message ?? 'Unable to proceed',
            ),
          );
        }
      },
    );
  }

  void _onClearToast(ClearToast event, Emitter<CartState> emit) {
    // Reset the status with the message, so a later success toast can't
    // inherit a stale error styling.
    emit(state.copyWith(toastMessage: null, toastIsError: false));
  }

  void _onClearCheckoutData(ClearCheckoutData event, Emitter<CartState> emit) {
    emit(state.copyWith(checkoutData: null));
  }

  void _onClearPromoActionSheet(ClearPromoActionSheet event, Emitter<CartState> emit) {
    emit(state.copyWith(promoActionSheet: null));
  }

  /// Re-fetches the full cart after a mutation (remove / move-to-wishlist)
  /// whose response doesn't include the full cart payload.
  ///
  /// [toastMessage] carries a server message the mutation itself returned (e.g.
  /// "Promo applied. You saved ₹50"), so it survives the state replacement.
  /// Re-reads the cart and emits it, returning the state a caller should
  /// treat as "current" from here on. Used by the post-login resume paths,
  /// where the cart in memory predates authentication.
  ///
  /// A failed reload returns the existing state rather than erroring out: the
  /// mutation that follows is the user's actual intent, and the server is the
  /// final authority on whether it is valid.
  Future<CartState> _reloadCartBeforeMutation(Emitter<CartState> emit) async {
    final token = swapCancelToken();
    final result = await getCartUseCase(
      _getCartParams(token),
    );
    return result.fold((_) => state, (cart) {
      final reloaded = CartState(
        status: CartStatus.loaded,
        cart: cart,
        staticMessageBars: state.staticMessageBars,
      );
      emit(reloaded);
      _trackCartViewed(cart, cartViewState: CartViewStates.cartReload);
      _autoMergeIfNeeded(cart);
      return reloaded;
    });
  }

  Future<void> _refreshAfterMutation(
    Emitter<CartState> emit,
    CartState previousState, {
    bool isMergeCall = false,
    bool afterMerge = false,
    String? reloadReason,
    String? toastMessage,
    BackendActionContentEntity? promoActionSheet,
  }) async {
    final token = swapCancelToken();
    final result = await getCartUseCase(
      _getCartParams(token, isMergeCall: isMergeCall),
    );
    result.fold(
      (failure) {
        if (failure is RequestCancelledFailure) return;
        if (previousState.isLoaded) {
          emit(
            previousState.copyWith(
              pendingItemAction: null,
              isCartUpdating: false,
              isPromoLoading: false,
              isMerging: false,
              toastMessage: toastMessage,
              promoActionSheet: promoActionSheet,
            ),
          );
        } else {
          emit(previousState.copyWith(status: CartStatus.error, errorMessage: failure.message));
        }
      },
      (cart) {
        emit(
          CartState(
            status: CartStatus.loaded,
            cart: cart,
            staticMessageBars: previousState.staticMessageBars,
            toastMessage: toastMessage,
            promoActionSheet: promoActionSheet,
          ),
        );
        _trackCartViewed(
          cart,
          cartViewState: CartViewStates.cartReload,
          reloadReason: reloadReason,
        );
        _autoMergeIfNeeded(cart, afterMerge: afterMerge);
      },
    );
  }

  void _onCartItemControlTapped(CartItemControlTapped event, Emitter<CartState> emit) {
    final cart = state.cart;
    final index = cart?.indexOfSku(event.sku) ?? -1;
    if (cart == null || index == -1) return;
    final item = cart.items[index];
    analytics.logProductUpdateClicked(
      fromLocation: event.fromLocation,
      sku: item.sku,
      productId: item.productId,
      brand: item.brandName,
      // The unit price here, against `product_updated`'s line total — Android
      // sends `product.price` raw on this event.
      price: item.priceInfo?.absoluteValue,
      quantity: item.quantity,
      quantityStatus: item.quantityStatus,
      priceStatus: cart.priceStatusAt(index),
    );
  }

  void _onPincodeCheckClicked(PincodeCheckClicked event, Emitter<CartState> emit) {
    analytics.logPincodeCheckClicked(
      fromScreen: FromScreens.shoppingCart,
      fromPincode: state.cart?.deliveryPincode?.pincode,
    );
  }

  // ─── Analytics ────────────────────────────────────────────────────────
  //
  // Every method here reads a `trackingMeta` block off the response and hands
  // it to the helper untouched. Nothing is derived: `quantity_status`,
  // `price_status`, `cart_filler_reco`, `atc_user`, the price block and the
  // per-item product blob all arrive finished, which is the whole point of the
  // backend change these events were built against (Android computes them in
  // three places with two implementations — see its `docs/CART_ANALYTICS.md`).
  // What the bloc contributes is the part the server cannot see: which screen
  // the user came from, what caused this particular reload, and the before
  // values of a change the app has just made.

  /// `cart_viewed`, fired from every path that lands a cart response.
  ///
  /// `from_screen` is read from the navigation trail rather than passed in:
  /// Android takes it off the launching intent (`CartFragment.fromScreen`),
  /// and the trail is the equivalent fact here without threading an argument
  /// through every entry point into the cart.
  /// `from_screen` for every cart event — the screen the visit came from.
  ///
  /// `from_page` is deliberately **not** forwarded even though [SourcePage]
  /// carries it: Android's cart events don't send it, and adding it here would
  /// put a key on `cart_viewed` that no Android build emits.
  String get _analyticsFromScreen => sourcePage?.fromScreen ?? AnalyticsDefaults.none;

  /// `from_location` for a `cart_viewed`.
  ///
  /// [reloadReason] names what re-read an already-open cart (a promo change, a
  /// quantity step, a pincode change). When it is null the read has no reason
  /// of its own — a fresh entry, or a pull-to-refresh — so the control that
  /// opened the cart is reported instead, which is what Android does for every
  /// read (its `fromLocation` is set once from the intent and repeats).
  String _fromLocationFor(String? reloadReason) =>
      reloadReason ?? sourcePage?.fromLocation ?? FromLocations.cartIconButton;

  /// Milliseconds from the cart being opened to this response landing, or null
  /// when the clock never started (the route was pushed by path rather than
  /// through `AppNavigator.goToCart`).
  ///
  /// Null for an **empty cart** too: Android builds `tti` only inside its
  /// non-empty branch (`fireCartViewedEvent`), so an empty bag reports the
  /// client keys alone. Sending it here would put a timing on a screen that
  /// renders no cart.
  int? _ttiFor(CartEntity cart) => cart.items.isEmpty ? null : cartTimer.elapsedMs;

  void _trackCartViewed(CartEntity cart, {required String cartViewState, String? reloadReason}) {
    // Read and flipped here, so exactly one cart_viewed per process reports
    // `Yes` regardless of which fetch path got there first.
    final isFirstLoad = firstCartLoad;
    firstCartLoad = false;

    analytics.logCartViewed(
      fromScreen: _analyticsFromScreen,
      fromLocation: _fromLocationFor(reloadReason),
      cartViewState: cartViewState,
      isFirstLoad: isFirstLoad,
      tti: _ttiFor(cart),
      trackingMeta: cart.trackingMeta?.analyticsProps,
    );
    _trackServerDrivenPromoChanges(cart);
  }

  /// `product_updated` after a successful quantity change or removal.
  ///
  /// Sourced from the line itself, not from a `trackingMeta` block: the cart
  /// response carries no per-line analytics block, and the nearest thing
  /// (`wishlistInfo.trackingMeta`) is the finished move-to-wishlist payload for
  /// a different reporting shape.
  ///
  /// [newQuantity] is null for a removal, which is what keeps `new_quantity`
  /// and `new_price` off that payload — Android's `if (product.quantity !=
  /// oldQty)` guard. `from_location` then carries the distinction the absence
  /// alone cannot.
  void _trackProductUpdated(
    CartEntity cart,
    CartItemEntity? item, {
    required String fromLocation,
    int? newQuantity,
  }) {
    if (item == null) return;
    // Android sends line totals here, not unit prices: `price * oldQty` and
    // `price * newQty`. `product_update_clicked` sends the unit price instead.
    final unitPrice = item.priceInfo?.absoluteValue;
    final oldQuantity = item.quantity;
    // `new_price` is sent on a removal too, where it equals `price`.
    //
    // Android computes it as `price * product.quantity` with no guard
    // (`CartAnalytics:17`) — only `new_quantity` is conditional. On a removal
    // it passes `oldQty = product.quantity`, so both sides read the same
    // quantity and the two totals come out equal. Falling back to
    // [oldQuantity] when there is no new one reproduces that exactly, rather
    // than dropping the key or sending 0 for "the line is gone".
    final effectiveNewQuantity = newQuantity ?? oldQuantity;
    analytics.logProductUpdated(
      fromScreen: _analyticsFromScreen,
      fromLocation: fromLocation,
      sku: item.sku,
      productId: item.productId,
      brand: item.brandName,
      quantity: oldQuantity,
      newQuantity: newQuantity,
      price: (unitPrice != null && oldQuantity != null) ? unitPrice * oldQuantity : null,
      newPrice: (unitPrice != null && effectiveNewQuantity != null)
          ? unitPrice * effectiveNewQuantity
          : null,
      imageUrl: item.imgSrc,
      quantityStatus: item.quantityStatus,
      priceStatus: cart.priceStatusAt(cart.indexOfSku(item.sku)),
    );
  }

  /// The body all three promo events share.
  ///
  /// Prefers `trackingMeta.orderDetails` (the analytics copy) over the
  /// response's top-level one, so the payload still builds with either.
  ///
  /// [isFailure] also drives `merch_promo` and `promotion_discount`, which
  /// describe the promo *on the cart* — something a rejected code never
  /// became. Android reaches the same result by matching the entered code
  /// against a list it was never added to.
  ///
  /// [isFailure] switches `item_discount` to the bag's own discount. Android's
  /// two implementations genuinely differ here and each event follows the one
  /// that fires it: `hscart` passes the promo's discount for applied/removed,
  /// while `PromosActivity:456` passes `orderDetails.discount` for failed.
  CartPromoPayload _promoPayload(CartEntity? cart, {bool isFailure = false}) {
    final details = cart?.trackingMeta?.orderDetails ?? cart?.orderDetails;
    final promotion = cart?.promotionData;

    // A rejected code is never in the cart's promo list, so Android's
    // `getPromoListData` resolves neither of these for it.
    final promoDiscount = isFailure ? 0 : (promotion?.appliedPromoDiscount ?? 0);

    return CartPromoPayload(
      totalItemPrice: details?.productAmount,
      totalAmount: details?.totalAmount,
      fromShipping: details?.shipping,
      fromNetAmount: details?.payAmount,
      itemDiscount: isFailure ? details?.discount : promoDiscount,
      // Android's `if (promotionDiscount > 0)`.
      promotionDiscount: promoDiscount > 0 ? promoDiscount : null,
      merchPromo: !isFailure && (promotion?.isMerchPromoApplied ?? false),
      promoCodes: promotion?.allPromoCodes ?? const [],
      promoAppliedCount: promotion?.promoAppliedCount ?? 0,
    );
  }

  /// Reports a promo action from the offers sheet, which has no cart of its
  /// own to build the payload from.
  ///
  /// **Apply and remove refresh in opposite orders, deliberately** — each
  /// event reports the bag its properties are named for. An apply says what
  /// the code was worth (post-refresh); a remove says what was given up, and
  /// `promo_code` / `promo_applied_count` / `promotion_discount` are all gone
  /// once the refresh lands. A rejection leaves the cart untouched and
  /// re-reads nothing. [_onApplyPromoCode] / [_onRemovePromoCode] match.
  ///
  /// Refreshing here rather than on sheet close is what keeps a session that
  /// removes one code then applies another from reporting both against the
  /// same cart.
  Future<void> _onOffersSheetPromoActionCompleted(
    OffersSheetPromoActionCompleted event,
    Emitter<CartState> emit,
  ) async {
    switch (event.outcome) {
      case OffersSheetPromoOutcome.failed:
        _trackPromoFailed(state.cart, event.promoCode, event.error);
        return;

      case OffersSheetPromoOutcome.removed:
        // Before the read — the cart still carries the code this names.
        _trackPromoRemoved(state.cart, event.promoCode);
        await _refreshAfterMutation(emit, state, reloadReason: FromLocations.removePromo);
        return;

      case OffersSheetPromoOutcome.applied:
        await _refreshAfterMutation(emit, state, reloadReason: FromLocations.applyPromo);
        // `state`, not a pre-await snapshot — the refresh is what put the
        // post-apply cart there.
        _trackPromoApplied(state.cart);
        return;
    }
  }

  void _trackPromoApplied(CartEntity? cart) =>
      analytics.logPromoCodeApplied(promo: _promoPayload(cart));

  void _trackPromoRemoved(CartEntity? cart, String removedPromoCode) =>
      analytics.logPromoCodeRemoved(promo: _promoPayload(cart), removedPromoCode: removedPromoCode);

  /// A rejected apply leaves the cart untouched, so the price context is the
  /// cart the user was already looking at.
  void _trackPromoFailed(CartEntity? cart, String promoCode, String? error) =>
      analytics.logPromoCodeFailed(
        // `isFailure`: `item_discount` becomes the bag's own discount.
        promo: _promoPayload(cart, isFailure: true),
        failedPromoCode: promoCode,
        promoError: error,
      );

  /// Codes the server applied or dropped on its own, reported once each.
  ///
  /// Ports `CartAnalytics.handleCartPromoEvent`, which inspects every cart
  /// response for an `autoApplied` or `forceRemove` promo and emits the
  /// matching event — the user tapped nothing, so no interaction handler will.
  ///
  /// Android re-runs that check on every cart response and re-fires for a code
  /// whose flag is still set, so a cart reloaded five times reports the same
  /// auto-apply five times. [_reportedServerPromoCodes] is why this does not:
  /// a code is reported once per bloc lifetime, keyed by code and direction so
  /// an auto-apply followed by a later force-remove of the same code still
  /// produces both.
  void _trackServerDrivenPromoChanges(CartEntity cart) {
    final promotion = cart.promotionData;
    if (promotion == null) return;
    final block = promotion.promoTrackingMeta;
    final code = promotion.promoCode;
    if (block == null || code == null || code.isEmpty) return;
    if (PromotionDataEntity.isPromoAutoApplied(block) &&
        _reportedServerPromoCodes.add('applied:$code')) {
      _trackPromoApplied(cart);
    } else if (PromotionDataEntity.isPromoForceRemoved(block) &&
        _reportedServerPromoCodes.add('removed:$code')) {
      _trackPromoRemoved(cart, code);
    }
  }

  final Set<String> _reportedServerPromoCodes = <String>{};
}
