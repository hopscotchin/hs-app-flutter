import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hs_app_flutter/components/app_bottom_sheet.dart';
import 'package:hs_app_flutter/components/atoms/filled_text_field.dart';

import '../../../../components/appbar/hs_appbar.dart';
import '../../../../components/atoms/outlined_text_field.dart';
import '../../../../components/page_components/message_bars_widget.dart';
import '../../../../core/constants/strings/address_pincode_strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography/text_style_extensions.dart';
import '../../../../core/theme/typography/typography_v1.dart';
import '../../domain/entities/manage_address_args.dart';
import '../../domain/entities/shipment_address_entity.dart';
import '../bloc/manage_address_bloc.dart';

/// Single page used for both Add and Edit (mirrors Android
/// `ManageAddressActivity` which switches title/CTA based on `mode`).
class AddAddressPage extends StatefulWidget {
  const AddAddressPage({super.key, this.args = const ManageAddressArgs()});

  final ManageAddressArgs args;

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  late final Map<ManageAddressField, TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = {
      for (final f in ManageAddressField.values) f: TextEditingController(),
    };
    context.read<ManageAddressBloc>().add(
      ManageAddressInitialized(widget.args),
    );
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _syncControllers(ManageAddressState state) {
    for (final entry in _controllers.entries) {
      final next = state.valueOf(entry.key);
      final controller = entry.value;
      if (controller.text != next) {
        final selection = TextSelection.collapsed(offset: next.length);
        controller.value = TextEditingValue(text: next, selection: selection);
      }
    }
  }

  String _title(ManageAddressState s) {
    return s.mode == ManageAddressMode.create
        ? AddressStrings.addAddressTitle
        : AddressStrings.editAddressTitle;
  }

  String _saveCta(ManageAddressState s) =>
      s.isCartFlow ? AddressStrings.continueLabel : AddressStrings.save;

  Future<bool> _confirmDiscardIfDirty(BuildContext context) async {
    final bloc = context.read<ManageAddressBloc>();
    if (!bloc.isDirty) return true;
    final result = await AppBottomSheet.show<bool>(
      context,
      title: AddressStrings.leaveBottomSheetTitle,
      description: AddressStrings.leaveDialogMessage,
      secondaryAction: AppBottomSheetAction(
        label: AddressStrings.leaveDiscard,
        onPressed: () => Navigator.of(context, rootNavigator: true).pop(true),
      ),
      primaryAction: AppBottomSheetAction(
        label: AddressStrings.leaveStay,
        style: AppBottomSheetButtonStyle.filled,
        onPressed: () => Navigator.of(context, rootNavigator: true).pop(false),
      ),
    );
    return result ?? false;
  }

