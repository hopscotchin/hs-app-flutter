import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/constants/image_constants.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/typography/text_style_extensions.dart';
import '../../../../core/theme/typography/typography_v1.dart';

/// App bar row matching auth Figma: back + title, bottom hairline (black 5%).
class AuthScreenHeader extends StatelessWidget {
  const AuthScreenHeader({
    super.key,
    required this.title,
    this.onLeadingTap,
    this.leading,
    this.showBottomBorder = true,
  });

  final String title;
  final VoidCallback? onLeadingTap;
  final Widget? leading;
  final bool showBottomBorder;

  static const Color _headerDivider = AppColors.divider;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.baseDefault,
        border: showBottomBorder
            ? const Border(bottom: BorderSide(color: _headerDivider, width: 1))
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            SizedBox(
              child:
                  leading ??
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    onPressed: onLeadingTap ?? () => Navigator.of(context).maybePop(),
                    icon: SvgPicture.asset(ImageConstants.arrowBack),
                  ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: AppTypographyV1.titleMedium.bold.copyWith(color: AppColors.neutralBlack),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
