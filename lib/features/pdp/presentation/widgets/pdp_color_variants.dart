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

  /// Swatch box width — also the decode target, see [build].
  static const double _kSwatchWidth = 40.0;

  @override
  Widget build(BuildContext context) {
    if (colorVariants.isEmpty) return const SizedBox.shrink();

    // Decode the swatches at the 40px box they are painted into instead of at
    // full product-image resolution. Untouched, every variant decoded a
    // full-size JPEG and uploaded a full-size GPU texture for a 40x48 thumbnail,
    // which the raster thread then had to downsample on each paint.
    //
    // Width only, deliberately: ResizeImage uses ResizeImagePolicy.exact, so
    // passing both dimensions decodes to exactly that box and stretches the
    // image instead of letting BoxFit.cover crop it. One dimension keeps the
    // aspect ratio, and allowUpscaling defaults to false, so a source narrower
    // than the target is left at its native size.
    final swatchCacheWidth = (_kSwatchWidth * MediaQuery.devicePixelRatioOf(context)).round();

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
                final isSelected = variant.isSelected || variant.productId == currentProductId;
                final inStock = variant.isStockAvailable;

                final variantKey = ValueKey('${PdpTestStrings.colorVariant}_$index');
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
                        width: _kSwatchWidth,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected ? AppColors.brandDefault : AppColors.transparent,
                            width: 1,
                          ),
                          borderRadius: const BorderRadius.all(Radius.circular(6)),
                        ),
                        child: variant.mediaUrl != null
                            ? ClipRRect(
                                borderRadius: const BorderRadius.all(Radius.circular(5)),
                                child: CachedNetworkImage(
                                  imageUrl: variant.mediaUrl!,
                                  fit: BoxFit.cover,
                                  memCacheWidth: swatchCacheWidth,
                                  fadeInDuration: Duration.zero,
                                  fadeOutDuration: Duration.zero,
                                  errorWidget: (_, _, _) => _buildPlaceholder(inStock),
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
          const SizedBox(height: 12),
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
          const Positioned.fill(child: CustomPaint(painter: _CrossLinePainter(AppColors.border))),
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
