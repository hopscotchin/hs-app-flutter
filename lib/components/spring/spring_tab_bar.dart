import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:hs_app_flutter/core/theme/typography/text_style_extensions.dart';
import 'package:hs_app_flutter/core/theme/typography/typography_v1.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';

// ζ = 56 / (2√600) ≈ 1.14 — slightly over-damped: fast settle, zero overshoot.
const _kTabSpring = SpringDescription(
  mass: 1.0,
  stiffness: 600.0,
  damping: 56.0,
);

const _kPillRadius = BorderRadius.all(Radius.circular(2));

// ─── Data model ───────────────────────────────────────────────────────────────

/// A single tab entry for [SpringTabBar].
///
/// Provide only [label] for the default text-pill rendering (w700 active,
/// w400 inactive, colour-interpolated).
///
/// Provide [buildContent] to replace the entire tile with any widget.
/// It receives [expansion] ∈ [0,1] and [isActive] (expansion ≥ 0.5) so the
/// caller can drive colour, size, opacity, or any other visual from the spring.
class SpringTabItem {
  const SpringTabItem({required this.label, this.buildContent});

  final String label;

  /// Custom tile builder. When non-null, the default text pill is skipped.
  /// [expansion] is the continuous spring value ∈ [0,1].
  /// [isActive] is true once expansion crosses 0.5.
  final Widget Function(BuildContext context, double expansion, bool isActive)?
  buildContent;
}

// ─── Widget ───────────────────────────────────────────────────────────────────

class SpringTabBar extends StatefulWidget {
  const SpringTabBar({
    super.key,
    required this.items,
    required this.initialIndex,
    required this.onTabSelected,
    this.backgroundColor,
    this.backgroundImageUrl,
    this.isImageDark = false,
  });

  final List<SpringTabItem> items;
  final int initialIndex;
  final ValueChanged<int> onTabSelected;

  /// Solid background color. Ignored when [backgroundImageUrl] is set.
  final Color? backgroundColor;

  /// Network image URL used as the bar's background. Takes priority over [backgroundColor].
  final String? backgroundImageUrl;
  final bool isImageDark;

  @override
  State<SpringTabBar> createState() => _SpringTabBarState();
}

