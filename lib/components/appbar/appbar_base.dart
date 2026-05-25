import 'package:flutter/material.dart';
import 'package:hs_app_flutter/core/theme/colors.dart';
import 'package:hs_app_flutter/core/theme/spacing.dart';

abstract class AppBarBase extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final Widget? center;
  final List<Widget>? actions;

  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final double height;
  final bool hasDivider;

  const AppBarBase({
    super.key,
    this.leading,
    this.center,
    this.actions,
    this.backgroundColor,
    this.padding,
    this.height = AppSpacing.appBarHeight,
    this.hasDivider = false
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Material(
      // ✅ important (ripple, elevation support later)
      color: backgroundColor ?? Colors.white,
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: padding ?? AppSpacing.paddingHorizontalMd,
              child: SizedBox(
                height: hasDivider ? height - 1: height,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (leading != null) ...[leading!, AppSpacing.horizontalGapXs],

                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: center ?? const SizedBox.shrink(),
                      ),
                    ),

                    if (actions != null && actions!.isNotEmpty) ...[
                      AppSpacing.horizontalGapXs,
                      Row(mainAxisSize: MainAxisSize.min, children: actions!),
                    ],
                  ],
                ),
              ),
            ),
            if (hasDivider)
              const Divider(height: 1, color: AppColors.divider),
          ],
        ),
      ),
    );
  }
}
