import 'package:flutter/material.dart';

import '../../core/theme/colors.dart';

/// A rounded-square checkbox. Unchecked shows a muted grey fill; checked
/// flips the fill to [AppColors.brandSecondary] with a white check glyph.
/// The footprint doesn't shift between states — only the fill + glyph.
///
/// Fires [onChanged] with the new value on tap.
class SelectionCheckbox extends StatelessWidget {
  const SelectionCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.size = 24,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final double size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: value ? AppColors.brandSecondary : AppColors.neutralGrey2,
          borderRadius: BorderRadius.circular(size * 0.25),
        ),
        alignment: Alignment.center,
        child: value
            ? Icon(
                Icons.check_rounded,
                size: size * 0.66,
                color: AppColors.whiteColor,
              )
            : null,
      ),
    );
  }
}
