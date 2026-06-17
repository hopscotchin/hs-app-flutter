import 'package:flutter/material.dart';

import '../../core/theme/colors.dart';

class DotsLoader extends StatefulWidget {
  const DotsLoader({
    super.key,
    this.controller,
    this.dotSize = 14.0,
    this.color = AppColors.textSecondary,
    this.spacing = 4.0,
  });

  final AnimationController? controller;

  final double dotSize;

  final Color color;

  final double spacing;

  @override
  State<DotsLoader> createState() => _DotsLoaderState();
}

class _DotsLoaderState extends State<DotsLoader> with SingleTickerProviderStateMixin {
  late final AnimationController _ownController;
  late final bool _ownsController;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    if (_ownsController) {
      _ownController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1200),
      )..repeat();
    }
  }

  @override
  void dispose() {
    if (_ownsController) _ownController.dispose();
    super.dispose();
  }

  AnimationController get _controller => widget.controller ?? _ownController;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final progress = ((_controller.value + i * 0.2) % 1.0);
            final scale = 0.6 + 0.4 * _bounce(progress);
            final opacity = 0.3 + 0.7 * _bounce(progress);
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: widget.spacing),
              child: Transform.scale(
                scale: scale,
                child: Opacity(
                  opacity: opacity,
                  child: Container(
                    width: widget.dotSize,
                    height: widget.dotSize,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: widget.color),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  double _bounce(double t) {
    if (t < 0.5) return t * 2;
    return (1 - t) * 2;
  }
}
