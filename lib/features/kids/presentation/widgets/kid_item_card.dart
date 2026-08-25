import 'package:flutter/material.dart';

import '../../../../components/atoms/circular_icon_button.dart';
import '../../../../components/atoms/custom_image.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography/text_style_extensions.dart';
import '../../../../core/theme/typography/typography_v1.dart';
import '../../domain/entities/child_entity.dart';

class KidItemCard extends StatelessWidget {
  const KidItemCard({
    super.key,
    required this.child,
    this.onEdit,
    this.onRemove,
    this.isRemoving = false,
    this.editKey,
    this.removeKey,
    this.nameKey,
  });

  final ChildEntity child;
  final VoidCallback? onEdit;
  final VoidCallback? onRemove;
  final bool isRemoving;

  final Key? editKey;
  final Key? removeKey;
  final Key? nameKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.neutralGrey1,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: AppColors.neutralGrey2, width: 0.5),
      ),
      child: Row(
        children: [
          ClipOval(
            child: child.imageUrl != null && child.imageUrl!.isNotEmpty
                ? CustomImage(
                    path: child.imageUrl!,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: 56,
                    height: 56,
                    color: AppColors.neutralGrey2,
                    child: const Icon(
                      Icons.person_outline,
                      color: AppColors.neutralGrey4,
                    ),
                  ),
          ),
          AppSpacing.horizontalGapSm,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  child.name,
                  key: nameKey,
                  style: AppTypographyV1.bodyRegular.bold.textPrimary(),
                ),
                const SizedBox(height: 4),
                Text(
                  '${child.gender.displayLabel}  •  ${child.ageDisplay}',
                  style: AppTypographyV1.labelLarge.medium.neutralGrey6(),
                ),
                const SizedBox(height: 2),
                Text(
                  child.dobDisplay,
                  style: AppTypographyV1.labelLarge.medium.neutralGrey6(),
                ),
              ],
            ),
          ),
          AppSpacing.horizontalGapSm,
          isRemoving
              ? const SizedBox(
                  width: 38,
                  height: 38,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : CircleIconButton(
                  key: removeKey,
                  onTap: onRemove ?? () {},
                  child: const Icon(
                    Icons.delete_outline,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
          AppSpacing.horizontalGapXs,
          CircleIconButton(
            key: editKey,
            onTap: onEdit ?? () {},
            child: const Icon(
              Icons.edit_outlined,
              color: AppColors.primary,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
