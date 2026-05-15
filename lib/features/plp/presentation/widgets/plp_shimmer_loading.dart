import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/spacing.dart';

class PlpShimmerLoading extends StatelessWidget {
  const PlpShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppSpacing.xs,
            mainAxisSpacing: AppSpacing.md,
            childAspectRatio: 0.48,
          ),
          itemCount: 6,
          itemBuilder: (context, index) => _buildShimmerCard(),
        ),
      ),
    );
  }

  Widget _buildShimmerCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 7,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: AppSpacing.borderRadiusXs,
            ),
          ),
        ),
        AppSpacing.verticalGapXs,
        Container(
          height: 10,
          width: 80,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: AppSpacing.borderRadiusXs,
          ),
        ),
        AppSpacing.verticalGapXxs,
        Container(
          height: 10,
          width: 120,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: AppSpacing.borderRadiusXs,
          ),
        ),
        AppSpacing.verticalGapXxs,
        Container(
          height: 10,
          width: 100,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: AppSpacing.borderRadiusXs,
          ),
        ),
      ],
    );
  }
}
