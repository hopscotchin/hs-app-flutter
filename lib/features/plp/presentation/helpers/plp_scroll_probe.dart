import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../domain/helpers/plp_scroll_payload.dart';
import '../../domain/helpers/plp_scroll_tracker.dart';

/// Samples "how deep is the user in the list" off the product sliver's real
/// geometry and feeds [PlpScrollTracker].
///
/// ## Why this is not a per-frame cost
///
/// A `ScrollController`/`ScrollNotification` fires on **every** frame of a
/// scroll — 60 to 120 times a second. Anything non-trivial on that path shows
/// up as jank, so this probe is built around three cheap-outs, in order:
///
/// 1. **Distance gate.** Returns immediately unless the viewport moved at least
///    [_minSampleDelta] since the last sample. At a typical fling that is a
///    handful of samples per second instead of one per frame.
/// 2. **Backwards walk.** [_lastVisibleIndex] starts at `lastChild` and walks
///    *up*, so it stops after one or two iterations. Walking down from
///    `firstChild` costs the full visible run every time.
/// 3. **Bounded population.** `RenderSliverMultiBoxAdaptor` only keeps children
///    inside the viewport plus its cache extent, so the walk is over ~2-8
///    children regardless of whether the list holds 20 products or 3,000. This
///    is O(visible), never O(list).
///
/// The work left on the hot path after those is a null check and a subtraction.
///
/// ## Row heights
///
/// Heights are recorded opportunistically as rows pass through the viewport,
/// because the tracker needs the height of a row *after* it has scrolled out of
/// the laid-out window. A row missed entirely (possible on a violent fling)
/// falls back to the last height seen, which is right for the two-up rows that
/// dominate the list and approximate for XL tiles. That is a deliberate trade:
/// the alternative is laying out off-screen children purely to measure them.
class PlpScrollProbe {
  PlpScrollProbe({required this.sliverKey}) {
    tracker = PlpScrollTracker(rowHeight: _rowHeight);
  }

  /// Key on the product sliver, so the probe can reach its render object.
  final GlobalKey sliverKey;

  late final PlpScrollTracker tracker;

  /// Minimum viewport movement, in logical pixels, between samples. Roughly a
  /// tenth of a product row — small enough that no row is skipped at ordinary
  /// speed, large enough to skip most frames.
  static const double _minSampleDelta = 24;

  final Map<int, double> _rowHeights = <int, double>{};
  double _lastKnownRowHeight = 0;
  double? _lastSampledPixels;
  double _displayWidth = 0;

  /// Geometry the depth maths needs, in the same unit as the recorded row
  /// heights (logical pixels). Set from the page — see [plpScaledRowHeight] for
  /// why only self-consistency matters, not the unit itself.
  ///
  /// [collapsingHeader] is the full expanded height of a header above the list
  /// and [headerCollapseOffset] the scroll offset at which it is fully
  /// collapsed; both default to "no header". Android folds the app bar's height
  /// into the depth **once, when it collapses**, and never removes it on
  /// re-expand — `ProductsListingActivity:1862` has a `COLLAPSED` branch with
  /// no `EXPANDED` counterpart. Only the boutique listing has such a header;
  /// the standard PLP toolbar floats and contributes nothing.
  void configure({
    required double displayWidth,
    double collapsingHeader = 0,
    double headerCollapseOffset = 0,
  }) {
    _displayWidth = displayWidth;
    _collapsingHeader = collapsingHeader;
    _headerCollapseOffset = headerCollapseOffset;
  }

  double _collapsingHeader = 0;
  double _headerCollapseOffset = 0;
  bool _headerCounted = false;

  /// Row heights reach the tracker already normalised, so `scrolled_height`
  /// accumulates in Android's 375-wide reference unit rather than raw pixels.
  /// Scaling on read (not on record) keeps the cache in device units, so a
  /// width change — rotation, split screen — rescales past rows too.
  double _rowHeight(int index) => plpScaledRowHeight(
    _rowHeights[index] ?? _lastKnownRowHeight,
    _displayWidth,
  ).toDouble();

  /// Hook for `NotificationListener<ScrollNotification>`. Never consumes the
  /// notification — callers keep their own handling (pagination, and so on).
  void onScrollNotification(ScrollNotification notification) {
    final metrics = notification.metrics;
    if (metrics.axis != Axis.vertical) return;

    final pixels = metrics.pixels;
    final last = _lastSampledPixels;
    if (last != null && (pixels - last).abs() < _minSampleDelta) return;
    _lastSampledPixels = pixels;

    // Only a real user drag or its fling counts as scrolling; the programmatic
    // jump back to 0 on a filter reload must not mark the page as scrolled.
    if (notification is ScrollUpdateNotification && notification.dragDetails != null) {
      tracker.setScrolled();
    }

    _countHeaderOnceCollapsed(pixels);

    final index = _lastVisibleIndex();
    if (index != null) tracker.onScrolledItemChanged(_rowsSeen(index));
  }

