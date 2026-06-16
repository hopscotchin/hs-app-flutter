import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hs_app_flutter/features/address/domain/entities/address_entity.dart';
import 'package:hs_app_flutter/features/address/domain/entities/manage_address_args.dart';
import 'package:hs_app_flutter/features/address/presentation/widgets/address_item_card.dart';

import '../constants/strings/auth_strings.dart';
import '../constants/strings/login_redirects.dart';
import '../constants/route_names.dart';
import '../entities/message_bar_entity.dart';
import '../../features/account/presentation/bloc/account_bloc.dart';
import '../../features/auth/domain/entities/otp_config/otp_config_entity.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

abstract final class AppNavigator {
   static bool _isRouteInStack(BuildContext context, String routeName) {
    final matches =
        GoRouter.of(context).routerDelegate.currentConfiguration.matches;
    return matches.whereType<RouteMatch>().any((m) => m.route.name == routeName);
  }

  static void goToHome(BuildContext context) => context.go(RouteNames.home);

  static void goToCategories(BuildContext context) => context.go(RouteNames.categories);

  static void goToMoments(BuildContext context) => context.go(RouteNames.moments);

  static void goToAccount(BuildContext context) => context.go(RouteNames.account);

  static void goToCart(BuildContext context) => context.pushNamed(RouteNames.cart);

  static void goToLogin(
    BuildContext context, {
    String? initialMobile,
    List<MessageBarEntity> initialMessageBars = const [],
    String? redirectType,
  }) {
    if (_isRouteInStack(context, RouteNames.login)) {
      context.pop();
      return;
    }
    final hasData =
        initialMobile != null || initialMessageBars.isNotEmpty || redirectType != null;
    final extra = hasData
        ? <String, dynamic>{
            'initialMobile': initialMobile,
            'initialMessageBars': initialMessageBars,
            'redirectType': redirectType,
          }
        : null;
    context.pushNamed(RouteNames.login, extra: extra);
  }

  static void goToJoinUs(
    BuildContext context, {
    String? initialMobile,
    String? redirectType,
  }) {
    if (_isRouteInStack(context, RouteNames.joinUs)) {
      context.pop();
      return;
    }
    final hasData = initialMobile != null || redirectType != null;
    final extra = hasData
        ? <String, dynamic>{'initialMobile': initialMobile, 'redirectType': redirectType}
        : null;
    context.pushNamed(RouteNames.joinUs, extra: extra);
  }

  /// Navigate to the OTP verification screen, sharing the existing [AuthBloc]
  /// instance via [BlocProvider.value] so the bloc is not re-created.
  static void goToOtpVerification(
    BuildContext context, {
    required AuthBloc bloc,
    required String loginId,
    required OtpConfigEntity otpConfig,
    String otpReason = AuthStrings.signInReason,
    bool isCheckoutFlow = false,
    String? redirectType,
  }) {
    context.pushNamed(
      RouteNames.otpVerification,
      extra: <String, dynamic>{
        'bloc': bloc,
        'accountBloc': context.read<AccountBloc>(),
        'loginId': loginId,
        'otpConfig': otpConfig,
        'otpReason': otpReason,
        'isCheckoutFlow': isCheckoutFlow,
        'redirectType': redirectType,
      },
    );
  }

  // Maps each redirect-type key to the screen to open after login.
  // Add an entry here when a new destination screen is implemented —
  // no other code needs to change.
  static final _redirectNavMap = <String, void Function(BuildContext)>{
    LoginRedirects.typeOrders: goToOrders,
    LoginRedirects.typeAddresses: goToAddresses,
  };

  /// Navigate to the appropriate screen after a successful login based on [redirectType].
  ///
  /// Pops all auth routes (login, join-us, otp) from the stack first so that
  /// pressing back from the destination never re-enters the auth flow.
  static void redirectAfterLogin(BuildContext context, String? redirectType) {
    _clearAuthStack(context);
    final navigate = _redirectNavMap[redirectType] ?? goToAccount;
    navigate(context);
  }

  static void _clearAuthStack(BuildContext context) {
    const authRoutes = {
      RouteNames.login,
      RouteNames.joinUs,
      RouteNames.otpVerification,
    };
    final matches =
        GoRouter.of(context).routerDelegate.currentConfiguration.matches;
    final authCount = matches
        .whereType<RouteMatch>()
        .where((m) => authRoutes.contains(m.route.name))
        .length;
    for (var i = 0; i < authCount; i++) {
      context.pop();
    }
  }

  /// Pushes the checkout mobile-login flow (mobile entry → OTP verification).
  /// Returns `true` if the user successfully logged in.
  static Future<bool> showMobileLoginFlow(BuildContext context) async {
    final accountBloc = context.read<AccountBloc>();
    final result = await context.pushNamed<bool>(
      RouteNames.checkoutLogin,
      extra: <String, dynamic>{'accountBloc': accountBloc},
    );
    return result == true;
  }

  static void goToPdp(BuildContext context, String productId) {
    context.pushNamed('pdp', pathParameters: {'productId': productId});
  }

  static void goToLandingPage(BuildContext context, {required String pageName, String? title}) {
    final queryParams = <String, String>{'pageName': pageName};
    if (title != null) queryParams['title'] = title;
    context.pushNamed('landingPage', queryParameters: queryParams);
  }

  static void goToWebView(BuildContext context, {required String url, String? title}) {
    context.pushNamed('webview', extra: <String, dynamic>{'url': url, 'title': title});
  }

  static void goToOrders(BuildContext context) => context.pushNamed('orders');

  static void goToAddresses(
      BuildContext context, {
        AddressListMode mode = AddressListMode.normal,
      }) => context.pushNamed(
    'addresses',
    extra: <String, dynamic>{'mode': mode},
  );

  /// Push the add/edit address screen.
  ///
  /// Pass [address] to enter edit mode, set [flow] to switch between
  /// account, cart, exchange, or return flows.
  /// Returns the resulting [ManageAddressResult] (success) or `null` (cancel).
  static Future<ManageAddressResult?> goToAddAddress(
      BuildContext context, {
        ManageAddressFlow flow = ManageAddressFlow.account,
        String? fromScreen,
        AddressEntity? address,
        bool popUpStyle = false,
      }) {
    final args = ManageAddressArgs(
      flow: flow,
      fromScreen: fromScreen,
      address: address,
      popUpStyle: popUpStyle,
    );
    return context.pushNamed<ManageAddressResult>(
      'addAddress',
      extra: <String, dynamic>{'args': args},
    );
  }
}
