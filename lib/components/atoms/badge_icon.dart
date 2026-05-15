import 'package:flutter/material.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';

class BadgeIcon extends StatelessWidget {
  final Widget child;
  final int count;

  const BadgeIcon({super.key, required this.child, this.count = 0});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        if (count > 0)
          Positioned(
            right: -6,
            top: -4,
            child: Container(
              padding: const EdgeInsets.all(2),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  count > 99 ? '99+' : '$count',
                  style: AppTypography.labelSmall.copyWith(
                    color: Colors.white,
                    fontSize: 9,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
