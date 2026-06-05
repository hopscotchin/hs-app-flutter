import 'package:flutter/material.dart';
import 'package:hs_app_flutter/core/theme/spacing.dart';

import '../core/theme/colors.dart';
import '../core/theme/typography/text_style_extensions.dart';
import '../core/theme/typography/typography_v1.dart';

enum AppDialogButtonStyle { outlined, filled }

class AppDialogAction {
  const AppDialogAction({
    required this.label,
    required this.onPressed,
    this.style = AppDialogButtonStyle.outlined,
  });

  final String label;
  final VoidCallback onPressed;
  final AppDialogButtonStyle style;
}

class AppDialog extends StatelessWidget {
  const AppDialog({
    super.key,
    this.title,
    required this.description,
    required this.primaryAction,
    this.secondaryAction,
  });

  final String? title;
  final String description;
  final AppDialogAction primaryAction;
  final AppDialogAction? secondaryAction;

  static Future<T?> show<T>(
    BuildContext context, {
    String? title,
    required String description,
    required AppDialogAction primaryAction,
    AppDialogAction? secondaryAction,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) => AppDialog(
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
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (title != null) ...[
              Text(
                title!,
                style: AppTypographyV1.bodyLarge.semiBold.textPrimary(),
              ),
              const SizedBox(height: 8),
            ],
            Text(
              description,
              style: AppTypographyV1.labelLarge.regular.textPrimary(),
            ),
            const SizedBox(height: 16),
            if (hasSecondary)
              Row(
                children: [
                  Expanded(child: _DialogButton(action: secondaryAction!)),
                  const SizedBox(width: 8),
                  Expanded(child: _DialogButton(action: primaryAction)),
                ],
              )
            else
              SizedBox(
                width: double.infinity,
                child: _DialogButton(action: primaryAction),
              ),
          ],
        ),
      ),
    );
  }
}

class _DialogButton extends StatelessWidget {
  const _DialogButton({required this.action});

  final AppDialogAction action;

  @override
  Widget build(BuildContext context) {
    final isFilled = action.style == AppDialogButtonStyle.filled;
    final textStyle = AppTypographyV1.labelLarge.semiBold.copyWith(
      color: isFilled ? Colors.white : AppColors.secondary,
    );
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    );
    const padding = EdgeInsets.symmetric(vertical: 10, horizontal: 12);

    if (isFilled) {
      return ElevatedButton(
        onPressed: action.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: shape,
          padding: padding,
        ),
        child: Text(action.label, style: textStyle),
      );
    }
    return OutlinedButton(
      onPressed: action.onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.secondary,
        side: const BorderSide(color: AppColors.secondary),
        shape: shape,
        padding: padding,
      ),
      child: Text(action.label, style: textStyle),
    );
  }
}
