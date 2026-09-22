import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hs_app_flutter/core/router/app_navigator.dart';

import '../../../../core/navigation/nav_destination.dart';
import '../../../../core/analytics/constants/analytics_defaults.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/typography.dart';
import '../../domain/entities/order_confirmation_entry_args.dart';
import '../../domain/entities/payment_retry_entity.dart';
import '../../domain/entities/payment_state_entry_args.dart';
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
            context,
            sourcePage: const SourcePage(fromScreen: FromScreens.paymentRetry),
          );
        } else if (state is CheckoutError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.container,
        appBar: AppBar(
          title: const Text('Payment'),
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

              // Instruction
              if (paymentRetryEntity.instruction != null)
                Text(
                  paymentRetryEntity.instruction!,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                  ),
                  textAlign: TextAlign.center,
                ),

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
                        paymentRetryEntity.amountSummary!.label ?? 'Amount',
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
    final actions = paymentRetryEntity.actions;
    if (actions == null) return const SizedBox.shrink();

    return Column(
      children: [
        // Primary action
        if (actions.primary != null)
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => _handleAction(context, actions.primary!),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Text(
                actions.primary!.label ?? 'Retry',
                style: AppTypography.buttonMedium,
              ),
            ),
          ),

        const SizedBox(height: 12),

        // Secondary action
        if (actions.secondary != null)
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton(
              onPressed: () => _handleAction(context, actions.secondary!),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                actions.secondary!.label ?? 'Other option',
                style: AppTypography.buttonMedium,
              ),
            ),
          ),

        const SizedBox(height: 12),

        // Tertiary action
        if (actions.tertiary != null)
          TextButton(
            onPressed: () => _handleAction(context, actions.tertiary!),
            child: Text(
              actions.tertiary!.label ?? 'Cancel',
              style: AppTypography.buttonMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
      ],
    );
  }

  void _handleAction(BuildContext context, FailureActionEntity action) {
    final paymentAction = action.action;
    if (paymentAction == null) return;

    final type = paymentAction.type?.toLowerCase();
    // Action's own mode wins; otherwise fall back to the failed attempt's
    // mode (Android threads this via IntentConstants.PAYMENT_MODE), then to
    // "POL" as a last resort.
    final paymentMode = paymentAction.paymentMode ?? previousPaymentMode ?? 'POL';

    switch (type) {
      case 'retry':
        context.read<CheckoutBloc>().add(
          RetryPayment(
            paymentCode: paymentMode,
            creditsApplied: false,
            failedOrderId: orderId,
          ),
        );
        break;
      case 'cancel':
        context.read<CheckoutBloc>().add(MarkOrderAsFailed(orderId: orderId));
        break;
      default:
        // Default behavior — retry with given payment mode
        context.read<CheckoutBloc>().add(
          RetryPayment(
            paymentCode: paymentMode,
            creditsApplied: false,
            failedOrderId: orderId,
          ),
        );
        break;
    }
  }
}
