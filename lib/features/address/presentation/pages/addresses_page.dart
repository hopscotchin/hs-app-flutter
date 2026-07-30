import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hs_app_flutter/components/app_bottom_sheet.dart';
import 'package:hs_app_flutter/components/buttons/app_button_named.dart';
import 'package:hs_app_flutter/components/buttons/button_enums.dart';
import 'package:hs_app_flutter/core/constants/strings/auto_test_strings.dart';
import 'package:hs_app_flutter/core/constants/strings/common_strings.dart';
import 'package:hs_app_flutter/core/theme/spacing.dart';

import '../../../../components/appbar/hs_appbar.dart';
import '../../../../components/atoms/error_retry_widget.dart';
import '../../../../components/atoms/loading_shimmer.dart';
import '../../../../core/constants/strings/account_strings.dart';
import '../../../../core/constants/strings/address_pincode_strings.dart';
import '../../../../core/router/app_navigator.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/typography/text_style_extensions.dart';
import '../../../../core/theme/typography/typography_v1.dart';
import '../../domain/entities/address_entity.dart';
import '../../domain/entities/manage_address_args.dart';
import '../bloc/address_bloc.dart';
import '../widgets/address_item_card.dart';

class AddressesPage extends StatefulWidget {
  const AddressesPage({super.key, this.mode = AddressListMode.normal});

  final AddressListMode mode;

  @override
  State<AddressesPage> createState() => _AddressesPageState();
}

class _AddressesPageState extends State<AddressesPage> {
  int? _selectedId;

  bool get _isCheckout => widget.mode == AddressListMode.checkout;

