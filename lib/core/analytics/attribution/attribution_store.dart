/// Contract every attribution store must implement so
/// `AppNavigationObserver` can snapshot & LIFO-restore them uniformly on
/// out-of-shell funnel excursions (PLP → Search/Cart → back).
///
/// Snapshots are opaque: the observer treats them as `Object?`, hands them
/// back to the store on restore, and the store casts to its own frozen
/// shape. Callers should never `is`-check across stores.
///
/// Adding a new attribution store is two touches:
///   1. `implements AttributionStore` on the helper + a private snapshot
///      shape.
///   2. Register the helper in `AppNavigationObserver._funnelScopedStores`.
abstract interface class AttributionStore {
  /// Frozen snapshot of the store's current state. `null` is a legitimate
  /// snapshot value (means "no state at that moment") and MUST round-trip
  /// through [restore] without side effects.
  Object? snapshot();

  /// Replace state with [snapshot]. Passing `null` restores the store to
  /// its empty state. Implementations cast to the specific snapshot type
  /// they returned; a store that receives a snapshot from a different
  /// store is a programmer error and will throw.
  void restore(Object? snapshot);
}
