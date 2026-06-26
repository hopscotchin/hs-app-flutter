import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/image_constants.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography/typography_v1.dart';
import '../../../../core/theme/typography/text_style_extensions.dart';
import '../../domain/entities/legal_touch_point.dart';

class LegalItemWidget extends StatelessWidget {
  final LegalTouchPoint touchPoint;
  final VoidCallback onTap;

  const LegalItemWidget({
    super.key,
    required this.touchPoint,
    required this.onTap,
  });

  String get _svgAsset => switch (touchPoint) {
    LegalTouchPoint.terms => ImageConstants.legalTermsIcon,
    LegalTouchPoint.privacy => ImageConstants.legalPrivacyIcon,
    LegalTouchPoint.aboutUs => ImageConstants.legalAboutUsIcon,
  };

  Widget _leading() {
    return SvgPicture.asset(
      _svgAsset,
      width: AppSpacing.iconSm,
      height: AppSpacing.iconSm,
      colorFilter: const ColorFilter.mode(
        AppColors.textPrimary,
        BlendMode.srcIn,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
        ),
        child: Row(
          children: [
            _leading(),
            AppSpacing.horizontalGapMd,
            Expanded(
              child: Text(
                touchPoint.title,
                style: AppTypographyV1.bodyLarge.regular.textPrimary(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}