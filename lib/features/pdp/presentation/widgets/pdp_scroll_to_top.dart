import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../components/atoms/custom_image.dart';
import '../../../../core/constants/image_constants.dart';
import '../../../../core/constants/strings/pdp_strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/typography/text_style_extensions.dart';
import '../../../../core/theme/typography/typography_v1.dart';

class PdpScrollToTop extends StatelessWidget {
  final VoidCallback? onTap;

  const PdpScrollToTop({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(2),
          border: Border.all(color: AppColors.brandPrimary),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.rotate(
              angle: 90 * math.pi / 180,
              child: const CustomImage(
                path: ImageConstants.arrowBack,
                color: AppColors.brandPrimary,
                height: 14,
                width: 14,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              PdpStrings.goToTop,
              style: AppTypographyV1.labelMedium.medium.brandPrimary(),
            ),
          ],
        ),
      ),
    );
  }
}
