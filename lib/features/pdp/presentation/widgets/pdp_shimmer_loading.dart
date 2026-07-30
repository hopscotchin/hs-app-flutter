import 'package:flutter/material.dart';

import '../../../../core/theme/spacing.dart';

class PdpShimmerLoading extends StatelessWidget {
  const PdpShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AspectRatio(aspectRatio: 5 / 6.8, child: _ShimmerBox()),
            AppSpacing.verticalGapMd,
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: _ShimmerBox(width: 120, height: 16),
            ),
            AppSpacing.verticalGapXs,
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: _ShimmerBox(width: 200, height: 14),
            ),
            AppSpacing.verticalGapSm,
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: _ShimmerBox(width: 160, height: 18),
            ),
            AppSpacing.verticalGapLgMd,
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: _ShimmerBox(width: 80, height: 14),
            ),
            AppSpacing.verticalGapSm,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Row(
                children: List.generate(
                  5,
                  (_) => const Padding(
                    padding: EdgeInsets.only(right: AppSpacing.xs),
                    child: _ShimmerBox(width: 48, height: 40),
                  ),
                ),
              ),
            ),
            AppSpacing.verticalGapLgMd,
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: _ShimmerBox(height: 48),
            ),
            AppSpacing.verticalGapLgMd,
            ...List.generate(
              3,
              (_) => const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: 6,
                ),
                child: _ShimmerBox(height: 44),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShimmerBox extends StatefulWidget {
  final double? width;
  final double? height;

  const _ShimmerBox({this.width, this.height});

  @override
  State<_ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<_ShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.08, end: 0.15).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: _animation.value),
            borderRadius: AppSpacing.borderRadiusXs,
          ),
        );
      },
    );
  }
}
