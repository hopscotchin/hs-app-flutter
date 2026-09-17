import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_defaults.dart';
import 'package:hs_app_flutter/core/router/app_navigator.dart';

import '../../../../components/app_bottom_sheet.dart';
import '../../../../components/atoms/custom_image.dart';
import '../../../../components/atoms/dots_loader.dart';
import '../../../../components/atoms/loading_shimmer.dart';
import '../../../../components/atoms/selection_checkbox.dart';
import '../../../../components/atoms/selection_radio.dart';
import '../../../../components/page_components/message_bars_widget.dart';
import '../../../../core/constants/image_constants.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/extensions/string_extensions.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography/text_style_extensions.dart';
import '../../../../core/theme/typography/typography_v1.dart';
import '../../../cart/domain/usecases/order_now_usecase.dart';
import '../../domain/entities/buy_now_entity.dart';
import '../../domain/entities/order_confirmation_entry_args.dart';
import '../../domain/entities/payment_state_entry_args.dart';
import '../bloc/checkout_bloc.dart';

/// Launches the checkout bottom sheet, matching Android's HSCheckoutFragment.
///
/// [fromScreen] is the analytics screen that opened checkout — Cart's own
/// review flow passes `FromScreens.shoppingCart`, PDP's Buy Now passes
/// `FromScreens.product`. Threaded through payment-state → retry → confirm.
Future<void> showCheckoutBottomSheet(
  BuildContext context, {
  required BuyNowEntity buyNowData,
  String? fromScreen,
}) {
  // Single source of truth for "who draws the handle". Material's default
  // handle sits in a ~48px interactive strip and adds unwanted top space,
  // so we opt out and paint our own tighter one to hit the design's 20px
  // spacing to "Checkout". Flip both together — the widget's
  // [_useCustomHandle] flag mirrors this so the two can never disagree
  // and double up.
  const useCustomHandle = true;
  return AppBottomSheet.showCustom<void>(
    context,
    showDragHandle: !useCustomHandle,
    builder: (_) => BlocProvider(
      create: (_) => sl<CheckoutBloc>(),
      child: CheckoutBottomSheet(
        buyNowData: buyNowData,
        fromScreen: fromScreen,
        useCustomHandle: useCustomHandle,
      ),
    ),
  );
}

class CheckoutBottomSheet extends StatefulWidget {
  final BuyNowEntity buyNowData;
  final String? fromScreen;

  /// True when the launch site opted out of Material's built-in drag
  /// handle — in which case we paint our own compact one above the title.
  /// Kept in sync with `showDragHandle` at the launch site so the sheet
  /// never draws two handles.
  final bool useCustomHandle;

  const CheckoutBottomSheet({
    super.key,
    required this.buyNowData,
    this.fromScreen,
    this.useCustomHandle = false,
  });

  @override
  State<CheckoutBottomSheet> createState() => _CheckoutBottomSheetState();
}

/// Rows that can appear in the refresh shimmer, in top-to-bottom order.
/// Kept as an enum so [_buildRefreshingRows] can look up the placeholder
/// height per row without a magic-index list.
enum _ShimmerRow { credits, shipTo, pay }

class _CheckoutBottomSheetState extends State<CheckoutBottomSheet> {
  late bool _creditsApplied;
  late int _selectedPaymentIndex;
  bool _isPlacingOrder = false;

  /// Stashed for the JuspayReady navigation — carried forward as
  /// `previousPaymentMode` on the payment-state → retry hand-off.
  String? _selectedPaymentCode;

  /// Local, mutable copy of the buy-now payload. Starts as
  /// `widget.buyNowData` and is replaced when the user picks a new
  /// address (address change can shift EDD / delivery charges / totals,
  /// so we re-fetch server-side).
  late BuyNowEntity _data;

  /// True while a re-fetch is in flight — rows are replaced by shimmer
  /// so the user isn't looking at stale numbers between the address
  /// pick and the fresh response.
  bool _isRefreshing = false;

  BuyNowEntity get data => _data;

  bool get _hasCredits => data.userCredits != null && (data.userCredits!.amount ?? 0) > 0;

