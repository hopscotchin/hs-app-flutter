import 'package:flutter/material.dart';

import '../../../../components/buttons/app_button_named.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography/text_style_extensions.dart';
import '../../../../core/theme/typography/typography_v1.dart';

/// Delete/discard confirm sheet for My Kids — uses the real `SecondaryButton`
/// (white bg, purple border, purple text) for the safe/cancel action and
/// `PrimaryButton` (solid purple) for the confirm action, matching the
/// Figma design exactly. `AppBottomSheet`'s own built-in buttons don't have
/// a true border-only style (its three variants are all filled/tinted), and
/// changing that shared component would affect every other screen that uses
/// it — so this is a small Kids-only sheet built directly on the same
/// `SecondaryButton`/`PrimaryButton` design-system pieces instead.
class KidsConfirmSheet {
  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String description,
    required String cancelLabel,
    required String confirmLabel,
    Key? titleKey,
    Key? descriptionKey,
    Key? cancelKey,
    Key? confirmKey,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.white,
      showDragHandle: false,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.xs, AppSpacing.md, AppSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 24,
                  height: 2,
                  margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.brandDefault,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  ),
                ),
              ),
              Text(title, key: titleKey, style: AppTypographyV1.titleSmall.bold.textPrimary()),
              AppSpacing.verticalGapMd,
              Text(
                description,
                key: descriptionKey,
                style: AppTypographyV1.bodyRegular.regular.copyWith(
                  color: AppColors.neutralGrey6,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: SecondaryButton.defaultType(
                      key: cancelKey,
                      text: cancelLabel,
                      onTap: () => Navigator.of(context, rootNavigator: true).pop(false),
                    ),
                  ),
                  AppSpacing.horizontalGapSm,
                  Expanded(
                    child: PrimaryButton.defaultType(
                      key: confirmKey,
                      text: confirmLabel,
                      onTap: () => Navigator.of(context, rootNavigator: true).pop(true),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
