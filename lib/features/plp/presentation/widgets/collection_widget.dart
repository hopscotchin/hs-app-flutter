import 'package:flutter/material.dart';
import 'package:hs_app_flutter/core/router/app_navigator.dart';

import '../../../../components/atoms/cached_image_widget.dart';
import '../../../../core/navigation/action_url_handler.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../../discover/domain/entities/home_page_entity.dart';
import '../../domain/entities/page_type.dart';

class CollectionWidget extends StatelessWidget {
  final CollectionData collectionData;
  final ComponentMargins? margins;

  const CollectionWidget({
    super.key,
    required this.collectionData,
    this.margins,
  });

  @override
  Widget build(BuildContext context) {
    if (collectionData.imageUrl == null) return const SizedBox.shrink();

    final horizontalMargin = margins?.horizontal ?? 16;

    return GestureDetector(
      onTap: () {
        // Try actionUrl first; if unrecognised, fall back to collection id
        final handled = ActionUrlHandler.navigate(
          context,
          collectionData.actionUrl,
          title: collectionData.name,
        );
        if (!handled) {
          final id = int.tryParse(collectionData.id ?? '') ?? 0;
          final isBoutique = collectionData.showInBoutiqueSetting == true;
          AppNavigator.goToPlp(
            context,
            pageType: isBoutique ? PageType.boutique : PageType.plp,
            plpId: id,
            categoryName: collectionData.name,
          );
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedImageWidget(
              imageUrl: collectionData.imageUrl!,
              width: double.infinity,
              height: 180,
              fit: BoxFit.cover,
            ),
            if (collectionData.name != null) ...[
              AppSpacing.verticalGapXs,
              Text(
                collectionData.name!,
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
