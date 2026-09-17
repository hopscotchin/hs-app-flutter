import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/theme/spacing.dart';

/// Two-column product grid placeholder used while a listing loads (PLP,
/// wishlist). [showCtaBar] adds a button-sized block at the bottom of each
/// card for listings whose tiles carry a CTA (e.g. wishlist's "Move to Bag").
class ProductGridShimmer extends StatelessWidget {
  const ProductGridShimmer({
    super.key,
    this.itemCount = 6,
    this.showCtaBar = false,
  });

  final int itemCount;
  final bool showCtaBar;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xffC6C6C6),
      highlightColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppSpacing.xs,
            mainAxisSpacing: AppSpacing.md,
            childAspectRatio: showCtaBar ? 0.42 : 0.48,
          ),
          itemCount: itemCount,
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
        AppSpacing.verticalGapSm,
        Container(
          height: 9,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: AppSpacing.borderRadiusXs,
          ),
        ),
        AppSpacing.verticalGapSm,
        Container(
          height: 13,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: AppSpacing.borderRadiusXs,
          ),
        ),
        AppSpacing.verticalGapSm,
        Container(
          height: 8,
          width: 100,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: AppSpacing.borderRadiusXs,
          ),
        ),
        if (showCtaBar) ...[
          AppSpacing.verticalGapSm,
          Container(
            height: 36,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: AppSpacing.borderRadiusXs,
            ),
          ),
        ],
      ],
    );
  }
}
