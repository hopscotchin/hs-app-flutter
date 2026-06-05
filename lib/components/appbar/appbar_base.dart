import 'package:flutter/material.dart';
import 'package:hs_app_flutter/core/theme/colors.dart';

abstract class AppBarBase extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final Widget? center;
  final List<Widget>? actions;

  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;

  /// Constrains the inner Row to this height. Pass `null` to let the Row size
  /// itself naturally (needed when vertical padding is added, e.g. auth style).
  final double? height;

  final bool showBottomBorder;
  final Color? borderColor;

  /// Gap between the leading widget and the center content.
  final double leadingGap;

  const AppBarBase({
    super.key,
    this.leading,
    this.center,
    this.actions,
    this.backgroundColor,
    this.padding,
    this.height = kToolbarHeight,
    this.showBottomBorder = false,
    this.borderColor,
    this.leadingGap = 8,
  });

  @override
  Size get preferredSize => Size.fromHeight(height ?? kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final Widget row = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (leading != null) ...[leading!, SizedBox(width: leadingGap)],

        Expanded(
          child: Align(alignment: Alignment.centerLeft, child: center ?? const SizedBox.shrink()),
        ),

        if (actions != null && actions!.isNotEmpty) ...[
          const SizedBox(width: 8),
          Row(mainAxisSize: MainAxisSize.min, children: actions!),
        ],
      ],
    );

    Widget content = Material(
      color: backgroundColor ?? Colors.white,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
          child: height != null ? SizedBox(height: height, child: row) : row,
        ),
      ),
    );

    if (showBottomBorder) {
      content = DecoratedBox(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: borderColor ?? AppColors.dividerLight, width: 1)),
        ),
        position: DecorationPosition.foreground,
        child: content,
      );
    }

    return content;
  }
}
