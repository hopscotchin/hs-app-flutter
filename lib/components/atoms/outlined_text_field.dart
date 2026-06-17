import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hs_app_flutter/core/theme/spacing.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/typography/text_style_extensions.dart';
import '../../core/theme/typography/typography_v1.dart';

/// Outlined auth field (Figma “Basic Input Field”): 48px min height, 4px radius, grey-3 border.
class OutlinedTextField extends StatefulWidget {
  const OutlinedTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.required = true,
    this.helperText,
    this.errorText,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.autocorrect = true,
    this.maxLength,
    this.minLines,
    this.maxLines = 1,
    this.inputFormatters,
    this.validator,
    this.prefixText,
    this.prefixStyle,
    this.focusNode,
    this.autofocus = false,
    this.enabled = true,
    this.readOnly = false,
    this.onChanged,
    this.onTap,
    this.onTapOutside,
    this.suffix,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String labelText;
  final bool required;
  final String? helperText;
  final String? errorText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool autocorrect;
  final int? maxLength;
  final int? minLines;
  final int? maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final String? prefixText;
  final TextStyle? prefixStyle;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool enabled;
  final bool readOnly;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final Widget? suffix;
  final Widget? suffixIcon;
  final Function(PointerDownEvent)? onTapOutside;

  @override
  State<OutlinedTextField> createState() => _OutlinedTextFieldState();
}

class _OutlinedTextFieldState extends State<OutlinedTextField> {
  FocusNode? _internalFocusNode;
  FocusNode get _focusNode => widget.focusNode ?? (_internalFocusNode ??= FocusNode());

  String? _validatorError;

  static final _idleLabelStyle = AppTypographyV1.bodyMedium.regular.copyWith(
    color: AppColors.neutralGrey5,
  );

  static final _inputStyle = AppTypographyV1.bodyMedium.medium.copyWith(
    color: AppColors.neutralBlack,
    height: 1.2,
  );

  late bool _isActive = _computeActive();

  bool _computeActive() => _focusNode.hasFocus || widget.controller.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onChange);
    widget.controller.addListener(_onChange);
  }

  @override
  void didUpdateWidget(covariant OutlinedTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onChange);
      widget.controller.addListener(_onChange);
    }
    if (oldWidget.focusNode != widget.focusNode) {
      (oldWidget.focusNode ?? _internalFocusNode)?.removeListener(_onChange);
      _focusNode.addListener(_onChange);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChange);
    _focusNode.removeListener(_onChange);
    _internalFocusNode?.dispose();
    super.dispose();
  }

  void _onChange() {
    final active = _computeActive();
    if (active != _isActive && mounted) {
      setState(() => _isActive = active);
    }
  }

  OutlineInputBorder _outline(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isActive = _isActive;
    final hasError =
        (widget.errorText != null && widget.errorText!.isNotEmpty) ||
        (_validatorError != null && _validatorError!.isNotEmpty);

    final labelColor = hasError
        ? AppColors.dangerDefault
        : isActive
        ? AppColors.brandPrimary
        : AppColors.neutralGrey5;

    final activeBorder = _outline(AppColors.brandPrimary);
    final idleBorder = _outline(AppColors.neutralGrey3);

    final floatingLabelStyle = AppTypographyV1.labelLarge.regular.copyWith(color: labelColor);
    final labelStyle = isActive ? floatingLabelStyle : _idleLabelStyle;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          autofocus: widget.autofocus,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          onChanged: widget.onChanged,
          onTap: widget.onTap,
          onTapOutside: widget.onTapOutside ?? (_) => FocusManager.instance.primaryFocus?.unfocus(),
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          obscureText: widget.obscureText,
          autocorrect: widget.autocorrect,
          maxLength: widget.maxLength,
          minLines: widget.minLines,
          maxLines: widget.maxLines,
          inputFormatters: widget.inputFormatters,
          style: _inputStyle,

          decoration: InputDecoration(
            counterText: '',
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            constraints: const BoxConstraints(minHeight: 48),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            prefixText: widget.prefixText,
            prefixStyle: widget.prefixStyle ?? _inputStyle,
            suffix: widget.suffix,
            suffixIcon: widget.suffixIcon,
            errorText: widget.errorText,
            errorMaxLines: 3,
            errorStyle: AppTypographyV1.labelMedium.regular.copyWith(
              color: AppColors.dangerDefault,
            ),
            label: Text.rich(
              TextSpan(
                text: widget.labelText,
                style: labelStyle,
                children: [
                  if (widget.required)
                    TextSpan(
                      text: ' *',
                      style: labelStyle.copyWith(color: AppColors.dangerDefault),
                    ),
                ],
              ),
            ),
            floatingLabelStyle: floatingLabelStyle,
            enabledBorder: isActive ? activeBorder : idleBorder,
            disabledBorder: isActive ? activeBorder : idleBorder,
            focusedBorder: activeBorder,
            errorBorder: _outline(AppColors.dangerDefault),
            focusedErrorBorder: _outline(AppColors.dangerDefault, width: 1),
          ),
          validator: widget.validator == null
              ? null
              : (value) {
                  final error = widget.validator!(value);
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted && error != _validatorError) {
                      setState(() => _validatorError = error);
                    }
                  });
                  return error;
                },
        ),
        if (!hasError && widget.helperText != null && widget.helperText!.isNotEmpty) ...[
          AppSpacing.verticalGapXs,
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.md),
            child: Text(
              widget.helperText!,
              style: AppTypographyV1.labelMedium.regular.copyWith(color: AppColors.neutralBlack),
            ),
          ),
        ],
      ],
    );
  }
}
