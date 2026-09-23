import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hs_app_flutter/core/constants/route_names.dart';

import '../../../core/di/injection.dart';
import '../domain/entities/order_confirmation_entry_args.dart';
import '../domain/entities/payment_retry_entry_args.dart';
import '../domain/entities/payment_state_entry_args.dart';
import 'bloc/checkout_bloc.dart';
import 'pages/order_confirmation_page.dart';
import 'pages/payment_retry_page.dart';
import 'pages/payment_state_page.dart';
import 'pages/payment_success_page.dart';

class CheckoutRoute {
  static List<GoRoute> getRoutes(GlobalKey<NavigatorState> rootKey) => [
    GoRoute(
      path: RouteNames.paymentState,
      name: 'paymentState',
      parentNavigatorKey: rootKey,
      builder: (context, state) {
        // `extra` is a map with an `args` key — mirrors the address-flow
        // pattern (address_route.dart:36) and the payment-retry route
        // below. Wrapping keeps room for future keys without changing
        // callers.
        final extra = state.extra as Map<String, dynamic>;
        final args = extra['args'] as PaymentStateEntryArgs;
        return BlocProvider(
          create: (_) => sl<CheckoutBloc>(),
          child: PaymentStatePage(
            initJusPayEntity: args.initJusPayEntity,
            orderId: args.orderId,
            creditsApplied: args.creditsApplied,
            quickPayEnabled: args.quickPayEnabled,
            fromScreen: args.fromScreen,
            paymentMode: args.paymentMode,
          ),
        );
      },
    ),
    GoRoute(
      path: RouteNames.paymentRetry,
      name: 'paymentRetry',
      parentNavigatorKey: rootKey,
      builder: (context, state) {
        final args = state.extra as PaymentRetryEntryArgs;
        return BlocProvider(
          create: (_) => sl<CheckoutBloc>(),
          child: PaymentRetryPage(
            paymentRetryEntity: args.paymentRetryEntity,
            orderId: args.orderId,
            fromScreen: args.fromScreen,
            previousPaymentMode: args.previousPaymentMode,
          ),
        );
      },
    ),
    GoRoute(
      path: RouteNames.paymentSuccess,
      name: 'paymentSuccess',
      parentNavigatorKey: rootKey,
      builder: (context, state) {
        final args = state.extra as OrderConfirmationEntryArgs;
        return PaymentSuccessPage(
          orderConfirmationEntity: args.orderConfirmationEntity,
          fromScreen: args.fromScreen,
        );
      },
    ),
    GoRoute(
      path: RouteNames.orderConfirmation,
      name: 'orderConfirmation',
      parentNavigatorKey: rootKey,
      // Slide-in from bottom — matches Android's
      // `OrderConfirmationActivityNew.start(addFlagAndAnimation = true)`.
      pageBuilder: (context, state) {
        final args = state.extra as OrderConfirmationEntryArgs;
        return CustomTransitionPage(
          key: state.pageKey,
          child: OrderConfirmationPage(
            orderConfirmationEntity: args.orderConfirmationEntity,
            fromScreen: args.fromScreen,
          ),
          transitionsBuilder: (context, animation, _, child) => SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
            child: child,
          ),
        );
      },
    ),
  ];
}
