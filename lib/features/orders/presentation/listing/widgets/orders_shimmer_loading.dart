import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../../core/theme/spacing.dart';

/// Initial-load skeleton for either listing tab.
///
/// Mirrors [OrderListingCard]'s geometry — same margin, padding, image width
/// and 3:4 ratio, same stack of text rows — so the real content does not jump
/// into a different layout when it lands.
///
/// Two things that look like oversights but are not: there is exactly one
/// [Shimmer.fromColors] at the root rather than one per card, and the cards
/// have no background fill. The shimmer gradient repaints every opaque pixel in
/// its subtree, so a filled card would merge with its bars into one travelling
/// block. Only the bars are coloured; the gaps show the page behind, which is
/// what makes the skeleton read as rows.
class OrdersShimmerLoading extends StatelessWidget {
  const OrdersShimmerLoading({super.key, this.itemCount = 5});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.neutralGrey2,
      highlightColor: AppColors.neutralGrey1,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
        itemCount: itemCount,
        itemBuilder: (_, _) => const _ShimmerOrderCard(),
      ),
    );
  }
}

const _cardMargin = EdgeInsets.symmetric(
  horizontal: AppSpacing.sm,
  vertical: AppSpacing.xxs,
);

Widget _bar({
  required double height,
  double? width,
  double radius = AppSpacing.radiusXxs,
  EdgeInsets margin = EdgeInsets.zero,
}) {
  return Container(
    width: width,
    height: height,
    margin: margin,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(radius),
    ),
  );
}

class _ShimmerOrderCard extends StatelessWidget {
  const _ShimmerOrderCard();

  static const double _imageWidth = 96;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: _cardMargin,
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: _imageWidth,
            child: AspectRatio(
              aspectRatio: 3 / 4,
              child: _bar(height: double.infinity),
            ),
          ),
          AppSpacing.horizontalGapSm,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _bar(height: 14, width: double.infinity), // title line 1
                AppSpacing.verticalGapXxs,
                _bar(height: 14, width: 160), // title line 2
                AppSpacing.verticalGapXs,
                _bar(height: 16, width: 70), // price
                AppSpacing.verticalGapXs,
                _bar(height: 12, width: 60), // qty
                AppSpacing.verticalGapXxs,
                _bar(height: 12, width: 110), // size
                AppSpacing.verticalGapSm,
                _bar(height: 12, width: 140), // status title
                AppSpacing.verticalGapXxs,
                _bar(height: 12, width: 180), // status subtitle
              ],
            ),
          ),
        ],
      ),
    );
  }
}
