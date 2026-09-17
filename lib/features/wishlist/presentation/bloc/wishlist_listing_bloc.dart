import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_defaults.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/analytics/events/analytics_helper.dart';
import '../../../../core/analytics/events/modules/wishlist_events.dart';
import '../../../../core/base/base_bloc.dart';
import '../../../../core/constants/strings/wishlist_strings.dart';
import '../../../../core/cubits/cart_count_cubit.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/wishlist_page_entity.dart';
import '../../domain/entities/wishlist_product_entity.dart';
import '../../domain/usecases/get_wishlist_page_usecase.dart';
import '../../domain/usecases/move_to_cart_usecase.dart';
import '../../domain/usecases/remove_from_wishlist_usecase.dart';

part 'wishlist_listing_bloc.freezed.dart';
part 'wishlist_listing_event.dart';
part 'wishlist_listing_state.dart';

/// BLoC for the wishlist listing screen.
///
/// Responsibilities:
///  - Load / refresh / paginate the wishlist grid.
///  - Remove a single item (delete icon) via [RemoveFromWishlistUseCase].
///  - Move a single item to the bag (CTA): add its SKU to the cart, then drop
///    it from the wishlist. Both per-item actions track the affected product
///    id in [WishlistListingState.processingIds] so the tile can show progress.
///
/// Per-item actions do NOT use [swapCancelToken]: their use cases are not
/// cancellable and several rows may act concurrently, so cancelling siblings
/// would be wrong. Only the paginated list handlers manage a cancel token.
@injectable
class WishlistListingBloc
    extends BaseBloc<WishlistListingEvent, WishlistListingState> {
  final GetWishlistPageUseCase _getWishlistPage;
  final RemoveFromWishlistUseCase _removeFromWishlist;
  final MoveToCartUseCase _moveToCart;
  final CartCountCubit _cartCountCubit;
  final AnalyticsHelper _analytics;

  /// Analytics screen that opened this wishlist — supplied by [LoadWishlist]
  /// and reused on paginated wishlist_viewed emits.
  String? _fromScreen;

  WishlistListingBloc(
    this._getWishlistPage,
    this._removeFromWishlist,
    this._moveToCart,
    this._cartCountCubit,
    this._analytics,
  ) : super(const WishlistListingState()) {
    on<LoadWishlist>(_onLoad);
    on<RefreshWishlist>(_onRefresh);
    on<LoadNextWishlistPage>(_onLoadNextPage);
    on<RemoveWishlistItem>(_onRemoveItem);
    on<MoveWishlistItemToBag>(_onMoveToBag);
    on<ClearWishlistMessage>(_onClearMessage);
  }

  Future<void> _onLoad(
    LoadWishlist event,
    Emitter<WishlistListingState> emit,
  ) async {
    _fromScreen = event.fromScreen;
    emit(const WishlistListingState(status: WishlistStatus.loading));
    final token = swapCancelToken();

    final result = await _getWishlistPage(
      GetWishlistPageParams(pageNo: 1, cancelToken: token),
    );

    result.fold(
      (failure) {
        if (failure is RequestCancelledFailure) return;
        emit(
          WishlistListingState(
            status: WishlistStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (page) {
        emit(
          WishlistListingState(
            status: WishlistStatus.success,
            page: page,
            currentPage: 1,
          ),
        );
        // Every payload key (feed_size included) comes from the response's
        // opaque trackingMeta; funnel keys are merged by the helper from the
        // attribution stores. Fire-and-forget — the user shouldn't wait on
        // the network queue.
        unawaited(
          _analytics.logWishlistViewed(
            trackingMetaChain: [page.trackingMeta],
            fromScreen: _fromScreen,
          ),
        );
      },
    );
  }

  Future<void> _onRefresh(
    RefreshWishlist event,
    Emitter<WishlistListingState> emit,
  ) async {
    add(LoadWishlist(fromScreen: _fromScreen));
  }

  Future<void> _onLoadNextPage(
    LoadNextWishlistPage event,
    Emitter<WishlistListingState> emit,
  ) async {
    if (state.status != WishlistStatus.success ||
        state.hasReachedEnd ||
        state.isLoadingMore) {
      return;
    }

    final current = state;
    final nextPage = current.currentPage + 1;
    emit(current.copyWith(isLoadingMore: true));
    final token = swapCancelToken();

    final result = await _getWishlistPage(
      GetWishlistPageParams(pageNo: nextPage, cancelToken: token),
    );

    result.fold(
      (failure) {
        if (failure is RequestCancelledFailure) return;
        emit(current.copyWith(isLoadingMore: false, message: failure.message));
      },
      (next) {
        emit(
          current.copyWith(
            isLoadingMore: false,
            page: current.page!.merge(next),
            currentPage: nextPage,
          ),
        );
        // Android emits `wishlist_viewed` from its shared load path
        // (`WishlistViewModel.loadWishlist`), which `loadMoreItems()` routes
        // through — so pagination re-fires it. Mirrored here, carrying the
        // fetched page's own blob.
        unawaited(
          _analytics.logWishlistViewed(
            trackingMetaChain: [next.trackingMeta],
            fromScreen: _fromScreen,
          ),
        );
      },
    );
  }

  Future<void> _onRemoveItem(
    RemoveWishlistItem event,
    Emitter<WishlistListingState> emit,
  ) async {
    final id = event.item.id;
    final wishlistId = event.item.wishlistId;
    if (wishlistId == null) {
      emit(state.copyWith(message: WishlistStrings.actionFailed));
      return;
    }
    if (state.isProcessing(id)) return;

    emit(state.copyWith(processingIds: _withId(state, id)));

    final result = await _removeFromWishlist(
      RemoveFromWishlistParams(wishlistId: wishlistId),
    );

    // Read latest state after the await: a sibling per-item action may have
    // mutated processingIds / page in the meantime.
    result.fold(
      (failure) {
        if (failure is RequestCancelledFailure) return;
        emit(
          state.copyWith(
            processingIds: _withoutId(state, id),
            message: failure.message,
          ),
        );
      },
      (popUpMessage) {
        emit(
          state.copyWith(
            page: state.page?.removeById(id),
            processingIds: _withoutId(state, id),
            message: popUpMessage ?? WishlistStrings.removedFromWishlist,
          ),
        );
        // Page blob first, then the record's own — the record wins on a key
        // clash. Every payload key comes from the backend.
        unawaited(
          _analytics.logProductRemovedFromWishlist(
            productId: event.item.product.id.toString(),
            fromScreen: FromScreens.wishlist,
            fromLocation: FromLocations.wishlistProduct,
            trackingMeta: state.page?.trackingMeta,
            skuTrackingMeta: event.item.product.trackingMeta,
          ),
        );
      },
    );
  }

  Future<void> _onMoveToBag(
    MoveWishlistItemToBag event,
    Emitter<WishlistListingState> emit,
  ) async {
    final id = event.item.id;
    // Size picked in the sheet wins over the wishlisted SKU.
    final sku = event.skuId ?? event.item.moveToBagSku;
    if (!event.item.canMoveToBag || sku == null || sku.isEmpty) {
      emit(state.copyWith(message: WishlistStrings.productUnavailable));
      return;
    }
    // The API keys the move on the wishlist entry, not the product.
    final wishlistItemId = event.item.wishlistId;
    if (wishlistItemId == null) {
      emit(state.copyWith(message: WishlistStrings.actionFailed));
      return;
    }
    if (state.isProcessing(id)) return;

    emit(state.copyWith(processingIds: _withId(state, id)));

    // One call does both halves server-side (add to cart + drop from wishlist).
    final result = await _moveToCart(
      MoveToCartParams(wishlistItemId: wishlistItemId, skuId: sku),
    );

    result.fold(
      (failure) {
        if (failure is RequestCancelledFailure) return;
        // failure.message is the API's popUpMessage when it sent one.
        emit(
          state.copyWith(
            processingIds: _withoutId(state, id),
            message: failure.message,
          ),
        );
      },
      (moved) {
        // Keep the bag badge in step with the count the API reports.
        final qty = moved.cartItemQty;
        if (qty != null) _cartCountCubit.set(qty);
        // Page → record → picked SKU, deepest wins. The SKU blob is what
        // carries the size/price keys for the moved line.
        unawaited(
          _analytics.logProductMovedToBag(
            trackingMetaChain: [
              state.page?.trackingMeta,
              event.item.product.trackingMeta,
              _skuTrackingMeta(event.item, sku),
            ],
          ),
        );
        emit(
          state.copyWith(
            page: state.page?.removeById(id),
            processingIds: _withoutId(state, id),
            message: WishlistStrings.movedToBag,
          ),
        );
      },
    );
  }

  Future<void> _onClearMessage(
    ClearWishlistMessage event,
    Emitter<WishlistListingState> emit,
  ) async {
    emit(state.copyWith(message: null));
  }

  /// Analytics blob of the SKU actually moved to the bag, when the response
  /// carried one for it.
  Map<String, dynamic>? _skuTrackingMeta(WishlistProductEntity item, String skuId) {
    for (final s in item.skus) {
      if (s.skuId == skuId) return s.trackingMeta;
    }
    return null;
  }

  Set<int> _withId(WishlistListingState s, int id) => {...s.processingIds, id};

  Set<int> _withoutId(WishlistListingState s, int id) =>
      s.processingIds.where((e) => e != id).toSet();
}
