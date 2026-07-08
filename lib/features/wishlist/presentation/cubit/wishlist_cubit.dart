import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/usecases/add_to_wishlist_usecase.dart';
import '../../domain/usecases/remove_from_wishlist_usecase.dart';

part 'wishlist_cubit.freezed.dart';
part 'wishlist_state.dart';

/// One product's current server membership, used to seed the store (the
/// backend-authoritative status) from any listing/detail response.
class WishlistSeed {
  const WishlistSeed({required this.productId, required this.wished, this.wishlistItemId});
  final String productId;
  final bool wished;
  final String? wishlistItemId;
}

/// A wishlist toggle deferred because the user was logged out. Replayed by
/// [WishlistCubit.resumePending] after a successful login.
class _PendingWishlist {
  const _PendingWishlist({required this.productId, required this.price, this.sku});
  final String productId;
  final int price;
  final String? sku;
}

/// Global single source of truth for "is this product wishlisted". Every screen
/// reads membership from here (via `context.select`) and dispatches toggles here,
/// so a change on one screen is reflected on all of them.
@singleton
class WishlistCubit extends Cubit<WishlistState> {
  WishlistCubit(this._addToWishlist, this._removeFromWishlist)
      : super(const WishlistState());

  final AddToWishlistUseCase _addToWishlist;
  final RemoveFromWishlistUseCase _removeFromWishlist;

  _PendingWishlist? _pending;

  /// Ids the user has explicitly toggled this session. This cubit is the only
  /// writer of wishlist membership, so once the user acts on a product our
  /// local state is authoritative and later [seed]s (which carry the *original*
  /// listing/detail response status — stale after a toggle) must not override
  /// it. Without this, a re-seed of already-rendered items (PLP pagination,
  /// carousel element recycling) would silently revert the user's heart.
  /// Cleared on auth change so a new user never inherits it.
  final Set<String> _userTouched = <String>{};

  /// Apply server-known statuses. The backend is authoritative for products the
  /// user hasn't touched, so a (re)load overwrites our state by id — except for
  /// (a) a product whose toggle is still in flight (would flicker if a response
  /// generated before the write arrives mid-call), and (b) a product the user
  /// has explicitly toggled this session (see [_userTouched]).
  void seed(Iterable<WishlistSeed> seeds) {
    final next = Map<String, String?>.from(state.items);
    var changed = false;
    for (final s in seeds) {
      if (state.inFlight.contains(s.productId) || _userTouched.contains(s.productId)) continue;
      if (s.wished) {
        if (!next.containsKey(s.productId) || next[s.productId] != s.wishlistItemId) {
          next[s.productId] = s.wishlistItemId;
          changed = true;
        }
      } else if (next.containsKey(s.productId)) {
        next.remove(s.productId);
        changed = true;
      }
    }
    if (changed) emit(state.copyWith(items: next));
  }

  /// Store a toggle to replay after login (user tapped while logged out).
  void setPending({required String productId, required int price, String? sku}) {
    _pending = _PendingWishlist(productId: productId, price: price, sku: sku);
  }

  /// Replay the toggle captured in [setPending], if any.
  void resumePending() {
    final p = _pending;
    _pending = null;
    if (p == null) return;
    toggle(productId: p.productId, price: p.price, sku: p.sku);
  }

  /// Drop the previous user's state on login/logout so we never briefly show
  /// their wishlist; the next responses re-seed with the current user's data.
  void invalidateOnAuthChange() {
    _userTouched.clear();
    emit(state.copyWith(items: const <String, String?>{}, inFlight: const <String>{}));
  }

  Future<void> toggle({required String productId, required int price, String? sku}) async {
    if (state.isInFlight(productId)) return;

    // The user acted on this product — local state now wins over any later seed.
    _userTouched.add(productId);

    final wasWishlisted = state.items.containsKey(productId);
    final existingItemId = state.items[productId];

    final optimistic = Map<String, String?>.from(state.items);
    if (wasWishlisted) {
      optimistic.remove(productId);
    } else {
      optimistic[productId] = null;
    }
    emit(state.copyWith(items: optimistic, inFlight: {...state.inFlight, productId}));

    if (wasWishlisted) {
      await _remove(productId: productId, wishlistItemId: existingItemId);
    } else {
      await _add(productId: productId, price: price, sku: sku);
    }
  }

  Future<void> _add({required String productId, required int price, String? sku}) async {
    final result = await _addToWishlist(
      AddToWishlistParams(productId: productId, price: price, skuId: sku),
    );
    result.fold(
          (failure) {
        if (failure is RequestCancelledFailure) return;
        final reverted = Map<String, String?>.from(state.items)..remove(productId);
        emit(_clearInFlight(productId, items: reverted));
        _emitFeedback("Couldn't add to wishlist", isError: true);
      },
          (response) {
        final updated = Map<String, String?>.from(state.items)
          ..[productId] = response.wishlistItemId;
        emit(_clearInFlight(productId, items: updated));
        _emitFeedback('Added to wishlist', isError: false);
      },
    );
  }

  Future<void> _remove({required String productId, required String? wishlistItemId}) async {
    if (wishlistItemId == null || wishlistItemId.isEmpty) {
      // Membership known but no item id to delete with — restore and report.
      final reverted = Map<String, String?>.from(state.items)..[productId] = wishlistItemId;
      emit(_clearInFlight(productId, items: reverted));
      _emitFeedback("Couldn't remove from wishlist", isError: true);
      return;
    }
    final result = await _removeFromWishlist(
      RemoveFromWishlistParams(wishlistId: wishlistItemId),
    );
    result.fold(
          (failure) {
        if (failure is RequestCancelledFailure) return;
        final reverted = Map<String, String?>.from(state.items)..[productId] = wishlistItemId;
        emit(_clearInFlight(productId, items: reverted));
        _emitFeedback("Couldn't remove from wishlist", isError: true);
      },
          (_) {
        emit(_clearInFlight(productId));
        _emitFeedback('Removed from wishlist', isError: false);
      },
    );
  }

  WishlistState _clearInFlight(String productId, {Map<String, String?>? items}) {
    return state.copyWith(
      items: items ?? state.items,
      inFlight: state.inFlight.where((id) => id != productId).toSet(),
    );
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
