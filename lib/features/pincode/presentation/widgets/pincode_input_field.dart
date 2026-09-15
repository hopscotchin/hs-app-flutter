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
    required this.keyPrefix,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onApply;
  final bool isChecking;
  final bool canApply;

  /// Host slug for this sheet's automation keys (see [PincodeTestStrings]).
  final String keyPrefix;

  @override
  Widget build(BuildContext context) {
    return OutlinedTextField(
      key: ValueKey('${keyPrefix}_${PincodeTestStrings.sheetInput}'),
      controller: controller,
      focusNode: focusNode,
      labelText: AddressStrings.enterPincodeHint,
      hintTextKey: ValueKey('${keyPrefix}_${PincodeTestStrings.sheetInputHint}'),
      required: false,
      keyboardType: TextInputType.number,
      maxLength: 6,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      suffixIconKey: ValueKey('${keyPrefix}_${PincodeTestStrings.sheetInputSuffixIcon}'),
      suffixIcon: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: isChecking
            ? Row(
                key: ValueKey('${keyPrefix}_${PincodeTestStrings.sheetApplyLoader}'),
                mainAxisSize: MainAxisSize.min,
                children: const [
                  SizedBox(
                    width: AppSpacing.md,
                    height: AppSpacing.md,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ],
              )
            : InkWell(
                key: ValueKey('${keyPrefix}_${PincodeTestStrings.sheetApplyButton}'),
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