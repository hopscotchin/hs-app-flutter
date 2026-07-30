import 'package:flutter/material.dart';

import '../../../../components/atoms/custom_image.dart';
import '../../../../core/constants/image_constants.dart';
import '../../../../core/constants/strings/auto_test_strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography/typography_v1.dart';
import '../../../../features/plp/domain/entities/product_price_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../../../components/page_components/price_info_row.dart';

// Design tokens from spec
const _kCalloutColor = AppColors.neutralGrey5; // #AEAEB2

class PdpBrandPrice extends StatelessWidget {
  final ProductEntity product;
  final ProductPriceEntity? skuPrice;
  final bool isWishlisted;
  final VoidCallback? onWishlistTap;
  final VoidCallback? onShareTap;

  const PdpBrandPrice({
    super.key,
    required this.product,
    this.skuPrice,
    this.isWishlisted = false,
    this.onWishlistTap,
    this.onShareTap,
  });

  ProductPriceEntity? get _effectivePrice => skuPrice ?? product.priceInfo;

  @override
  Widget build(BuildContext context) {
    final price = _effectivePrice;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Row 1: product name ──────────────────────────────────────────────
          if (product.name != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                product.name!,
                key: const ValueKey(PdpTestStrings.productNameText),
                style: AppTypographyV1.titleSmall.copyWith(
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF000000),
                  height: 1.1,
                ),
              ),
            ),

          const SizedBox(height: 14),

          // ── Row 2: price column + share/wishlist ─────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (price != null)
                      PriceInfoRow(
                        price: price,
                        sellingPriceKey: const ValueKey(
                          PdpTestStrings.sellingPriceText,
                        ),
                        mrpKey: const ValueKey(PdpTestStrings.mrpText),
                        discountKey: const ValueKey(
                          PdpTestStrings.discountText,
                        ),
                      ),
                    if (price?.callout != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        price!.callout!,
                        key: const ValueKey(PdpTestStrings.priceCalloutText),
                        style: AppTypographyV1.bodySmall.copyWith(
                          fontWeight: FontWeight.w500,
                          color: _kCalloutColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Share + wishlist — 20px icons, gap 12px
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ActionIcon(
                    key: const ValueKey(PdpTestStrings.shareButton),
                    path: ImageConstants.shareIcon,
                    color: AppColors.primary,
                    onTap: onShareTap,
                    width: 20,
                    height: 20,
                  ),
                  AppSpacing.horizontalGapSm,
                  _ActionIcon(
                    key: const ValueKey(PdpTestStrings.wishlistButton),
                    path: isWishlisted
                        ? ImageConstants.wishlistAdded
                        : ImageConstants.addWishlist,
                    onTap: onWishlistTap,
                    width: 20,
                    height: 20,
                  ),
                ],
              ),
            ],
          ),
          AppSpacing.verticalGapLg,
        ],
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final String path;
  final Color? color;
  final double? width;
  final double? height;
  final VoidCallback? onTap;

  const _ActionIcon({
    super.key,
    required this.path,
    this.color,
    this.width,
    this.height,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: CustomImage(
        path: path,
        color: color,
        width: width,
        height: height,
      ),
    );
  }
}
