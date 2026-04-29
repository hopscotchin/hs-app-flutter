import 'package:flutter/material.dart';

import 'deeplink_hosts.dart';
import 'nav_destination.dart';

export 'nav_destination.dart';

/// Centralised handler for deep links and web URLs.
///
/// Two public methods:
///   - [navigate] — parse and go to the matching screen
///   - [parse]    — obtain the [NavDestination] without navigating
///
/// Routing:
///   - **App links** : `hopscotch://<route>?<queryParams>`
///   - **Web links** : `https://www.hopscotch.in/<path>/<params>`
///   - **Bare IDs**  : `12345` → PLP boutique
///   - **External**  : any non-Hopscotch URL → system browser
///   - **Unknown Hopscotch path** → in-app WebView
class ActionUrlHandler {
  ActionUrlHandler._();

  // ── Public API ───────────────────────────────────────────────

  /// Parse [actionUrl] and navigate to the matching screen.
  ///
  /// Returns `true` if the URL was handled, `false` otherwise.
  static bool navigate(
    BuildContext context,
    String? actionUrl, {
    String? title,
  }) {
    if (actionUrl == null || actionUrl.isEmpty) return false;

    final destination = parse(actionUrl);
    if (destination == null) {
      debugPrint('ActionUrlHandler: unrecognised → $actionUrl');
      return false;
    }

    debugPrint('ActionUrlHandler: $actionUrl → ${destination.runtimeType}');
    destination.navigate(context, title: title);
    return true;
  }

  /// Parse [actionUrl] into a [NavDestination] without navigating.
  ///
  /// Returns `null` when the URL cannot be mapped to any destination.
  static NavDestination? parse(String actionUrl) {
    if (actionUrl.isEmpty) return null;

    final uri = Uri.tryParse(actionUrl);
    if (uri == null) return null;

    // hopscotch://<route>?<params>
    if (uri.scheme == 'hopscotch') return _parseAppLink(uri);

    // https://…
    if (uri.scheme == 'http' || uri.scheme == 'https') {
      if (_isHopscotchDomain(uri.host)) return _parseWebLink(uri);
      return ExternalDestination(url: actionUrl);
    }

    return null;
  }

  // ── App-link routing ─────────────────────────────────────────
  //
  // Format: hopscotch://<route>?id=<value>&q=<keyword>
  // The `host` portion of the URI is the route name.

  static NavDestination? _parseAppLink(Uri uri) {
    final route = uri.host;
    final params = uri.queryParameters;
    final id = params['id'] ?? '';

    switch (route) {
      // ── Home ──
      case _Route.discover || _Route.home ||
           DeeplinkHost.discoverPage || DeeplinkHost.homePage || DeeplinkHost.customTiles ||
           DeeplinkHost.changeSortBar || DeeplinkHost.notificationPermission:
        return const HomeDestination();

      // ── Cart ──
      case _Route.cart || DeeplinkHost.shoppingCart || DeeplinkHost.cartMerge:
        return const CartDestination();

      // ── Categories ──
      case _Route.categories:
        return const CategoriesDestination();

      // ── Moments ──
      case _Route.moments ||
           DeeplinkHost.momentPage || DeeplinkHost.momentUpload ||
           DeeplinkHost.momentUpload2 || DeeplinkHost.myMoment ||
           DeeplinkHost.photo:
        return const MomentsDestination();

      // ── Account & sub-pages ──
      case _Route.account ||
           DeeplinkHost.meTab || DeeplinkHost.accountPage ||
           DeeplinkHost.facebook || DeeplinkHost.ordersListing ||
           DeeplinkHost.orderDetails || DeeplinkHost.orderTracking ||
           DeeplinkHost.orderReturn || DeeplinkHost.address ||
           DeeplinkHost.name || DeeplinkHost.email ||
           DeeplinkHost.password || DeeplinkHost.setPassword ||
           DeeplinkHost.mobile || DeeplinkHost.mobileVerify ||
           DeeplinkHost.addMobile || DeeplinkHost.addKids ||
           DeeplinkHost.aboutKids || DeeplinkHost.credits ||
           DeeplinkHost.helpCenter || DeeplinkHost.contactUs:
        return const AccountDestination();

      // ── Auth → Home (TODO: navigate to auth flow) ──
      case DeeplinkHost.signInPage || DeeplinkHost.signInEmail ||
           DeeplinkHost.signInMobile || DeeplinkHost.signUp ||
           DeeplinkHost.join:
        return const HomeDestination();

      // ── Rate / Update app ──
      case DeeplinkHost.rateApp || DeeplinkHost.updateApp ||
           DeeplinkHost.updateApp2:
        return const RateAppDestination();

      // ── TODO: navigate to dedicated pages when built ──
      case DeeplinkHost.bestsellersPage || DeeplinkHost.newPage ||
           DeeplinkHost.salePage || DeeplinkHost.endingSoon ||
           DeeplinkHost.upcomingPage || DeeplinkHost.wishlist ||
           DeeplinkHost.offers || DeeplinkHost.offersFromPdp ||
           DeeplinkHost.productRatings ||
           DeeplinkHost.productRating || DeeplinkHost.legal ||
           DeeplinkHost.sizeChart ||
           DeeplinkHost.bottomSheet:
        return const HomeDestination();

      default:
        debugPrint('ActionUrlHandler: unknown app-link route=$route');
        return null;
    }
  }

