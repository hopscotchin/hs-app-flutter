import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../components/atoms/custom_image.dart';
import '../../../../components/atoms/product_tile.dart';
import '../../../../components/buttons/app_button.dart';
import '../../../../components/buttons/button_enums.dart';
import '../../../../core/constants/image_constants.dart';
import '../../../../core/constants/strings/wishlist_strings.dart';
import '../../../../core/theme/spacing.dart';
import '../../domain/entities/wishlist_product_entity.dart';
import '../bloc/wishlist_listing_bloc.dart';

/// A wishlist grid tile: the shared [ProductTile] visual (image, name, price,
/// sold-out scrim) with a delete action overlaid top-right of the image and a
/// full-width "Move to Bag" secondary CTA below it.
class WishlistProductTile extends StatelessWidget {
  final WishlistProductEntity item;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onMoveToBag;

  const WishlistProductTile({
    super.key,
    required this.item,
    this.onTap,
    this.onDelete,
    this.onMoveToBag,
  });

  @override
  Widget build(BuildContext context) {
    final soldOut = item.isSoldOut;
    // ponytail: scope the processing subscription to this one tile. The parent
    // BlocBuilder ignores processingIds, so only this tile rebuilds when its
    // own action is in flight — the other N-1 tiles stay put.
    final isProcessing = context.select<WishlistListingBloc, bool>(
      (b) => b.state.processingIds.contains(item.id),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Stack(
          children: [
            // canWishlist is false on the mapped entity, so ProductTile does
            // not render its own heart icon here — we overlay delete instead.
            ProductTile.fromProduct(item.product, onTap: onTap),
            Positioned(
              top: AppSpacing.xxs,
              right: AppSpacing.xxs,
              child: _DeleteButton(onTap: isProcessing ? null : onDelete),
            ),
          ],
        ),
        AppSpacing.verticalGapXs,
        AppButton(
          text: WishlistStrings.moveToBag,
          variant: ButtonVariant.secondary,
          size: ButtonSize.small,
          isFullWidth: true,
          state: soldOut
              ? ButtonState.disabled
              : (isProcessing ? ButtonState.loading : ButtonState.enabled),
          onTap: soldOut ? null : onMoveToBag,
        ),
      ],
    );
  }
}

class _DeleteButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _DeleteButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: const Padding(
        // Enlarge the tap target around the 28px icon.
        padding: EdgeInsets.all(AppSpacing.xxs),
        child: CustomImage(
          path: ImageConstants.deleteIcon,
          height: 28,
          width: 28,
        ),
      ),
    );
  }
}
