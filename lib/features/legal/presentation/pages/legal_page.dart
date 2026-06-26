import 'package:flutter/material.dart';

import '../../../../components/appbar/hs_appbar.dart';
import '../../../../core/constants/strings/legal_strings.dart';
import '../../../../core/navigation/legal_launcher.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../domain/entities/legal_touch_point.dart';
import '../widgets/legal_item_widget.dart';

/// Static list of legal pages (Terms / Privacy / About Us).
///
/// Ported from the Android `LegalPageActivity`: each row opens the matching
/// web page in the in-app WebView via [LegalLauncher].
class LegalPage extends StatelessWidget {
  const LegalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.baseDefault,
      appBar: HsAppbar(title: LegalStrings.legal),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        itemCount: LegalTouchPoint.values.length,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.xl),
        itemBuilder: (context, index) {
          final touchPoint = LegalTouchPoint.values[index];
          return LegalItemWidget(
            touchPoint: touchPoint,
            onTap: () => LegalLauncher.open(context, touchPoint),
          );
        },
      ),
    );
  }
}
