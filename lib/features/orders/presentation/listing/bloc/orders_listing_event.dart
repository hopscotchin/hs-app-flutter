part of 'orders_listing_bloc.dart';

/// Every event names the tab it acts on, because one bloc owns both.
///
/// That is forced by the rule that `BlocProvider` may only live in the route
/// file: a provider per tab inside the `TabBarView` is not an option, so the
/// single bloc keeps a [TabListingState] for each and the tab travels on the
/// event rather than being implied by which instance received it.
@freezed
sealed class OrdersListingEvent with _$OrdersListingEvent {
  /// Load page 1 from scratch. Shows the shimmer.
  const factory OrdersListingEvent.load(OrdersTab tab) = LoadListing;

  /// Silent reload of page 1 — no loading flag, so the current list stays on
  /// screen under the pull-to-refresh spinner. Bumps `refreshTick` on success
  /// *and* failure so the page can await completion.
  const factory OrdersListingEvent.refresh(OrdersTab tab) = RefreshListing;

  /// Append the next page. Ignored unless the tab is loaded, has more, and is
  /// not already fetching.
  const factory OrdersListingEvent.loadNextPage(OrdersTab tab) =
      LoadNextListingPage;

  /// The user moved to another tab. Loads it on first visit; otherwise just
  /// records the change, since each tab keeps its own state.
  const factory OrdersListingEvent.switchTab(OrdersTab tab) = SwitchListingTab;

  /// Clears the one-shot pagination error after the snackbar has shown.
  const factory OrdersListingEvent.clearPaginationError(OrdersTab tab) =
      ClearListingPaginationError;
}
