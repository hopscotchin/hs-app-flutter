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

  static final _promptStyle = AppTypographyV1.labelMedium.regular.textPrimary();
  static final _actionStyle = AppTypographyV1.labelMedium.bold.brand();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          onTap: onActionTap,
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 4,
            runSpacing: 4,
            children: [
              Text(promptText, style: _promptStyle),
              Text(actionLabel, style: _actionStyle),
            ],
          ),
        ),
      ],
    );
  }
}
