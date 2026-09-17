import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_defaults.dart';
import 'package:hs_app_flutter/core/router/app_navigator.dart';

import '../../../../components/page_components/message_bars_widget.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/typography.dart';
import '../../../address/presentation/widgets/address_item_card.dart';
import '../../domain/entities/buy_now_entity.dart';
import '../bloc/checkout_bloc.dart';

/// Launches the checkout bottom sheet, matching Android's HSCheckoutFragment.
Future<void> showCheckoutBottomSheet(BuildContext context, {required BuyNowEntity buyNowData}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider(
      create: (_) => sl<CheckoutBloc>(),
      child: CheckoutBottomSheet(buyNowData: buyNowData),
    ),
  );
}

class CheckoutBottomSheet extends StatefulWidget {
  final BuyNowEntity buyNowData;

  const CheckoutBottomSheet({super.key, required this.buyNowData});

  @override
  State<CheckoutBottomSheet> createState() => _CheckoutBottomSheetState();
}

class _CheckoutBottomSheetState extends State<CheckoutBottomSheet> {
  late bool _creditsApplied;
  late int _selectedPaymentIndex;
  bool _isPlacingOrder = false;

  BuyNowEntity get data => widget.buyNowData;

  bool get _hasCredits => data.userCredits != null && (data.userCredits!.amount ?? 0) > 0;

  bool get _hasPaymentModes => data.paymentModeMessages.isNotEmpty;

  @override
  void initState() {
    super.initState();
    // Android: isCreditsSelected = (userCredits.active == true).not()
    _creditsApplied = data.userCredits?.active != true;
    _selectedPaymentIndex = data.paymentModeMessages.indexWhere((m) => m.selected);
    if (_selectedPaymentIndex < 0 && data.paymentModeMessages.isNotEmpty) {
      _selectedPaymentIndex = 0;
    }
  }

  // ─── Computed values ────────────────────────────────────────────────────────

  PaymentModeMessageEntity? get _selectedMode {
    if (!_hasPaymentModes || _selectedPaymentIndex < 0) return null;
    return data.paymentModeMessages[_selectedPaymentIndex];
  }

  int get _effectivePayable {
    final base = _selectedMode?.payableAmount ?? data.orderSummary?.payableAmount ?? 0;
    final adjustment = _selectedMode?.chargeAdjustment ?? 0;
    var amount = base + adjustment;
    if (_creditsApplied && _hasCredits) {
      amount -= data.userCredits!.amount ?? 0;
      if (amount < 0) amount = 0;
    }
    return amount;
  }

  bool get _fullCreditsApplied => _creditsApplied && _effectivePayable <= 0;

  String get _buttonText {
    if (_fullCreditsApplied) {
      final payValue = data.orderSummary?.payAmount?.value;
      return 'PLACE ORDER${payValue != null ? '  \u2022  \u20B9$payValue' : ''}';
    }
    final ctaText = _selectedMode?.ctaText ?? 'PROCEED TO PAY';
    return '$ctaText  \u2022  \u20B9$_effectivePayable';
  }