  void _onSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _onSubmitResult(BuildContext context, ManageAddressState s) {
    if (s.status == ManageAddressStatus.success) {
      Navigator.of(context).pop<ManageAddressResult>((
        address: s.submittedAddress,
        popUpMessage: s.toastMessage,
      ));
    } else if (s.status == ManageAddressStatus.returnReady &&
        s.shipmentResult != null) {
      Navigator.of(context).pop<ShipmentAddressEntity>(s.shipmentResult);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ManageAddressBloc, ManageAddressState>(
      listenWhen: (prev, curr) =>
          prev.toastMessage != curr.toastMessage ||
          prev.status != curr.status ||
          prev.values != curr.values,
      listener: (context, state) {
        _syncControllers(state);
        final willPopWithMessage = state.status == ManageAddressStatus.success;
        if (!willPopWithMessage &&
            state.toastMessage != null &&
            state.toastMessage!.isNotEmpty) {
          _onSnack(context, state.toastMessage!);
          context.read<ManageAddressBloc>().add(
            const ManageAddressTransientConsumed(),
          );
        }
        _onSubmitResult(context, state);
      },
      builder: (context, state) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) async {
            if (didPop) return;
            final allow = await _confirmDiscardIfDirty(context);
            if (allow && context.mounted) Navigator.of(context).pop();
          },
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Scaffold(
              backgroundColor: AppColors.baseDefault,
              appBar: HsAppbar(
                title: _title(state),
                onLeadingTap: () async {
                  final allow = await _confirmDiscardIfDirty(context);
                  if (allow && context.mounted) Navigator.of(context).pop();
                },
              ),
              body: SafeArea(
                top: false,
                child: Column(
                  children: [
                    Expanded(
                      child: _Form(controllers: _controllers, state: state),
                    ),
                    _BottomActions(
                      saveLabel: _saveCta(state),
                      submitting: state.status == ManageAddressStatus.submitting,
                      onCancel: () async {
                        final allow = await _confirmDiscardIfDirty(context);
                        if (allow && context.mounted) {
                          Navigator.of(context).pop();
                        }
                      },
                      onSave: () => context.read<ManageAddressBloc>().add(
                        const ManageAddressSubmitted(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Form extends StatelessWidget {
  const _Form({required this.controllers, required this.state});

  final Map<ManageAddressField, TextEditingController> controllers;
  final ManageAddressState state;

  void _emit(BuildContext context, ManageAddressField f, String v) {
    context.read<ManageAddressBloc>().add(ManageAddressFieldChanged(f, v));
  }

  String? _errorFor(ManageAddressField f) {
    if (state.errors[f] == true) {
      return state.errorMessages[f] ?? AddressStrings.errorRequired;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: AppSpacing.screenPadding,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
      children: [
        if (state.messageBar != null) ...[
          MessageBarsWidget(messageBars: [state.messageBar!], cardStyle: true),
          AppSpacing.verticalGapMd,
        ],
        OutlinedTextField(
          controller: controllers[ManageAddressField.name]!,
          onTapOutside: (_) {},
          labelText: AddressStrings.name,
          autocorrect: false,
          textInputAction: TextInputAction.next,
          onChanged: (v) => _emit(context, ManageAddressField.name, v),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z ]')),
          ],
          errorText: _errorFor(ManageAddressField.name),
        ),
        AppSpacing.verticalGapMd,
        OutlinedTextField(
          controller: controllers[ManageAddressField.mobile]!,
          onTapOutside: (_) {},
          labelText: AddressStrings.mobile,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          prefixText: '+91 ',
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            const MobileNumberFormatter(),
          ],
          onChanged: (v) => _emit(context, ManageAddressField.mobile, v),
          errorText: _errorFor(ManageAddressField.mobile),
        ),
        AppSpacing.verticalGapMd,
        _FieldWithTrailingIcon(
          icon: Icons.info_outline,
          tooltip: AddressStrings.tooltipAlternativeMobile,
          child: OutlinedTextField(
            controller: controllers[ManageAddressField.alternateMobile]!,
            onTapOutside: (_) {},
            labelText: AddressStrings.alternativeMobile,
            required: false,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            prefixText: '+91 ',
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              const MobileNumberFormatter(),
            ],
            onChanged: (v) =>
                _emit(context, ManageAddressField.alternateMobile, v),
            errorText: _errorFor(ManageAddressField.alternateMobile),
          ),
        ),
        AppSpacing.verticalGapMd,
        OutlinedTextField(
          controller: controllers[ManageAddressField.pincode]!,
          onTapOutside: (_) {},
          labelText: AddressStrings.pincode,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            const PincodeFormatter(),
          ],
          onChanged: (v) => _emit(context, ManageAddressField.pincode, v),
          errorText: _errorFor(ManageAddressField.pincode),
          suffix: SizedBox(
            width: 16,
            height: 16,
            child: state.pincodeChecking
                ? const CircularProgressIndicator(strokeWidth: 2)
                : null,
          ),
        ),
        AppSpacing.verticalGapMd,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: OutlinedTextField(
                controller: controllers[ManageAddressField.city]!,
                labelText: AddressStrings.city,
                enabled: false,
                onChanged: (v) => _emit(context, ManageAddressField.city, v),
                errorText: _errorFor(ManageAddressField.city),
              ),
            ),
            AppSpacing.horizontalGapSm,
            Expanded(
              child: OutlinedTextField(
                controller: controllers[ManageAddressField.state]!,
                labelText: AddressStrings.state,
                enabled: false,
                onChanged: (v) => _emit(context, ManageAddressField.state, v),
                errorText: _errorFor(ManageAddressField.state),
              ),
            ),
          ],
        ),
        AppSpacing.verticalGapMd,
        OutlinedTextField(
          controller: controllers[ManageAddressField.address1]!,
          onTapOutside: (_) {},
          labelText: AddressStrings.flatHouse,
          keyboardType: TextInputType.multiline,
          autocorrect: false,
          minLines: 1,
          maxLines: null,
          onChanged: (v) => _emit(context, ManageAddressField.address1, v),
          errorText: _errorFor(ManageAddressField.address1),
        ),
        AppSpacing.verticalGapMd,
        OutlinedTextField(
          controller: controllers[ManageAddressField.streetAddress]!,
          onTapOutside: (_) {},
          labelText: AddressStrings.streetArea,
          keyboardType: TextInputType.multiline,
          autocorrect: false,
          minLines: 1,
          maxLines: null,
          onChanged: (v) => _emit(context, ManageAddressField.streetAddress, v),
          errorText: _errorFor(ManageAddressField.streetAddress),
        ),
        AppSpacing.verticalGapMd,
        OutlinedTextField(
          controller: controllers[ManageAddressField.landmark]!,
          onTapOutside: (_) {},
          labelText: AddressStrings.landmark,
          required: false,
          autocorrect: false,
          textInputAction: TextInputAction.done,
          onChanged: (v) => _emit(context, ManageAddressField.landmark, v),
        ),
        AppSpacing.verticalGapMd,
        _DefaultAddressCheckbox(
          value: state.isDefault,
          onChanged: (v) => context.read<ManageAddressBloc>().add(
            ManageAddressDefaultToggled(v ?? false),
          ),
        ),
      ],
    );
  }
}

class _FieldWithTrailingIcon extends StatelessWidget {
  const _FieldWithTrailingIcon({
    required this.child,
    required this.icon,
    required this.tooltip,
  });

  final Widget child;
  final IconData icon;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        child,
        Padding(
          padding: const EdgeInsets.only(right: AppSpacing.md),
          child: Tooltip(
            message: tooltip,
            triggerMode: TooltipTriggerMode.tap,
            preferBelow: false,
            verticalOffset: 12,
            margin: const EdgeInsets.only(right: AppSpacing.sm),
            decoration: const ShapeDecoration(
              color: AppColors.neutralGrey6,
              shape: _TooltipShape(arrowRightInset: 20),
            ),
            child: Icon(
              icon,
              size: AppSpacing.iconSm,
              color: AppColors.neutralBlack,
            ),
          ),
        ),
      ],
    );
  }
}

