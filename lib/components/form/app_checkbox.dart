import 'package:flutter/material.dart';
import 'package:hs_app_flutter/core/extensions/string_extensions.dart';
import 'package:hs_app_flutter/core/theme/colors.dart';
import 'package:hs_app_flutter/core/theme/spacing.dart';
import 'package:hs_app_flutter/core/theme/typography/text_style_extensions.dart';
import 'package:hs_app_flutter/core/theme/typography/typography_v1.dart';

class AppCheckbox extends StatelessWidget {
  const AppCheckbox({
    super.key,
    required this.isSelected,
    this.onChanged,
    this.isDisabled = false,
    this.checkBoxSelectedColor,
    this.checkBoxUnSelectedColor,
    this.checkColor,
    this.count,
    this.maxLabelLines = 1,
    this.border,
  }) : label = null;

  const AppCheckbox.labeled({
    super.key,
    required this.isSelected,
    required this.label,
    this.onChanged,
    this.isDisabled = false,
    this.checkBoxSelectedColor,
    this.checkBoxUnSelectedColor,
    this.checkColor,
    this.count,
    this.maxLabelLines = 1,
    this.border,
  });

  final bool isSelected;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final bool isDisabled;
  final Color? checkBoxSelectedColor;
  final Color? checkBoxUnSelectedColor;
  final Color? checkColor;
  final String? count;
  final int maxLabelLines;
  final BoxBorder? border;

  static const double _boxSize = 20.0;
  static const double _radius = 4.0;
  static const double _checkIconSize = 13.0;

  static const Color _checkColor = Colors.white;
  static const Color _labelColor = AppColors.neutralBlack;

  bool get _isInteractive => !isDisabled && onChanged != null;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isDisabled ? 0.5 : 1.0,
      duration: const Duration(milliseconds: 150),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isInteractive ? () => onChanged!(!isSelected) : null,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          child: label != null ? _buildWithLabel() : _buildBox(),
        ),
      ),
    );
  }

  Widget _buildWithLabel() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildBox(),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            label ?? '',
            style: AppTypographyV1.bodyRegular.regular.copyWith(color: _labelColor),
            overflow: TextOverflow.ellipsis,
            maxLines: maxLabelLines,
          ),
        ),
        if (count.isNotNullOrEmpty) ...[
          Text(
            count ?? '',
            textAlign: TextAlign.end,
            style: AppTypographyV1.labelLarge.regular.copyWith(color: Colors.black.withAlpha(50)),
          ),
          const SizedBox(width: 12),
        ],
      ],
    );
  }

  Widget _buildBox() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: _boxSize,
      height: _boxSize,
      decoration: BoxDecoration(
        color: isSelected
            ? checkBoxSelectedColor ?? AppColors.brandSecondary
            : checkBoxUnSelectedColor ?? AppColors.neutralGrey2,
        borderRadius: BorderRadius.circular(_radius),
        border: border,
      ),
      child: isSelected
          ? Center(
              child: Icon(
                Icons.check_rounded,
                size: _checkIconSize,
                color: checkColor ?? _checkColor,
              ),
            )
          : null,
    );
  }
}
