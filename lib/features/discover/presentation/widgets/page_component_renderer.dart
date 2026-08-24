import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../components/page_components/custom_tiles_widget.dart';
import '../../../../components/page_components/hero_carousel_widget.dart';
import '../../../../components/page_components/page_carousel_widget.dart';
import '../../../../components/page_components/product_grid_widget.dart';
import '../../../../core/analytics/home/home_track_analytic_manager.dart';
import '../../../../core/di/injection.dart';
import '../../data/models/component_models.dart';
import '../../domain/entities/home_page_entity.dart';
import '../../../../core/constants/strings/auto_test_strings.dart';

/// Threshold: mark impression when at least this fraction of the component
/// sits inside the viewport. Matches "1 full + 1 half-visible" spec —
/// anything less counts as peeking, not an impression.
const double _kVisibilityThreshold = 0.5;

/// Fallback for widgets taller than the viewport: `visibleFraction` is
/// bounded by `viewport / widgetHeight`, so tall PRODUCT_GRIDs (20+ tiles ≈
/// 10 rows, ~3000px) never approach [_kVisibilityThreshold]. Fire as soon
/// as roughly one product row is on screen — small enough to catch tall
/// grids on first scroll, large enough that a 1-pixel peek during scroll
/// past a boundary doesn't count as an impression.
const double _kViewportCoverageThreshold = 0.15;

class PageComponentRenderer extends StatefulWidget {
  final PageComponent component;

  /// The component's index in the enclosing `pageComponents` list. Passed
  /// through to [HomeTrackAnalyticManager.notifyVisible] as the impression
  /// key. We use the list index rather than [PageComponent.position] because
  /// the JSON `position` field defaults to `0` when the backend omits it —
  /// which would collapse every component into a single visibility bucket
  /// and drop all but the first impression.
  final int index;

  /// Host page prefix for automation keys: `hp` for home, `lp_<pageName>` for
  /// a landing page. Null disables keying (component renders without keys).
  final String? pagePrefix;

  const PageComponentRenderer({
    super.key,
    required this.component,
    this.index = 0,
    this.pagePrefix,
  });

  /// Composes the component-level key prefix, e.g. `hp_pg_2`. Returns null when
  /// no page prefix is supplied or the component type has no abbreviation.
  String? _keyPrefix() {
    final page = pagePrefix;
    if (page == null) return null;
    final abbrev = switch (component.type) {
      PageComponentType.hero => HomeComponentTestStrings.hero,
      PageComponentType.customTiles => HomeComponentTestStrings.customTiles,
      PageComponentType.productGrid => HomeComponentTestStrings.productGrid,
      PageComponentType.pageCarousel => HomeComponentTestStrings.pageCarousel,
      _ => null,
    };
    if (abbrev == null) return null;
    return '${page}_${abbrev}_$index';
  }

  @override
  State<PageComponentRenderer> createState() => _PageComponentRendererState();
}

class _PageComponentRendererState extends State<PageComponentRenderer> {
  /// Was this widget above the visibility threshold on the previous
  /// callback? Impressions fire on the rising edge (`false → true`);
  /// falling edges just flip the flag so a later re-entry can fire again
  /// (matches the "re-visited items re-log after a direction change" rule
  /// — the tracker's direction-snapshot handles whether it actually emits).
  bool _wasAboveThreshold = false;