/// Tooltip bubble with rounded corners and a downward-pointing triangle
/// at the bottom, positioned near the right edge to point at the info icon.
class _TooltipShape extends ShapeBorder {
  const _TooltipShape({
    this.radius = AppSpacing.xxs,
    this.arrowWidth = 12,
    this.arrowHeight = 7,
    this.arrowRightInset = 14,
  });

  /// Corner radius of the bubble.
  final double radius;

  /// Base width of the triangle.
  final double arrowWidth;

  /// Height the triangle protrudes below the bubble.
  final double arrowHeight;

  /// Distance from the right edge to the triangle's center.
  final double arrowRightInset;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.only(bottom: arrowHeight);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      getOuterPath(rect, textDirection: textDirection);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final body = Rect.fromLTWH(
      rect.left,
      rect.top,
      rect.width,
      rect.height - arrowHeight,
    );
    final arrowCenter = body.right - arrowRightInset;
    return Path()
      ..addRRect(RRect.fromRectAndRadius(body, Radius.circular(radius)))
      ..moveTo(arrowCenter - arrowWidth / 2, body.bottom)
      ..lineTo(arrowCenter, body.bottom + arrowHeight)
      ..lineTo(arrowCenter + arrowWidth / 2, body.bottom)
      ..close();
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => _TooltipShape(
    radius: radius * t,
    arrowWidth: arrowWidth * t,
    arrowHeight: arrowHeight * t,
    arrowRightInset: arrowRightInset * t,
  );
}

class _MarkOnMapRow extends StatelessWidget {
  const _MarkOnMapRow({required this.locationApplied, required this.onTap});

