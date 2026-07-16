import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';

/// Right-side page indicator for the PDP vertical image carousel and the
/// fullscreen image gallery. The active dot elongates.
class PdpVerticalDotIndicator extends StatelessWidget {
  const PdpVerticalDotIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
    this.activeColor = _defaultActiveColor,
  });

  final int count;
  final int currentIndex;
  final Color activeColor;

  // Figma: inactive 5×5 rgba(0,0,0,0.2), active 5×13 rgba(0,0,0,0.5), gap=4, r=42
  static const _dotWidth = 5.0;
  static const _inactiveHeight = 5.0;
  static const _activeHeight = 13.33;
  static const _inactiveColor = Color(0x33000000); // rgba(0,0,0,0.2)
  static const _defaultActiveColor = AppColors.overlay; // rgba(0,0,0,0.5)
  static const _borderColor = Color(0xFFFFFFFF); // 0.5px white stroke

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        final selected = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(vertical: 2),
          width: _dotWidth,
          height: selected ? _activeHeight : _inactiveHeight,
          decoration: BoxDecoration(
            color: selected ? activeColor : _inactiveColor,
            border: Border.all(color: _borderColor, width: 0.5),
            borderRadius: BorderRadius.circular(42),
          ),
        );
      }),
    );
  }
}