  void _ensureSelection(List<AddressEntity> items) {
    if (items.isEmpty) {
      _selectedId = null;
      return;
    }
    final stillExists = _selectedId != null && items.any((a) => a.id == _selectedId);
    if (stillExists) return;
    final primary = items.firstWhere((a) => a.isDefault, orElse: () => items.first);
    _selectedId = primary.id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.baseDefault,
      appBar: HsAppbar(
        title: widget.mode == AddressListMode.normal
            ? AccountStrings.savedAddresses
            : AddressStrings.shipToTitle,
        titleKey: const ValueKey(AddressTestStrings.listAppBarTitle),
        backButtonKey: const ValueKey(AddressTestStrings.listBackButton),
      ),
      body: SafeArea(
        top: false,
        child: MultiBlocListener(
          listeners: [
            BlocListener<AddressBloc, AddressState>(
              listenWhen: (prev, curr) =>
                  curr.deleteSuccessMessage != prev.deleteSuccessMessage ||
                  curr.deleteError != prev.deleteError,
              listener: (context, state) {
                final msg = state.deleteSuccessMessage ?? state.deleteError;
                if (msg == null) return;
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text(msg)));
                context.read<AddressBloc>().add(const ClearDeleteFeedback());
              },
            ),
            BlocListener<AddressBloc, AddressState>(
              listenWhen: (prev, curr) =>
                  curr.selectSucceeded != prev.selectSucceeded ||
                  curr.selectError != prev.selectError,
              listener: (context, state) {
                if (state.selectError != null) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text(state.selectError!)));
                  context.read<AddressBloc>().add(const ClearSelectFeedback());
                  return;
                }
                if (state.selectSucceeded) {
                  context.read<AddressBloc>().add(const ClearSelectFeedback());
                  if (_isCheckout) {
                    Navigator.of(context).pop();
                  } else {
                    context.read<AddressBloc>().add(const RefreshAddresses());
                  }
                }
              },
            ),
          ],
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<AddressBloc, AddressState>(
                  builder: (context, state) {
                    if (state.status == AddressStatus.loading) {
                      return LoadingShimmer.listShimmer(itemCount: 6, itemHeight: 140);
                    }

                    if (state.status == AddressStatus.error) {
                      return ErrorRetryWidget(
                        message: state.errorMessage!,
                        onRetry: () => context.read<AddressBloc>().add(LoadAddresses(source: state.source)),
                      );
                    }

                    if (state.status == AddressStatus.success) {
                      if (state.items.isEmpty) {
                        return Center(
                          child: Text(
                            AddressStrings.noSavedAddresses,
                            key: const ValueKey(AddressTestStrings.listEmptyText),
                            style: AppTypographyV1.bodyLarge.regular.textSecondary(),
                          ),
                        );
                      }

                      _ensureSelection(state.items);

                      final defaultAddress = state.items.where((a) => a.isDefault).toList();
                      final otherAddresses = state.items.where((a) => !a.isDefault).toList();

                      // In selection modes the radio sits left of the name, so
                      // align the divider start with the name (skip radio + gap)
                      // instead of from the card edge.
                      final dividerIndent = widget.mode == AddressListMode.normal
                          ? 16.0
                          : 16.0 + 20.0 + AppSpacing.sm;

                      return ListView(
                        children: [
                          if (defaultAddress.isNotEmpty) ...[
                            const _SectionHeading(label: AddressStrings.defaultAddressHeading),
                            for (var d = 0; d < defaultAddress.length; d++) ...[
                              AddressItemCard(
                                key: ValueKey('${AddressTestStrings.listItem}_$d'),
                                editKey: ValueKey(
                                  '${AddressTestStrings.listItem}_${d}_${AddressTestStrings.listItemEditSuffix}',
                                ),
                                removeKey: ValueKey(
                                  '${AddressTestStrings.listItem}_${d}_${AddressTestStrings.listItemRemoveSuffix}',
                                ),
                                address: defaultAddress[d],
                                mode: widget.mode,
                                isSelected: defaultAddress[d].id == _selectedId,
                                isSettingDefault: state.selectingId == defaultAddress[d].id,
                                onSelect: () => setState(() => _selectedId = defaultAddress[d].id),
                                onSetDefault: _onSetDefault(defaultAddress[d]),
                                onEdit: () => _onEdit(context, defaultAddress[d]),
                                onRemove: () => _confirmRemove(context, defaultAddress[d]),
                              ),
                              if (otherAddresses.isEmpty)
                                Divider(
                                  height: 1,
                                  color: AppColors.dividerLight,
                                  indent: dividerIndent,
                                  endIndent: 16,
                                ),
                            ],
                          ],
                          if (otherAddresses.isNotEmpty) ...[
                            const _SectionHeading(
                              label: AddressStrings.otherAddressHeading,
                              topSpacing: 6,
                            ),
                            for (var i = 0; i < otherAddresses.length; i++) ...[
                              AddressItemCard(
                                key: ValueKey(
                                  '${AddressTestStrings.listItem}_${defaultAddress.length + i}',
                                ),
                                editKey: ValueKey(
                                  '${AddressTestStrings.listItem}_${defaultAddress.length + i}_${AddressTestStrings.listItemEditSuffix}',
                                ),
                                removeKey: ValueKey(
                                  '${AddressTestStrings.listItem}_${defaultAddress.length + i}_${AddressTestStrings.listItemRemoveSuffix}',
                                ),
                                address: otherAddresses[i],
                                mode: widget.mode,
                                isSelected: otherAddresses[i].id == _selectedId,
                                isSettingDefault: state.selectingId == otherAddresses[i].id,
                                onSelect: () => setState(() => _selectedId = otherAddresses[i].id),
                                onSetDefault: _onSetDefault(otherAddresses[i]),
                                onEdit: () => _onEdit(context, otherAddresses[i]),
                                onRemove: () => _confirmRemove(context, otherAddresses[i]),
                              ),
                              Divider(
                                height: 1,
                                color: AppColors.dividerLight,
                                indent: dividerIndent,
                                endIndent: 16,
                              ),
                              if (i != otherAddresses.length - 1) const SizedBox(height: 17),
                            ],
                          ],
                        ],
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
              if (_isCheckout)
                BlocBuilder<AddressBloc, AddressState>(
                  buildWhen: (prev, curr) => prev.selectingId != curr.selectingId,
                  builder: (context, state) => _CheckoutBottomBar(
                    onAddNewAddress: _onAddNewAddress,
                    onContinue: state.selectingId != null ? null : _onContinue,
                    isSubmitting: state.selectingId != null,
                  ),
                )
              else
                _AddNewAddressButton(onPressed: _onAddNewAddress),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onAddNewAddress() async {
    final result = await AppNavigator.goToAddAddress(
      context,
      flow: _isCheckout ? ManageAddressFlow.cart : ManageAddressFlow.account,
    );
    if (result == null || !mounted) return;
    if (_isCheckout && result.address != null) {
      Navigator.of(context).pop();
      return;
    }
    _showResultSnack(result.popUpMessage);
    context.read<AddressBloc>().add(const RefreshAddresses());
  }

  void _showResultSnack(String? message) {
    if (message == null || message.isEmpty) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  VoidCallback _onSetDefault(AddressEntity address) {
    if (widget.mode == AddressListMode.normal) {
      return () => context.read<AddressBloc>().add(SelectAddress(address.id));
    }
    return () => setState(() => _selectedId = address.id);
  }

  void _onContinue() {
    final id = _selectedId;
    if (id == null) return;
    context.read<AddressBloc>().add(SelectAddress(id));
  }

  Future<void> _onEdit(BuildContext context, AddressEntity address) async {
    final bloc = context.read<AddressBloc>();
    final result = await AppNavigator.goToAddAddress(
      context,
      flow: _isCheckout ? ManageAddressFlow.cart : ManageAddressFlow.account,
      address: address,
    );
    if (result != null && mounted) {
      _showResultSnack(result.popUpMessage);
      bloc.add(const RefreshAddresses());
    }
  }

  Future<void> _confirmRemove(BuildContext context, AddressEntity address) async {
    final bloc = context.read<AddressBloc>();
    final confirmed = await AppBottomSheet.show<bool>(
      context,
      title: AddressStrings.removeAddressTitle,
      description: AddressStrings.confirmDeletePrompt,
      titleKey: const ValueKey(AddressTestStrings.deleteBottomSheetTitle),
      descriptionKey: const ValueKey(AddressTestStrings.deleteBottomSheetDescription),
      secondaryAction: AppBottomSheetAction(
        label: CommonStrings.confirm,
        buttonKey: const ValueKey(AddressTestStrings.deleteBottomSheetConfirmButton),
        onPressed: () => Navigator.of(context, rootNavigator: true).pop(true),
      ),
      primaryAction: AppBottomSheetAction(
        label: CommonStrings.cancel,
        style: AppBottomSheetButtonStyle.filled,
        buttonKey: const ValueKey(AddressTestStrings.deleteBottomSheetCancelButton),
        onPressed: () => Navigator.of(context, rootNavigator: true).pop(false),
      ),
    );

    if (confirmed == true) {
      bloc.add(DeleteAddress(address.id));
    }
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.label, this.topSpacing = 21});

  final String label;
  final double topSpacing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, topSpacing, 16, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(label, style: AppTypographyV1.labelLarge.bold.textPrimary()),
          AppSpacing.horizontalGapXs,
          const Expanded(child: Divider(height: 1, thickness: 1, color: AppColors.dividerDark)),
        ],
      ),
    );
  }
}

