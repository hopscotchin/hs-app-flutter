// lib/components/spring_bottom_nav_bar.dart
//
// iOS-style spring bottom navigation — interaction fidelity port.
// Wraps itself in a rounded white capsule (margin, border, shadow) so it can
// be dropped straight into a Scaffold's floatingActionButton slot.
//
// ── Architecture ──────────────────────────────────────────────────────────────
//
//  SpringNavController  (ChangeNotifier)
//    └─ Owns an unbounded AnimationController whose VALUE IS the dragFloat.
//       dragFloat ∈ [0, N-1]: fractional tab index.
//       Moving it 1.0→2.0 simultaneously shrinks tab 1 and expands tab 2.
//       A single spring drives both — no independent per-tab animations —
//       that shared driver is what produces the liquid / shared-element feel.
//
//  SpringBottomNavBar  (StatefulWidget)
//    └─ LayoutBuilder → GestureDetector → ListenableBuilder → Row of _NavTile
//       LayoutBuilder  : provides barWidth for responsive width math.
//       GestureDetector: one detector covers the whole bar (tap + long-drag).
//       ListenableBuilder: rebuilds only the Row on each spring tick.
//
//  _NavTile  (StatelessWidget)
//    └─ Pure function of [expansion] ∈ [0,1].  No local AnimationController.
//       Icon widget is supplied by caller via NavBarItem.buildIcon, so any
//       asset type (IconData, SVG, image, badge overlay) is supported.
//
// ── Width invariant ───────────────────────────────────────────────────────────
//
//  expansion[i] = clamp(1 − |i − dragFloat|, 0, 1)
//  width[i]     = base + bonus × expansion[i]
//  base         = (barWidth − bonus) / N
//
//  Between adjacent tabs A and B at fraction f:
//    expansion[A] = 1-f,  expansion[B] = f  → Σ expansions = 1
//    Σ widths = N×base + bonus×1 = barWidth                          ✓
//
// ── Gesture mapping ───────────────────────────────────────────────────────────
//
//  Equal-slot mapping (barWidth/N per tab) is used for drag position:
//    dragFloat = x×N/barWidth − 0.5
//  Tap uses actual animated widths so the wider active tab is a larger target.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:hs_app_flutter/core/theme/colors.dart';
import 'package:hs_app_flutter/core/theme/spacing.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Spring tuning
// ─────────────────────────────────────────────────────────────────────────────

// ζ = damping / (2√(mass × stiffness)) = 50 / (2√500) ≈ 1.12
// Slightly over-damped: fast settle with zero overshoot.
// Prevents the adjacent-tab flash caused by dragFloat overshooting the
// target integer and briefly giving the next tab a positive expansion.
const _kSpring = SpringDescription(mass: 1.0, stiffness: 500.0, damping: 50.0);

// Visual gap between adjacent tab tiles. Tap math still treats the bar as
// equal slots — small enough (vs. tile width) that the slight skew is
// imperceptible at touch granularity.
const double _kTileSpacing = 30.0;

// ─────────────────────────────────────────────────────────────────────────────
// Data model
// ─────────────────────────────────────────────────────────────────────────────

class NavBarItem {
  const NavBarItem({required this.buildIcon, required this.label});

  /// Called inside _NavTile.build — receives the tile's BuildContext (usable
  /// with context.watch), the interpolated color, and whether the tab is
  /// past the active threshold (expansion ≥ 0.5).
  final Widget Function(BuildContext context, Color color, bool isActive)
  buildIcon;
  final String label;
}

// ─────────────────────────────────────────────────────────────────────────────
// Controller
// ─────────────────────────────────────────────────────────────────────────────

/// Single source of truth for all nav bar visual state.
///
/// [dragFloat] is the fractional tab index that drives everything:
///   Tap       → spring-animates dragFloat to the target integer.
///   Drag      → dragFloat tracks the finger position directly.
///   Release   → springs to nearest integer, inheriting current velocity.
class SpringNavController extends ChangeNotifier {
  SpringNavController({
    required TickerProvider vsync,
    required this.itemCount,
    int initialIndex = 0,
  }) : _selectedIndex = initialIndex {
    // Unbounded so value can travel freely across [0, N-1].
    _ctrl = AnimationController.unbounded(vsync: vsync)
      ..value = initialIndex.toDouble()
      ..addListener(notifyListeners);
  }

