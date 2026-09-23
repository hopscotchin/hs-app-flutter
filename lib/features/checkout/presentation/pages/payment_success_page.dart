import 'package:flutter/material.dart';
import 'package:hs_app_flutter/core/constants/image_constants.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/constants/strings/checkout_strings.dart';
import '../../../../core/router/app_navigator.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/typography/text_style_extensions.dart';
import '../../../../core/theme/typography/typography_v1.dart';
import '../../domain/entities/order_confirmation_entry_args.dart';
import '../../domain/entities/order_confirmation_entity.dart';

/// Full-screen "Thank you" beat between payment success and the order
/// confirmation. Ports Android's `PaymentSuccessActivity`: 150dp Lottie
/// on top, "Thank you" and "Order placed successfully" beneath, and on
/// animation-end it advances to the order confirmation screen (which
/// slides in from the bottom — see `AppNavigator.goToOrderConfirmation`).
class PaymentSuccessPage extends StatefulWidget {
  final OrderConfirmationEntity orderConfirmationEntity;
  final String? fromScreen;

  const PaymentSuccessPage({
    super.key,
    required this.orderConfirmationEntity,
    this.fromScreen,
  });

  @override
  State<PaymentSuccessPage> createState() => _PaymentSuccessPageState();
}

class _PaymentSuccessPageState extends State<PaymentSuccessPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this)
    ..addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        AppNavigator.goToHome(context);
        // AppNavigator.goToOrderConfirmation(
        //   context,
        //   OrderConfirmationEntryArgs(
        //     orderConfirmationEntity: widget.orderConfirmationEntity,
        //     fromScreen: widget.fromScreen,
        //   ),
        // );
      }
    });

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // No back — this is a one-shot transition to order confirmation.
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  ImageConstants.orderConfirmationAnimation,
                  width: 150,
                  height: 150,
                  controller: _controller,
                  onLoaded: (composition) {
                    _controller
                      ..duration = composition.duration
                      ..forward();
                  },
                ),
                const SizedBox(height: 5),
                Text(
                  CheckoutStrings.thankYou,
                  style: AppTypographyV1.titleLarge.bold.copyWith(
                    color: AppColors.successDefault,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  CheckoutStrings.orderPlacedSuccessfully,
                  style: AppTypographyV1.bodyRegular.bold.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
