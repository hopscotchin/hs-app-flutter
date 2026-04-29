import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';

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
            icon: Icons.help_outline,
            label: 'HELP',
            onTap: () {},
          ),
          _HelpItem(
            icon: Icons.share_outlined,
            label: 'SHARE',
            onTap: () {},
          ),
          _HelpItem(
            icon: Icons.star_outline,
            label: 'RATE',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _HelpItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _HelpItem({
    required this.icon,
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
              Icon(
                icon,
                size: AppSpacing.iconMd,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                  letterSpacing: AppTypography.letterSpacingWider,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