  final int itemCount;
  int _selectedIndex;
  bool _isDragging = false;
  // Tap mode: animate only `_tapFromIndex` → `_selectedIndex`, skipping any
  // intermediate tabs the spring sweeps through. Without this, tapping Home(0)
  // → Account(3) makes Categories(1) and Search(2) flash on as dragFloat
  // passes their integer positions.
  bool _tapMode = false;
  int _tapFromIndex = 0;
  double _barWidth = 0;
  late final AnimationController _ctrl;
  // Pre-allocated so expansions never creates a new List per animation tick.
  late final List<double> _expansionCache = List.filled(itemCount, 0.0);

  int get selectedIndex => _selectedIndex;
  bool get isDragging => _isDragging;

  /// Fractional tab index, clamped to valid range.
  double get dragFloat => _ctrl.value.clamp(0.0, itemCount - 1.0);

  /// Per-tab expansion in [0, 1].
  /// Drag mode: adjacency math — expansion[A] + expansion[B] = 1 for adjacent A,B.
  /// Tap mode: only the from/to tabs receive expansion; intermediates stay 0.
  /// Returns the same List instance every call — callers must not hold a ref.
  List<double> get expansions {
    final v = dragFloat;
    if (_tapMode && _tapFromIndex != _selectedIndex) {
      final from = _tapFromIndex;
      final to = _selectedIndex;
      final progress = ((v - from) / (to - from)).clamp(0.0, 1.0);
      for (var i = 0; i < itemCount; i++) {
        _expansionCache[i] = i == from
            ? 1.0 - progress
            : i == to
            ? progress
            : 0.0;
      }
    } else {
      for (var i = 0; i < itemCount; i++) {
        _expansionCache[i] = (1.0 - (i - v).abs()).clamp(0.0, 1.0);
      }
    }
    return _expansionCache;
  }

  void updateBarWidth(double w) => _barWidth = w;

  /// Tap: spring to [index], inheriting in-flight velocity for natural feel.
  void selectTab(int index) {
    if (_selectedIndex == index && !_isDragging) return;
    _isDragging = false;
    _tapMode = true;
    _tapFromIndex = _selectedIndex;
    _selectedIndex = index;
    _springTo(index.toDouble());
    HapticFeedback.selectionClick();
  }

  /// Long-press start: freeze current spring, enter direct tracking.
  /// mediumImpact signals to the user that drag mode is now active.
  void dragStart(Offset local) {
    _ctrl.stop();
    _isDragging = true;
    _tapMode = false;
    _ctrl.value = _xToFloat(local.dx);
    HapticFeedback.mediumImpact();
  }

  /// Long-press move: raw position — no spring during active drag.
  void dragUpdate(Offset local) {
    if (!_isDragging) return;
    final f = _xToFloat(local.dx);
    _ctrl.value = f;
    _checkCrossover(f);
  }

  /// Long-press end: snap to nearest tab via spring, inherit finger velocity.
  /// Passing velocity makes the snap a continuation, not a sudden correction.
  void dragEnd() {
    _isDragging = false;
    final target = dragFloat.round().clamp(0, itemCount - 1);
    _selectedIndex = target;
    _springTo(target.toDouble(), v: _ctrl.velocity);
    HapticFeedback.selectionClick();
  }

  void _springTo(double target, {double v = 0.0}) =>
      _ctrl.animateWith(SpringSimulation(_kSpring, _ctrl.value, target, v));

  void _checkCrossover(double f) {
    final nearest = f.round().clamp(0, itemCount - 1);
    if (nearest != _selectedIndex) {
      _selectedIndex = nearest;
      HapticFeedback.selectionClick();
      // notifyListeners() omitted — _ctrl.value = f in dragUpdate already
      // fired it via addListener(notifyListeners). Calling it again would
      // cause a double rebuild on the same frame.
    }
  }

