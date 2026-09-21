import 'package:flutter/material.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/typography/text_style_extensions.dart';
import '../../core/theme/typography/typography_v1.dart';

/// A tappable "recent search" pill — bordered, small radius, bold label.
/// Shared by the Search page and Categories' inline search so both render
/// recent searches identically.
class RecentSearchChip extends StatelessWidget {
  const RecentSearchChip({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppSpacing.borderRadiusXxs,
      onTap: onTap,
      child: Container(
        padding: AppSpacing.buttonPaddingCompact,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.dividerLight),
          borderRadius: AppSpacing.borderRadiusXxs,
        ),
        child: Text(label, style: AppTypographyV1.bodyRegular.medium),
      ),
    );
  }
}
