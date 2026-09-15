import 'package:flutter/material.dart';

import '../../core/theme/colors.dart';

class BadgeIcon extends StatelessWidget {
  final dynamic icon;
  final int count;
  final Color? iconColor;
  final double iconSize;
  final Color badgeColor;
  final Color badgeTextColor;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  /// Hit-test behaviour of the tap area. The default only registers taps that
  /// land on the icon itself; pass [HitTestBehavior.opaque] when [padding] is
  /// meant to be part of the touch target.
  final HitTestBehavior behavior;

  const BadgeIcon({
    super.key,
    this.count = 0,
    this.icon,
    this.iconColor,
    this.iconSize = 24,
    this.badgeColor = AppColors.brandDefault,
    this.badgeTextColor = Colors.white,
    this.onTap,
    this.padding = const EdgeInsets.all(5.0),
    this.behavior = HitTestBehavior.deferToChild,
  });

  @override
  Widget build(BuildContext context) {
    final displayText = count > 9 ? '9+' : '$count';

    return GestureDetector(
      onTap: onTap,
      behavior: behavior,
      child: Padding(
        padding: padding,
        child: Badge(
          isLabelVisible: count > 0,
          offset: const Offset(6, -8),
          backgroundColor: badgeColor,
          label: Text(
            displayText,
            style: TextStyle(fontSize: 10, color: badgeTextColor),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
          child: icon is IconData
              ? Icon(icon, size: iconSize, color: iconColor)
              : icon,
        ),
      ),
    );
  }
}
