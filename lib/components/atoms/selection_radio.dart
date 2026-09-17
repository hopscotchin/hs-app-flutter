import 'package:flutter/material.dart';

import '../../core/theme/colors.dart';

/// A 20px filled-dot radio indicator. Selected fills the inner dot with
/// [AppColors.brandSecondary]; unselected shows only the outlined border in
/// [AppColors.neutralGrey5]; disabled paints the whole thing in
/// [AppColors.neutralGrey4] with the dot visible so the row still reads as
/// "chosen but unactionable".
///
/// Presentational only — the tap target is the caller's responsibility.
class SelectionRadio extends StatelessWidget {
  const SelectionRadio({
    super.key,
    required this.selected,
    this.isDisabled = false,
  });

  final bool selected;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    final borderColor = isDisabled
        ? AppColors.neutralGrey4
        : selected
        ? AppColors.brandSecondary
        : AppColors.neutralGrey5;
    final showDot = isDisabled || selected;
    final dotColor = isDisabled ? AppColors.neutralGrey4 : AppColors.brandSecondary;

    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 1.8),
      ),
      child: showDot
          ? Center(
              child: Container(
                width: 13,
                height: 13,
                decoration: BoxDecoration(shape: BoxShape.circle, color: dotColor),
              ),
            )
          : null,
    );
  }
}
