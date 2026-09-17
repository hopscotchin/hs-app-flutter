import 'package:flutter/material.dart';
import 'package:hs_app_flutter/core/theme/colors.dart';

enum SnackStatus { success, error, warning, info, defaultStatus }

extension SnackbarX on BuildContext {
  /// [key] is the automation key for the snack's message text — snacks live on
  /// the app's `ScaffoldMessenger`, outside the page's own tree, so a test can
  /// only reach one by key. Named per screen+effect
  /// (`<screen>_<effect>_snackbar`); null leaves it unkeyed, so no existing
  /// call site changes.
  void showSnack(
    String message, {
    SnackStatus status = SnackStatus.defaultStatus,
    Duration duration = const Duration(seconds: 2),
    SnackBarAction? action,
    Key? key,
  }) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message, key: key),
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