  bool get _hasPaymentModes => data.paymentModeMessages.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _data = widget.buyNowData;
    // `active: true` in the response means "credits are selected / to be
    // applied" — box shows CHECKED by default. `_creditsApplied` here
    // drives `_effectivePayable` to subtract credits, so a direct read
    // (not `!active` — Android's `isCreditsSelected` variable is named
    // for the opt-OUT case, which is why its mapping is inverted).
    _creditsApplied = data.userCredits?.active == true;
    _selectedPaymentIndex = data.paymentModeMessages.indexWhere((m) => m.selected);
    if (_selectedPaymentIndex < 0 && data.paymentModeMessages.isNotEmpty) {
      _selectedPaymentIndex = 0;
    }
  }

  Future<void> _refreshBuyNow() async {
    if (_isRefreshing) return;
    setState(() => _isRefreshing = true);
    final result = await sl<OrderNowUseCase>()(const OrderNowParams());
    if (!mounted) return;
    result.fold(
      (failure) {
        setState(() => _isRefreshing = false);
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(failure.message)));
      },
      (fresh) {
        setState(() {
          _data = fresh;
          _isRefreshing = false;
          // Server can shift these — resync so the UI reflects the new
          // response rather than the old choices.
          _creditsApplied = fresh.userCredits?.active == true;
          final idx = fresh.paymentModeMessages.indexWhere((m) => m.selected);
          _selectedPaymentIndex = idx >= 0
              ? idx
              : (fresh.paymentModeMessages.isEmpty ? -1 : 0);
        });
      },
    );
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

  /// The compact "Pay ₹XXX + method icons" pill is used only when the
  /// backend returned no payment-mode selector AND credits don't cover
  /// the whole amount. Full credits falls through to the plain proceed
  /// button so it renders as `Place Order • ₹X`; the payment-mode row
  /// stays visible but disabled (see `_buildPaymentRow`).
  bool get _useCompactCta => !_hasPaymentModes && !_fullCreditsApplied;

  String get _proceedLabel {
    if (_fullCreditsApplied) return 'Place Order';
    // Ignore backend `ctaText` — Android sends it in all-caps
    // ("PROCEED TO PAY"). Design calls for mixed case; hardcode it here
    // and let the backend override only when it starts sending cased
    // strings that match the design system.
    return 'Proceed To Pay';
  }

  // ─── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocListener<CheckoutBloc, CheckoutState>(
      listener: _onCheckoutStateChanged,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Only draw our compact handle when the modal itself isn't
            // drawing one — [useCustomHandle] mirrors `showDragHandle:
            // false` at the launch site, so flipping either flag never
            // leaves the sheet with two handles.
            if (widget.useCustomHandle) _buildDragHandle(),
            _buildTitle(),
            if (_isRefreshing) ..._buildRefreshingRows() else ...[
              if (data.messageBars.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xxs,
                  ),
                  child: MessageBarsWidget(messageBars: data.messageBars),
                ),
              if (_hasCredits) _buildCreditsRow(),
              _buildAddressRow(showDivider: _hasPaymentModes),
              // Payment row stays mounted when full credits are applied
              // (design shows it disabled, not hidden). Uncheck credits
              // → row re-enables.
              if (_hasPaymentModes) _buildPaymentRow(),
            ],
            AppSpacing.verticalGapSm,
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                0,
                AppSpacing.md,
                AppSpacing.sm,
              ),
              // Shimmer over the CTA too while refreshing — the button
              // was showing stale totals a moment ago and tapping it
              // would place the wrong order. Sized to the pill height
              // so nothing jumps.
              child: _isRefreshing
                  ? const LoadingShimmer(height: 48)
                  : (_useCompactCta ? _buildPayPill() : _buildProceedButton()),
            ),
          ],
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
        PaymentStateEntryArgs(
          initJusPayEntity: state.initJusPayEntity,
          orderId: orderId,
          creditsApplied: _creditsApplied,
          fromScreen: widget.fromScreen,
          paymentMode: _selectedPaymentCode,
        ),
      );
    } else if (state is OrderConfirmationLoaded) {
      Navigator.pop(context); // Close bottom sheet before navigating
      AppNavigator.goToOrderConfirmation(
        context,
        OrderConfirmationEntryArgs(
          orderConfirmationEntity: state.orderConfirmationEntity,
          fromScreen: widget.fromScreen,
        ),
      );
    } else if (state is CheckoutError) {
      setState(() => _isPlacingOrder = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
    }
  }

  // ─── Title ──────────────────────────────────────────────────────────────────

  Widget _buildDragHandle() {
    // Centered 24x2 pill in brand purple, offset 8px from the top of the
    // sheet — matches Material's default look but without the 48px
    // interactive frame the theme wraps around it. Together with the
    // title's top padding, sheet-top → "Checkout" comes to ~20px.
    return const Padding(
      padding: EdgeInsets.only(top: AppSpacing.lgMd),
      child: SizedBox(
        width: 24,
        height: 2,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.brandDefault,
            borderRadius: BorderRadius.all(Radius.circular(1)),
          ),
        ),
      ),
    );
  }

  /// Placeholder rows shown while `_refreshBuyNow` is in flight. Emits
  /// one shimmer per row that would otherwise be visible — so a sheet
  /// with just credits + ship-to shimmers two, and one with the pay row
  /// shimmers three. Kept in the same order as the real rows so nothing
  /// jumps when the refresh lands.
  List<Widget> _buildRefreshingRows() {
    // Height for each row's placeholder — matches the real content's
    // approximate vertical footprint (credits: single value line,
    // ship-to: two lines, pay: radio + subtitle).
    const heights = <_ShimmerRow, double>{
      _ShimmerRow.credits: 24,
      _ShimmerRow.shipTo: 48,
      _ShimmerRow.pay: 40,
    };
    final visible = <_ShimmerRow>[
      if (_hasCredits) _ShimmerRow.credits,
      _ShimmerRow.shipTo,
      if (_hasPaymentModes) _ShimmerRow.pay,
    ];
    return [
      for (var i = 0; i < visible.length; i++)
        Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.md,
            i == 0 ? AppSpacing.md : AppSpacing.xs,
            AppSpacing.md,
            i == visible.length - 1 ? AppSpacing.md : AppSpacing.xs,
          ),
          child: LoadingShimmer(height: heights[visible[i]]!),
        ),
    ];
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.xsm,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Checkout',
          style: AppTypographyV1.titleMedium.bold.textPrimary(),
        ),
      ),
    );
  }

  // ─── Credits Row ────────────────────────────────────────────────────────────

  Widget _buildCreditsRow() {
    final credits = data.userCredits!;
    final displayAmount = credits.displayText ??
        '${credits.sign ?? '₹'}${credits.amount}';

    // Whole row is the tap target — matches Android's HSCheckoutFragment,
    // which binds `creditsRow.setOnClickListener` at the row level, not the
    // checkbox. The checkbox's own GestureDetector still handles direct
    // taps; Flutter's gesture arena resolves the inner-wins-outer conflict
    // so we don't double-toggle.
    return GestureDetector(
      onTap: () => setState(() => _creditsApplied = !_creditsApplied),
      behavior: HitTestBehavior.opaque,
      child: _RowSection(
        label: 'Credits:',
        child: Row(
          children: [
            Expanded(
              child: Text(
                displayAmount,
                style: AppTypographyV1.bodyRegular.regular.textPrimary(),
              ),
            ),
            SelectionCheckbox(
              value: _creditsApplied,
              onChanged: (v) => setState(() => _creditsApplied = v),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  // ─── Address Row ────────────────────────────────────────────────────────────

  Widget _buildAddressRow({required bool showDivider}) {
    final address = data.address;

    return _RowSection(
      label: 'Ship to:',
      showDivider: showDivider,
      child: GestureDetector(
        onTap: () async {
          // Address change can move totals / EDD server-side — re-fetch
          // the buy-now payload after the user picks a new one. The
          // shimmer replaces the row contents while the request is in
          // flight (see `_buildRefreshingBody`).
          final selected = await AppNavigator.showAddressesSheet(
            context,
            fromScreen: FromScreens.checkout,
          );
          if (!mounted || selected != true) return;
          await _refreshBuyNow();
        },
        behavior: HitTestBehavior.opaque,
        child: Row(
          children: [
            Expanded(
              child: address != null
                  ? Text(
                      _buildAddressDisplay(address),
                      style: AppTypographyV1.bodyRegular.regular.textPrimary(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )
                  : Text(
                      'Add Delivery Address',
                      style: AppTypographyV1.bodyRegular.semiBold.brand(),
                    ),
            ),
            AppSpacing.horizontalGapXs,
            const Icon(
              Icons.chevron_right,
              size: 22,
              color: AppColors.brandDefault,
            ),
          ],
        ),
      ),
    );
  }

  String _buildAddressDisplay(CheckoutAddressEntity addr) {
    // Match the two-line design: line 1 = address name, line 2 = "City - PIN".
    final line1 = addr.name;
    final cityPin = [addr.city, addr.zipCode]
        .whereType<String>()
        .where((s) => s.isNotEmpty)
        .join(' - ');
    if (line1 != null && line1.isNotEmpty && cityPin.isNotEmpty) {
      return '$line1\n$cityPin';
    }
    if (addr.displayAddress != null && addr.displayAddress!.isNotEmpty) {
      return addr.displayAddress!;
    }
    return [line1, addr.city, addr.state, addr.zipCode]
        .whereType<String>()
        .where((s) => s.isNotEmpty)
        .join('  ');
  }

  // ─── Payment Row ────────────────────────────────────────────────────────────

  Widget _buildPaymentRow() {
    final modes = data.paymentModeMessages;
    // Full credits cover the whole amount → payment modes are moot. The
    // row stays visible per the design but every option greys out and
    // stops responding to taps until credits are unchecked.
    final disabled = _fullCreditsApplied;
    final labelColor =
        disabled ? AppColors.neutralGrey4 : AppColors.neutralBlack;

    return _RowSection(
      label: 'Pay:',
      showDivider: false,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: modes.asMap().entries.map((entry) {
            final index = entry.key;
            final mode = entry.value;
            final isSelected = index == _selectedPaymentIndex;
            final subtitle = isSelected ? mode.activeMessage : mode.inActiveMessage;
            final subtitleColor =
                (isSelected ? mode.activeColor : mode.inActiveColor)
                    .toColorOrNull;

            return Expanded(
              child: GestureDetector(
                onTap: disabled
                    ? null
                    : () => setState(() => _selectedPaymentIndex = index),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: EdgeInsets.only(
                    left: index == 0 ? 0 : AppSpacing.sm,
                    right: index < modes.length - 1 ? AppSpacing.sm : 0,
                  ),
                  decoration: index < modes.length - 1
                      ? const BoxDecoration(
                          border: Border(
                            right: BorderSide(color: AppColors.dividerLight),
                          ),
                        )
                      : null,
                  // Subtitle aligns to the RADIO's left edge, not the
                  // label's — stack radio+label as a Row, then place the
                  // subtitle below at the outer Column's left edge.
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SelectionRadio(
                            selected: isSelected,
                            isDisabled: disabled,
                          ),
                          AppSpacing.horizontalGapXs,
                          Expanded(
                            child: Text(
                              mode.label ?? mode.type ?? '',
                              style: AppTypographyV1.bodyRegular.regular
                                  .copyWith(color: labelColor),
                            ),
                          ),
                        ],
                      ),
                      if (subtitle != null && subtitle.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: AppTypographyV1.labelLarge.regular.copyWith(
                            color: disabled
                                ? AppColors.neutralGrey4
                                : (subtitleColor ?? AppColors.neutralGrey5),
                          ),
                        ),
                      ],
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

  // ─── CTAs — two variants ────────────────────────────────────────────────────

  /// Compact pill used when no payment-mode selector is shown. Matches
  /// the Figma spec: 343×48, 4px vertical / 16px horizontal padding,
  /// `justify-content: space-between`. Three children: amount → "Auto"
  /// hint → supported-methods strip + double-chevron.
  Widget _buildPayPill() {
    return _PurpleCta(
      loading: _isPlacingOrder,
      onTap: _canSubmit ? _dispatchPlaceOrder : null,
      horizontalPadding: AppSpacing.md,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Pay ₹$_effectivePayable',
            style: AppTypographyV1.bodyLarge.bold
                .copyWith(color: AppColors.whiteColor),
          ),
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomImage(
                path: ImageConstants.paymentModes,
                height: 30,
                fit: BoxFit.contain,
              ),
              Icon(
                Icons.keyboard_double_arrow_right,
                color: AppColors.whiteColor,
                size: 22,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Plain button used when a "Pay:" radio row is above it. Full-credits
  /// case shows the FULL pre-credit total (matches Android's
  /// `place_order_checkout` string formatted with `orderSummary.payAmount
  /// .value`), so the CTA reads `Place Order • ₹6,069` even though the
  /// customer is paying 0 out of pocket. Every other case shows the
  /// live payable — credits, adjustments, and mode surcharges applied.
  Widget _buildProceedButton() {
    return _PurpleCta(
      loading: _isPlacingOrder,
      onTap: _canSubmit ? _dispatchPlaceOrder : null,
      child: Text(
        '$_proceedLabel  •  $_ctaAmountLabel',
        style: AppTypographyV1.bodyLarge.bold
            .copyWith(color: AppColors.whiteColor),
      ),
    );
  }

  /// Amount string shown on the proceed button. For full credits, prefer
  /// the server-formatted `payAmount.value` (already carries the ₹
  /// prefix and locale separators — "₹6,069"); fall back to the raw
  /// `payableAmount` int with a hardcoded ₹ prefix when the string
  /// isn't populated. Non-full-credits keeps the live payable.
  String get _ctaAmountLabel {
    if (_fullCreditsApplied) {
      final formatted = data.orderSummary?.payAmount?.value;
      if (formatted != null && formatted.isNotEmpty) return formatted;
      final base = data.orderSummary?.payableAmount ?? 0;
      return '₹$base';
    }
    return '₹$_effectivePayable';
  }

  bool get _canSubmit => data.address != null && !_isPlacingOrder;

  void _dispatchPlaceOrder() {
    setState(() => _isPlacingOrder = true);
    final String paymentCode =
        _fullCreditsApplied ? 'OWP' : (_selectedMode?.type ?? 'POL');
    _selectedPaymentCode = paymentCode;
    context.read<CheckoutBloc>().add(
      PlaceOrder(
        paymentCode: paymentCode,
        creditsApplied: _creditsApplied,
        fullCreditsApplied: _fullCreditsApplied,
      ),
    );
  }

}

// ─── Row section ────────────────────────────────────────────────────────────

class _RowSection extends StatelessWidget {
  final String label;
  final Widget child;
  final bool showDivider;

  const _RowSection({
    required this.label,
    required this.child,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    // Outer horizontal padding sits OUTSIDE the container that carries the
    // border, so the divider is inset by 16px on both sides (design ask).
    // Vertical padding stays on the container itself.
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Container(
        decoration: showDivider
            ? const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.dividerLight),
                ),
              )
            : null,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 70,
              child: Text(
                label,
                style: AppTypographyV1.bodyRegular.bold.textPrimary(),
              ),
            ),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

// ─── Purple CTA container ───────────────────────────────────────────────────

class _PurpleCta extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool loading;

  /// Horizontal padding on the inner content. The pay-pill variant needs
  /// 16 per the design spec (`display: flex; padding: 4px 16px`); the
  /// plain proceed button stays on the tighter 4 default.
  final double horizontalPadding;

  const _PurpleCta({
    required this.child,
    this.onTap,
    this.loading = false,
    this.horizontalPadding = AppSpacing.xxs,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color:
          onTap != null ? AppColors.brandDefault : AppColors.disabledDefault,
      borderRadius: BorderRadius.circular(AppSpacing.xxs),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.xxs),
        child: Container(
          width: double.infinity,
          height: 48,
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          // Always center — the pay-pill's inner Row expands to full width
          // and lays its children out with `spaceBetween`, so centering
          // here is a no-op for the loaded state; the loading dots read
          // as centered in every case.
          alignment: Alignment.center,
          child: loading
              // Matches the cart's proceed-to-checkout button, which
              // renders `DotsLoader` when `AppButton.state ==
              // ButtonState.loading`. Same three-dot bounce here so the
              // busy state feels consistent across the two CTAs the user
              // sees back-to-back.
              ? const DotsLoader(
                  dotSize: 12,
                  color: AppColors.whiteColor,
                )
              : child,
        ),
      ),
    );
  }
}

