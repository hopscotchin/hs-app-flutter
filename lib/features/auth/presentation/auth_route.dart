import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hs_app_flutter/core/constants/route_names.dart';

import '../../../core/di/injection.dart';
import '../../../core/entities/message_bar_entity.dart';
import '../../account/presentation/bloc/account_bloc.dart';
import '../domain/entities/otp_config/otp_config_entity.dart';
import 'bloc/auth_bloc.dart';
import 'pages/join_us_page.dart';
import 'pages/login_page.dart';
import 'pages/otp_verification_page.dart';
import 'widgets/mobile_login_bottom_sheet.dart';

class AuthRoute {
  static List<GoRoute> getRoutes(GlobalKey<NavigatorState> rootKey) => [
    GoRoute(
      path: RouteNames.login,
      name: RouteNames.login,
      parentNavigatorKey: rootKey,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return BlocProvider(
          create: (_) => sl<AuthBloc>(),
          child: LoginPage(
            initialMobile: extra?['initialMobile'] as String?,
            initialMessageBars:
                extra?['initialMessageBars'] as List<MessageBarEntity>? ?? const [],
          ),
        );
      },
    ),

    GoRoute(
      path: RouteNames.otpVerification,
      name: RouteNames.otpVerification,
      parentNavigatorKey: rootKey,
      builder: (_, state) {
        final extra = state.extra as Map<String, dynamic>;
        return BlocProvider.value(
          value: extra['bloc'] as AuthBloc,
          child: OtpVerificationPage(
            loginId: extra['loginId'] as String,
            otpConfig: extra['otpConfig'] as OtpConfigEntity,
            otpReason: extra['otpReason'] as String? ?? 'SIGN_IN',
            isCheckoutFlow: extra['isCheckoutFlow'] as bool? ?? false,
          ),
        );
      },
    ),
    GoRoute(
      path: RouteNames.checkoutLogin,
      name: RouteNames.checkoutLogin,
      parentNavigatorKey: rootKey,
      builder: (_, state) {
        final extra = state.extra as Map<String, dynamic>;
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => sl<AuthBloc>()),
            BlocProvider.value(value: extra['accountBloc'] as AccountBloc),
          ],
          child: const MobileLoginPage(),
        );
      },
    ),
  ];
}
