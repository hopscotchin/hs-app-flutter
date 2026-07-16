import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hs_app_flutter/core/constants/strings/address_pincode_strings.dart';

import '../../../../components/buttons/app_button.dart';
import '../../../../components/buttons/button_enums.dart';
import '../../../../components/page_components/message_bars_widget.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/entities/message_bar_entity.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography/text_style_extensions.dart';
import '../../../../core/theme/typography/typography_v1.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../bloc/pincode_sheet_bloc.dart';
import 'pincode_address_section.dart';

export '../bloc/pincode_sheet_source.dart';
import 'pincode_input_field.dart';

/// Bottom sheet that lets the user pick a saved address or enter a pincode
/// to validate delivery serviceability. Returns the chosen pincode (string)
/// to the caller, or `null` if dismissed.
class PincodeBottomSheet extends StatelessWidget {
  const PincodeBottomSheet({super.key, this.onPdpVerify});

  /// PDP-only: runs the product-aware verify API while the sheet stays open
  /// showing the Apply loader. The sheet pops once this completes.
  final Future<void> Function(String pincode)? onPdpVerify;

  static Future<String?> show(
    BuildContext context, {
    PincodeSheetSource source = PincodeSheetSource.cart,
    Future<void> Function(String pincode)? onPdpVerify,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider(
        create: (_) => sl<PincodeSheetBloc>()
          ..add(PincodeSheetEvent.open(source: source)),
        child: PincodeBottomSheet(onPdpVerify: onPdpVerify),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _PincodeSheetBody(onPdpVerify: onPdpVerify);
  }
}

class _PincodeSheetBody extends StatefulWidget {
  const _PincodeSheetBody({this.onPdpVerify});

  final Future<void> Function(String pincode)? onPdpVerify;

  @override
  State<_PincodeSheetBody> createState() => _PincodeSheetBodyState();
}

class _PincodeSheetBodyState extends State<_PincodeSheetBody> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  // PDP-only: true while Proceed drives the verify API, showing the button loader.
  bool _proceeding = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode()..addListener(_onFocusChange);
    _controller.addListener(_onTextChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _controller.removeListener(_onTextChange);
    _controller.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      context.read<PincodeSheetBloc>().add(const PincodeSheetEvent.focusInput());
    }
  }

  void _onTextChange() {
    final bloc = context.read<PincodeSheetBloc>();
    if (bloc.state.enteredPincode != _controller.text) {
      bloc.add(PincodeSheetEvent.pincodeChanged(_controller.text));
    }
  }

  Future<void> _onApplyPressed() async {
    final bloc = context.read<PincodeSheetBloc>();
    final state = bloc.state;
    // Fires the Apply loader (isChecking) in both flows.
    bloc.add(const PincodeSheetEvent.apply());

    // PDP: keep the sheet open with the loader while PDP runs its own
    // product-aware verify API, then pop. Cart is fully driven by the bloc
    // (it sets popResult on success, which the listener below pops).
    if (state.source == PincodeSheetSource.pdp && widget.onPdpVerify != null) {
      final pincode = state.enteredPincode.trim();
      if (pincode.length != 6) return;
      await widget.onPdpVerify!(pincode);
      if (mounted) Navigator.of(context).pop();
    }
  }

