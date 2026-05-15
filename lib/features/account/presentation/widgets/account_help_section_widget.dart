import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hs_app_flutter/core/constants/image_constants.dart';
import 'package:hs_app_flutter/core/constants/strings/account_strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography/typography_v1.dart';
import '../../../../core/theme/typography/text_style_extensions.dart';

/// 3-column help grid: Help | Share | Rate
class AccountHelpSectionWidget extends StatelessWidget {
  const AccountHelpSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        children: [
          _HelpItem(
            svgAsset: ImageConstants.helpIcon,
            label: AccountStrings.help,
            onTap: () {},
          ),
          _HelpItem(
            svgAsset: ImageConstants.shareIcon,
            label: AccountStrings.share,
            onTap: () {},
          ),
          _HelpItem(
            svgAsset: ImageConstants.sqaureStar,
            label: AccountStrings.rate,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _HelpItem extends StatelessWidget {
  final String svgAsset;
  final String label;
  final VoidCallback onTap;

  const _HelpItem({
    required this.svgAsset,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: AppSpacing.borderRadiusSm,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: AppTypographyV1.bodyRegular.semiBold.textPrimary(),
              ),
              AppSpacing.verticalGapXxs,
              SvgPicture.asset(
                svgAsset,
                width: AppSpacing.iconSm,
                height: AppSpacing.iconSm,
                colorFilter: const ColorFilter.mode(
                  AppColors.textPrimary,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
