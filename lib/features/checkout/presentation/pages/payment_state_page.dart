import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hs_app_flutter/core/router/app_navigator.dart';

import '../../../../components/app_bottom_sheet.dart';
import '../../../../components/appbar/hs_appbar.dart';
import '../../../../components/atoms/custom_image.dart';
import '../../../../components/atoms/dots_loader.dart';
import '../../../../components/buttons/app_button_named.dart';
import '../../../../core/constants/image_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography/text_style_extensions.dart';
import '../../../../core/theme/typography/typography_v1.dart';
import '../../../../core/utils/json_parsers.dart';
import '../../data/services/juspay_service.dart';
import '../../domain/entities/init_juspay_entity.dart';
import '../../domain/entities/order_confirmation_entry_args.dart';
import '../../domain/entities/payment_retry_entry_args.dart';
import '../../domain/entities/payment_status_entity.dart';
import '../bloc/checkout_bloc.dart';

class PaymentStatePage extends StatefulWidget {
  final InitJusPayEntity initJusPayEntity;
  final int orderId;
  final bool creditsApplied;
  final bool quickPayEnabled;

  /// Analytics attribution for the payment flow — read from route extra by
  /// [AppNavigator.goToPaymentState]. Passed through to the retry / confirm
  /// pages so the whole chain reports one origin.
  final String? fromScreen;

  /// Payment mode chosen at the checkout sheet (POL / COD / OWP / etc.).
  /// Threaded into the retry page as `previousPaymentMode` — mirrors
  /// Android's `PaymentStateActivity.launchPaymentRetry(orderId,
  /// previousPaymentMode)` (`PaymentStateActivity.kt:104`).
  final String? paymentMode;

  const PaymentStatePage({
    super.key,
    required this.initJusPayEntity,
    required this.orderId,
    required this.creditsApplied,
    this.quickPayEnabled = false,
    this.fromScreen,
    this.paymentMode,
  });

  @override
  State<PaymentStatePage> createState() => _PaymentStatePageState();
}

class _PaymentStatePageState extends State<PaymentStatePage> {
  late final JuspayService _juspayService;

  @override
  void initState() {
    super.initState();
    _juspayService = JuspayService();
    _initAndProcess();
  }

  Future<void> _initAndProcess() async {
    await _juspayService.initiate();
    if (!mounted) return;

    final sdkPayload = widget.initJusPayEntity.sdkPayload;
    if (sdkPayload == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment initialization failed')),
      );
      Navigator.pop(context);
      return;
    }

    // Paint the strip above Juspay's dark chrome as an extension of it.
    // Juspay's own Activity may or may not set an overlay of its own; by
    // pushing brand+white here we guarantee the icons are visible on top
    // of a dark bar whether or not the SDK touches SystemUi.
    SystemChrome.setSystemUIOverlayStyle(AppTheme.systemUiBrand);

