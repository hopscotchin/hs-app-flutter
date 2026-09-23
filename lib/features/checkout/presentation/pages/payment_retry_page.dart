import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hs_app_flutter/core/router/app_navigator.dart';

import '../../../../components/buttons/app_button_named.dart';
import '../../../../components/page_components/message_bars_widget.dart';
import '../../../../core/constants/strings/checkout_strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../domain/entities/order_confirmation_entry_args.dart';
import '../../domain/entities/payment_retry_entity.dart';
import '../../domain/entities/payment_state_entry_args.dart';
import '../../domain/entities/payment_state_result.dart';
import '../bloc/checkout_bloc.dart';

class PaymentRetryPage extends StatelessWidget {
  final PaymentRetryEntity paymentRetryEntity;
  final int orderId;

  /// Analytics attribution carried from the payment-state page — kept on
  /// every downstream event fired here (retry click, order confirmation).
  final String? fromScreen;

  /// Payment mode of the failed attempt. When non-null, Android auto-retries
  /// with this mode instead of showing the retry sheet; used as the fallback
  /// when a retry action's own paymentMode is absent.
  final String? previousPaymentMode;

  const PaymentRetryPage({
    super.key,
    required this.paymentRetryEntity,
    required this.orderId,
    this.fromScreen,
    this.previousPaymentMode,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<CheckoutBloc, CheckoutState>(
      listener: (context, state) {
        if (state is PlaceOrderSuccess) {
          if (state.fullCreditsApplied) {
            final id = state.placeOrderEntity.orderId ?? orderId;
            context.read<CheckoutBloc>().add(
              LoadOrderConfirmation(orderId: id),
            );
          } else {
            // Init Juspay for online retry
            context.read<CheckoutBloc>().add(
              InitiatePayment(
                recordId: state.placeOrderEntity.recordId ?? 0,
                creditsApplied: false,
                quickPayEnabled: false,
              ),
            );
          }
        } else if (state is JuspayReady) {
          AppNavigator.goToPaymentState(
            context,
            PaymentStateEntryArgs(
              initJusPayEntity: state.initJusPayEntity,
              orderId: orderId,
              creditsApplied: false,
              fromScreen: fromScreen,
              paymentMode: previousPaymentMode,
            ),
          );
        } else if (state is OrderConfirmationLoaded) {
          AppNavigator.goToOrderConfirmation(
            context,
            OrderConfirmationEntryArgs(
              orderConfirmationEntity: state.orderConfirmationEntity,
              fromScreen: fromScreen,
            ),
          );
        } else if (state is OrderMarkedFailed) {
          // Pop back to the existing Cart, unwinding retry (and any
          // retry-pushed payment-state) rather than pushing a new Cart.
          AppNavigator.backToCart(
            context
          );
        } else if (state is CheckoutError) {
          // Retry-scope API failure — pop back to the sheet (payment-state
          // forwards our result) with the messageBars for the top strip.
          Navigator.of(context, rootNavigator: true)
              .pop<PaymentStateResult>(
            PaymentStateResult.apiError(state.messageBars),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.container,
        appBar: AppBar(
          title: const Text(CheckoutStrings.payment),
          backgroundColor: AppColors.container,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
        ),
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<CheckoutBloc, CheckoutState>(
      builder: (context, state) {
        if (state is CheckoutLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 24),

              // Image
              if (paymentRetryEntity.imageUrl != null)
                CachedNetworkImage(
                  imageUrl: paymentRetryEntity.imageUrl!,
                  width: 120,
                  height: 120,
                  fit: BoxFit.contain,
                  errorWidget: (_, _, _) => const Icon(
                    Icons.error_outline,
                    size: 80,
                    color: AppColors.error,
                  ),
                ),

              const SizedBox(height: 24),

              // Title
              if (paymentRetryEntity.title != null)
                Text(
                  paymentRetryEntity.title!,
                  style: AppTypography.headlineSmall.copyWith(
                    fontWeight: AppTypography.semiBold,
                  ),
                  textAlign: TextAlign.center,
                ),

              const SizedBox(height: 8),

              // Subtitle
              if (paymentRetryEntity.subtitle != null)
                Text(
                  paymentRetryEntity.subtitle!,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),

              const SizedBox(height: 16),

              // Instruction — hidden on the failure path (Android mirrors
              // this in handleFailure by binding.instruction.gone()).
              if (paymentRetryEntity.isSuccessful &&
                  paymentRetryEntity.instruction != null)
                Text(
                  paymentRetryEntity.instruction!,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                  ),
                  textAlign: TextAlign.center,
                ),

              // Message bar on the failure path — surfaces the server's
              // `messageBars.first` (or singular `messageBar`) so the user
              // sees why the re-attempt itself couldn't be offered.
              if (!paymentRetryEntity.isSuccessful) ...[
                if (paymentRetryEntity.messageBars.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: MessageBarsWidget(
                      messageBars: [paymentRetryEntity.messageBars.first],
                    ),
                  )
                else if (paymentRetryEntity.messageBar != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: MessageBarsWidget(
                      messageBars: [paymentRetryEntity.messageBar!],
                    ),
                  ),
              ],

              // Amount Summary
              if (paymentRetryEntity.amountSummary != null) ...[
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryExtra,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        paymentRetryEntity.amountSummary!.label ??
                            CheckoutStrings.amount,
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: AppTypography.semiBold,
                        ),
                      ),
                      Text(
                        paymentRetryEntity.amountSummary!.value ?? '',
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: AppTypography.semiBold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 32),

              // Action buttons
              _buildActions(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActions(BuildContext context) {
    // Non-success re-attempt: server can't offer a retry — full-width
    // REVIEW CART + Cancel text below. Mirrors Android's
    // PaymentRetryActivity.handleFailure (reviewCart + cancelReview).
    if (!paymentRetryEntity.isSuccessful) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PrimaryButton.defaultType(
            text: CheckoutStrings.reviewCart,
            isFullWidth: true,
            onTap: () => AppNavigator.backToCart(context),
          ),
          AppSpacing.verticalGapSm,
          Center(
            child: TextButton(
              onPressed: () => AppNavigator.backToCart(context),
              child: Text(
                paymentRetryEntity.actions?.tertiary?.label ??
                    CheckoutStrings.cancel,
                style: AppTypography.buttonMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      );
    }

    final actions = paymentRetryEntity.actions;
    if (actions == null) return const SizedBox.shrink();

    // Row layout matches activity_payment_retry.xml: secondary (outlined)
    // on the left, primary (solid) on the right, both equal-width.
    final primary = actions.primary;
    final secondary = actions.secondary;
    final tertiary = actions.tertiary;

    return Column(
      children: [
        if (primary != null || secondary != null)
          Row(
            children: [
              if (secondary != null) ...[
                Expanded(
                  child: SecondaryButton.defaultType(
                    text: secondary.label ?? CheckoutStrings.otherOption,
                    isFullWidth: true,
                    onTap: () => _handleAction(context, secondary),
                  ),
                ),
                if (primary != null) AppSpacing.horizontalGapXs,
              ],
              if (primary != null)
                Expanded(
                  child: PrimaryButton.defaultType(
                    text: primary.label ?? CheckoutStrings.retry,
                    isFullWidth: true,
                    onTap: () => _handleAction(context, primary),
                  ),
                ),
            ],
          ),
        // Tertiary: text-only Cancel, always pops back to cart. Android's
        // XML wires the button to onBackPressedCallback (RESULT_CANCELED),
        // not the action.type — REDIRECT/whatever, same outcome.
        if (tertiary != null) ...[
          AppSpacing.verticalGapSm,
          TextButton(
            onPressed: () => AppNavigator.backToCart(context),
            child: Text(
              tertiary.label ?? CheckoutStrings.cancel,
              style: AppTypography.buttonMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _handleAction(BuildContext context, FailureActionEntity action) {
    final paymentAction = action.action;
    if (paymentAction == null) return;

    // Both PAYMENT_FALLBACK (COD) and PAYMENT_RETRY (POL) route to
    // retry-place-order — mirrors Android's processOrder(paymentMode).
    // REDIRECT / anything else pops back to cart (Android's tertiary
    // wiring). No MarkOrderAsFailed — the transaction already exists,
    // per spec.
    final type = paymentAction.type?.toUpperCase();
    if (type == 'REDIRECT') {
      AppNavigator.backToCart(context);
      return;
    }
    final paymentMode =
        paymentAction.paymentMode ?? previousPaymentMode ?? 'POL';
    context.read<CheckoutBloc>().add(
      RetryPayment(
        paymentCode: paymentMode,
        creditsApplied: false,
        failedOrderId: orderId,
      ),
    );
  }
}
