import 'package:flutter/material.dart';

import '../../../../components/atoms/dots_loader.dart';
import '../../../../core/constants/strings/auth_strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography/text_style_extensions.dart';
import '../../../../core/theme/typography/typography_v1.dart';

/// Static six-dot loader + “Waiting for OTP” (Figma OTP screen).
class OtpWaitingIndicator extends StatefulWidget {
  const OtpWaitingIndicator({super.key, this.dotCount = 6});

  final int dotCount;

  @override
  State<OtpWaitingIndicator> createState() => _OtpWaitingIndicatorState();
}

class _OtpWaitingIndicatorState extends State<OtpWaitingIndicator> with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: const Duration(seconds: 1), vsync: this);
    controller.repeat(reverse: false);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DotsLoader(controller: controller),
        AppSpacing.verticalGapXs,
        Text(
          AuthStrings.waitingForOtp,
          textAlign: TextAlign.center,
          style: AppTypographyV1.labelLarge.medium.copyWith(color: AppColors.neutralGrey5),
        ),
      ],
    );
  }
}
