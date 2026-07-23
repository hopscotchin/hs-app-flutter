import 'package:flutter/material.dart';
import 'package:hs_app_flutter/core/extensions/string_extensions.dart';
import 'package:hs_app_flutter/core/theme/colors.dart';
import 'package:hs_app_flutter/core/theme/spacing.dart';
import 'package:hs_app_flutter/core/theme/typography/text_style_extensions.dart';
import 'package:hs_app_flutter/core/theme/typography/typography_v1.dart';

class AppRadio extends StatelessWidget {
  const AppRadio({
    super.key,
    required this.isSelected,
    this.onTap,
    this.isDisabled = false,
    this.count,
    this.maxLabelLines = 3,
    this.labelKey,
    this.countKey,
  }) : label = null;

  const AppRadio.labeled({
    super.key,
    required this.isSelected,
    required this.label,
    this.onTap,
    this.isDisabled = false,
    this.count,
    this.maxLabelLines = 3,
    this.labelKey,
    this.countKey,
  });

  final bool isSelected;
  final VoidCallback? onTap;
  final String? label;
  final bool isDisabled;
  final String? count;
  final int maxLabelLines;

  /// Automation keys for the label / count text (null → unkeyed).
  final Key? labelKey;
  final Key? countKey;

  static const Color _labelColor = AppColors.neutralBlack;

  bool get _isInteractive => !isDisabled && onTap != null;
  double get _size => 20.0;
  Color get _activeColor => AppColors.brandSecondary;
  Color get _inactiveColor => AppColors.neutralGrey3;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isDisabled ? 0.5 : 1.0,
      duration: const Duration(milliseconds: 150),
      child: GestureDetector(
        onTap: _isInteractive ? onTap : null,
        behavior: HitTestBehavior.opaque,
        child: label != null ? _buildWithLabel() : buildRadio(),
      ),
    );
  }

  Widget _buildWithLabel() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        buildRadio(),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          flex: 1,
          child: Text(
            label ?? '',
            key: labelKey,
            style: AppTypographyV1.bodyRegular.regular.copyWith(color: _labelColor),
            overflow: TextOverflow.ellipsis,
            maxLines: maxLabelLines,
          ),
        ),
        if (count.isNotNullOrEmpty) ...[
          const SizedBox(width: 10),
          Text(
            count ?? '',
            key: countKey,
            style: AppTypographyV1.labelLarge.regular.copyWith(color: Colors.black.withAlpha(50)),
          ),
          const SizedBox(width: 10),
        ],
      ],
    );
  }

  Widget buildRadio() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: _size,
      height: _size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? _activeColor : Colors.transparent,
        border: Border.all(color: isSelected ? _activeColor : _inactiveColor, width: 2),
      ),
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: isSelected ? _size * 0.8 : 0,
          height: isSelected ? _size * 0.8 : 0,
          decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: isSelected ? _size * 0.5 : 0,
              height: isSelected ? _size * 0.5 : 0,
              decoration: BoxDecoration(shape: BoxShape.circle, color: _activeColor),
            ),
          ),
        ),
      ),
    );
  }
}
