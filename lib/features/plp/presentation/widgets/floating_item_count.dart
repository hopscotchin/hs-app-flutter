import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:hs_app_flutter/components/atoms/custom_image.dart';
import 'package:hs_app_flutter/core/constants/image_constants.dart';
import 'package:hs_app_flutter/core/theme/colors.dart';
import 'package:hs_app_flutter/core/theme/typography/text_style_extensions.dart';
import 'package:hs_app_flutter/core/theme/typography/typography_v1.dart';

class FloatingItemCount extends StatelessWidget {
  final int position;
  final int totalCount;
  final Function()? onTap;
  const FloatingItemCount({
    super.key,
    required this.position,
    required this.totalCount,
    this.onTap,
  });

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
              '$position of $totalCount',
              style: AppTypographyV1.labelMedium.medium.brandPrimary(),
            ),
          ],
        ),
      ),
    );
  }
}
