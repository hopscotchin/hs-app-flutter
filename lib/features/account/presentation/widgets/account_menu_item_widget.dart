import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography/typography_v1.dart';
import '../../../../core/theme/typography/text_style_extensions.dart';

class AccountMenuItemWidget extends StatelessWidget {
  final String svgAsset;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? subtitleColor;
  final String? trailingText;

  const AccountMenuItemWidget({
    super.key,
    required this.svgAsset,
    required this.title,
    this.subtitle,
    this.onTap,
    this.iconColor,
    this.subtitleColor,
    this.trailingText,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              svgAsset,
              width: AppSpacing.iconSm,
              height: AppSpacing.iconSm,
              colorFilter: ColorFilter.mode(
                iconColor ?? AppColors.textPrimary,
                BlendMode.srcIn,
              ),
            ),
            AppSpacing.horizontalGapMd,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypographyV1.bodyLarge.textPrimary()),
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        subtitle!,
                        style: AppTypographyV1.labelLarge.copyWith(
                          color: subtitleColor ?? AppColors.textPrimary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (trailingText != null)
              Text(
                trailingText!,
                style: AppTypographyV1.bodyLarge.copyWith(
                  color: subtitleColor ?? AppColors.textPrimary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}