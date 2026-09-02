import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hs_app_flutter/features/address/domain/entities/address_entity.dart';
import 'package:hs_app_flutter/features/address/domain/entities/manage_address_args.dart';
import 'package:hs_app_flutter/features/address/presentation/widgets/address_item_card.dart';
import 'package:hs_app_flutter/features/pdp/domain/entities/media_entity.dart';
import 'package:hs_app_flutter/features/plp/domain/entities/page_type.dart';

import '../navigation/nav_destination.dart';
import '../../features/account/presentation/bloc/account_bloc.dart';
import '../../features/auth/domain/entities/otp_config/otp_config_entity.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/cart/presentation/bloc/cart_bloc.dart';
import '../../features/cart/presentation/cubit/cart_actions_cubit.dart';
import '../../features/pdp/domain/entities/pdp_entry_args.dart';
import '../../features/wishlist/presentation/cubit/wishlist_cubit.dart';
import '../constants/route_names.dart';
import '../constants/strings/auth_strings.dart';
import '../constants/strings/login_redirects.dart';
import '../entities/message_bar_entity.dart';

abstract final class AppNavigator {
  static bool _isRouteInStack(BuildContext context, String routeName) {
    final matches = GoRouter.of(
      context,
    ).routerDelegate.currentConfiguration.matches;
    return matches.whereType<RouteMatch>().any(
      (m) => m.route.name == routeName,
    );
  }

  static void goToHome(BuildContext context) => context.go(RouteNames.home);

  static void goToCategories(BuildContext context) =>
      context.go(RouteNames.categories);

  static void goToAccount(BuildContext context) =>
      context.go(RouteNames.account);

  /// Opens the bag. [fromBuyNow] puts the cart in buy-now mode: it proceeds to
  /// checkout on its own as soon as the cart loads, instead of waiting for the
  /// checkout button — the Flutter equivalent of Android's
  /// `Util.createBuyNowShoppingCartIntent` passing `IS_FROM_BUYNOW`.
  static void goToCart(BuildContext context, {bool fromBuyNow = false}) =>
      context.pushNamed(
        RouteNames.cartName,
        queryParameters: fromBuyNow ? const {'fromBuyNow': 'true'} : const {},
      );

  /// Pops the current route / dismisses the top-most sheet or dialog.
  static void goBack(BuildContext context) => context.pop();

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
        initialMobile != null ||
        initialMessageBars.isNotEmpty ||
        redirectType != null;
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
        ? <String, dynamic>{
            'initialMobile': initialMobile,
            'redirectType': redirectType,
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
    const authRoutes = {
      RouteNames.login,
      RouteNames.joinUs,
      RouteNames.otpVerification,
    };
    final matches = GoRouter.of(
      context,
    ).routerDelegate.currentConfiguration.matches;
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

  static void goToPlp(
    BuildContext context, {
    PageType pageType = PageType.plp,
    required int plpId,
    String? categoryName,
    String? searchQuery,
    String? rawSearchParams,
  }) {
    final queryParams = <String, String>{
      'pageType': pageType.name,
      'plpId': plpId.toString(),
    };
    if (categoryName != null) queryParams['categoryName'] = categoryName;
    if (searchQuery != null) queryParams['searchQuery'] = searchQuery;
    if (rawSearchParams != null)
      queryParams['rawSearchParams'] = rawSearchParams;
    context.pushNamed('plp', queryParameters: queryParams);
  }

  /// [args] carries the analytics entry context (`from_screen`, `position`,
  /// `source_tile_type`, …) — the Flutter equivalent of the Intent bundle
  /// Android reads in `PDPAnalytics.setIntentData`. Omit it for a deeplink-style
  /// open, which is what Android does too when nothing is passed.
  static Future<void> goToPdp(
    BuildContext context,
    String productId, {
    PdpEntryArgs? args,
  }) async {
    await context.pushNamed(
      'pdp',
      pathParameters: {'productId': productId},
      extra: args,
    );
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

  static void goToLandingPage(
    BuildContext context, {
    required String pageName,
    String? title,
  }) {
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
      extra: <String, dynamic>{
        'url': url,
        'title': title,
        'fromNotification': fromNotification,
      },
    );
  }

  static void goToOrders(BuildContext context) => context.pushNamed('orders');

  static void goToLegal(BuildContext context) => context.pushNamed('legal');

  /// [savingsTextFromCart] is the cart's "You saved ₹X" line, shown on the
  /// detail page when the user arrives from the cart's offer sheet.
  ///
  /// It travels in `extra`, not in the URL: `RouteNames.promoDetails` declares
  /// exactly one path parameter (`:promoId`), so passing a second one trips
  /// go_router's `paramNames.contains(key)` assertion. It is also display
  /// copy — free text with spaces, ₹ and commas — which has no business in a
  /// path segment even if the route did accept it.
  static void goToPromoDetails(
    BuildContext context,
    int promoId, {
    String? savingsTextFromCart,
  }) => context.pushNamed(
    'promoDetails',
    pathParameters: {'promoId': promoId.toString()},
    extra: <String, dynamic>{
      if (savingsTextFromCart != null && savingsTextFromCart.isNotEmpty)
        PromoDetailsDestination.savingsTextExtraKey: savingsTextFromCart,
    },
  );

  static void goToSearch(BuildContext context) => context.pushNamed('search');
  static void goToAddresses(
    BuildContext context, {
    AddressListMode mode = AddressListMode.normal,
  }) => context.pushNamed('addresses', extra: <String, dynamic>{'mode': mode});

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
