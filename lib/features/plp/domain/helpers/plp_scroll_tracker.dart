import '../../../../core/analytics/constants/analytics_properties.dart';

/// Dart port of Android's `common/.../helper/ScrollTrackingHelper.java`, the
/// accumulator behind `plp_scrolled`.
///
/// ## What it measures
///
/// Not "where is the user now" but **how far down the list they ever got**.
/// The counters only ever move forward: scrolling back up does not decrement
/// [scrolledRow] or [scrolledHeight]. That is why the class keeps its own
/// running totals instead of reading them off the scroll position — a user who
/// scrolls to row 40 and back to row 2 has still seen 40 rows, and the event
/// must say so.
///
/// ## Why heights are accumulated row by row
///
/// [onScrolledItemChanged] walks one index at a time rather than jumping
/// straight to the new index, because each row contributes its *own* height —
/// an XL tile is much taller than a two-up product row. Skipping intermediate
/// rows would undercount `scrolled_height` on a fast fling. The walk is bounded
/// by rows actually traversed, so a fling over 30 rows costs 30 cheap
/// iterations once, not per frame.
///
/// ## The `isUnScrolled && isUnSent` case
///
/// [scrollDepthParams] deliberately returns a map for a listing the user never
/// scrolled, exactly once (`ScrollTrackingHelper.java:74`). A bounced visit is
/// signal — it reports `from_row: 1`, `scrolled_row: 0`, `scrolled_height: 0`.
/// After that first read `isUnSent` flips and an unscrolled page goes quiet.
///
/// Callers must therefore gate on "did the tracker return params", never on a
/// "did the user scroll" flag of their own.
class PlpScrollTracker {
  PlpScrollTracker({required this.rowHeight});

  /// Height of the row at an index, in logical pixels. Mirrors Android's
  /// `ScrollDepthCalculator.getItemHeight`. Return 0 for rows that should not
  /// contribute height (headers).
  final double Function(int rowIndex) rowHeight;

  int _lastScrolledRowIndex = 0;
  int _startScrolledItemIndex = 0;
  int _scrolledRowCount = 0;
  double _maxScrolledHeight = 0;

  int _extraRowCount = 0;
  double _extraRowHeight = 0;

  bool _isUnScrolled = true;
  bool _isUnSent = true;

  /// Rows excluded from the *count* — Android uses this for interleaved
  /// non-product rows. Their height still counts when
  /// [countHeightForExcludedRows] is true, which is Android's default.
  final Set<int> _excludedRows = <int>{};
  bool countHeightForExcludedRows = true;

  /// Raw index of the deepest row reached. `getRawEndIndex()`.
  int get rawEndIndex => _lastScrolledRowIndex;

  /// `getStartScrollIndex()` — where this reporting window began.
  int get startScrollIndex => _startScrolledItemIndex + _extraRowCount;

  /// `getEndScrollIndex()`.
  int get endScrollIndex => _lastScrolledRowIndex + _extraRowCount;

  /// `getScrolledRowCount()`.
  int get scrolledRow => _scrolledRowCount + _extraRowCount;

  /// `getMaxScrolledHeight()`, floored at 0 as `getScrolledHeight()` does.
  double get scrolledHeight =>
      (_maxScrolledHeight + _extraRowHeight).clamp(0, double.infinity);

  /// `getFromRow()` — 1-based, and 1 until the window has actually moved.
  int get fromRow => _startScrolledItemIndex <= 0 ? 1 : startScrollIndex;

  int get extraRowCount => _extraRowCount;

  /// Extra rows that exist above the tracked list (Android: banner/header rows
  /// the list itself does not own). Folded into every derived figure.
  void setExtraRowData({required int rows, required double height}) {
    _extraRowCount = rows;
    _extraRowHeight = height;
  }

  void excludePosition(int rowIndex) => _excludedRows.add(rowIndex);

  void removeExcludedPosition(int rowIndex) => _excludedRows.remove(rowIndex);

  /// Marks that real scrolling happened — flips the unscrolled latch so the
  /// zero-depth report is no longer the thing being described.
  void setScrolled() => _isUnScrolled = false;

  /// Whether a real drag has happened. Read by the probe so seeding the
  /// initial viewport cannot rewind a window the user has already moved.
  bool get hasScrolled => !_isUnScrolled;

  /// The deepest visible row moved to [newRowIndex]. No-ops when the index is
  /// not deeper than what we have already seen, which is what makes scrolling
  /// back up a no-op rather than a decrement.
  ///
  /// Mirrors `onScrolledItemChanged` (`:138`) including its quirk that an
  /// excluded row still contributes height when
  /// [countHeightForExcludedRows] is set.
  void onScrolledItemChanged(int newRowIndex) {
    if (newRowIndex <= _lastScrolledRowIndex) return;
    while (newRowIndex > _lastScrolledRowIndex) {
      _lastScrolledRowIndex++;
      final excluded = _excludedRows.contains(_lastScrolledRowIndex);
      if (!excluded) {
        _scrolledRowCount++;
        _maxScrolledHeight += rowHeight(_lastScrolledRowIndex);
      } else if (countHeightForExcludedRows) {
        _maxScrolledHeight += rowHeight(_lastScrolledRowIndex);
      }
    }
  }

  /// Opens a new reporting window at the current depth. Android calls this
  /// straight after sending, so the next event reports the *next* stretch of
  /// list rather than repeating everything from row 1.
  void resetStartScrollIndex() {
    _startScrolledItemIndex = _lastScrolledRowIndex;
  }

  /// `recalculateViewHeight` — used when the list is rebuilt underneath the
  /// tracker (filter or sort reload) and previously counted heights no longer
  /// describe the rows at those indices.
  void recalculateViewHeight(int newStartPosition, int lastPosition) {
    _scrolledRowCount = 0;
    _maxScrolledHeight = 0;
    _lastScrolledRowIndex = newStartPosition;
    onScrolledItemChanged(lastPosition);
  }

  /// The `from_row` / `scrolled_row` / `scrolled_height` block, or `null` when
  /// there is nothing to report.
  ///
  /// Returns non-null when the window advanced, **or** on the first read of a
  /// never-scrolled page. Reading it consumes the unscrolled allowance, so this
  /// is not a pure getter — call it once per send, matching Android where
  /// `getScrollDepthParams()` flips `isUnSent`.
  ///
  /// `scrolled_height` is omitted when it is 0 *unless* this is the
  /// never-scrolled report, so a genuine zero still ships there — the one place
  /// the drop rule is deliberately bypassed (`ScrollTrackingHelper.java:88`).
  Map<String, Object?>? consumeScrollDepthParams() {
    final advanced = _lastScrolledRowIndex > _startScrolledItemIndex;
    final firstUnscrolledReport = _isUnScrolled && _isUnSent;
    if (!advanced && !firstUnscrolledReport) return null;

    final data = <String, Object?>{
      AnalyticsProperties.fromRow: fromRow,
      AnalyticsProperties.scrolledRow: scrolledRow,
    };
    if (scrolledHeight != 0 || firstUnscrolledReport) {
      data[AnalyticsProperties.scrolledHeight] = scrolledHeight.round();
    }

    _isUnSent = false;
    return data;
  }
}