    _juspayService.processPayment(sdkPayload, (eventData) {
      if (!mounted) return;
      // Any process_result callback means Juspay has closed its native
      // Activity — flip the overlay back to the app default *now*.
      // `AnnotatedRegion` is declarative and won't re-fire without a
      // widget-tree change, so an imperative call is what actually lands
      // the reset.
      SystemChrome.setSystemUIOverlayStyle(AppTheme.systemUiLight);

      // hypersdkflutter delivers Juspay's raw JSON as `{event: "process_result",
      // error, payload: {status, orderId, ...}}` — see
      // `HyperSdkFlutterPlugin.kt:186`, which invokes `channel.invokeMethod(
      // event, data.toString())`, so `eventData['event']` is always the
      // envelope name ("process_result") and never a routable status.
      //
      // Mirror Android `PaymentStateActivity.onEvent`
      // (`PaymentStateActivity.kt:244-266`) which reads `payload.status`
      // and routes on that — "backpressed" / "user_aborted" → exit;
      // everything else → checkOrderStatus.
      final envelope = eventData['event']?.toString();
      final payload = (eventData['payload'] is Map)
          ? Map<String, dynamic>.from(eventData['payload'] as Map)
          : const <String, dynamic>{};
      final status =
          payload['status']?.toString() ?? envelope ?? 'unknown';
      // Juspay delivers `orderId` as a STRING (e.g. "26719663") even
      // though the JSON literal looks numeric — parse either form.
      final orderId =
          parseToIntOrNull(payload['orderId']) ??
          parseToIntOrNull(eventData['orderId']) ??
          widget.orderId;

      context.read<CheckoutBloc>().add(
        JuspayCallbackReceived(
          event: status,
          payload: {...eventData, ...payload, 'orderId': orderId},
        ),
      );
    });
  }

  @override
  void dispose() {
    _juspayService.terminate();
    // Belt-and-suspenders — if we leave via the bloc navigating away
    // (order confirmation / retry / cart) before Juspay's callback
    // has fired the reset above, we still restore the overlay so the
    // next screen doesn't inherit brand+white icons.
    SystemChrome.setSystemUIOverlayStyle(AppTheme.systemUiLight);
    super.dispose();
  }

  /// Mirrors Android's `PaymentProcessingFragment` — on back press we open
  /// a confirmation sheet ("Transaction is pending. Do you want to go
  /// back?"). "YES, GO BACK" pops back to Cart WITHOUT marking the order
  /// failed.
  ///
  /// The order is only marked failed when Juspay itself reports abort
  /// (`backpressed` / `user_aborted`) — that runs inline in the Juspay
  /// callback, before this sheet is ever reachable. By the time
  /// `_confirmExit` opens, we're on the payment-state page polling a
  /// live server-side order — killing it here would race the polling.
  Future<void> _confirmExit() async {
    final shouldExit = await _PaymentExitConfirmSheet.show(context);
    if (!mounted || shouldExit != true) return;
    AppNavigator.backToCart(context);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      // Restore the app's dark-icons-on-white overlay whenever this page
      // is on top. Juspay's native activity flips the system overlay to
      // light icons for its dark chrome; when it closes and Flutter
      // comes back, the overlay stays flipped until something (this
      // region, or HsAppbar's inner AnnotatedRegion) resets it.
      value: AppTheme.systemUiLight,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (didPop) return;
          _confirmExit();
        },
        child: Scaffold(
        backgroundColor: AppColors.baseDefault,
        appBar: HsAppbar(
          // Empty title — design shows just the back arrow at the top left.
          title: '',
          showBottomBorder: true,
          onLeadingTap: _confirmExit,
        ),
        body: BlocListener<CheckoutBloc, CheckoutState>(
          listener: (context, state) {
            if (state is PaymentStatusReceived) {
              _handlePaymentStatus(state.paymentStatusEntity);
            } else if (state is PaymentRetryLoaded) {
              AppNavigator.goToPaymentRetry(
                context,
                PaymentRetryEntryArgs(
                  paymentRetryEntity: state.paymentRetryEntity,
                  orderId: state.orderId,
                  fromScreen: widget.fromScreen,
                  previousPaymentMode: widget.paymentMode,
                ),
              );
            } else if (state is OrderConfirmationLoaded) {
              AppNavigator.goToOrderConfirmation(
                context,
                OrderConfirmationEntryArgs(
                  orderConfirmationEntity: state.orderConfirmationEntity,
                  fromScreen: widget.fromScreen,
                ),
              );
            } else if (state is OrderMarkedFailed) {
              // Back-press / user-aborted / any explicit failure: pop
              // back to the ORIGINAL Cart route already on the stack.
              // Pushing a fresh Cart with `goToCart` would leave the
              // payment-state page beneath it, and system-back from
              // there would drop the user back into the aborted flow.
              AppNavigator.backToCart(context);
            } else if (state is CheckoutError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
              Navigator.pop(context);
            }
          },
            child: const _PaymentStateBody(),
          ),
        ),
      ),
    );
  }

  void _handlePaymentStatus(PaymentStatusEntity status) {
    final actionState = status.actionStatus;

    if (actionState == ActionState.success ||
        status.paymentStatusEnum == PaymentState.success) {
      final orderId = status.orderId ?? widget.orderId;
      context.read<CheckoutBloc>().add(LoadOrderConfirmation(orderId: orderId));
    }
    // Other states handled by BlocListener via CheckoutBloc events
  }
}

/// Static "Processing your payment" body — hero icon + title + subtitle +
/// dot bounce. Kept as a widget so the parent's build stays small.
class _PaymentStateBody extends StatelessWidget {
  const _PaymentStateBody();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CustomImage(
            path: ImageConstants.paymentPending,
            width: 180,
            height: 180,
            fit: BoxFit.contain,
          ),
          AppSpacing.verticalGapMd,
          Text(
            'Processing your payment',
            style: AppTypographyV1.titleSmall.bold.textPrimary(),
          ),
          AppSpacing.verticalGapXs,
          Text(
            'Please wait, this may take a while',
            style: AppTypographyV1.bodyRegular.regular.textSecondary(),
          ),
          AppSpacing.verticalGapLg,
          const DotsLoader(
            dotSize: 8,
            color: AppColors.neutralGrey4,
          ),
        ],
      ),
    );
  }
}

/// Bottom sheet shown when the user tries to leave mid-payment. Mirrors
/// Android's `PaymentProcessingFragment` — a title row with a `CANCEL`
/// dismiss, a "transaction is pending" body, and two buttons where "YES,
/// GO BACK" resolves to `true` (caller marks the order failed) and "NO"
/// resolves to `false` (stay on the processing page).
class _PaymentExitConfirmSheet extends StatelessWidget {
  const _PaymentExitConfirmSheet();

  static Future<bool?> show(BuildContext context) {
    return AppBottomSheet.showCustom<bool>(
      context,
      showDragHandle: true,
      builder: (_) => const _PaymentExitConfirmSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.md,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Payment Processing',
                    style: AppTypographyV1.titleSmall.bold.textPrimary(),
                  ),
                ),
              ],
            ),
            AppSpacing.verticalGapMd,
            Text(
              'Transaction is pending. Do you want to go back?',
              style: AppTypographyV1.bodyRegular.regular
                  .textPrimary()
                  .copyWith(height: 1.5),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: TertiaryButton.defaultType(
                    text: 'YES, GO BACK',
                    onTap: () => Navigator.pop(context, true),
                  ),
                ),
                AppSpacing.horizontalGapXs,
                Expanded(
                  child: PrimaryButton.defaultType(
                    text: 'NO',
                    onTap: () => Navigator.pop(context, false),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