  Future<void> _onProceedPressed(String pincode) async {
    final bloc = context.read<PincodeSheetBloc>();
    // PDP: verify the selected address pincode in-place (button loader), then
    // pop. Cart already validated on select/apply, so just return the pincode.
    if (bloc.state.source == PincodeSheetSource.pdp && widget.onPdpVerify != null) {
      setState(() => _proceeding = true);
      await widget.onPdpVerify!(pincode);
      if (mounted) Navigator.of(context).pop();
      return;
    }
    Navigator.of(context).pop(pincode);
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets.bottom;
    final maxHeight = MediaQuery.of(context).size.height * 0.85;

    return MultiBlocListener(
      listeners: [
        BlocListener<PincodeSheetBloc, PincodeSheetState>(
          listenWhen: (p, c) => p.toastMessage != c.toastMessage,
          listener: (context, state) {
            if (state.toastMessage != null && state.toastMessage!.isNotEmpty) {
              context.showSnack(state.toastMessage!);
            }
          },
        ),
        BlocListener<PincodeSheetBloc, PincodeSheetState>(
          listenWhen: (p, c) => p.popResult != c.popResult,
          listener: (context, state) {
            // Apply closes the sheet immediately with the entered pincode.
            // Address selection does not set popResult — it waits for Proceed.
            if (state.popResult != null) {
              Navigator.of(context).pop(state.popResult);
            }
          },
        ),
        BlocListener<PincodeSheetBloc, PincodeSheetState>(
          listenWhen: (p, c) => p.enteredPincode != c.enteredPincode,
          listener: (context, state) {
            if (_controller.text != state.enteredPincode) {
              _controller.text = state.enteredPincode;
            }
          },
        ),
      ],
      child: SafeArea(
        top: false,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: Padding(
            padding: EdgeInsets.only(bottom: viewInsets),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _MessageBarsSlot(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AddressStrings.deliverTo,
                      style: AppTypographyV1.titleSmall.bold.textPrimary(),
                    ),
                  ),
                ),
                const Flexible(child: _AddressList()),
                AppSpacing.verticalGapLg,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: BlocBuilder<PincodeSheetBloc, PincodeSheetState>(
                    buildWhen: (p, c) =>
                        p.enteredPincode != c.enteredPincode ||
                        p.isChecking != c.isChecking,
                    builder: (context, state) {
                      final canApply =
                          state.enteredPincode.length == 6 && !state.isChecking;
                      return PincodeInputField(
                        controller: _controller,
                        focusNode: _focusNode,
                        isChecking: state.isChecking,
                        canApply: canApply,
                        onApply: _onApplyPressed,
                      );
                    },
                  ),
                ),
                AppSpacing.verticalGapMd,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: _ProceedButton(
                    loading: _proceeding,
                    onProceed: _onProceedPressed,
                  ),
                ),
                AppSpacing.verticalGapMd,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProceedButton extends StatelessWidget {
  const _ProceedButton({required this.loading, required this.onProceed});

  final bool loading;
  final void Function(String pincode) onProceed;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PincodeSheetBloc, PincodeSheetState>(
      buildWhen: (p, c) =>
          p.lastCheckedValidPincode != c.lastCheckedValidPincode ||
          p.isChecking != c.isChecking,
      builder: (context, state) {
        final pincode = state.lastCheckedValidPincode;
        final canProceed = pincode != null && !state.isChecking;
        return AppButton(
          text: AddressStrings.proceed,
          variant: ButtonVariant.primary,
          isFullWidth: true,
          state: loading
              ? ButtonState.loading
              : (canProceed ? ButtonState.enabled : ButtonState.disabled),
          onTap: canProceed && !loading ? () => onProceed(pincode) : null,
        );
      },
    );
  }
}

class _AddressList extends StatelessWidget {
  const _AddressList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PincodeSheetBloc, PincodeSheetState>(
      buildWhen: (p, c) =>
          p.addresses != c.addresses ||
          p.selectedAddressId != c.selectedAddressId,
      builder: (context, state) {
        if (state.addresses.isEmpty) return const SizedBox.shrink();
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSpacing.verticalGapLg,
              PincodeAddressSection(
                title: AddressStrings.defaultAddressHeading,
                addresses: state.defaultAddresses,
                selectedAddressId: state.selectedAddressId,
                topSpacing: 0,
                onSelect: (id) => context
                    .read<PincodeSheetBloc>()
                    .add(PincodeSheetEvent.selectAddress(id)),
              ),
              PincodeAddressSection(
                title: AddressStrings.otherAddressHeading,
                addresses: state.otherAddresses,
                selectedAddressId: state.selectedAddressId,
                topSpacing: AppSpacing.xs,
                onSelect: (id) => context
                    .read<PincodeSheetBloc>()
                    .add(PincodeSheetEvent.selectAddress(id)),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MessageBarsSlot extends StatelessWidget {
  const _MessageBarsSlot();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PincodeSheetBloc, PincodeSheetState,
        List<MessageBarEntity>>(
      selector: (s) => s.messageBars,
      builder: (context, bars) {
        if (bars.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
          child: MessageBarsWidget(
            messageBars: bars,
          ),
        );
      },
    );
  }
}
