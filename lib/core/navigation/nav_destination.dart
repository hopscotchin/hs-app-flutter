import 'package:flutter/material.dart';
import 'package:hs_app_flutter/core/router/app_navigator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/entities/message_bar_entity.dart';
import '../../features/pdp/domain/entities/pdp_entry_args.dart';
import '../../features/plp/domain/entities/page_type.dart';

/// Base class for navigation destinations.
sealed class NavDestination {
  const NavDestination();

  void navigate(BuildContext context, {String? title, Map<String, dynamic>? extra});
}

class PlpDestination extends NavDestination {
  final PageType pageType;
  final int plpId;
  final String? categoryName;
  final String? searchQuery;

  const PlpDestination({
    required this.pageType,
    required this.plpId,
    this.categoryName,
    this.searchQuery,
  });

  @override
  void navigate(BuildContext context, {String? title, Map<String, dynamic>? extra}) {
    AppNavigator.goToPlp(
      context,
      pageType: pageType,
      plpId: plpId,
      categoryName: title ?? categoryName,
      searchQuery: searchQuery,
    );
  }
}

class PdpDestination extends NavDestination {
  final String productId;

  const PdpDestination({required this.productId});

  /// Forwards [PdpEntryArgs] from [extra] when the caller supplied it.
  ///
  /// Without this, the two ways into PDP behave differently: a PLP tile calling
  /// `goToPdp(args:)` carries entry context, while the same product opened
  /// through an `actionUri` routes here and arrives with none — so `from_screen`,
  /// `from_page`, `from_feed_size` and `position` go missing on all 22 PDP events
  /// and `source_tile_type` reports its `'other'` default.
  ///
  /// Per-tile context cannot travel any other way. Attribution is persisted and
  /// merged, so it has no notion of "this hop"; the navigation observer is
  /// route-derived, so it knows *PLP* but not *tile 7 of 164*. Mirrors Android's
  /// intent extras (`IntentHelper.buildNewPDPAnalyticsData`).
  @override
  void navigate(BuildContext context, {String? title, Map<String, dynamic>? extra}) {
    final args = extra?[pdpEntryArgsKey];
    AppNavigator.goToPdp(context, productId, args: args is PdpEntryArgs ? args : null);
  }
}

class PromoDetailsDestination extends NavDestination {
  final int promoId;

  const PromoDetailsDestination({required this.promoId});

  @override
  void navigate(BuildContext context, {String? title, Map<String, dynamic>? extra}) {
    AppNavigator.goToPromoDetails(context, promoId);
  }
}

/// Key under which [PdpEntryArgs] travels in a [NavDestination] `extra` map.
///
/// A constant rather than a literal so the producer and consumer cannot drift —
/// a typo would silently drop the entry context with nothing to catch it.
const String pdpEntryArgsKey = 'pdpEntryArgs';

class HomeDestination extends NavDestination {
  const HomeDestination();

  @override
  void navigate(BuildContext context, {String? title, Map<String, dynamic>? extra}) {
    AppNavigator.goToHome(context);
  }
}

class CartDestination extends NavDestination {
  const CartDestination();

  @override
  void navigate(BuildContext context, {String? title, Map<String, dynamic>? extra}) {
    AppNavigator.goToCart(context);
  }
}

class CategoriesDestination extends NavDestination {
  const CategoriesDestination();

  @override
  void navigate(BuildContext context, {String? title, Map<String, dynamic>? extra}) {
    AppNavigator.goToCategories(context);
  }
}

class AccountDestination extends NavDestination {
  const AccountDestination();

  @override
  void navigate(BuildContext context, {String? title, Map<String, dynamic>? extra}) {
    AppNavigator.goToAccount(context);
  }
}

class ExternalDestination extends NavDestination {
  final String url;

  const ExternalDestination({required this.url});

  @override
  void navigate(BuildContext context, {String? title, Map<String, dynamic>? extra}) {
    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }
}

class RateAppDestination extends NavDestination {
  const RateAppDestination();

  @override
  void navigate(BuildContext context, {String? title, Map<String, dynamic>? extra}) {
    launchUrl(
      Uri.parse('market://details?id=in.hopscotch.android'),
      mode: LaunchMode.externalApplication,
    );
  }
}

class LandingPageDestination extends NavDestination {
  final String pageName;
  final String? pageTitle;

  const LandingPageDestination({required this.pageName, this.pageTitle});

  @override
  void navigate(BuildContext context, {String? title, Map<String, dynamic>? extra}) {
    AppNavigator.goToLandingPage(context, pageName: pageName, title: title ?? pageTitle);
  }
}

class JoinUsDestination extends NavDestination {
  const JoinUsDestination({this.mobile});

  final String? mobile;

  @override
  void navigate(BuildContext context, {String? title, Map<String, dynamic>? extra}) {
    AppNavigator.goToJoinUs(
      context,
      initialMobile: mobile,
      redirectType: extra?['redirectType'] as String?,
    );
  }
}

class LoginDestination extends NavDestination {
  const LoginDestination({this.mobile, this.messageBars = const []});

  final String? mobile;
  final List<MessageBarEntity> messageBars;

  @override
  void navigate(BuildContext context, {String? title, Map<String, dynamic>? extra}) {
    final extraBars = extra?['messageBars'] as List<MessageBarEntity>? ?? const [];
    AppNavigator.goToLogin(
      context,
      initialMobile: mobile,
      initialMessageBars: extraBars.isNotEmpty ? extraBars : messageBars,
    );
  }
}

class WebViewDestination extends NavDestination {
  final String url;
  final String? pageTitle;

  const WebViewDestination({required this.url, this.pageTitle});

  @override
  void navigate(BuildContext context, {String? title, Map<String, dynamic>? extra}) {
    AppNavigator.goToWebView(context, url: url, title: title ?? pageTitle);
  }
}
