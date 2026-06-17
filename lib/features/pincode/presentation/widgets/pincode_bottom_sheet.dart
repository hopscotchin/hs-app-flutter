import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hs_app_flutter/core/constants/strings/address_pincode_strings.dart';

import '../../../../components/page_components/message_bars_widget.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/entities/message_bar_entity.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography/text_style_extensions.dart';
import '../../../../core/theme/typography/typography_v1.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../bloc/pincode_sheet_bloc.dart';
import 'pincode_address_section.dart';
import 'pincode_input_field.dart';

/// Bottom sheet that lets the user pick a saved address or enter a pincode
/// to validate delivery serviceability. Returns the chosen pincode (string)
/// to the caller, or `null` if dismissed.
class PincodeBottomSheet extends StatelessWidget {
  const PincodeBottomSheet({super.key});

  static Future<String?> show(BuildContext context) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider(
        create: (_) =>
            sl<PincodeSheetBloc>()..add(const PincodeSheetEvent.open()),
        child: const PincodeBottomSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const _PincodeSheetBody();
  }
}

class _PincodeSheetBody extends StatefulWidget {
  const _PincodeSheetBody();

  @override
  State<_PincodeSheetBody> createState() => _PincodeSheetBodyState();
}

class _PincodeSheetBodyState extends State<_PincodeSheetBody> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

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
                AppSpacing.verticalGapMd,
                Container(
                  width: AppSpacing.lg,
                  height: AppSpacing.xxxs,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                AppSpacing.verticalGapXl,
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
                AppSpacing.verticalGapLg,
                const Flexible(child: _AddressList()),
                AppSpacing.verticalGapMd,
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
                        onApply: () => context
                            .read<PincodeSheetBloc>()
                            .add(const PincodeSheetEvent.apply()),
                      );
                    },
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
