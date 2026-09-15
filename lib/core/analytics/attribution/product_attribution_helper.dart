import 'package:injectable/injectable.dart';

import 'attribution_store.dart';
import 'product_attribution_data.dart';

/// Frozen slice of [ProductAttributionHelper] state for LIFO restore
/// around out-of-shell funnel excursions. Opaque to readers — construct
/// via [ProductAttributionHelper.snapshot], hand back via
/// [ProductAttributionHelper.restore].
class ProductAttributionSnapshot {
  const ProductAttributionSnapshot({
    required this.entries,
    required this.perScopeCount,
  });

  final List<ProductAttributionData> entries;
  final List<int> perScopeCount;
}

/// Nav-stack-aligned stack of PLP tile clicks — **in-memory only**. Newest
/// at front (index 0). Each entry is one tile tap taken while a PLP was on
/// top of the Navigator; every tap made from within that PLP scope is
/// discarded together when the PLP is popped, so the stack always mirrors
/// the live nav depth.
///
/// Scope lifecycle — driven by `AppNavigationObserver`:
/// - PLP pushed  → [beginPlpScope]
/// - PLP popped  → [endPlpScope] (drops every entry pushed inside)
///
/// Tile-tap sites outside a PLP (Discover home grid, deeplinks) call
/// [push] with no active scope; the push is a no-op there, matching the
/// user's PLP-centric attribution model.
///
/// Unbounded on purpose: forward journeys can be arbitrarily deep and no
/// entry is stale until its PLP is popped, so any cap would silently
/// drop context the reader still needs.
///
/// [segmentParams] spreads the top entry's `trackingMeta` — the click
/// that led to the current screen — onto every attribution-carrying
/// event via `AnalyticsHelper._commonEventProperties`.
@lazySingleton
class ProductAttributionHelper implements AttributionStore {
  ProductAttributionHelper();

  final List<ProductAttributionData> _entries = <ProductAttributionData>[];

  /// Push count per active PLP scope. Top-of-list is the current PLP; its
  /// counter is decremented on every [push] and used to bulk-pop on
  /// [endPlpScope].
  final List<int> _perScopeCount = <int>[];

  List<ProductAttributionData> get entries => List.unmodifiable(_entries);

  bool get isEmpty => _entries.isEmpty;

  /// **PLP pushed onto nav.** Opens a new scope; every subsequent [push]
  /// belongs to this scope until [endPlpScope].
  void beginPlpScope() => _perScopeCount.add(0);

  /// **PLP popped from nav.** Closes the top scope and drops every entry
  /// pushed inside it. No-op when no scope is active (defensive against a
  /// stray PLP pop the observer didn't pair).
  void endPlpScope() {
    if (_perScopeCount.isEmpty) return;
    final count = _perScopeCount.removeLast();
    for (var i = 0; i < count; i++) {
      if (_entries.isEmpty) break;
      _entries.removeAt(0);
    }
  }

  /// **Tile click.** Push the merged blob onto the top of the stack. Two
  /// gates: an empty blob is ignored (mis-configured record), and a push
  /// with no active PLP scope is ignored (tap made outside a PLP — Discover
  /// home grid, a deeplinked screen, etc.).
  void push(Map<String, dynamic> trackingMeta) {
    if (trackingMeta.isEmpty) return;
    if (_perScopeCount.isEmpty) return;
    _entries.insert(
      0,
      ProductAttributionData(trackingMeta: Map<String, dynamic>.of(trackingMeta)),
    );
    _perScopeCount[_perScopeCount.length - 1]++;
  }

  /// Wipe everything. Called by `AppNavigationObserver._applyFunnel` on
  /// every funnel transition so a new funnel starts with a clean stack.
  void clear() {
    _entries.clear();
    _perScopeCount.clear();
  }

  /// Take a point-in-time snapshot for LIFO restore. Paired with [restore]
  /// by `AppNavigationObserver` around out-of-shell funnel pushes
  /// (Search / Cart) so a `PLP → Search → back → PLP` round-trip
  /// preserves the tile-click stack that `_applyFunnel` wipes.
  @override
  Object? snapshot() => ProductAttributionSnapshot(
        entries: List<ProductAttributionData>.of(_entries),
        perScopeCount: List<int>.of(_perScopeCount),
      );

  /// Replace state with [snapshot]. `null` restores to empty. Used by the
  /// observer's `_restoreAttributionIfFunnelRoute`.
  @override
  void restore(Object? snapshot) {
    final s = snapshot as ProductAttributionSnapshot?;
    _entries
      ..clear()
      ..addAll(s?.entries ?? const <ProductAttributionData>[]);
    _perScopeCount
      ..clear()
      ..addAll(s?.perScopeCount ?? const <int>[]);
  }

  /// Segment payload — the top entry's `trackingMeta`, spread verbatim.
  /// Composed into every attribution-carrying event via
  /// `AnalyticsHelper._commonEventProperties`, alongside
  /// `OrderAttributionHelper.segmentParams` and
  /// `LpAttributionHelper.segmentParams`.
  Map<String, Object?> get segmentParams {
    if (_entries.isEmpty) return const <String, Object?>{};
    return Map<String, Object?>.of(_entries.first.trackingMeta);
  }
}
