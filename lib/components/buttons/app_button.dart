import 'package:flutter/material.dart';
import 'package:hs_app_flutter/components/atoms/dots_loader.dart';
import 'package:hs_app_flutter/components/buttons/button_enums.dart';
import 'package:hs_app_flutter/components/buttons/button_theme.dart';
import 'package:hs_app_flutter/core/theme/spacing.dart';
import 'package:hs_app_flutter/core/theme/typography/text_style_extensions.dart';
import 'package:hs_app_flutter/core/theme/typography/typography_v1.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
    required this.variant,
    this.styleType = ButtonStyleType.defaultType,
    this.onTap,
    this.isFullWidth = false,
    this.size = ButtonSize.medium,
    this.state = ButtonState.enabled,
    this.leadingIcon,
    this.trailingIcon,
    this.textStyle,
    this.foregroundColor,
    this.padding,
  });

  final String text;
  final ButtonVariant variant;
  final ButtonStyleType styleType;
  final VoidCallback? onTap;
  final bool isFullWidth;
  final ButtonSize size;
  final ButtonState state;
  final Widget? leadingIcon;
  final Widget? trailingIcon;

  /// Merged over the label style the [size] would otherwise give — set only the
  /// properties that differ. For a caller whose design specs the label
  /// differently from the shared scale, e.g. the PDP's CTAs at w700 on a 22px
  /// line box.
  final TextStyle? textStyle;

  /// Overrides the label (and loading dots) colour the [variant] would give.
  /// Background and border still come from the variant.
  final Color? foregroundColor;

  /// Replaces the inner padding [size] would give. For a caller narrow enough
  /// that the hugging padding crowds the label: the PDP's two CTAs split a
  /// 296px bar, where 20px per side was most of the slack "Add To Bag" needed
  /// on a 320pt screen. A full-width button centres its label, so trimming this
  /// costs nothing visually.
  final EdgeInsets? padding;

  // ── State helpers ──────────────────────────────────────────────────────

  bool get _isLoading => state == ButtonState.loading;
  bool get _isDisabled => state == ButtonState.disabled;
  bool get _isInteractive => !_isDisabled && !_isLoading && onTap != null;
  bool get _isTextOnly => variant == ButtonVariant.link || variant == ButtonVariant.linksmall;

  // ── Size tokens ────────────────────────────────────────────────────────

  double get _height => switch (size) {
    ButtonSize.small => AppSpacing.buttonHeightXs, // 28
    ButtonSize.medium => AppSpacing.buttonHeightBase, // 48
    ButtonSize.large => AppSpacing.buttonHeightLg, // 52
    ButtonSize.regular => AppSpacing.buttonHeightLg, // 35
  };

  EdgeInsets get _padding =>
      padding ??
      switch (size) {
        ButtonSize.small => const EdgeInsets.symmetric(horizontal: AppSpacing.sm), // 12
        ButtonSize.medium => const EdgeInsets.symmetric(horizontal: AppSpacing.lgMd), // 20
        ButtonSize.large => const EdgeInsets.symmetric(horizontal: AppSpacing.lg), // 24
        ButtonSize.regular => const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xs,
        ), // 24
      };

  double get _dotSize => switch (size) {
    ButtonSize.small => isFullWidth ? 8 : 6.0,
    ButtonSize.medium => isFullWidth ? 12 : 10.0,
    ButtonSize.large || ButtonSize.regular => isFullWidth ? 14 : 12.0,
  };

  TextStyle get _textStyle => switch (size) {
    ButtonSize.small =>
      _isTextOnly
          ? AppTypographyV1.labelMedium.bold.linkColor()
          : AppTypographyV1.labelLarge.bold, // 12px
    ButtonSize.medium =>
      _isTextOnly
          ? AppTypographyV1.labelLarge.medium.linkColor()
          : AppTypographyV1.bodyLarge.semiBold, // 14px
    ButtonSize.large => AppTypographyV1.bodyLarge.semiBold, // 15px
    ButtonSize.regular => AppTypographyV1.bodyLarge.bold, // 15px
  };

  TextStyle get _resolvedTextStyle => _textStyle.merge(textStyle);

  // ── Build ──────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final resolved = AppButtonTheme.resolve(variant: variant, styleType: styleType);
    final style = foregroundColor == null
        ? resolved
        : AppButtonStyle(
            backgroundColor: resolved.backgroundColor,
            foregroundColor: foregroundColor!,
            borderColor: resolved.borderColor,
          );

    final Widget button = AnimatedOpacity(
      opacity: _isDisabled ? 0.5 : 1.0,
      duration: const Duration(milliseconds: 150),
      child: GestureDetector(
        onTap: _isInteractive ? onTap : null,
        behavior: HitTestBehavior.opaque,
        child: _isTextOnly ? _buildTextOnly(style) : _buildBoxButton(style),
      ),
    );

    return isFullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }

  // ── Box button (defaultType / hover / inactive) ────────────────────────

  Widget _buildBoxButton(AppButtonStyle style) {
    final List<Widget> rowChildren = [
      if (leadingIcon != null) ...[leadingIcon!, const SizedBox(width: AppSpacing.xs)],
      // One line, ellipsised past it. Not shrink-to-fit: a FittedBox scales each
      // button independently, so a pair would render its two labels at different
      // sizes — and scaling and wrapping are mutually exclusive anyway, since a
      // FittedBox lays its child out unbounded.
      Flexible(
        child: Text(
          text,
          style: _resolvedTextStyle.copyWith(color: style.foregroundColor),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
      if (trailingIcon != null) ...[const SizedBox(width: AppSpacing.xs), trailingIcon!],
    ];

    final Widget row = isFullWidth
        ? Row(mainAxisAlignment: MainAxisAlignment.center, children: rowChildren)
        : Row(mainAxisSize: MainAxisSize.min, children: rowChildren);

    return Container(
      height: _height,
      padding: _padding,
      decoration: BoxDecoration(
        color: style.backgroundColor,
        border: style.borderColor != null
            ? Border.all(color: style.borderColor!, width: 1.5)
            : null,
        borderRadius: AppSpacing.borderRadiusXs,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Opacity(opacity: _isLoading ? 0.0 : 1.0, child: row),
          if (_isLoading) _buildLoader(style),
        ],
      ),
    );
  }

  // ── Text-only button (link / linksmall) ────────────────────────────────

  Widget _buildTextOnly(AppButtonStyle style) {
    return SizedBox(
      height: _height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Opacity(
            opacity: _isLoading ? 0.0 : 1.0,
            child: Text(
              text.toUpperCase(),
              style: _resolvedTextStyle.copyWith(color: style.foregroundColor),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          if (_isLoading) _buildLoader(style),
        ],
      ),
    );
  }

  // ── Shared loader ──────────────────────────────────────────────────────

  Widget _buildLoader(AppButtonStyle style) {
    return DotsLoader(dotSize: _dotSize, color: style.foregroundColor, spacing: 3.0);
  }
}
