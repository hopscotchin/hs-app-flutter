import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/strings/auto_test_strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../domain/entities/color_variants_entity.dart';
import '../../../../components/atoms/auto_semantics.dart';

class PdpColorVariants extends StatelessWidget {
  final List<ColorVariantEntity> colorVariants;
  final int? currentProductId;
  final ValueChanged<int> onColorSelected;

  const PdpColorVariants({
    super.key,
    required this.colorVariants,
    this.currentProductId,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (colorVariants.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        // vertical: AppSpacing.sm,
      ),
      child: Column(
        children: [
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: colorVariants.length,
              separatorBuilder: (_, _) => AppSpacing.horizontalGapXs,
              itemBuilder: (context, index) {
                final variant = colorVariants[index];
                // Backend sends isSelected; also guard against current product match
                final isSelected =
                    variant.isSelected || variant.productId == currentProductId;
                final inStock = variant.isStockAvailable;

                final variantKey = ValueKey(
                  '${PdpTestStrings.colorVariant}_$index',
                );
                return AutoSemantics.fromKey(
                  variantKey,
                  container: true,
                  child: GestureDetector(
                    key: variantKey,
                    onTap: () {
                      if (variant.productId != null && !isSelected) {
                        onColorSelected(variant.productId!);
                      }
                    },
                    child: Opacity(
                      opacity: inStock ? 1.0 : 0.4,
                      child: Container(
                        width: 40,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected
                                ? AppColors.brandDefault
                                : AppColors.transparent,
                            width: 1,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(6),
                          ),
                        ),
                        child: variant.mediaUrl != null
                            ? ClipRRect(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(5),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: variant.mediaUrl!,
                                  fit: BoxFit.cover,
                                  fadeInDuration: Duration.zero,
                                  fadeOutDuration: Duration.zero,
                                  errorWidget: (_, _, _) =>
                                      _buildPlaceholder(inStock),
                                ),
                              )
                            : _buildPlaceholder(inStock),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(bool inStock) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(color: AppColors.secondary),
        if (!inStock)
          const Positioned.fill(
            child: CustomPaint(painter: _CrossLinePainter(AppColors.border)),
          ),
      ],
    );
  }
}

class _CrossLinePainter extends CustomPainter {
  const _CrossLinePainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    canvas.drawLine(Offset(0, size.height), Offset(size.width, 0), paint);
  }

  @override
  bool shouldRepaint(_CrossLinePainter old) => old.color != color;
}