class _SpringTabBarState extends State<SpringTabBar>
    with SingleTickerProviderStateMixin {
  // ── Spring controller ─────────────────────────────────────────────────────
  late final AnimationController _ctrl;
  // Two base styles pre-computed once — only color is swapped per frame.
  late final TextStyle _activeStyle;
  late final TextStyle _inactiveStyle;
  int _selectedIndex = 0;
  double _barWidth = 0;

  void _springTo(double target, {double v = 0.0}) =>
      _ctrl.animateWith(SpringSimulation(_kTabSpring, _ctrl.value, target, v));

  // ── Gesture state ─────────────────────────────────────────────────────────
  Timer? _pressTimer;
  bool _dragActive = false;
  bool _pointerMoved = false;
  Offset _downPos = Offset.zero;
  int? _trackedPointer;
  int _lastReported = 0;

  static const _kLongPressDuration = Duration(milliseconds: 400);
  static const _kHorizontalThreshold = 6.0;
  static const _kSlop = 18.0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _lastReported = widget.initialIndex;
    _ctrl = AnimationController.unbounded(vsync: this)
      ..value = widget.initialIndex.toDouble();
    _activeStyle = AppTypographyV1.bodyLarge.bold;
    _inactiveStyle = AppTypography.bodyLarge.regular;
  }

  @override
  void dispose() {
    _pressTimer?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  // ── Pointer handlers ──────────────────────────────────────────────────────

  void _onPointerDown(PointerDownEvent e) {
    if (_trackedPointer != null) return;
    _trackedPointer = e.pointer;
    _downPos = e.localPosition;
    _dragActive = false;
    _pointerMoved = false;
    _pressTimer = Timer(_kLongPressDuration, () {
      if (!mounted) return;
      _ctrl.stop();
      _ctrl.value = _xToFloat(_downPos.dx);
      _dragActive = true;
      HapticFeedback.mediumImpact();
    });
  }

  void _onPointerMove(PointerMoveEvent e) {
    if (e.pointer != _trackedPointer) return;
    if (_dragActive) {
      _ctrl.value = _xToFloat(e.localPosition.dx);
      _checkCrossover();
      _syncCallback();
      return;
    }
    if (_pointerMoved) return;
    final delta = e.localPosition - _downPos;
    final absDx = delta.dx.abs();
    final absDy = delta.dy.abs();
    if (absDx >= _kHorizontalThreshold && absDx >= absDy * 1.5) {
      _pressTimer?.cancel();
      _pressTimer = null;
      _ctrl.stop();
      _ctrl.value = _xToFloat(_downPos.dx);
      _dragActive = true;
      HapticFeedback.mediumImpact();
      _ctrl.value = _xToFloat(e.localPosition.dx);
      _checkCrossover();
      _syncCallback();
    } else if (delta.distance > _kSlop) {
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
      _dragActive = false;
      final target = _ctrl.value.round().clamp(0, widget.items.length - 1);
      _selectedIndex = target;
      _springTo(target.toDouble(), v: _ctrl.velocity);
      HapticFeedback.selectionClick();
      _syncCallback();
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
      _dragActive = false;
      final target = _ctrl.value.round().clamp(0, widget.items.length - 1);
      _selectedIndex = target;
      _springTo(target.toDouble(), v: _ctrl.velocity);
    }
  }

  void _onTap(double localX) {
    if (_barWidth == 0) return;
    final idx = (localX / _barWidth * widget.items.length).floor().clamp(
      0,
      widget.items.length - 1,
    );
    _selectedIndex = idx;
    _springTo(idx.toDouble());
    HapticFeedback.selectionClick();
    _lastReported = idx;
    widget.onTabSelected(idx);
  }

  void _checkCrossover() {
    final nearest = _ctrl.value.round().clamp(0, widget.items.length - 1);
    if (nearest != _selectedIndex) {
      _selectedIndex = nearest;
      HapticFeedback.selectionClick();
    }
  }

  void _syncCallback() {
    if (_selectedIndex != _lastReported) {
      _lastReported = _selectedIndex;
      widget.onTabSelected(_selectedIndex);
    }
  }

  double _xToFloat(double x) {
    if (_barWidth == 0) return _selectedIndex.toDouble();
    return (x * widget.items.length / _barWidth - 0.5).clamp(
      0.0,
      widget.items.length - 1.0,
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        _barWidth = constraints.maxWidth;
        return Listener(
          behavior: HitTestBehavior.opaque,
          onPointerDown: _onPointerDown,
          onPointerMove: _onPointerMove,
          onPointerUp: _onPointerUp,
          onPointerCancel: _onPointerCancel,
          child: Container(
            decoration: BoxDecoration(
              color: widget.backgroundImageUrl != null
                  ? null
                  : (widget.backgroundColor ?? Colors.white),
              image: widget.backgroundImageUrl != null
                  ? DecorationImage(
                image: CachedNetworkImageProvider(
                  widget.backgroundImageUrl!,
                ),
                fit: BoxFit.cover,
              )
                  : null,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: RepaintBoundary(
              child: AnimatedBuilder(
                animation: _ctrl,
                builder: (ctx, _) {
                  final v = _ctrl.value;
                  return Row(
                    children: List.generate(widget.items.length, (i) {
                      final exp = (1.0 - (i - v).abs()).clamp(0.0, 1.0);
                      final isActive = exp >= 0.5;
                      final item = widget.items[i];

                      return Expanded(
                        child: item.buildContent != null
                            ? item.buildContent!(ctx, exp, isActive)
                            : _DefaultTab(
                          label: item.label,
                          expansion: exp,
                          isActive: isActive,
                          activeStyle: _activeStyle,
                          inactiveStyle: _inactiveStyle,
                          isImageDark: widget.isImageDark,
                        ),
                      );
                    }),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─── Default tile ─────────────────────────────────────────────────────────────
// Extracted as a StatelessWidget so its const fields never re-allocate,
// and Flutter can short-circuit equality checks when expansion hasn't changed.

class _DefaultTab extends StatelessWidget {
  const _DefaultTab({
    required this.label,
    required this.expansion,
    required this.isActive,
    required this.activeStyle,
    required this.inactiveStyle,
    this.isImageDark = false,
  });

  final String label;
  final double expansion;
  final bool isActive;
  final TextStyle activeStyle;
  final TextStyle inactiveStyle;
  final bool isImageDark;

  @override
  Widget build(BuildContext context) {
    final activeColor = isImageDark
        ? AppColors.brandDefault
        : AppColors.textPrimary;
    final inactiveColor = isImageDark
        ? AppColors.secondaryExtra
        : AppColors.neutralGrey5;
    final pillColor = isImageDark
        ? AppColors.baseDefault
        : AppColors.secondaryExtra;

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: Color.lerp(Colors.transparent, pillColor, expansion),
          borderRadius: _kPillRadius,
        ),
        child: Text(
          label,
          style: (isActive ? activeStyle : inactiveStyle).copyWith(
            color: Color.lerp(inactiveColor, activeColor, expansion),
          ),
        ),
      ),
    );
  }
}

/*
* Usage
* SpringTabItem(
    label: 'Sale',
    buildContent: (ctx, expansion, isActive) => Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: Color.lerp(Colors.transparent, Colors.red.shade50, expansion),
          borderRadius: _kPillRadius,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.local_offer, size: 14,
                color: Color.lerp(Colors.grey, Colors.red, expansion)),
            const SizedBox(width: 4),
            Text('Sale', style: TextStyle(
              color: Color.lerp(Colors.grey, Colors.red, expansion),
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
            )),
          ],
        ),
      ),
    ),
  )
* */
