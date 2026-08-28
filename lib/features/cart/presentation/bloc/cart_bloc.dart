import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/base/base_bloc.dart';
import '../../../../core/constants/strings/cart_strings.dart';
import '../../../../core/entities/backend_action_entity.dart';
import '../../../../core/entities/message_bar_entity.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../promos_offers/domain/entities/promo_action_result_entity.dart';
import '../../../promos_offers/domain/entities/promo_offers_source.dart';
import '../../../promos_offers/domain/usecases/apply_promo_usecase.dart';
import '../../../promos_offers/domain/usecases/remove_promo_usecase.dart';
import '../../domain/entities/cart_entity.dart';
import '../../domain/entities/delivery_pincode_entity.dart';
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
    on<UpdateDeliveryPincode>(_onUpdateDeliveryPincode);
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
  Future<void> _onRefreshCart(
    RefreshCart event,
    Emitter<CartState> emit,
  ) async {
    final current = state;
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
        emit(current.copyWith(refreshTick: current.refreshTick + 1));
      },
      (cart) => emit(
        current.copyWith(
          status: CartStatus.loaded,
          cart: cart,
          staticMessageBars: staticBars,
          refreshTick: current.refreshTick + 1,
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

  /// Static bars are decorative — a failed read just means none are shown.
  Future<List<MessageBarEntity>> _staticMessageBars() async {
    final result = await getStaticMessageBarsUseCase(NoParams());
    return result.fold((_) => const [], (bars) => bars);
  }

  Future<void> _onRemoveCartItem(
    RemoveCartItem event,
    Emitter<CartState> emit,
  ) async {
    final current = state;
    if (current.isLoaded) {
      emit(current.copyWith(loadingItemSku: event.sku, isCartUpdating: true));
    }
    final token = swapCancelToken();
    final result = await removeCartItemUseCase(
      RemoveCartItemParams(sku: event.sku, instantCheckout: instantCheckout, cancelToken: token),
    );
    await result.fold(
      (failure) {
        if (failure is RequestCancelledFailure) return;
        if (current.isLoaded) {
          emit(current.copyWith(loadingItemSku: null, isCartUpdating: false));
        } else {
          emit(
            current.copyWith(
              status: CartStatus.error,
              errorMessage: failure.message,
            ),
          );
        }
      },
      // Remove API doesn't return full cart data — re-fetch
      (_) async => _refreshAfterMutation(emit, current),
    );
  }

  Future<void> _onUpdateCartItem(
    UpdateCartItemQuantity event,
    Emitter<CartState> emit,
  ) async {
    final current = state;
    if (current.isLoaded) {
      emit(current.copyWith(loadingItemSku: event.sku, isCartUpdating: true));
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
    await result.fold(
      (failure) {
        if (failure is RequestCancelledFailure) return;
        if (current.isLoaded) {
          emit(current.copyWith(loadingItemSku: null, isCartUpdating: false));
        } else {
          emit(
            current.copyWith(
              status: CartStatus.error,
              errorMessage: failure.message,
            ),
          );
        }
      },
      // Update-quantity API doesn't return full cart data — re-fetch
      (_) async => _refreshAfterMutation(emit, current),
    );
  }

  Future<void> _onMoveToWishlist(
    MoveToWishlist event,
    Emitter<CartState> emit,
  ) async {
    final current = event.reloadCartFirst ? await _reloadCartBeforeMutation(emit) : state;
    if (current.isLoaded) {
      emit(current.copyWith(loadingItemSku: event.sku, isCartUpdating: true));
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
    await result.fold(
      (failure) {
        if (failure is RequestCancelledFailure) return;
        if (current.isLoaded) {
          // Feedback matters more here than on the other mutations: the row
          // stays put on failure, so without a toast the tap looks ignored.
          emit(
            current.copyWith(
              loadingItemSku: null,
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
      // Move-to-wishlist API doesn't return full cart data — re-fetch
      (_) async => _refreshAfterMutation(emit, current, toastMessage: CartStrings.movedToWishlist),
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

  /// Matches Android CartViewModel.orderNow() logic:
  /// 1. refreshCartForRemovedItem → refresh cart with message
  /// 2. action == SUCCESS → open checkout bottom sheet
  /// 3. messageBars present → show them on cart
  /// 4. else → show error
  Future<void> _onProceedToCheckout(
    ProceedToCheckout event,
    Emitter<CartState> emit,
  ) async {}

  void _onClearToast(ClearToast event, Emitter<CartState> emit) {
    // Reset the status with the message, so a later success toast can't
    // inherit a stale error styling.
    emit(state.copyWith(toastMessage: null, toastIsError: false));
  }

  void _onClearPromoActionSheet(
    ClearPromoActionSheet event,
    Emitter<CartState> emit,
  ) {
    emit(state.copyWith(promoActionSheet: null));
  }

  /// Locally updates the delivery pincode — no backend endpoint exists for
  /// this yet, so it just patches the currently-loaded cart entity.
  void _onUpdateDeliveryPincode(
    UpdateDeliveryPincode event,
    Emitter<CartState> emit,
  ) {
    final current = state;
    if (!current.isLoaded) return;
    emit(
      current.copyWith(
        cart: current.cart!.copyWith(
          deliveryPincode: DeliveryPincodeEntity(pincode: event.pincode),
        ),
      ),
    );
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
      GetCartParams(isMergeCall: isMergeCall, instantCheckout: instantCheckout, cancelToken: token),
    );
    result.fold(
      (failure) {
        if (failure is RequestCancelledFailure) return;
        if (previousState.isLoaded) {
          emit(
            previousState.copyWith(
              loadingItemSku: null,
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
