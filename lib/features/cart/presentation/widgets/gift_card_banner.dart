import 'package:flutter/material.dart';

import '../../../../components/atoms/cached_image_widget.dart';
import '../../../../core/extensions/string_extensions.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography/text_style_extensions.dart';
import '../../../../core/theme/typography/typography_v1.dart';
import '../../domain/entities/gift_card_item_entity.dart';

/// "Your free gift" banner shown when the cart qualifies for a free-gift
/// promo (backend-driven via `giftCardItem`).
class GiftCardBanner extends StatelessWidget {
  final GiftCardItemEntity giftCardItem;

  const GiftCardBanner({super.key, required this.giftCardItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.sm, left: AppSpacing.sm, right: AppSpacing.sm),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: AppSpacing.borderRadiusSm,
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.radiusXxs),
              border: Border.all(color: AppColors.surfaceBorder, width: 0.5),
            ),
            child: CachedImageWidget(
              imageUrl: giftCardItem.imgSrc ?? '',
              width: AppSpacing.thumbnailSm,
              height: AppSpacing.thumbnailSm,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (giftCardItem.title.isNotNullOrEmpty)
                  Text(
                    giftCardItem.title!,
                    style: AppTypographyV1.bodyRegular.semiBold.neutralGrey6(),
                  ),
                if (giftCardItem.description.isNotNullOrEmpty) ...[
                  AppSpacing.verticalGapXxxs,
                  Text(
                    giftCardItem.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypographyV1.labelMedium.regular.neutralGrey6(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
