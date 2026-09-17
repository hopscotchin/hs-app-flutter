import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hs_app_flutter/core/router/app_navigator.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/typography.dart';
import '../../data/services/juspay_service.dart';
import '../../domain/entities/init_juspay_entity.dart';
import '../../domain/entities/payment_status_entity.dart';
import '../bloc/checkout_bloc.dart';

class PaymentStatePage extends StatefulWidget {
  final InitJusPayEntity initJusPayEntity;
  final int orderId;
  final bool creditsApplied;
  final bool quickPayEnabled;

  const PaymentStatePage({
    super.key,
    required this.initJusPayEntity,
    required this.orderId,
    required this.creditsApplied,
    this.quickPayEnabled = false,
  });

  @override
  State<PaymentStatePage> createState() => _PaymentStatePageState();
}

class _PaymentStatePageState extends State<PaymentStatePage> {
  late final JuspayService _juspayService;
  bool _paymentStarted = false;

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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Payment initialization failed')));
      Navigator.pop(context);
      return;
    }

    setState(() => _paymentStarted = true);

    _juspayService.processPayment(sdkPayload, (eventData) {
      if (!mounted) return;

      final event = eventData['event']?.toString() ?? 'unknown';
      final orderId = eventData['orderId'] as int? ?? widget.orderId;

      context.read<CheckoutBloc>().add(
        JuspayCallbackReceived(event: event, payload: {...eventData, 'orderId': orderId}),
      );
    });
  }

  @override
  void dispose() {
    _juspayService.terminate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final consumed = await _juspayService.onBackPress();
        if (!consumed && context.mounted) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.container,
        body: BlocListener<CheckoutBloc, CheckoutState>(
          listener: (context, state) {
            if (state is PaymentStatusReceived) {
              _handlePaymentStatus(state.paymentStatusEntity);
            } else if (state is PaymentRetryLoaded) {
              AppNavigator.goToPaymentRetry(
                context,
                paymentRetryEntity: state.paymentRetryEntity,
                orderId: state.orderId,
              );
            } else if (state is OrderConfirmationLoaded) {
              AppNavigator.goToOrderConfirmation(
                context,
                orderConfirmationEntity: state.orderConfirmationEntity,
              );
            } else if (state is OrderMarkedFailed) {
              // Go back to cart
              Navigator.pop(context);
            } else if (state is CheckoutError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
              Navigator.pop(context);
            }
          },
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: AppColors.primary),
          const SizedBox(height: 24),
          Text(
            _paymentStarted ? 'Processing payment...' : 'Initiating payment...',
            style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  void _handlePaymentStatus(PaymentStatusEntity status) {
    final actionState = status.actionStatus;

    if (actionState == ActionState.success || status.paymentStatusEnum == PaymentState.success) {
      // Navigate to order confirmation
      final orderId = status.orderId ?? widget.orderId;
      context.read<CheckoutBloc>().add(LoadOrderConfirmation(orderId: orderId));
    }
    // Other states handled by BlocListener via CheckoutBloc events
  }
}
