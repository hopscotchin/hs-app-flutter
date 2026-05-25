import 'package:flutter/material.dart';
import 'package:hs_app_flutter/core/theme/spacing.dart';

import '../theme/colors.dart';
import '../theme/typography/text_style_extensions.dart';
import '../theme/typography/typography_v1.dart';

enum AppBottomSheetButtonStyle { outlined, filled }

class AppBottomSheetAction {
  const AppBottomSheetAction({
    required this.label,
    required this.onPressed,
    this.style = AppBottomSheetButtonStyle.outlined,
  });

  final String label;
  final VoidCallback onPressed;
  final AppBottomSheetButtonStyle style;
}

class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({
    super.key,
    this.title,
    required this.description,
    required this.primaryAction,
    this.secondaryAction,
  });

  final String? title;
  final String description;
  final AppBottomSheetAction primaryAction;
  final AppBottomSheetAction? secondaryAction;

  static Future<T?> show<T>(
    BuildContext context, {
    String? title,
    required String description,
    required AppBottomSheetAction primaryAction,
    AppBottomSheetAction? secondaryAction,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => AppBottomSheet(
        title: title,
        description: description,
        primaryAction: primaryAction,
        secondaryAction: secondaryAction,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasSecondary = secondaryAction != null;
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.md,
          right: AppSpacing.md,
          top: AppSpacing.sm,
          bottom: AppSpacing.md + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: AppSpacing.lg,
                height: AppSpacing.xxxs,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            AppSpacing.verticalGapLg,
            if (title != null) ...[
              Text(
                title!,
                style: AppTypographyV1.titleSmall.bold.textPrimary(),
              ),
              AppSpacing.verticalGapMd,
            ],
            Text(
              description,
              style: AppTypographyV1.bodyRegular.regular.textPrimary().copyWith(
                height: 1.5
              ),
            ),
            const SizedBox(height: 28),
            if (hasSecondary)
              Row(
                children: [
                  Expanded(child: _SheetButton(action: secondaryAction!)),
                  AppSpacing.horizontalGapXs,
                  Expanded(child: _SheetButton(action: primaryAction)),
                ],
              )
            else
              SizedBox(
                width: double.infinity,
                child: _SheetButton(action: primaryAction),
              ),
          ],
        ),
      ),
    );
  }
}

class _SheetButton extends StatelessWidget {
  const _SheetButton({required this.action});

  final AppBottomSheetAction action;

  @override
  Widget build(BuildContext context) {
    final isFilled = action.style == AppBottomSheetButtonStyle.filled;
    final textStyle = AppTypographyV1.bodyLarge.bold.copyWith(
      color: isFilled ? Colors.white : AppColors.primary,
    );
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
    );
    const padding = EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.sm);

    if (isFilled) {
      return TextButton(
        onPressed: action.onPressed,
        style: TextButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: shape,
          padding: padding,
        ),
        child: Text(action.label, style: textStyle),
      );
    }
    return TextButton(
      onPressed: action.onPressed,
      style: TextButton.styleFrom(
        backgroundColor: AppColors.brandTertiary,
        foregroundColor: Colors.white,
        shape: shape,
        padding: padding,
      ),
      child: Text(action.label, style: textStyle),
    );
  }
}
