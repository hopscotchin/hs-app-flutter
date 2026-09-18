import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/pdp/domain/entities/pdp_entry_args.dart';
import 'package:hs_app_flutter/features/address/domain/entities/address_entity.dart';
import 'package:hs_app_flutter/features/address/domain/entities/manage_address_args.dart';
import 'package:hs_app_flutter/features/address/presentation/widgets/address_item_card.dart';
import 'package:hs_app_flutter/features/kids/domain/entities/child_entity.dart';
import 'package:hs_app_flutter/features/checkout/domain/entities/init_juspay_entity.dart';
import 'package:hs_app_flutter/features/checkout/domain/entities/order_confirmation_entity.dart';
import 'package:hs_app_flutter/features/checkout/domain/entities/payment_retry_entity.dart';
import 'package:hs_app_flutter/features/pdp/domain/entities/media_entity.dart';
import 'package:hs_app_flutter/features/plp/domain/entities/page_type.dart';
import 'package:hs_app_flutter/features/plp/domain/entities/plp_entry_args.dart';

import '../../features/account/presentation/bloc/account_bloc.dart';
import '../../features/auth/domain/entities/auth_entry_args.dart';
import '../../features/auth/domain/entities/otp_config/otp_config_entity.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/cart/presentation/bloc/cart_bloc.dart';
import '../../features/cart/presentation/cubit/cart_actions_cubit.dart';
import '../../features/wishlist/presentation/cubit/wishlist_cubit.dart';
import '../analytics/constants/analytics_defaults.dart';
import '../constants/route_names.dart';
import '../constants/strings/auth_strings.dart';
import '../constants/strings/login_redirects.dart';
import '../entities/message_bar_entity.dart';
import '../navigation/nav_destination.dart';

abstract final class AppNavigator {
  static bool _isRouteInStack(BuildContext context, String routeName) {
    final matches = GoRouter.of(context).routerDelegate.currentConfiguration.matches;
    return matches.whereType<RouteMatch>().any((m) => m.route.name == routeName);
  }

  static void goToHome(BuildContext context) => context.go(RouteNames.home);

  static void goToCategories(BuildContext context) => context.go(RouteNames.categories);

  static void goToAccount(BuildContext context) => context.go(RouteNames.account);

  /// Opens the bag. [fromBuyNow] puts the cart in buy-now mode: it proceeds to
  /// checkout on its own as soon as the cart loads, instead of waiting for the
  /// checkout button — the Flutter equivalent of Android's
  /// `Util.createBuyNowShoppingCartIntent` passing `IS_FROM_BUYNOW`.
  /// Opens the cart.
  ///
  /// [sourcePage] is **required** and names where the user came from — its
  /// `fromScreen` becomes `from_screen` on every `cart_viewed` of the visit,
  /// and its `fromLocation` names the control that opened the cart. Android
  /// passes both at each call site the same way
  /// (`CommonEvents.navigateToCart(fromScreen, fromLocation)`), and they are
  /// required here for the same reason: neither can be derived. The PLP's
  /// `fromScreen` is the *boutique's name* (`ProductListActivity:745`), which
  /// no router or navigation observer knows.
  ///
  /// [SourcePage] rather than two loose strings so the cart matches the
  /// Discover → PLP → PDP journeys, which already travel this way — one type,
  /// one place where the field-to-wire-name mapping lives.
  static void goToCart(
    BuildContext context, {
    required SourcePage sourcePage,
    bool fromBuyNow = false,
  }) {
    context.pushNamed(
      RouteNames.cartName,
      queryParameters: fromBuyNow ? const {'fromBuyNow': 'true'} : const {},
      // Passed as `extra` rather than a query parameter: it is a value object,
      // and `PlpRoute` already carries its entry args this way.
      extra: sourcePage,
    );
  }

  /// Pops the current route / dismisses the top-most sheet or dialog.
  static void goBack(BuildContext context) => context.pop();

