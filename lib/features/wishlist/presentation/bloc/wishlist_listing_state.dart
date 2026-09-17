part of 'wishlist_listing_bloc.dart';

enum WishlistStatus { initial, loading, success, error }

@freezed
abstract class WishlistListingState with _$WishlistListingState {
  const factory WishlistListingState({
    @Default(WishlistStatus.initial) WishlistStatus status,
    WishlistPageEntity? page,
    @Default(1) int currentPage,
    String? errorMessage,
    @Default(false) bool isLoadingMore,
    // One-shot effect field for per-item action results and pagination
    // errors, surfaced as a snackbar and cleared by the listener.
    String? message,
    // Product ids with an in-flight remove / move-to-bag action.
    @Default(<int>{}) Set<int> processingIds,
  }) = _WishlistListingState;
}

extension WishlistListingStateX on WishlistListingState {
  List<WishlistProductEntity> get items => page?.items ?? const [];
  bool get hasReachedEnd => page?.hasReachedEnd ?? false;
  bool isProcessing(int id) => processingIds.contains(id);
}
