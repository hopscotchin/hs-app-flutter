import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';

/// Initial cart-load skeleton. Mirrors [CartItemWidget]'s exact card
/// geometry (margin/padding/image size/row structure) so the real content
/// doesn't jump into a different layout once it loads in.
class CartShimmerLoading extends StatelessWidget {
  const CartShimmerLoading({super.key});

  static const int _itemCount = 4;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.neutralGrey2,
      highlightColor: AppColors.neutralGrey1,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        children: [
          for (int i = 0; i < _itemCount; i++) const _ShimmerCartItemCard(),
          AppSpacing.verticalGapXsm,
          _bar(height: AppSpacing.buttonHeightLg, radius: AppSpacing.radiusSm, margin: _cardMargin),
          AppSpacing.verticalGapXl,
          _bar(height: 220, radius: AppSpacing.radiusSm, margin: _cardMargin),
        ],
      ),
    );
  }
}

const _cardMargin = EdgeInsets.symmetric(
  horizontal: AppSpacing.lgMd,
  vertical: AppSpacing.sm,
);

Widget _bar({
  required double height,
  double? width,
  double radius = AppSpacing.radiusXs,
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

class _ShimmerCartItemCard extends StatelessWidget {
  const _ShimmerCartItemCard();

  @override
  Widget build(BuildContext context) {
    // No full-bleed background fill here — `Shimmer.fromColors` repaints
    // every opaque pixel in its subtree with the same travelling gradient,
    // so a colored card backdrop behind the bars would merge into one solid
    // block instead of showing distinct bars. Only the bars themselves
    // (via `_bar`) are colored; the real gaps between them show the page's
    // actual background, which is what makes the skeleton legible.
    return Container(
      margin: _cardMargin,
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 1, child: _imageColumn()),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: AppSpacing.sm,
                  top: AppSpacing.sm,
                  right: AppSpacing.xs,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [_details(), _wishlistRow()],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageColumn() {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 5 / 7,
          child: _bar(height: 176, width: 132, radius: AppSpacing.radiusXxs),
        ),
        AppSpacing.verticalGapXs,
        _bar(height: 14, width: 90),
      ],
    );
  }

  Widget _details() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _bar(height: 14, width: double.infinity)),
            Padding(
              padding: const EdgeInsets.only(left: AppSpacing.md),
              child: _bar(height: 18, width: 18, radius: AppSpacing.radiusSm),
            ),
          ],
        ),
        AppSpacing.verticalGapXxs,
        Row(
          children: [
            _bar(height: 14, width: 50),
            AppSpacing.horizontalGapXs,
            _bar(height: 14, width: 40),
            AppSpacing.horizontalGapXs,
            _bar(height: 14, width: 50),
          ],
        ),
        AppSpacing.verticalGapXs,
        _bar(height: 14, width: 70),
        AppSpacing.verticalGapXs,
        _bar(height: 14, width: 120),
      ],
    );
  }

  Widget _wishlistRow() {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: _bar(height: 18, width: 140),
    );
  }
}
