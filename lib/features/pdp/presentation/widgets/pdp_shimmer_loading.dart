import 'package:flutter/material.dart';

import '../../../../core/theme/spacing.dart';

class PdpShimmerLoading extends StatefulWidget {
  const PdpShimmerLoading({super.key});

  @override
  State<PdpShimmerLoading> createState() => _PdpShimmerLoadingState();
}

class _PdpShimmerLoadingState extends State<PdpShimmerLoading>
    with SingleTickerProviderStateMixin {
  // ONE ticker for all fourteen boxes.
  //
  // Each _ShimmerBox used to own its own AnimationController running the
  // identical 1500ms 0.08→0.15 tween. They were all constructed in the same
  // frame and all call repeat(reverse: true) from 0, so they were always in
  // lockstep — thirteen of the fourteen tickers were producing a value that
  // was, by construction, the same as the first one's. That overhead landed
  // exactly during PDP load, when the frame budget is already going to image
  // decode and JSON parsing.
  //
  // Sharing one controller is therefore pixel-identical, not merely close.
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  )..repeat(reverse: true);

  late final Animation<double> _alpha = Tween<double>(
    begin: 0.08,
    end: 0.15,
  ).animate(_controller);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(aspectRatio: 5 / 6.8, child: _ShimmerBox(alpha: _alpha)),
            AppSpacing.verticalGapMd,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: _ShimmerBox(alpha: _alpha, width: 120, height: 16),
            ),
            AppSpacing.verticalGapXs,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: _ShimmerBox(alpha: _alpha, width: 200, height: 14),
            ),
            AppSpacing.verticalGapSm,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: _ShimmerBox(alpha: _alpha, width: 160, height: 18),
            ),
            AppSpacing.verticalGapLgMd,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: _ShimmerBox(alpha: _alpha, width: 80, height: 14),
            ),
            AppSpacing.verticalGapSm,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Row(
                children: List.generate(
                  5,
                  (_) => Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.xs),
                    child: _ShimmerBox(alpha: _alpha, width: 48, height: 40),
                  ),
                ),
              ),
            ),
            AppSpacing.verticalGapLgMd,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: _ShimmerBox(alpha: _alpha, height: 48),
            ),
            AppSpacing.verticalGapLgMd,
            ...List.generate(
              3,
              (_) => Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: 6,
                ),
                child: _ShimmerBox(alpha: _alpha, height: 44),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One shimmering placeholder block, driven by [alpha] — the single animation
/// owned by [PdpShimmerLoading] rather than a controller of its own.
///
/// Each box keeps its own AnimatedBuilder rather than the parent wrapping the
/// whole Column in one: that way a frame rebuilds only the fourteen
/// DecoratedBoxes, not the Paddings, Rows and gaps around them.
class _ShimmerBox extends StatelessWidget {
  const _ShimmerBox({required this.alpha, this.width, this.height});

  final Animation<double> alpha;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: alpha,
      builder: (context, child) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: alpha.value),
            borderRadius: AppSpacing.borderRadiusXs,
          ),
        );
      },
    );
  }
}
