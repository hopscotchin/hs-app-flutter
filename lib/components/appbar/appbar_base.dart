import 'package:flutter/material.dart';

abstract class AppBarBase extends StatelessWidget
    implements PreferredSizeWidget {
  final Widget? leading;
  final Widget? center;
  final List<Widget>? actions;

  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final double height;

  const AppBarBase({
    super.key,
    this.leading,
    this.center,
    this.actions,
    this.backgroundColor,
    this.padding,
    this.height = kToolbarHeight,
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
        child: Padding(
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            height: height,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (leading != null) ...[leading!, const SizedBox(width: 8)],

                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: center ?? const SizedBox.shrink(),
                  ),
                ),

                if (actions != null && actions!.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  Row(mainAxisSize: MainAxisSize.min, children: actions!),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