  ScrollPosition? _scrollPosition;
  double _viewportHeight = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Hand the scroll position to the tracker so it can detect scroll
    // direction and pivot the "already-in-viewport" snapshot at each
    // direction change. Idempotent — no-ops if the same position is
    // already attached.
    final position = Scrollable.maybeOf(context)?.position;
    if (position != null && !identical(_scrollPosition, position)) {
      _scrollPosition = position;
      sl<HomeTrackAnalyticManager>().attachScrollPosition(position);
    }
    // Cache viewport height here (auto-refreshes on orientation / split-
    // screen resize via didChangeDependencies) so the visibility callback
    // is a field read, not an InheritedModel lookup.
    _viewportHeight = MediaQuery.maybeSizeOf(context)?.height ?? 0;
  }

  @override
  void didUpdateWidget(covariant PageComponentRenderer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index != widget.index ||
        oldWidget.component.type != widget.component.type) {
      // Slot reassigned to a different component — release the previous
      // index's tracking so the tracker's currently-visible set stays
      // accurate.
      if (_wasAboveThreshold) {
        sl<HomeTrackAnalyticManager>().notifyInvisible(oldWidget.index);
      }
      _wasAboveThreshold = false;
    }
  }

  @override
  void dispose() {
    if (_wasAboveThreshold) {
      // Widget is being torn down while still visible — inform the tracker
      // so a later re-mount (e.g. list rebuilt from a fresh fetch) can
      // fire a fresh impression instead of being treated as still-visible.
      sl<HomeTrackAnalyticManager>().notifyInvisible(widget.index);
    }
    super.dispose();
  }

  /// [VisibilityDetector] callback. Fires whenever the visible fraction
  /// (widget bounds ∩ ancestor clip rects) crosses the throttle interval
  /// configured on [VisibilityDetectorController] (100ms — set in
  /// `main.dart` so we don't miss initial-viewport items on fast opens).
  ///
  /// We only forward RISING and FALLING edges through the 0.5 threshold,
  /// so the tracker doesn't churn on tiny fraction wiggles during scroll.
  void _onVisibilityChanged(VisibilityInfo info) {
    final viewportCoverage = _viewportHeight > 0
        ? info.visibleBounds.height / _viewportHeight
        : 0;
    final isAbove = info.visibleFraction > _kVisibilityThreshold ||
        viewportCoverage > _kViewportCoverageThreshold;
    if (isAbove == _wasAboveThreshold) return;
    final tracker = sl<HomeTrackAnalyticManager>();
    if (isAbove) {
      tracker.notifyVisible(widget.index);
    } else {
      tracker.notifyInvisible(widget.index);
    }
    _wasAboveThreshold = isAbove;
  }

  @override
  Widget build(BuildContext context) {
    final parsed = widget.component.parsedData;
    final margins = widget.component.margins;
    final keyPrefix = widget._keyPrefix();

    // Each widget handles horizontal + inner margins internally.
    // Renderer only applies top/bottom outer spacing.
    final child = switch (widget.component.type) {
      PageComponentType.hero => _buildHero(parsed, margins, keyPrefix),
      PageComponentType.customTiles => _buildCustomTiles(parsed, margins, keyPrefix),
      PageComponentType.productGrid => _buildProductGrid(parsed, margins, keyPrefix),
      PageComponentType.pageCarousel => _buildPageCarousel(parsed, margins, keyPrefix),
      _ => const SizedBox.shrink(),
    };

    final wrapped = margins == null
        ? child
        : Padding(
      padding: EdgeInsets.only(top: margins.top, bottom: margins.bottom),
      child: child,
    );

    return VisibilityDetector(
      // Key must be unique per slot AND stable across rebuilds. `index`
      // alone is unique per slot; combining with `type` guards against
      // API reshuffles where the same index changes component type.
      key: Key('page-component-${widget.index}-${widget.component.type}'),
      onVisibilityChanged: _onVisibilityChanged,
      child: wrapped,
    );
  }

  Widget _buildHero(Object? parsed, ComponentMargins? margins, String? keyPrefix) {
    final data = parsed is HeroCarouselData
        ? parsed
        : widget.component.data != null
        ? ComponentDataParser.parseHero(widget.component.data!)
        : null;
    if (data == null) return const SizedBox.shrink();
    return HeroCarouselWidget(
      heroData: data,
      margins: margins,
      keyPrefix: keyPrefix,
      componentIndex: widget.index,
    );
  }

  Widget _buildCustomTiles(Object? parsed, ComponentMargins? margins, String? keyPrefix) {
    final data = parsed is CustomTilesData
        ? parsed
        : widget.component.data != null
        ? ComponentDataParser.parseCustomTiles(widget.component.data!)
        : null;
    if (data == null) return const SizedBox.shrink();
    return CustomTilesWidget(tilesData: data, margins: margins, keyPrefix: keyPrefix);
  }

  Widget _buildProductGrid(Object? parsed, ComponentMargins? margins, String? keyPrefix) {
    final data = parsed is ProductGridData
        ? parsed
        : widget.component.data != null
        ? ComponentDataParser.parseProductGrid(widget.component.data!)
        : null;
    if (data == null) return const SizedBox.shrink();
    return ProductGridWidget(gridData: data, margins: margins, keyPrefix: keyPrefix);
  }

  Widget _buildPageCarousel(Object? parsed, ComponentMargins? margins, String? keyPrefix) {
    final data = parsed is PageCarouselData
        ? parsed
        : widget.component.data != null
        ? ComponentDataParser.parsePageCarousel(widget.component.data!)
        : null;
    if (data == null) return const SizedBox.shrink();
    return PageCarouselWidget(carouselData: data, margins: margins, keyPrefix: keyPrefix);
  }
}
