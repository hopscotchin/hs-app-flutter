import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hs_app_flutter/core/constants/strings/address_pincode_strings.dart';

import '../../../../components/page_components/message_bars_widget.dart';
import '../../../../core/constants/image_constants.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/entities/message_bar_entity.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography/text_style_extensions.dart';
import '../../../../core/theme/typography/typography_v1.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../../address/domain/entities/address_entity.dart';
import '../bloc/pincode_sheet_bloc.dart';
import 'pincode_address_section.dart';

export '../bloc/pincode_sheet_source.dart';
import 'pincode_input_field.dart';

/// Outcome of the PDP product-aware pincode verify (`onPdpVerify`). On failure
/// the sheet stays open and shows [error] inline as a plain message instead of
/// popping.
class PincodeVerifyResult {
  const PincodeVerifyResult.success()
      : success = true,
        error = null;
  const PincodeVerifyResult.failure(this.error) : success = false;

  final bool success;
  final String? error;
}

/// Bottom sheet that lets the user pick a saved address or enter a pincode
/// to validate delivery serviceability. Returns the chosen pincode (string)
/// to the caller, or `null` if dismissed.
class PincodeBottomSheet extends StatelessWidget {
  const PincodeBottomSheet({super.key, this.onPdpVerify});

  /// PDP-only: runs the product-aware verify API while the sheet stays open
  /// showing the Apply loader. The sheet pops once this completes.
  final Future<PincodeVerifyResult> Function(String pincode)? onPdpVerify;

  static Future<String?> show(
    BuildContext context, {
    PincodeSheetSource source = PincodeSheetSource.cart,
    Future<PincodeVerifyResult> Function(String pincode)? onPdpVerify,
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

  final Future<PincodeVerifyResult> Function(String pincode)? onPdpVerify;

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

  Future<void> _onApplyPressed() async {
    final bloc = context.read<PincodeSheetBloc>();
    final state = bloc.state;
    // Fires the Apply loader (isChecking) in both flows.
    bloc.add(const PincodeSheetEvent.apply());

    // PDP: keep the sheet open with the loader while it runs its own
    // product-aware verify API, then pop. Cart is fully driven by the bloc
    // (it sets popResult on success, which the listener below pops).
    if (state.source == PincodeSheetSource.pdp && widget.onPdpVerify != null) {
      final pincode = state.enteredPincode.trim();
      if (pincode.length != 6) return;
      await _verify(pincode);
    }
  }

  // Tapping an address (PDP) verifies its pincode in-place; cart lets the bloc
  // run the serviceability + selectAddress APIs and auto-close on success.
  void _onAddressSelected(int addressId) {
    final bloc = context.read<PincodeSheetBloc>();
    if (bloc.state.source == PincodeSheetSource.pdp &&
        widget.onPdpVerify != null) {
      final addr = bloc.state.addresses.firstWhere(
        (a) => a.id == addressId,
        orElse: () => const AddressEntity(),
      );
      if (addr.id == 0 || !addr.isServicable) return;
      bloc.add(PincodeSheetEvent.selectAddress(addressId));
      _verify(addr.pincode);
      return;
    }
    bloc.add(PincodeSheetEvent.selectAddress(addressId));
  }

  // Runs the product-aware verify API in-place. On success the caller has the
  // updated PDP section data, so we pop. On failure (action failure on a 200 or
  // any error status) we keep the sheet open and show the API message inline
  // below the input field via [PdpVerifyFailed].
  Future<void> _verify(String pincode) async {
    final bloc = context.read<PincodeSheetBloc>();
    final route = ModalRoute.of(context);
    final result = await widget.onPdpVerify!(pincode);
    if (!mounted) return;
    if (result.success) {
      // Only pop if the sheet is still the current route. If the user already
      // dismissed it while verify was in flight, the widget can still be
      // `mounted` during the dismiss animation — popping again would pop the
      // PDP page underneath. Guard on isCurrent to avoid that double pop.
      if (route?.isCurrent ?? false) {
        Navigator.of(context).pop();
      }
    } else {
      bloc.add(PincodeSheetEvent.pdpVerifyFailed(result.error));
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
                      AddressStrings.enterPincodeForEdd,
                      style: AppTypographyV1.titleSmall.bold.textPrimary(),
                    ),
                  ),
                ),
                // Address list is checkout-only; cart and PDP are pincode-only.
                Flexible(
                  child: BlocSelector<PincodeSheetBloc, PincodeSheetState,
                      PincodeSheetSource>(
                    selector: (s) => s.source,
                    builder: (context, source) =>
                        source == PincodeSheetSource.checkout
                            ? _AddressList(onSelect: _onAddressSelected)
                            : const SizedBox.shrink(),
                  ),
                ),
                AppSpacing.verticalGapLg,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: BlocBuilder<PincodeSheetBloc, PincodeSheetState>(
                    buildWhen: (p, c) =>
                        p.enteredPincode != c.enteredPincode ||
                        p.isChecking != c.isChecking ||
                        p.pincodeError != c.pincodeError,
                    builder: (context, state) {
                      // Disabled after a failed verify until the user edits the
                      // pincode (which clears pincodeError).
                      final canApply = state.enteredPincode.length == 6 &&
                          !state.isChecking &&
                          state.pincodeError == null;
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
                const _PdpErrorSlot(),
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
  const _AddressList({required this.onSelect});

  final ValueChanged<int> onSelect;

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
                onSelect: onSelect,
              ),
              PincodeAddressSection(
                title: AddressStrings.otherAddressHeading,
                addresses: state.otherAddresses,
                selectedAddressId: state.selectedAddressId,
                topSpacing: AppSpacing.xs,
                onSelect: onSelect,
              ),
            ],
          ),
        );
      },
    );
  }
}

/// PDP-only: renders the product-aware verify failure as a plain inline error
/// string (no message bars).
class _PdpErrorSlot extends StatelessWidget {
  const _PdpErrorSlot();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PincodeSheetBloc, PincodeSheetState, String?>(
      selector: (s) => s.pincodeError,
      builder: (context, error) {
        if (error == null || error.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.md + 2, AppSpacing.xs, AppSpacing.md, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: SvgPicture.asset(
                  ImageConstants.messageBarError,
                  width: AppSpacing.iconXs,
                  height: AppSpacing.iconXs,
                  // Match the error text color beside it (.error()).
                  colorFilter: const ColorFilter.mode(
                    AppColors.dangerDefault,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              AppSpacing.horizontalGapXs,
              // Wraps to the next line(s) when the message exceeds one line.
              Expanded(
                child: Text(
                  error,
                  style: AppTypographyV1.bodySmall.error(),
                ),
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
