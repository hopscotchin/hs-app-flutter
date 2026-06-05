import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/typography.dart';
import '../../core/utils/group_digits_input_formatter.dart';

class FilledTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputType? keyboardType;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  const FilledTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.keyboardType,
    this.maxLength,
    this.inputFormatters,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      style: AppTypography.bodyLarge.copyWith(color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
        floatingLabelStyle: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
        counterText: '',
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.border),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppSpacing.radiusXs),
            topRight: Radius.circular(AppSpacing.radiusXs),
          ),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.border),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppSpacing.radiusXs),
            topRight: Radius.circular(AppSpacing.radiusXs),
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary, width: 2),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppSpacing.radiusXs),
            topRight: Radius.circular(AppSpacing.radiusXs),
          ),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.error),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppSpacing.radiusXs),
            topRight: Radius.circular(AppSpacing.radiusXs),
          ),
        ),
        contentPadding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.sm,
        ),
      ),
      validator: validator,
    );
  }
}

/// Formats digits as "XXXXX XXXXX" while typing.
/// 10-digit mobile grouped as `12345 67890`.
///
/// Thin alias over [GroupDigitsInputFormatter] — single grouping
/// implementation across mobile and pincode fields.
class MobileNumberFormatter extends GroupDigitsInputFormatter {
  const MobileNumberFormatter() : super(groupSize: 5, maxDigits: 10);
}

/// 6-digit pincode grouped as `123 456`.
///
/// Thin alias over [GroupDigitsInputFormatter] — single grouping
/// implementation across mobile and pincode fields.
class PincodeFormatter extends GroupDigitsInputFormatter {
  const PincodeFormatter() : super(groupSize: 3, maxDigits: 6);
}
