import 'package:flutter/material.dart';
import 'package:hs_app_flutter/components/atoms/custom_image.dart';
import 'package:hs_app_flutter/core/theme/colors.dart';
import 'package:hs_app_flutter/core/theme/typography/text_style_extensions.dart';
import 'package:hs_app_flutter/core/theme/typography/typography_v1.dart';

class CustomChipWidget extends StatelessWidget {
  final TextStyle? textStyle;
  final String text;
  final dynamic leadingIcon;
  final dynamic trailingIcon;
  final Function()? onPressed;
  final Color? textColor;
  final Color? leadingIconColor;
  final (double, double)? leadingIconSize;
  final (double, double)? trailingIconSize;
  final Color? trailingIconColor;
  final String? uniqueKey;
  final Color? backgroundColor;
  final Color? borderColor;
  final EdgeInsets? padding;
  final double? height;
  final double? width;
  final double borderRadius;

  const CustomChipWidget({
    super.key,
    required this.text,
    this.leadingIcon,
    this.trailingIcon,
    this.onPressed,
    this.textColor,
    this.leadingIconColor,
    this.trailingIconColor,
    this.uniqueKey,
    this.backgroundColor,
    this.borderColor,
    this.textStyle,
    this.padding,
    this.borderRadius = 100,
    this.height,
    this.width,
    this.leadingIconSize = (const (16, 16)),
    this.trailingIconSize = (const (16, 16)),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: uniqueKey != null ? Key(uniqueKey!) : null,
      onTap: onPressed,
      child: Container(
        height: height,
        width: width,
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.brandTertiary,
          border: Border.all(color: borderColor ?? AppColors.brandSecondary, width: 1),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (leadingIcon != null) ...[
              if (leadingIcon is String) ...{
                CustomImage(
                  path: leadingIcon!,
                  width: leadingIconSize?.$1,
                  height: leadingIconSize?.$2,
                  color: leadingIconColor,
                ),
              } else ...{
                if (leadingIcon is Widget) ...{leadingIcon} else ...{const SizedBox.shrink()},
              },
            ],
            Flexible(
              child: Text(
                text,
                style: textStyle ?? AppTypographyV1.labelMedium.regular.textPrimary(),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: false,
              ),
            ),
            if (trailingIcon != null) ...[
              if (trailingIcon is String) ...{
                CustomImage(
                  path: trailingIcon!,
                  width: trailingIconSize?.$1,
                  height: trailingIconSize?.$2,
                  color: trailingIconColor,
                ),
              } else ...{
                if (trailingIcon is Widget) ...{trailingIcon} else ...{const SizedBox.shrink()},
              },
            ],
          ],
        ),
      ),
    );
  }
}