  // Equal-slot mapping: slot i center at (i+0.5)×W/N → dragFloat = x×N/W − 0.5
  double _xToFloat(double x) {
    if (_barWidth == 0) return _selectedIndex.toDouble();
    return (x * itemCount / _barWidth - 0.5).clamp(0.0, itemCount - 1.0);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Main widget
// ─────────────────────────────────────────────────────────────────────────────

class SpringBottomNavBar extends StatefulWidget {
  const SpringBottomNavBar({
    super.key,
    required this.items,
    required this.onTabSelected,
    this.initialIndex = 0,
    this.height = 64.0,
    this.backgroundColor = Colors.white,
    this.activeColor = Colors.black,
    this.inactiveColor = const Color(0xFF8E8E93),
    // Optional decoration applied to each tile, driven by its expansion value.
    // e.g. (e) => BoxDecoration(color: Color.lerp(transparent, highlight, e))
    this.tileDecoration,
  }) : assert(
         items.length >= 2 && items.length <= 6,
         'SpringBottomNavBar: provide between 2 and 6 items',
       );

  final List<NavBarItem> items;
  final ValueChanged<int> onTabSelected;
  final int initialIndex;
  final double height;
  final Color backgroundColor;
  final Color activeColor;
  final Color inactiveColor;
  final BoxDecoration? Function(double expansion)? tileDecoration;

  @override
  State<SpringBottomNavBar> createState() => _SpringBottomNavBarState();
}

class _SpringBottomNavBarState extends State<SpringBottomNavBar>
    with SingleTickerProviderStateMixin {
  late final SpringNavController _controller;
  double _barWidth = 0;
  late int _lastReported;

  // ── Long-press-drag via Listener (not GestureDetector) ──────────────────
  //
  // GestureDetector.onLongPress* competes in the gesture arena. The active
  // tab's page content (scrollables, etc.) can win and swallow the event.
  // Listener is non-competitive — it receives every raw pointer event,
  // regardless of the arena outcome. This fixes drag on the active tab.
  Timer? _pressTimer;
  bool _dragActive = false;
  bool _pointerMoved = false;
  Offset _downPos = Offset.zero;
  int? _trackedPointer; // guards against secondary touches mid-gesture

  // Slightly faster than Flutter's default 500 ms — feels snappier.
  static const _kLongPressDuration = Duration(milliseconds: 400);
  // Horizontal movement (px) required to trigger drag without waiting for the timer.
  static const _kHorizontalThreshold = 6.0;
  // Non-horizontal movement (px) that cancels the pending long-press entirely.
  static const _kSlop = 18.0;

  @override
  void initState() {
    super.initState();
    _lastReported = widget.initialIndex;
    _controller = SpringNavController(
      vsync: this,
      itemCount: widget.items.length,
      initialIndex: widget.initialIndex,
    );
  }

  @override
  void didUpdateWidget(SpringBottomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only react to *external* changes — not the parent rebuild caused by our
    // own onTabSelected callback. Without this guard, every drag crossover
    // would echo back through the parent and call selectTab(), which sets
    // _isDragging = false and aborts the gesture mid-drag.
    if (oldWidget.initialIndex != widget.initialIndex &&
        widget.initialIndex != _lastReported) {
      _controller.selectTab(widget.initialIndex);
      _lastReported = widget.initialIndex;
    }
  }

  @override
  void dispose() {
    _pressTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  // ── Raw pointer handlers ─────────────────────────────────────────────────

  void _onPointerDown(PointerDownEvent e) {
    if (_trackedPointer != null) return;
    _trackedPointer = e.pointer;
    _downPos = e.localPosition;
    _dragActive = false;
    _pointerMoved = false;
    _pressTimer = Timer(_kLongPressDuration, () {
      if (!mounted) return;
      _dragActive = true;
      _controller.dragStart(_downPos);
    });
  }

  void _onPointerMove(PointerMoveEvent e) {
    if (e.pointer != _trackedPointer) return;

    if (_dragActive) {
      _controller.dragUpdate(e.localPosition);
      _syncCallback();
      return;
    }

    if (_pointerMoved) return;

    final delta = e.localPosition - _downPos;
    final absDx = delta.dx.abs();
    final absDy = delta.dy.abs();

    if (absDx >= _kHorizontalThreshold && absDx >= absDy * 1.5) {
      // Predominantly horizontal swipe → enter drag immediately, no timer wait.
      _pressTimer?.cancel();
      _pressTimer = null;
      _dragActive = true;
      _controller.dragStart(_downPos);
      _controller.dragUpdate(e.localPosition);
      _syncCallback();
    } else if (delta.distance > _kSlop) {
      // Vertical or diagonal movement → not a drag, cancel long-press.
      _pointerMoved = true;
      _pressTimer?.cancel();
      _pressTimer = null;
    }
  }

  void _onPointerUp(PointerUpEvent e) {
    if (e.pointer != _trackedPointer) return;
    _trackedPointer = null;
    _pressTimer?.cancel();
    _pressTimer = null;
    if (_dragActive) {
      _controller.dragEnd();
      _syncCallback();
      _dragActive = false;
    } else if (!_pointerMoved) {
      _onTap(e.localPosition.dx);
    }
  }

  void _onPointerCancel(PointerCancelEvent e) {
    if (e.pointer != _trackedPointer) return;
    _trackedPointer = null;
    _pressTimer?.cancel();
    _pressTimer = null;
    if (_dragActive) {
      _controller.dragEnd();
      _dragActive = false;
    }
  }

  // ── Tap / commit ─────────────────────────────────────────────────────────

  void _onTap(double localX) {
    final idx = (localX / _barWidth * widget.items.length).floor().clamp(
      0,
      widget.items.length - 1,
    );
    _commit(idx);
  }

  void _commit(int index) {
    _controller.selectTab(index);
    if (index != _lastReported) {
      _lastReported = index;
      widget.onTabSelected(index);
    }
  }

  void _syncCallback() {
    final idx = _controller.selectedIndex;
    if (idx != _lastReported) {
      _lastReported = idx;
      widget.onTabSelected(idx);
    }
  }

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 13),
      height: widget.height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.baseDefault,
        borderRadius: BorderRadius.circular(20),
        border: BoxBorder.all(color: AppColors.neutralGrey1, width: 1),
        // Figma: dy 25, stdDeviation 18.85, ~2% black. The big blur with the
        // near-transparent colour gives the bar a soft, lifted feel without a
        // visible drop shadow.
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 37.7,
            offset: Offset(0, 25),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSpacing.xxs),
      child: LayoutBuilder(
        builder: (ctx, constraints) {
          _barWidth = constraints.maxWidth;
          _controller.updateBarWidth(_barWidth);

          return Listener(
            behavior: HitTestBehavior.opaque,
            onPointerDown: _onPointerDown,
            onPointerMove: _onPointerMove,
            onPointerUp: _onPointerUp,
            onPointerCancel: _onPointerCancel,
            // RepaintBoundary isolates the animated row into its own GPU layer
            // so the parent (Scaffold, page body) never repaints on each tick.
            child: RepaintBoundary(
              child: ColoredBox(
                color: widget.backgroundColor,
                child: ListenableBuilder(
                  listenable: _controller,
                  builder: (_, _) {
                    final exps = _controller.expansions;
                    return Row(
                      spacing: _kTileSpacing,
                      children: [
                        for (int i = 0; i < widget.items.length; i++)
                          Expanded(
                            child: _NavTile(
                              item: widget.items[i],
                              expansion: exps[i],
                              activeColor: widget.activeColor,
                              inactiveColor: widget.inactiveColor,
                              tileDecoration: widget.tileDecoration,
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tile
// ─────────────────────────────────────────────────────────────────────────────

// Constant fields extracted so _NavTile.build only creates a new TextStyle
// for the one field that changes per frame (color).
// Not using AppTypographyV1.labelMedium because animated widgets rebuilding every frame as performance is significant
const _kNavLabelBase = TextStyle(
  fontSize: 10,
  fontWeight: FontWeight.w600,
  letterSpacing: 0.2,
  height: 1.0,
);

/// Pure function of [expansion] ∈ [0, 1]. No local state, no controllers.
///
/// Animation decisions:
///   icon color — fixed (inactiveColor). The Figma design keeps the icon
///                lavender in both states; only the label switches purple.
///   label color — lerp(inactive → active): continuous, no threshold snap.
///   pill        — fills the whole tile; the tile width itself (set by the
///                 outer Row spacing) defines the capsule's footprint.
class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.item,
    required this.expansion,
    required this.activeColor,
    required this.inactiveColor,
    this.tileDecoration,
  });

  final NavBarItem item;
  final double expansion;
  final Color activeColor;
  final Color inactiveColor;
  final BoxDecoration? Function(double expansion)? tileDecoration;

  @override
  Widget build(BuildContext context) {
    final labelColor = Color.lerp(inactiveColor, activeColor, expansion)!;

    return Container(
      decoration: tileDecoration?.call(expansion),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          item.buildIcon(context, inactiveColor, expansion >= 0.5),
          const SizedBox(height: 8),
          Text(
            item.label,
            style: _kNavLabelBase.copyWith(color: labelColor),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
