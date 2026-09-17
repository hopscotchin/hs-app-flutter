import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hs_app_flutter/core/constants/route_names.dart';

import '../../../core/di/injection.dart';
import '../domain/entities/init_juspay_entity.dart';
import '../domain/entities/order_confirmation_entity.dart';
import '../domain/entities/payment_retry_entity.dart';
import 'bloc/checkout_bloc.dart';
import 'pages/order_confirmation_page.dart';
import 'pages/payment_retry_page.dart';
import 'pages/payment_state_page.dart';

class CheckoutRoute {
  static List<GoRoute> getRoutes(GlobalKey<NavigatorState> rootKey) => [
    GoRoute(
      path: RouteNames.paymentState,
      name: 'paymentState',
      parentNavigatorKey: rootKey,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return BlocProvider(
          create: (_) => sl<CheckoutBloc>(),
          child: PaymentStatePage(
            initJusPayEntity: extra['initJusPayEntity'] as InitJusPayEntity,
            orderId: extra['orderId'] as int,
            creditsApplied: extra['creditsApplied'] as bool? ?? false,
            quickPayEnabled: extra['quickPayEnabled'] as bool? ?? false,
          ),
        );
      },
    ),
    GoRoute(
      path: RouteNames.paymentRetry,
      name: 'paymentRetry',
      parentNavigatorKey: rootKey,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return BlocProvider(
          create: (_) => sl<CheckoutBloc>(),
          child: PaymentRetryPage(
            paymentRetryEntity:
                extra['paymentRetryEntity'] as PaymentRetryEntity,
            orderId: extra['orderId'] as int,
          ),
        );
      },
    ),
    GoRoute(
      path: RouteNames.orderConfirmation,
      name: 'orderConfirmation',
      parentNavigatorKey: rootKey,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return OrderConfirmationPage(
          orderConfirmationEntity:
              extra['orderConfirmationEntity'] as OrderConfirmationEntity,
        );
      },
    ),
  ];
}