  /// Deepest row index (0-based) → number of rows seen (1-based), which is what
  /// the tracker counts.
  ///
  /// Android derives the same figure from the item position:
  /// `ceil((lastVisibleItemPosition + 1) / 2f)` (`ListItemsScrollManager:38`)
  /// — with two products per row, item 3 is row 2. Our sliver children *are*
  /// rows, so the conversion is just the off-by-one.
  int _rowsSeen(int deepestRowIndex) => deepestRowIndex + 1;

  /// Registers the rows visible on first paint as "reached", without counting
  /// them as scrolled.
  ///
  /// Needed because a user who opens a listing and immediately leaves produces
  /// no scroll notification at all, so the tracker would report an empty window
  /// and the payload would fall into `plpScrollRange`'s `start == 0 &&
  /// end == 0` branch — which reports **the entire loaded page**. Android does
  /// not do that: its bounce payload lists only the products that fit on
  /// screen, because its window already ends at the last visible row while
  /// `scrolled_row` is still 0.
  ///
  /// [PlpScrollTracker.recalculateViewHeight] is the mechanism that separates
  /// the two — Android's own (`ScrollTrackingHelper:157`). Passing the same
  /// value for both arguments moves `_lastScrolledRowIndex` to the visible
  /// depth while leaving `_scrolledRowCount` and `_maxScrolledHeight` at 0, so
  /// the bounce still reports `scrolled_row: 0` and `scrolled_height: 0` and
  /// only the *range* narrows.
  ///
  /// Safe to call repeatedly; it no-ops once the user has actually scrolled, so
  /// it cannot rewind a real window.
  void seedInitialViewport() {
    if (_seeded || tracker.hasScrolled) return;
    final index = _lastVisibleIndex();
    if (index == null) return;
    _seeded = true;
    final rows = _rowsSeen(index);
    tracker.recalculateViewHeight(rows, rows);
  }

  bool _seeded = false;

  /// Folds the header into the depth the first time it collapses, normalised
  /// the same way rows are — Android scales this term too
  /// (`ceil(375 * appBarLayout.measuredHeight / displayWidth)`), unlike the
  /// hsplp module which adds it raw.
  void _countHeaderOnceCollapsed(double pixels) {
    if (_headerCounted || _collapsingHeader <= 0) return;
    if (_headerCollapseOffset <= 0 || pixels < _headerCollapseOffset) return;
    _headerCounted = true;
    tracker.setExtraRowData(
      rows: 0,
      height: plpScaledRowHeight(_collapsingHeader, _displayWidth).toDouble(),
    );
  }

  /// Resets the sampling gate after the list is replaced under us, so the first
  /// notification of the new list always samples.
  void onListReplaced() => _lastSampledPixels = null;

  /// Index of the deepest laid-out child whose top edge is inside the viewport,
  /// recording heights as it goes. Null while geometry is not ready.
  int? _lastVisibleIndex() {
    final renderObject = sliverKey.currentContext?.findRenderObject();
    if (renderObject is! RenderSliverMultiBoxAdaptor) return null;
    if (renderObject.geometry?.visible != true) return null;

    final constraints = renderObject.constraints;
    final viewportBottom =
        constraints.scrollOffset + constraints.remainingPaintExtent;

    // One pass over the laid-out children — a handful of them — recording every
    // height on the way. Walking the whole (tiny) population rather than
    // breaking early keeps the height cache complete, which matters more than
    // the two or three iterations it saves.
    int? deepest;
    RenderBox? child = renderObject.lastChild;
    while (child != null) {
      final parentData = child.parentData! as SliverMultiBoxAdaptorParentData;
      final index = parentData.index;
      final childStart = parentData.layoutOffset;

      if (index != null) {
        final height = child.size.height;
        if (height > 0) {
          _rowHeights[index] = height;
          _lastKnownRowHeight = height;
        }
        if (childStart != null &&
            childStart <= viewportBottom &&
            (deepest == null || index > deepest)) {
          deepest = index;
        }
      }
      child = renderObject.childBefore(child);
    }
    return deepest;
  }
}