  // ─── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocListener<CheckoutBloc, CheckoutState>(
      listener: _onCheckoutStateChanged,
      child: Container(
        // Wraps content — never expands
        decoration: const BoxDecoration(
          color: AppColors.container,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),

              // Message bars (errors from API)
              if (data.messageBars.isNotEmpty) MessageBarsWidget(messageBars: data.messageBars),

              // Credits row
              if (_hasCredits) _buildCreditsRow(),

              // Address row (always shown)
              _buildAddressRow(),

              // Payment row
              if (_hasPaymentModes && !_fullCreditsApplied) _buildPaymentRow(),

              // Place order button
              _buildButton(),
            ],
          ),
        ),
      ),
    );
  }

  void _onCheckoutStateChanged(BuildContext context, CheckoutState state) {
    if (state is PlaceOrderSuccess) {
      // Don't pop the bottom sheet yet — keep it alive so the BlocListener
      // can receive JuspayReady / OrderConfirmationLoaded after the next API call.
      if (state.fullCreditsApplied) {
        // COD or full credits — go to order confirmation
        final orderId = state.placeOrderEntity.orderId;
        if (orderId != null) {
          context.read<CheckoutBloc>().add(LoadOrderConfirmation(orderId: orderId));
        }
      } else {
        // Online payment — init Juspay
        final recordId = state.placeOrderEntity.recordId;
        if (recordId != null) {
          context.read<CheckoutBloc>().add(
            InitiatePayment(
              recordId: recordId,
              creditsApplied: _creditsApplied,
              quickPayEnabled: false,
            ),
          );
        }
      }
    } else if (state is JuspayReady) {
      Navigator.pop(context); // Close bottom sheet before navigating
      final orderId = int.tryParse(state.initJusPayEntity.orderId ?? '') ?? 0;
      AppNavigator.goToPaymentState(
        context,
        initJusPayEntity: state.initJusPayEntity,
        orderId: orderId,
        creditsApplied: _creditsApplied,
      );
    } else if (state is OrderConfirmationLoaded) {
      Navigator.pop(context); // Close bottom sheet before navigating
      AppNavigator.goToOrderConfirmation(
        context,
        orderConfirmationEntity: state.orderConfirmationEntity,
      );
    } else if (state is CheckoutError) {
      setState(() => _isPlacingOrder = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
    }
  }

  // ─── Header ─────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Checkout',
            style: AppTypography.headlineSmall.copyWith(fontWeight: AppTypography.semiBold),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Text(
              'CANCEL',
              style: AppTypography.labelLarge.copyWith(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Credits Row ────────────────────────────────────────────────────────────

  Widget _buildCreditsRow() {
    final credits = data.userCredits!;
    final displayAmount = credits.displayText ?? '${credits.sign ?? '\u20B9'}${credits.amount}';

    return _RowSection(
      label: 'Credits:',
      child: Row(
        children: [
          Expanded(
            child: Text(
              displayAmount,
              style: AppTypography.bodyMedium.copyWith(fontWeight: AppTypography.semiBold),
            ),
          ),
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: _creditsApplied,
              activeColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
              onChanged: (v) => setState(() => _creditsApplied = v ?? false),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Address Row ────────────────────────────────────────────────────────────

  Widget _buildAddressRow() {
    final address = data.address;

    return _RowSection(
      label: 'Ship to:',
      child: GestureDetector(
        onTap: () => AppNavigator.goToAddresses(
          context,
          mode: AddressListMode.checkout,
          fromScreen: FromScreens.checkout,
        ),
        child: Row(
          children: [
            Expanded(
              child: address != null
                  ? Text(
                      _buildAddressDisplay(address),
                      style: AppTypography.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )
                  : Text(
                      'Add Delivery Address',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.secondary,
                        fontWeight: AppTypography.semiBold,
                      ),
                    ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, size: 22, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  String _buildAddressDisplay(CheckoutAddressEntity addr) {
    if (addr.displayAddress != null && addr.displayAddress!.isNotEmpty) {
      return addr.displayAddress!;
    }
    return [
      addr.firstName ?? addr.name,
      addr.city,
      addr.state,
      addr.zipCode,
    ].where((s) => s != null && s.isNotEmpty).join('  ');
  }

  // ─── Payment Row ────────────────────────────────────────────────────────────

  Widget _buildPaymentRow() {
    final modes = data.paymentModeMessages;

    return _RowSection(
      label: 'Pay:',
      noPadding: true,
      child: IntrinsicHeight(
        child: Row(
          children: modes.asMap().entries.map((entry) {
            final index = entry.key;
            final mode = entry.value;
            final isSelected = index == _selectedPaymentIndex;
            final subtitle = isSelected ? mode.activeMessage : mode.inActiveMessage;
            final subtitleColor = _parseColor(isSelected ? mode.activeColor : mode.inActiveColor);

            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedPaymentIndex = index),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: const EdgeInsets.only(left: 4, right: 12, top: 0, bottom: 4),
                  decoration: index < modes.length - 1
                      ? const BoxDecoration(
                          border: Border(right: BorderSide(color: AppColors.dividerLight)),
                        )
                      : null,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Icon(
                          isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                          size: 18,
                          color: isSelected ? AppColors.primary : AppColors.textTertiary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              mode.label ?? mode.type ?? '',
                              style: AppTypography.bodyMedium.copyWith(
                                fontWeight: AppTypography.semiBold,
                              ),
                            ),
                            if (subtitle != null && subtitle.isNotEmpty)
                              Text(
                                subtitle,
                                style: AppTypography.bodySmall.copyWith(
                                  color: subtitleColor ?? AppColors.textSecondary,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ─── Button ─────────────────────────────────────────────────────────────────

  Widget _buildButton() {
    final hasAddress = data.address != null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: hasAddress && !_isPlacingOrder
              ? () {
                  setState(() => _isPlacingOrder = true);

                  // Determine paymentCode
                  String paymentCode;
                  if (_fullCreditsApplied) {
                    paymentCode = 'OWP';
                  } else {
                    paymentCode = _selectedMode?.type ?? 'POL';
                  }

                  context.read<CheckoutBloc>().add(
                    PlaceOrder(
                      paymentCode: paymentCode,
                      creditsApplied: _creditsApplied,
                      fullCreditsApplied: _fullCreditsApplied,
                    ),
                  );
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
            disabledBackgroundColor: AppColors.secondaryInActive,
            disabledForegroundColor: AppColors.onPrimary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 0,
          ),
          child: _isPlacingOrder
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.onPrimary),
                )
              : Text(
                  _buttonText,
                  style: AppTypography.buttonMedium.copyWith(color: AppColors.onPrimary),
                ),
        ),
      ),
    );
  }

  // ─── Helpers ────────────────────────────────────────────────────────────────

  static Color? _parseColor(String? colorStr) {
    if (colorStr == null || colorStr.isEmpty) return null;
    try {
      var hex = colorStr.replaceFirst('#', '');
      if (hex.length == 6) hex = 'FF$hex';
      return Color(int.parse(hex, radix: 16));
    } catch (_) {
      return null;
    }
  }
}

// ─── Row Section ────────────────────────────────────────────────────────────
// Each section is a row: fixed-width label on the left, content on the right,
// separated by a horizontal divider below.

class _RowSection extends StatelessWidget {
  final String label;
  final Widget child;
  final bool noPadding;

  const _RowSection({required this.label, required this.child, this.noPadding = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.dividerLight)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: noPadding ? 14 : 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                label,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: AppTypography.semiBold,
                ),
              ),
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
