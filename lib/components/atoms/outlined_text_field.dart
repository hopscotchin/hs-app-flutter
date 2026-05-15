import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/typography/text_style_extensions.dart';
import '../../core/theme/typography/typography_v1.dart';

/// Outlined auth field (Figma “Basic Input Field”): 48px min height, 4px radius, grey-3 border.
class OutlinedTextField extends StatelessWidget {
  const OutlinedTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.required = true,
    this.helperText,
    this.keyboardType,
    this.maxLength,
    this.inputFormatters,
    this.validator,
    this.prefixText,
    this.prefixStyle,
    this.focusNode,
    this.autofocus = false,
  });

  final TextEditingController controller;
  final String labelText;
  final bool required;
  final String? helperText;
  final TextInputType? keyboardType;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final String? prefixText;
  final TextStyle? prefixStyle;
  final FocusNode? focusNode;
  final bool autofocus;
  static final _idleLabelStyle = AppTypographyV1.bodyMedium.regular.copyWith(
    color: AppColors.neutralGrey5,
  );

  static final _floatingLabelStyle = AppTypographyV1.labelLarge.regular.copyWith(
    color: AppColors.brandPrimary,
  );

  static final _inputStyle = AppTypographyV1.bodyMedium.medium.copyWith(
    color: AppColors.neutralBlack,
  );

  OutlineInputBorder _outline(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          autofocus: autofocus,
          keyboardType: keyboardType,
          maxLength: maxLength,
          inputFormatters: inputFormatters,
          style: _inputStyle,
          decoration: InputDecoration(
            counterText: '',
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            constraints: const BoxConstraints(minHeight: 48),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            prefixText: prefixText,
            prefixStyle: prefixStyle ?? _inputStyle,
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(labelText, style: _idleLabelStyle),
                if (required) ...[
                  const SizedBox(width: 2),
                  Text('*', style: _idleLabelStyle.copyWith(color: AppColors.dangerDefault)),
                ],
              ],
            ),
            floatingLabelStyle: _floatingLabelStyle,
            enabledBorder: _outline(AppColors.neutralGrey3),
            focusedBorder: _outline(AppColors.brandPrimary, width: 1),
            errorBorder: _outline(AppColors.dangerDefault),
            focusedErrorBorder: _outline(AppColors.dangerDefault, width: 2),
          ),
          validator: validator,
        ),
        if (helperText != null && helperText!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              helperText!,
              style: AppTypographyV1.labelMedium.regular.copyWith(color: AppColors.neutralBlack),
            ),
          ),
        ],
      ],
    );
  }
}
