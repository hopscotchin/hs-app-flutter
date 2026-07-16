import 'package:flutter/material.dart';

import '../../../../core/constants/strings/pdp_strings.dart';
import '../../../../core/theme/spacing.dart';

/// Snackbars for the PDP, lifted above the floating Buy Now / Go to Bag bar so
/// they never cover it. Use [PdpSnackbar.show] instead of
/// [ScaffoldMessenger.showSnackBar] anywhere on the PDP.
class PdpSnackbar {
  PdpSnackbar._();

  static void show(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 2),
  }) {
    // Outer SafeArea has bottom: false, so account for the system nav/gesture
    // inset the same way the bar itself does in PdpContent.
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: duration,
          // margin is only honoured with SnackBarBehavior.floating (set in the
          // app theme). Clear the bar's height + its bottom gap + a small margin.
          margin: const EdgeInsets.only(
            left: AppSpacing.md,
            right: AppSpacing.md,
            bottom: PdpStrings.addToBagBarHeight + AppSpacing.md,
          ),
        ),
      );
  }
}
