import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/typography.dart';

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
class MobileNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length > 10) {
      return oldValue;
    }

    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i == 5) buffer.write(' ');
      buffer.write(digits[i]);
    }
    final formatted = buffer.toString();

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
