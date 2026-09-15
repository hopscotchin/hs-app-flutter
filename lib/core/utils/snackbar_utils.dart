import 'package:flutter/material.dart';
import 'package:hs_app_flutter/components/atoms/auto_semantics.dart';
import 'package:hs_app_flutter/core/theme/colors.dart';

enum SnackStatus { success, error, warning, info, defaultStatus }

extension SnackbarX on BuildContext {
  void showSnack(
    String message, {
    SnackStatus status = SnackStatus.defaultStatus,
    Duration duration = const Duration(seconds: 2),
    SnackBarAction? action,
    // Automation key for the snackbar's text. Optional so existing call sites
    // stay unkeyed; mirrored onto the platform a11y node for Maestro/Appium.
    Key? contentKey,
  }) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: AutoSemantics.fromKey(
            contentKey,
            child: Text(message, key: contentKey),
          ),
          backgroundColor: const Color(0xff353535),
          // _bgFor(status),
          duration: duration,
          action: action,
        ),
      );
  }

  Color? _bgFor(SnackStatus status) => switch (status) {
    SnackStatus.success => AppColors.successDefault,
    SnackStatus.error => AppColors.dangerDefault,
    SnackStatus.warning => AppColors.warningDefault,
    SnackStatus.info => AppColors.infoDefault,
    SnackStatus.defaultStatus => null,
  };
}
