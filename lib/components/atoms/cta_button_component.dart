import 'package:flutter/material.dart';
import 'package:hs_app_flutter/core/theme/typography/text_style_extensions.dart';
import 'package:hs_app_flutter/core/theme/typography/typography_v1.dart';

import '../../core/theme/colors.dart';

/// Visual variant of [CtaButtonComponent]. Maps directly from the API's
/// `ctaButton.type` string ("primary" / "secondary" / "tertiary").
enum CtaButtonStyle {
  primary,
  secondary,
  tertiary;

  static CtaButtonStyle fromString(String? value) {
    final v = value?.toLowerCase().trim();
    if (v == null || v.isEmpty) return CtaButtonStyle.primary;
    if (v.contains('secondary')) return CtaButtonStyle.secondary;
    if (v.contains('tertiary')) return CtaButtonStyle.tertiary;
    return CtaButtonStyle.primary;
  }
}

/// White pill button sitting on a coloured "drop-shadow" block offset down-right.
/// Variant decides the accent colour (border + text + shadow block):
///   - primary   → brand purple
///   - secondary → black
///   - tertiary  → secondaryExtra (light lavender)
class CtaButtonComponent extends StatelessWidget {
  final String label;
  final CtaButtonStyle style;
  final VoidCallback? onPressed;

  const CtaButtonComponent({
    super.key,
    required this.label,
    this.style = CtaButtonStyle.primary,
    this.onPressed,
  });

  static const double _height = 42;
  static const double _shadowOffset = 6;
  static const double _cornerRadius = 2;
  static const double _borderWidth = 1.5;

  Color get _accent => switch (style) {
    CtaButtonStyle.primary => AppColors.brandPrimary,
    CtaButtonStyle.secondary => AppColors.neutralBlack,
    CtaButtonStyle.tertiary => AppColors.secondaryExtra,
  };

  @override
  Widget build(BuildContext context) {
    final Color accent = _accent;
    final BorderRadius radius = BorderRadius.circular(_cornerRadius);

    return Stack(
      children: [
        // Shadow block, drawn first → sits behind the white card.
        // Fills from (offset, offset) to the bottom-right of the Stack,
        // matching the white card's footprint translated down-right.
        Positioned(
          left: _shadowOffset,
          top: _shadowOffset,
          right: 0,
          bottom: 0,
          child: DecoratedBox(
            decoration: BoxDecoration(color: accent, borderRadius: radius),
          ),
        ),
        // White card, padded so the shadow peeks out on the bottom + right.
        Padding(
          padding: const EdgeInsets.only(right: _shadowOffset, bottom: _shadowOffset),
          // Material + InkWell give the tap a clipped ripple. The Container
          // below keeps the accent border on top of the ripple.
          child: Material(
            color: AppColors.baseDefault,
            borderRadius: radius,
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onPressed,
              borderRadius: radius,
              splashColor: AppColors.disabledDefault,
              highlightColor: AppColors.disabledDefault.withValues(alpha: 0.2),
              child: Container(
                height: _height,
                padding: const EdgeInsets.symmetric(horizontal: 32),
                decoration: BoxDecoration(
                  borderRadius: radius,
                  border: Border.all(color: accent, width: _borderWidth),
                ),
                child: Center(
                  widthFactor: 1,
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: AppTypographyV1.bodyRegular.bold.copyWith(
                      color: accent,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