  /// [entry] is where the user came from, for the auth events. Callers that
  /// know their surface should pass it; the default reports "none" on the
  /// wire, which is what Android sends when its intent extras are absent.
  static void goToLogin(
    BuildContext context, {
    String? initialMobile,
    List<MessageBarEntity> initialMessageBars = const [],
    String? redirectType,
    AuthEntryArgs entry = AuthEntryArgs.unknown,
  }) {
    if (_isRouteInStack(context, RouteNames.login)) {
      context.pop();
      return;
    }
    final hasData =
        initialMobile != null ||
        initialMessageBars.isNotEmpty ||
        redirectType != null ||
        entry != AuthEntryArgs.unknown;
    final extra = hasData
        ? <String, dynamic>{
            'initialMobile': initialMobile,
            'initialMessageBars': initialMessageBars,
            'redirectType': redirectType,
            'entry': entry,
          }
        : null;
    context.pushNamed(RouteNames.login, extra: extra);
  }

  /// See [goToLogin] for [entry].
  static void goToJoinUs(
    BuildContext context, {
    String? initialMobile,
    String? redirectType,
    AuthEntryArgs entry = AuthEntryArgs.unknown,
  }) {
    if (_isRouteInStack(context, RouteNames.joinUs)) {
      context.pop();
      return;
    }
    final hasData =
        initialMobile != null || redirectType != null || entry != AuthEntryArgs.unknown;
    final extra = hasData
        ? <String, dynamic>{
            'initialMobile': initialMobile,
            'redirectType': redirectType,
            'entry': entry,
          }
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
    AuthEntryArgs entry = AuthEntryArgs.unknown,
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
        // Carried from the screen that opened login: login → OTP → verified is
        // one journey, so the entry point that started it applies throughout.
        'entry': entry,
      },
    );
  }

  // Maps each redirect-type key to the screen to open after login.
  // Add an entry here when a new destination screen is implemented —
  // no other code needs to change.
  static final _redirectNavMap = <String, void Function(BuildContext)>{
    LoginRedirects.typeOrders: goToOrders,
    LoginRedirects.typeAddresses: (ctx) =>
        goToAddresses(ctx, fromScreen: FromScreens.account),
    LoginRedirects.typeKids: goToKids,
    LoginRedirects.typeWishlistScreenFromAccount: goToWishlist,
    LoginRedirects.typeWishlistScreen: goToWishlist,
    LoginRedirects.typeGoToWishlist: goToWishlist,
  };

  /// Navigate to the appropriate screen after a successful login based on [redirectType].
  ///
  /// Pops all auth routes (login, join-us, otp) from the stack first so that
  /// pressing back from the destination never re-enters the auth flow.
  ///
  /// Two flavours:
  ///  - "resume-in-place" types ([LoginRedirects.typeAddToWishlist] /
  ///    [LoginRedirects.typeAddToCart] / [LoginRedirects.typePromo]) just pop the
  ///    auth stack — the originating PLP/PDP/discover/cart page is still mounted
  ///    underneath — then replay the action the user attempted while logged out,
  ///    so the UI updates on the same page.
  ///  - destination types (orders, addresses, …) navigate to a fixed screen.
  static void redirectAfterLogin(BuildContext context, String? redirectType) {
    // Capture singletons before popping — the popped context becomes defunct.
    final wishlistCubit = context.read<WishlistCubit>();
    final cartCubit = context.read<CartActionsCubit>();
    final cartBloc = context.read<CartBloc>();

    // Local state was captured while logged out; re-seed with user-specific data.
    // (Both leave any pending action intact so resume below still fires.)
    wishlistCubit.invalidateOnAuthChange();
    cartCubit.clearOnAuthChange();

    _clearAuthStack(context);

    switch (redirectType) {
      case LoginRedirects.typeAddToWishlist:
        // Two different stores can hold a pending wishlist add: the global
        // WishlistCubit (a PLP/PDP heart tap) and CartBloc (a cart line's
        // "Move To Wishlist", which is a different endpoint because it also
        // removes the line). Only one is ever populated, and both are no-ops
        // when empty, so resuming both keeps one redirect type covering both
        // surfaces.
        wishlistCubit.resumePending();
        cartBloc.resumePendingMoveToWishlist();
        return;
      case LoginRedirects.typeAddToCart:
        cartCubit.resumePending();
        return;
      case LoginRedirects.typePromo:
        cartBloc.resumePendingPromo();
        return;
    }

    final navigate = _redirectNavMap[redirectType] ?? goToAccount;
    navigate(context);
  }

  static void _clearAuthStack(BuildContext context) {
    const authRoutes = {RouteNames.login, RouteNames.joinUs, RouteNames.otpVerification};
    final matches = GoRouter.of(context).routerDelegate.currentConfiguration.matches;
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
  ///
  /// See [goToLogin] for [entry] — this route has two callers on different
  /// screens, so the surface has to come from the caller.
  static Future<bool> showMobileLoginFlow(
    BuildContext context, {
    AuthEntryArgs entry = AuthEntryArgs.unknown,
  }) async {
    final accountBloc = context.read<AccountBloc>();
    final result = await context.pushNamed<bool>(
      RouteNames.checkoutLogin,
      extra: <String, dynamic>{'accountBloc': accountBloc, 'entry': entry},
    );
    return result == true;
  }

  /// [args] carries the analytics entry context (`from_screen`,
  /// `from_location`, `position`, …) — the Flutter equivalent of the Intent
  /// extras Android reads in `PLPAnalytics.setIntentData`. It travels as
  /// `extra` rather than a query parameter so it stays out of the URL and off
  /// deeplinks; omit it for a deeplink-style open, which is what Android does
  /// too when nothing is passed.
  static void goToPlp(
    BuildContext context, {
    PageType pageType = PageType.plp,
    required int plpId,
    String? categoryName,
    String? searchQuery,
    String? rawSearchParams,
    PlpEntryArgs? args,
  }) {
    final queryParams = <String, String>{'pageType': pageType.name, 'plpId': plpId.toString()};
    if (categoryName != null) queryParams['categoryName'] = categoryName;
    if (searchQuery != null) queryParams['searchQuery'] = searchQuery;
    if (rawSearchParams != null) queryParams['rawSearchParams'] = rawSearchParams;
    context.pushNamed('plp', queryParameters: queryParams, extra: args);
  }

  /// [args] carries the analytics entry context (`from_screen`, `position`,
  /// `source_tile_type`, …) — the Flutter equivalent of the Intent bundle
  /// Android reads in `PDPAnalytics.setIntentData`. Omit it for a deeplink-style
  /// open, which is what Android does too when nothing is passed.
  static Future<void> goToPdp(BuildContext context, String productId, {PdpEntryArgs? args}) async {
    await context.pushNamed('pdp', pathParameters: {'productId': productId}, extra: args);
  }

  /// Open the fullscreen product image gallery starting at [initialIndex].
  static void goToPdpImageGallery(
    BuildContext context, {
    required List<MediaEntity> media,
    int initialIndex = 0,
  }) {
    context.pushNamed(
      'pdpImageGallery',
      extra: <String, dynamic>{'media': media, 'initialIndex': initialIndex},
    );
  }

  static void goToLandingPage(BuildContext context, {required String pageName, String? title}) {
    final queryParams = <String, String>{'pageName': pageName};
    if (title != null) queryParams['title'] = title;
    context.pushNamed('landingPage', queryParameters: queryParams);
  }

  static void goToWebView(
    BuildContext context, {
    required String url,
    String? title,
    bool fromNotification = false,
  }) {
    context.pushNamed(
      'webview',
      extra: <String, dynamic>{'url': url, 'title': title, 'fromNotification': fromNotification},
    );
  }

  static void goToPaymentState(
    BuildContext context, {
    required InitJusPayEntity initJusPayEntity,
    required int orderId,
    required bool creditsApplied,
    bool quickPayEnabled = false,
  }) {
    context.pushNamed(
      'paymentState',
      extra: <String, dynamic>{
        'initJusPayEntity': initJusPayEntity,
        'orderId': orderId,
        'creditsApplied': creditsApplied,
        'quickPayEnabled': quickPayEnabled,
      },
    );
  }

  static void goToPaymentRetry(
    BuildContext context, {
    required PaymentRetryEntity paymentRetryEntity,
    required int orderId,
  }) {
    context.pushReplacementNamed(
      'paymentRetry',
      extra: <String, dynamic>{'paymentRetryEntity': paymentRetryEntity, 'orderId': orderId},
    );
  }

  static void goToOrderConfirmation(
    BuildContext context, {
    required OrderConfirmationEntity orderConfirmationEntity,
  }) {
    context.pushReplacementNamed(
      'orderConfirmation',
      extra: <String, dynamic>{'orderConfirmationEntity': orderConfirmationEntity},
    );
  }

  static void goToOrders(BuildContext context) => context.pushNamed('orders');

  /// [fromScreen] is stamped on the wishlist_viewed analytics event so
  /// dashboards can attribute the open to Home / PLP / PDP / Cart / etc.
  static void goToWishlist(BuildContext context, {String? fromScreen}) =>
      context.pushNamed('wishlist', extra: fromScreen);

  /// Open the wishlist, gating on login. When logged out, routes to login
  /// with a wishlist redirect so the user lands directly on the wishlist
  /// screen after signing in (see [_redirectNavMap]).
  static void goToWishlistGated(BuildContext context, {String? fromScreen}) {
    final loggedIn = context.read<AccountBloc>().state.account.isLoggedIn;
    if (loggedIn) {
      goToWishlist(context, fromScreen: fromScreen);
      return;
    }
    goToLogin(
      context,
      redirectType: LoginRedirects.typeWishlistScreen,
      initialMessageBars: const [
        MessageBarEntity(
          text: LoginRedirects.redirectWishlistScreen,
          type: 'info',
          hasIcon: true,
        ),
      ],
    );
  }

  static void goToLegal(BuildContext context) => context.pushNamed('legal');

  /// [savingsTextFromCart] is the cart's "You saved ₹X" line, shown on the
  /// detail page when the user arrives from the cart's offer sheet.
  ///
  /// It travels in `extra`, not in the URL: `RouteNames.promoDetails` declares
  /// exactly one path parameter (`:promoId`), so passing a second one trips
  /// go_router's `paramNames.contains(key)` assertion. It is also display
  /// copy — free text with spaces, ₹ and commas — which has no business in a
  /// path segment even if the route did accept it.
  static void goToPromoDetails(BuildContext context, int promoId, {String? savingsTextFromCart}) =>
      context.pushNamed(
        'promoDetails',
        pathParameters: {'promoId': promoId.toString()},
        extra: <String, dynamic>{
          if (savingsTextFromCart != null && savingsTextFromCart.isNotEmpty)
            PromoDetailsDestination.savingsTextExtraKey: savingsTextFromCart,
        },
      );

  static void goToSearch(BuildContext context) => context.pushNamed('search');

  static void goToKids(BuildContext context) => context.pushNamed(RouteNames.kidsName);

  /// Push the add/edit child screen. Pass [existing] to enter edit mode.
  /// Returns the saved [ChildEntity] on success, or `null` on cancel.
  static Future<ChildEntity?> goToAddKid(BuildContext context, {ChildEntity? existing}) {
    return context.pushNamed<ChildEntity>(
      RouteNames.addKidName,
      extra: <String, dynamic>{'existing': existing},
    );
  }

  static void goToAddresses(
    BuildContext context, {
    required String fromScreen,
    AddressListMode mode = AddressListMode.normal,
  }) => context.pushNamed(
        RouteNames.addressesName,
        extra: <String, dynamic>{'mode': mode, 'fromScreen': fromScreen},
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
      RouteNames.addAddressName,
      extra: <String, dynamic>{'args': args},
    );
  }
}
