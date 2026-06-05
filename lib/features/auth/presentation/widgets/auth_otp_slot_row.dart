import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/typography/text_style_extensions.dart';
import '../../../../core/theme/typography/typography_v1.dart';

/// OTP digit placeholders: hollow circles when empty, digit text when filled.
/// 2px brand-primary bottom rule (Figma).
class AuthOtpSlotRow extends StatelessWidget {
  const AuthOtpSlotRow({super.key, required this.length, required this.otp});

  final int length;
  final String otp;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.baseDefault,
        borderRadius: BorderRadius.circular(4),
        border: const Border(bottom: BorderSide(color: AppColors.brandPrimary, width: 2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(length, (i) {
          final filled = i < otp.length;
          if (filled) {
            return SizedBox(
              width: 20,
              child: Text(
                otp[i],
                textAlign: TextAlign.center,
                style: AppTypographyV1.titleMedium.bold.copyWith(color: AppColors.neutralBlack),
              ),
            );
          }
          return Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
              border: Border.all(color: AppColors.neutralGrey5),
            ),
          );
        }),
      ),
    );
  }
}