  final bool locationApplied;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.neutralGrey1,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Icon(
              locationApplied ? Icons.check_circle_outline : Icons.my_location,
              size: 20,
              color: locationApplied
                  ? AppColors.successDefault
                  : AppColors.neutralBlack,
            ),
            AppSpacing.horizontalGapSm,
            Expanded(
              child: Text(
                locationApplied
                    ? AddressStrings.locationUpdated
                    : AddressStrings.markItOnMap,
                style: AppTypographyV1.bodyMedium.medium.copyWith(
                  color: AppColors.neutralBlack,
                ),
              ),
            ),
            const Tooltip(
              message: AddressStrings.tooltipLocation,
              triggerMode: TooltipTriggerMode.tap,
              preferBelow: false,
              child: Icon(Icons.info_outline, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}

class _DefaultAddressCheckbox extends StatefulWidget {
  const _DefaultAddressCheckbox({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  State<_DefaultAddressCheckbox> createState() =>
      _DefaultAddressCheckboxState();
}

class _DefaultAddressCheckboxState extends State<_DefaultAddressCheckbox> {
  final GlobalKey _checkboxKey = GlobalKey();

  void _handleTap() {
    widget.onChanged(!widget.value);
    _rippleOnCheckbox();
  }

  // Paint an ink ripple centred on the checkbox regardless of where the tap
  // landed (checkbox or label). Contained + clipped to a rounded square rect so
  // the splash stays a square hugging the checkbox.
  void _rippleOnCheckbox() {
    final context = _checkboxKey.currentContext;
    if (context == null) return;
    final box = context.findRenderObject() as RenderBox?;
    final controller = Material.maybeOf(context);
    if (box == null || controller == null) return;
    final rect = (Offset.zero & box.size).inflate(1);
    InkRipple(
      controller: controller,
      referenceBox: box,
      position: rect.center,
      rectCallback: () => rect,
      borderRadius: BorderRadius.circular(4),
      color: AppColors.secondary.withValues(alpha: 0.24),
      containedInkWell: true,
      radius: 14,
      textDirection: Directionality.of(context),
    ).confirm();
  }

  @override
  Widget build(BuildContext context) {
    final value = widget.value;
    return Material(
      type: MaterialType.transparency,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: _handleTap,
            behavior: HitTestBehavior.opaque,
            child: SizedBox(
              key: _checkboxKey,
              width: 18,
              height: 18,
              child: Ink(
                decoration: BoxDecoration(
                  color: value ? AppColors.secondary : AppColors.neutralGrey2,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: value ? AppColors.secondary : AppColors.neutralGrey2,
                    width: 2,
                  ),
                ),
                child: value
                    ? const Padding(
                        padding: EdgeInsets.all(1.5),
                        child: FittedBox(
                          child: Icon(
                            Icons.check,
                            color: AppColors.baseDefault,
                          ),
                        ),
                      )
                    : null,
              ),
            ),
          ),
          AppSpacing.horizontalGapXs,
          GestureDetector(
            onTap: _handleTap,
            behavior: HitTestBehavior.opaque,
            child: Text(
              AddressStrings.makeDefault,
              style: AppTypographyV1.bodyRegular.medium.copyWith(
                color: AppColors.neutralBlack,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomActions extends StatelessWidget {
  const _BottomActions({
    required this.saveLabel,
    required this.submitting,
    required this.onCancel,
    required this.onSave,
  });

  final String saveLabel;
  final bool submitting;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Platform.isIOS
          ? const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md,
              0,
            )
          : const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 48,
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  backgroundColor: AppColors.brandTertiary,
                  padding: AppSpacing.paddingVerticalMd,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                onPressed: submitting ? null : onCancel,
                child: Text(
                  AddressStrings.cancel,
                  style: AppTypographyV1.bodyLarge.bold.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SizedBox(
              height: 48,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  padding: AppSpacing.paddingVerticalMd,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                onPressed: submitting ? null : onSave,
                child: submitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.onPrimary,
                          ),
                        ),
                      )
                    : Text(saveLabel, style: AppTypographyV1.bodyLarge.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
