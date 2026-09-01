import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/base/base_bloc.dart';
import '../../../../core/constants/strings/cart_strings.dart';
import '../../../../core/entities/backend_action_entity.dart';
import '../../../../core/entities/message_bar_entity.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/extensions/string_extensions.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../promos_offers/domain/entities/promo_action_result_entity.dart';
import '../../../promos_offers/domain/entities/promo_offers_source.dart';
import '../../../promos_offers/domain/usecases/apply_promo_usecase.dart';
import '../../../promos_offers/domain/usecases/remove_promo_usecase.dart';
import '../../domain/entities/cart_entity.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/usecases/get_cart_usecase.dart';
import '../../domain/usecases/get_static_message_bars_usecase.dart';
import '../../domain/usecases/merge_cart_usecase.dart';
import '../../domain/usecases/move_to_wishlist_usecase.dart';
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
  final GetStaticMessageBarsUseCase getStaticMessageBarsUseCase;

  CartBloc({
    required this.getCartUseCase,
    required this.removeCartItemUseCase,
    required this.updateCartItemUseCase,
    required this.moveToWishlistUseCase,
    required this.applyPromoUseCase,
    required this.removePromoUseCase,
    required this.mergeCartUseCase,
    required this.getStaticMessageBarsUseCase,
  }) : super(const CartState()) {
    on<LoadCart>(_onLoadCart);
    on<RefreshCart>(_onRefreshCart);
    on<RemoveCartItem>(_onRemoveCartItem);
    on<UpdateCartItemQuantity>(_onUpdateCartItem);
    on<MoveToWishlist>(_onMoveToWishlist);
    on<ApplyPromoCode>(_onApplyPromoCode);
    on<RemovePromoCode>(_onRemovePromoCode);
    on<MergeCart>(_onMergeCart);
    on<ClearToast>(_onClearToast);
    on<ClearPromoActionSheet>(_onClearPromoActionSheet);
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

  void setPendingMoveToWishlist(MoveToWishlist event) =>
      _pendingMoveToWishlist = event;

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
      GetCartParams(instantCheckout: instantCheckout, cancelToken: token),
    );
    result.fold(
      (failure) {
        if (failure is RequestCancelledFailure) return;
        emit(
          CartState(status: CartStatus.error, errorMessage: failure.message),
        );
      },
      (cart) => emit(
        CartState(
          status: CartStatus.loaded,
          cart: cart,
          staticMessageBars: staticBars,
        ),
      ),
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
  Future<void> _onRefreshCart(
    RefreshCart event,
    Emitter<CartState> emit,
  ) async {
    final token = swapCancelToken();
    final staticBars = await _staticMessageBars();
    final result = await getCartUseCase(
      GetCartParams(instantCheckout: instantCheckout, cancelToken: token),
    );
    result.fold(
      // Silently ignore the failure — keep current cart data visible — but
      // still bump refreshTick so a pull-to-refresh spinner awaiting it stops.
      // A cancelled request is the exception: a newer load owns the UI now.
      (failure) {
        if (failure is RequestCancelledFailure) return;
        emit(state.copyWith(refreshTick: state.refreshTick + 1));
      },
      (cart) => emit(
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
      ),
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
  static int _indexOfItem(
    List<CartItemEntity> items, {
    required String sku,
    int? hint,
  }) {
    if (hint != null &&
        hint >= 0 &&
        hint < items.length &&
        items[hint].sku == sku) {
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
    add(const RefreshCart());
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
  Future<void> _onRemoveCartItem(
    RemoveCartItem event,
    Emitter<CartState> emit,
  ) async {
    final current = state;
    if (current.isLoaded) {
      emit(
        current.copyWith(
          pendingItemAction: (sku: event.sku, action: CartItemAction.remove),
        ),
      );
    }
    final token = swapCancelToken();
    final result = await removeCartItemUseCase(
      RemoveCartItemParams(
        sku: event.sku,
        instantCheckout: instantCheckout,
        cancelToken: token,
      ),
    );
    result.fold(
      (failure) {
        // Unlike the other mutations, a cancelled remove still has to clear the
        // pending action — the sheet would otherwise sit there spinning
        // forever, waiting for a call that will never answer.
        if (!current.isLoaded) {
          if (failure is! RequestCancelledFailure) {
            emit(
              current.copyWith(
                status: CartStatus.error,
                errorMessage: failure.message,
              ),
            );
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
            toastMessage: _messageOr(
              failure.message,
              CartStrings.couldNotRemoveItem,
            ),
            toastIsError: true,
          ),
        );
      },
      // The sheet closes the moment this lands rather than after the refresh —
      // `message` is the server's own confirmation text (Android toasts
      // exactly this).
      (cart) {
        if (!current.isLoaded) return;
        _completeItemRemoval(
          emit,
          current,
          sku: event.sku,
          toastMessage: _messageOr(cart.message, CartStrings.itemRemoved),
        );
      },
    );
  }

  Future<void> _onUpdateCartItem(
    UpdateCartItemQuantity event,
    Emitter<CartState> emit,
  ) async {
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
          // A rejected step (cart item-limit, sold out, qty cap) must leave the
          // row on its OLD quantity and say why — silently dropping the spinner
          // reads as "nothing happened". `current` is pre-mutation state, so the
          // stepper snaps back on its own.
          emit(
            current.copyWith(
              pendingItemAction: null,
              isCartUpdating: false,
              toastMessage: failure.message,
              toastIsError: true,
              toastDuration: const Duration(seconds: 7),
            ),
          );
        } else {
          emit(
            current.copyWith(
              status: CartStatus.error,
              errorMessage: failure.message,
            ),
          );
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
        final index = _indexOfItem(
          items,
          sku: event.sku,
          hint: event.itemIndex,
        );
        if (index != -1) {
          items[index] = items[index].withQuantity(event.quantity);
        }

        emit(
          current.copyWith(
            pendingItemAction: null,
            isCartUpdating: false,
            cart: current.cart!.copyWith(items: items),
          ),
        );
        add(const RefreshCart());
      },
    );
  }

  Future<void> _onMoveToWishlist(
    MoveToWishlist event,
    Emitter<CartState> emit,
  ) async {
    final current = event.reloadCartFirst
        ? await _reloadCartBeforeMutation(emit)
        : state;
    if (current.isLoaded) {
      emit(
        current.copyWith(
          pendingItemAction: (
            sku: event.sku,
            action: CartItemAction.moveToWishlist,
          ),
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
          emit(
            current.copyWith(
              status: CartStatus.error,
              errorMessage: failure.message,
            ),
          );
        }
      },
      // The overlay lifts as soon as the move lands; the cart re-read that
      // follows is silent. Server message first, same as remove.
      (cart) {
        if (!current.isLoaded) return;
        _completeItemRemoval(
          emit,
          current,
          sku: event.sku,
          toastMessage: _messageOr(cart.message, CartStrings.movedToWishlist),
        );
      },
    );
  }

  /// The offer-code field applies through `POST /v3/promotion/apply`, the same
  /// endpoint the offers bottom sheet uses. That endpoint answers with only
  /// `{success, message}` — no cart — so the cart is re-read afterwards to pick
  /// up the new totals.
  Future<void> _onApplyPromoCode(
    ApplyPromoCode event,
    Emitter<CartState> emit,
  ) async {
    // A second tap while the first apply is still running would run the call
    // twice and answer with two sheets stacked on top of each other. The Apply
    // button already ignores taps while `isPromoLoading`, but the button is not
    // the only way in (keyboard submit, the post-login replay), so the guard
    // belongs here too.
    if (state.isPromoLoading) return;
    final current = event.reloadCartFirst
        ? await _reloadCartBeforeMutation(emit)
        : state;
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
          toastMessage: action.hasMessage ? action.message : null,
          promoActionSheet: sheet,
        );
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
  Future<void> _onRemovePromoCode(
    RemovePromoCode event,
    Emitter<CartState> emit,
  ) async {
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
        await _refreshAfterMutation(
          emit,
          current,
          toastMessage: action.hasMessage ? action.message : null,
          promoActionSheet: sheet,
        );
      },
    );
  }

  Future<void> _onMergeCart(MergeCart event, Emitter<CartState> emit) async {
    final current = state;
    if (current.isLoaded) {
      emit(current.copyWith(isMerging: true, isCartUpdating: true));
    }
    final token = swapCancelToken();
    final result = await mergeCartUseCase(MergeCartParams(cancelToken: token));
    await result.fold((failure) {
      if (failure is RequestCancelledFailure) return;
      if (current.isLoaded) {
        emit(
          current.copyWith(
            isMerging: false,
            isCartUpdating: false,
            toastMessage: failure.message,
          ),
        );
      } else {
        emit(
          current.copyWith(
            status: CartStatus.error,
            errorMessage: failure.message,
          ),
        );
      }
    }, (_) async => _refreshAfterMutation(emit, current, isMergeCall: true));
  }

  void _onClearToast(ClearToast event, Emitter<CartState> emit) {
    // Reset the status and duration with the message, so a later toast can't
    // inherit stale error styling or the 10s hold.
    emit(
      state.copyWith(
        toastMessage: null,
        toastIsError: false,
        toastDuration: const Duration(seconds: 2),
      ),
    );
  }

  void _onClearPromoActionSheet(
    ClearPromoActionSheet event,
    Emitter<CartState> emit,
  ) {
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
      GetCartParams(instantCheckout: instantCheckout, cancelToken: token),
    );
    return result.fold((_) => state, (cart) {
      final reloaded = CartState(
        status: CartStatus.loaded,
        cart: cart,
        staticMessageBars: state.staticMessageBars,
      );
      emit(reloaded);
      return reloaded;
    });
  }

  Future<void> _refreshAfterMutation(
    Emitter<CartState> emit,
    CartState previousState, {
    bool isMergeCall = false,
    String? toastMessage,
    BackendActionContentEntity? promoActionSheet,
  }) async {
    final token = swapCancelToken();
    final result = await getCartUseCase(
      GetCartParams(
        isMergeCall: isMergeCall,
        instantCheckout: instantCheckout,
        cancelToken: token,
      ),
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
          emit(
            previousState.copyWith(
              status: CartStatus.error,
              errorMessage: failure.message,
            ),
          );
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
      },
    );
  }
}
