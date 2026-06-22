import 'package:flutter/material.dart';

import '../../core/theme/colors.dart';

/// Defaults: track 36x18, thumb 20x20.
class AppToggleSwitch extends StatelessWidget {
  const AppToggleSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.trackWidth = 36,
    this.trackHeight = 18,
    this.thumbSize = 20,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final double trackWidth;
  final double trackHeight;
  final double thumbSize;

  static const Color _onTrackColor = Color(0x26836EF1);

  @override
  Widget build(BuildContext context) {
    final enabled = onChanged != null;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: enabled ? () => onChanged!(!value) : null,
      child: SizedBox(
        width: trackWidth,
        height: thumbSize,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: trackWidth,
              height: trackHeight,
              decoration: BoxDecoration(
                color: value ? _onTrackColor : AppColors.neutralGrey2,
                borderRadius: BorderRadius.circular(trackHeight / 2),
              ),
            ),
            AnimatedAlign(
              duration: const Duration(milliseconds: 150),
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: thumbSize,
                height: thumbSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: value ? AppColors.secondary : AppColors.baseDefault,
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x29000000),
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
