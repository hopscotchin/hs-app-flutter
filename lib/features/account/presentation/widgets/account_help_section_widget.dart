import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hs_app_flutter/core/constants/image_constants.dart';
import 'package:hs_app_flutter/core/constants/strings/account_strings.dart';
import 'package:hs_app_flutter/core/constants/strings/auto_test_strings.dart';
import '../../../../core/navigation/app_share_launcher.dart';
import '../../../../core/navigation/help_center_launcher.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography/typography_v1.dart';
import '../../../../core/theme/typography/text_style_extensions.dart';

/// 3-column help grid: Help | Share | Rate
class AccountHelpSectionWidget extends StatelessWidget {
  const AccountHelpSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _HelpItem(
          key: const ValueKey(AccountTestStrings.accountHelpItemHelpButton),
          svgAsset: ImageConstants.helpIcon,
          label: AccountStrings.help,
          onTap: () => HelpCenterLauncher.openHelpCenter(context),
        ),
        const _HelpItem(
          key: ValueKey(AccountTestStrings.accountHelpItemShareButton),
          svgAsset: ImageConstants.shareIcon,
          label: AccountStrings.share,
          onTap: AppShareLauncher.shareApp,
        ),
        const _HelpItem(
          key: ValueKey(AccountTestStrings.accountHelpItemRateButton),
          svgAsset: ImageConstants.sqaureStar,
          label: AccountStrings.rate,
          onTap: AppShareLauncher.rateApp,
        ),
      ],
    );
  }
}

class _HelpItem extends StatelessWidget {
  final String svgAsset;
  final String label;
  final VoidCallback onTap;

  const _HelpItem({
    super.key,
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
          padding: AppSpacing.paddingVerticalLg,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: AppTypographyV1.bodyRegular.semiBold.textPrimary(),
              ),
              const SizedBox(height: 6),
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
