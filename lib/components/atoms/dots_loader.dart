import 'package:flutter/material.dart';

import '../../core/theme/colors.dart';

/// Animated bouncing dots — grey dots that scale up/down in sequence. Defaults to 6 dots.
class DotsLoader extends StatelessWidget {
  final AnimationController controller;
  final int dotCount;

  const DotsLoader({super.key, required this.controller, this.dotCount = 6});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(dotCount, (i) {
            final offset = i * (1.0 / dotCount);
            final progress = ((controller.value + offset) % 1.0);
            final scale = 0.4 + 0.4 * _bounce(progress);
            final opacity = 0.3 + 0.7 * _bounce(progress);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Transform.scale(
                scale: scale,
                child: Opacity(
                  opacity: opacity,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.textSecondary,
                    ),
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
