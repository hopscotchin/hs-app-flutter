import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/spacing.dart';
import '../../domain/entities/page_type.dart';

class PlpShimmerLoading extends StatelessWidget {
  const PlpShimmerLoading({super.key, this.pageType = PageType.plp});

  final PageType pageType;

  /// Matches `_PlpHeaderDelegate._expandedHeight`.
  static const double _bannerHeight = 300;

  /// Matches `_StickyFilterBarDelegate.maxExtent`.
  static const double _filterBarHeight = 62;

  /// The hero banner and the sticky filter bar under it both belong to the
  /// boutique layout only.
  bool get _isBoutique => pageType == PageType.boutique;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xffC6C6C6),
      highlightColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_isBoutique) ...[_buildBanner(), _buildFilterBar()],
          // Expanded (not shrinkWrap) so the grid takes exactly the space left
          // under the banner/filter bar — the parent is a SliverFillRemaining,
          // so a self-sizing grid would overflow it on short screens.
          Expanded(child: _buildGrid()),
        ],
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      height: _bannerHeight,
      width: double.infinity,
      color: Colors.white,
    );
  }

  /// Stand-in for `StickyFilterBar`: a row of quick-filter chips on the left
  /// and the Sort By / Filter By pair on the right.
  Widget _buildFilterBar() {
    return SizedBox(
      height: _filterBarHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        child: Row(
          children: [
            _bar(width: 84, height: 28, radius: 4),
            const SizedBox(width: AppSpacing.xs),
            _bar(width: 72, height: 28, radius: 4),
            const Spacer(),
            _bar(width: 60, height: 28),
            const SizedBox(width: AppSpacing.sm),
            _bar(width: 60, height: 28),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: AppSpacing.xs,
          mainAxisSpacing: AppSpacing.md,
          childAspectRatio: 0.48,
        ),
        itemCount: 6,
        itemBuilder: (context, index) => _buildShimmerCard(),
      ),
    );
  }

  Widget _bar({
    required double width,
    required double height,
    double radius = 4,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
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
      ],
    );
  }
}
