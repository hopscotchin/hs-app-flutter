import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/typography/text_style_extensions.dart';
import '../../../../core/theme/typography/typography_v1.dart';

/// Divider + single-line prompt with a bold secondary action (Figma auth footers).
class AuthFooterLinkRow extends StatelessWidget {
  const AuthFooterLinkRow({
    super.key,
    required this.promptText,
    required this.actionLabel,
    required this.onActionTap,
  });

  final String promptText;
  final String actionLabel;
  final VoidCallback onActionTap;

  static final _promptStyle = AppTypographyV1.labelMedium.regular.copyWith(
    color: AppColors.neutralBlack,
  );
  static final _actionStyle = AppTypographyV1.labelMedium.bold.copyWith(
    color: AppColors.secondary,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(height: 1, color: AppColors.dividerLight),
        const SizedBox(height: 24),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 4,
          runSpacing: 4,
          children: [
            Text(promptText, style: _promptStyle),
            GestureDetector(
              onTap: onActionTap,
              child: Text(actionLabel, style: _actionStyle),
            ),
          ],
        ),
      ],
    );
  }
}
