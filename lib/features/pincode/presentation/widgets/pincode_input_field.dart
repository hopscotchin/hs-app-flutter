import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hs_app_flutter/core/constants/strings/address_pincode_strings.dart';
import 'package:hs_app_flutter/core/constants/strings/auto_test_strings.dart';
import 'package:hs_app_flutter/core/constants/strings/common_strings.dart';
import 'package:hs_app_flutter/core/theme/spacing.dart';

import '../../../../components/atoms/outlined_text_field.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/typography/text_style_extensions.dart';
import '../../../../core/theme/typography/typography_v1.dart';

class PincodeInputField extends StatelessWidget {
  const PincodeInputField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onApply,
    required this.isChecking,
    required this.canApply,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onApply;
  final bool isChecking;
  final bool canApply;

  @override
  Widget build(BuildContext context) {
    return OutlinedTextField(
      controller: controller,
      focusNode: focusNode,
      labelText: AddressStrings.enterPincodeHint,
      hintTextKey: const ValueKey(PincodeTestStrings.sheetInputHint),
      required: false,
      keyboardType: TextInputType.number,
      maxLength: 6,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      suffixIconKey: const ValueKey(PincodeTestStrings.sheetInputSuffixIcon),
      suffixIcon: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: isChecking
            ? const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: AppSpacing.md,
                    height: AppSpacing.md,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ],
              )
            : InkWell(
                onTap: canApply ? onApply : null,
                child: Align(
                  widthFactor: 1,
                  child: Text(
                    CommonStrings.apply,
                    style: AppTypographyV1.bodyRegular.bold.copyWith(
                      color: canApply
                          ? AppColors.primary
                          : AppColors.neutralGrey5,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}