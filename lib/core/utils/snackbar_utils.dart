import 'package:flutter/material.dart';
import 'package:hs_app_flutter/core/theme/colors.dart';

enum SnackStatus { success, error, warning, info, defaultStatus }

extension SnackbarX on BuildContext {
  void showSnack(
    String message, {
    SnackStatus status = SnackStatus.defaultStatus,
    Duration duration = const Duration(seconds: 2),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
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