class _AddNewAddressButton extends StatelessWidget {
  const _AddNewAddressButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Platform.isIOS ? const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, 0) : const EdgeInsets.all(AppSpacing.md),
      child: SizedBox(
        width: double.infinity,
        child: PrimaryButton.defaultType(
          key: const ValueKey(AddressTestStrings.listAddNewButton),
          text: AddressStrings.addNewAddress,
          onTap: onPressed,
        ),
      ),
    );
  }
}

class _CheckoutBottomBar extends StatelessWidget {
  const _CheckoutBottomBar({
    required this.onAddNewAddress,
    required this.onContinue,
    this.isSubmitting = false,
  });

  final VoidCallback onAddNewAddress;
  final VoidCallback? onContinue;
  final bool isSubmitting;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Platform.isIOS ? const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, 0) : const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: SecondaryButton.defaultType(
              key: const ValueKey(AddressTestStrings.listAddNewButton),
              text: AddressStrings.addNewAddress,
              onTap: isSubmitting ? null : onAddNewAddress),
          ),
          AppSpacing.horizontalGapXs,
          Expanded(
            child: PrimaryButton.defaultType(
              key: const ValueKey(AddressTestStrings.listContinueButton),
              text: AddressStrings.continueLabel,
              onTap: onContinue,
              state: isSubmitting ? ButtonState.loading : ButtonState.enabled,
            ),
          ),
        ],
      ),
    );
  }
}
