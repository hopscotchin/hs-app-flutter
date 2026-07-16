import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/cubits/cart_count_cubit.dart';
import '../../../../core/error/failures.dart';
import '../../domain/usecases/add_to_cart_usecase.dart';

part 'cart_actions_cubit.freezed.dart';
part 'cart_actions_state.dart';

/// An add-to-cart deferred because the user was logged out. Replayed by
/// [CartActionsCubit.resumePending] after a successful login.
class _PendingCart {
  const _PendingCart({required this.skuId, required this.quantity});
  final String skuId;
  final int quantity;
}

/// Global single source of truth for add-to-cart across PLP, PDP and discover.
/// Owns the shared "added" affordance and keeps the global [CartCountCubit] badge
/// in sync regardless of which screen performed the action.
@singleton
class CartActionsCubit extends Cubit<CartActionsState> {
  CartActionsCubit(this._addToCart, this._cartCountCubit)
    : super(const CartActionsState());

  final AddToCartUseCase _addToCart;
  final CartCountCubit _cartCountCubit;

  _PendingCart? _pending;

  /// Seed the "added" affordance for SKUs already in the bag (e.g. from a PDP
  /// load), so the button shows "GO TO BAG" without a tap.
  void markAdded(Iterable<String> skuIds) {
    final next = {...state.addedSkus, ...skuIds};
    if (next.length != state.addedSkus.length) {
      emit(state.copyWith(addedSkus: next));
    }
  }

  /// Reset the per-SKU "added" affordance on login/logout (the bag belongs to a
  /// specific user). Intentionally leaves [_pending] intact so a logged-out
  /// add-to-cart can still be replayed by [resumePending] right after login.
  void clearOnAuthChange() {
    if (state.addedSkus.isEmpty && state.inFlight.isEmpty) return;
    emit(state.copyWith(addedSkus: const <String>{}, inFlight: const <String>{}));
  }

  void setPending({required String skuId, int quantity = 1}) {
    _pending = _PendingCart(skuId: skuId, quantity: quantity);
  }

  void resumePending() {
    final p = _pending;
    _pending = null;
    if (p == null) return;
    add(skuId: p.skuId, quantity: p.quantity);
  }

  Future<void> add({required String skuId, int quantity = 1}) async {
    if (state.isInFlight(skuId)) return;
    emit(state.copyWith(inFlight: {...state.inFlight, skuId}));

    final result = await _addToCart(AddToCartParams(skuId: skuId, quantity: quantity));
    result.fold(
      (failure) {
        if (failure is RequestCancelledFailure) {
          emit(_clearInFlight(skuId));
          return;
        }
        emit(_clearInFlight(skuId));
        _emitFeedback(failure.message, isError: true);
      },
      (response) {
        if (response.cartItemQty != null) _cartCountCubit.set(response.cartItemQty!);
        emit(
          _clearInFlight(skuId).copyWith(addedSkus: {...state.addedSkus, skuId}),
        );
        _emitFeedback(response.message ?? 'Added to bag', isError: false);
      },
    );
  }

  CartActionsState _clearInFlight(String skuId) {
    return state.copyWith(inFlight: state.inFlight.where((s) => s != skuId).toSet());
  }

  void _emitFeedback(String message, {required bool isError}) {
    emit(
      state.copyWith(
        feedbackTick: state.feedbackTick + 1,
        feedbackMessage: message,
        feedbackIsError: isError,
      ),
    );
  }
}