  // ── Web-link routing ─────────────────────────────────────────
  //
  // Format: https://www.hopscotch.in/<path>?<params>
  // Unknown Hopscotch paths fall through to the in-app WebView.

  static NavDestination _parseWebLink(Uri uri) {
    final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
    final params = uri.queryParameters;
    final url = uri.toString();

    // Root (https://www.hopscotch.in) → Home
    if (segments.isEmpty) return const HomeDestination();

    final first = segments[0].toLowerCase();

    switch (first) {
      // ── Home ──
      case _Route.discover || _Route.home:
        return const HomeDestination();

      // ── Cart: /cart, /shoppingcart, /checkout ──
      case _Route.cart || 'shoppingcart' || 'shopping-cart' || 'checkout':
        return const CartDestination();

      // ── Categories ──
      case _Route.categories || 'category':
        return const CategoriesDestination();

      // ── Moments ──
      case _Route.moments || 'moment':
        return const MomentsDestination();

      // ── Account: /account, /my/*, /helpcenter ──
      case _Route.account || 'my' || 'helpcenter':
        return const AccountDestination();

      // ── Auth → Home (TODO: navigate to auth flow) ──
      case 'login' || 'register':
        return const HomeDestination();

      // ── Static / legal pages → in-app WebView ──
      case 'about':
        final sub = segments.length >= 2 ? segments[1].toLowerCase() : '';
        final title = switch (sub) {
          'returnpolicy' => 'Return Policy',
          'privacy'      => 'Privacy Policy',
          'terms'        => 'Terms & Conditions',
          'faq'          => 'FAQ',
          _              => 'About',
        };
        return WebViewDestination(url: url, pageTitle: title);

      case 'feedback':
        return WebViewDestination(url: url, pageTitle: 'Feedback');

      // ── TODO: navigate to dedicated pages when built ──
      case 'bestsellers' || 'endingsoon' || 'new' || 'sale' ||
           'coming_soon' || 'coming-soon' || 'offers' || 'wishlist':
        return const HomeDestination();

      // ── Unknown Hopscotch path → in-app WebView ──
      default:
        return WebViewDestination(url: url);
    }
  }

  // ── Private helpers ──────────────────────────────────────────

  static bool _isHopscotchDomain(String host) {
    final h = host.toLowerCase();
    return h == 'hopscotch.in' || h.endsWith('.hopscotch.in');
  }

  static int _id(String? value) => int.tryParse(value ?? '') ?? 0;
}

/// Primary route names shared by app links and web paths.
///
/// App link : `hopscotch://discover`
/// Web link : `https://www.hopscotch.in/discover`
abstract final class _Route {
  static const discover   = 'discover';
  static const home       = 'home';
  static const products   = 'products';
  static const product    = 'product';
  static const boutique   = 'boutique';
  static const search     = 'search';
  static const cart       = 'cart';
  static const categories = 'categories';
  static const moments    = 'moments';
  static const account    = 'account';
}
