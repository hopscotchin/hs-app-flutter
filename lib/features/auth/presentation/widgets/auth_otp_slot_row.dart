import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';

/// OTP digit placeholders: hollow circles, 2px brand-primary bottom rule (Figma).
class AuthOtpSlotRow extends StatelessWidget {
  const AuthOtpSlotRow({super.key, required this.length, required this.filledCount});

  final int length;
  final int filledCount;

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
          final filled = i < filledCount;
          return Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: filled ? AppColors.neutralGrey6 : Colors.transparent,
              border: Border.all(color: AppColors.neutralGrey5),
            ),
          );
        }),
      ),
    );
  }
}
