import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hs_app_flutter/core/analytics/analytics_map.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_properties.dart';
import 'package:hs_app_flutter/core/router/app_navigator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../analytics/constants/analytics_defaults.dart';
import '../../core/entities/message_bar_entity.dart';
import '../../features/auth/domain/entities/auth_entry_args.dart';
import '../../features/pdp/domain/entities/pdp_entry_args.dart';
import '../analytics/constants/analytics_defaults.dart';
import '../../features/plp/domain/entities/page_type.dart';
import '../../features/plp/domain/entities/plp_entry_args.dart';

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

  /// Entry context comes from one of two places, and explicit args win.
  ///
  /// * [PlpEntryArgs] under [plpEntryArgsKey] — a caller that built the whole
  ///   payload itself: the PLP's custom-product-tile, Categories, Search.
  ///   Passed through untouched.
  /// * [SourcePage] under [sourcePageKey] — a tile that only knows which screen
  ///   it sat on. Contributes `from_screen`, for a boutique exactly as for any
  ///   other listing.
  ///
  ///   This used to skip boutiques, on the grounds that Android's boutique
  ///   deeplink hosts write no `FROM_SCREEN` (`TileAction:138`, `:145`) where
  ///   the listing host does (`:128`). That compared the wrong screens: those
  ///   hosts open `SearchResultsShowingBoutiquesActivity`, which lists
  ///   *boutiques*, whereas [PageType.boutique] here is a listing of
  ///   *products* — the same [PlpPage], differing only by its banner. Its
  ///   Android counterpart is `ProductListActivity` serving a sale plan, which
  ///   does carry `FROM_SCREEN` (`ProductListActivity.kt:716`).
  ///
  ///   Only the keys in the `context instanceof HomePageActivity` block
  ///   (`:905-924`) stay out, since matched production payloads show that block
  ///   does not fire.
  @override
  void navigate(BuildContext context, {String? title, Map<String, dynamic>? extra}) {
    AppNavigator.goToPlp(
      context,
      pageType: pageType,
      plpId: plpId,
      categoryName: title ?? categoryName,
      searchQuery: searchQuery,
      args: entryArgsFrom(extra),
    );
  }

  /// The entry context this destination takes from [extra]. Named rather than
  /// inlined so the rule can be read — and tested — without a Navigator.
  PlpEntryArgs? entryArgsFrom(Map<String, dynamic>? extra) => switch (extra?[plpEntryArgsKey]) {
    final PlpEntryArgs args => args,
    _ => switch (extra?[sourcePageKey]) {
      final SourcePage source => PlpEntryArgs(
        fromScreen: source.fromScreen,
        fromLocation: source.fromLocation,
      ),
      _ => null,
    },
  };
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
  ///
  /// A [SourcePage] is the fallback: a home or landing-page tile knows only
  /// the page it sat on, and Android passes exactly that much here —
  /// `buildIntentExtras(fromScreen, …)` in the `deepLinkProductPage` branch
  /// (`TileAction:209`). Explicit args win, since a caller that built the whole
  /// payload knows more than the origin does.
  @override
  void navigate(BuildContext context, {String? title, Map<String, dynamic>? extra}) {
    AppNavigator.goToPdp(context, productId, args: entryArgsFrom(extra));
  }

  /// The entry context this destination takes from [extra]. See
  /// [PlpDestination.entryArgsFrom].
  PdpEntryArgs? entryArgsFrom(Map<String, dynamic>? extra) => switch (extra?[pdpEntryArgsKey]) {
    final PdpEntryArgs args => args,
    _ => switch (extra?[sourcePageKey]) {
      final SourcePage source => PdpEntryArgs(
        fromScreen: source.fromScreen,
        fromPage: source.fromPage,
      ),
      _ => null,
    },
  };
}

class PromoDetailsDestination extends NavDestination {
  /// Key under which the cart's savings line travels in a [navigate] `extra`
  /// map — and the query parameter a deeplink may carry it in.
  static const String savingsTextExtraKey = 'savingsTextFromCart';

  final int promoId;

  /// Set when the URL itself carried `?savingsTextFromCart=…`. A caller that
  /// has the text in hand (the cart's offer sheet) passes it through
  /// [navigate]'s `extra` instead, which takes precedence.
  final String? savingsTextFromCart;

  const PromoDetailsDestination({required this.promoId, this.savingsTextFromCart});

  @override
  void navigate(BuildContext context, {String? title, Map<String, dynamic>? extra}) {
    final fromExtra = extra?[savingsTextExtraKey] as String?;
    AppNavigator.goToPromoDetails(
      context,
      promoId,
      savingsTextFromCart: (fromExtra?.isNotEmpty ?? false) ? fromExtra : savingsTextFromCart,
    );
  }
}

/// Key under which [PdpEntryArgs] travels in a [NavDestination] `extra` map.
///
/// A constant rather than a literal so the producer and consumer cannot drift —
/// a typo would silently drop the entry context with nothing to catch it.
const String pdpEntryArgsKey = 'pdpEntryArgs';

/// Key under which a [SourcePage] travels in a [NavDestination] `extra` map.
const String sourcePageKey = 'sourcePage';

/// The page a navigation started from — its name and its kind.
///
/// A tile knows which page it sits on but nothing about where it will land —
/// the same `actionUri` can resolve to a PLP, a PDP, a landing page or a
/// webview. So the page states itself once and each [NavDestination] takes
/// what it needs, which is also how Android splits the job:
/// `TileAction.getActionIntent` branches on the deeplink host and writes a
/// different set of extras per destination.
///
/// Today two destinations read it, and they take **different amounts** —
/// which is the reason this is a type rather than a bare string:
///
/// | Destination | Takes | Android |
/// |---|---|---|
/// | PDP | `from_screen` **and** `from_page` | `getActionIntent:209` — `buildIntentExtras(fromScreen, fromPage, …)` |
/// | listing / search PLP | `from_screen` only | `getActionIntent:128`, `:347` |
/// | boutique PLP | *nothing* | no `FROM_SCREEN` write |
/// | everything else | *nothing* | no `FROM_SCREEN` write |
///
/// `from_page` reaches the PDP unconditionally, but the PLP's copy sits in the
/// `context instanceof HomePageActivity` block (`:911-916`) that production
/// payloads show does not fire — so the same tap contributes two keys to a PDP
/// and one to a PLP.
///
/// A caller that knows more builds the destination's own args instead
/// ([PlpEntryArgs], [PdpEntryArgs]) and those win — this is the floor, not a
/// competing source.
class SourcePage {
  const SourcePage({this.fromScreen, this.fromPage, this.fromLocation});

  /// `Discover`, or a landing page's API `pageName`.
  final String? fromScreen;

  /// The kind of page the tile sat on — `homepage`, `landingPage`,
  /// `tabbedlandingpage`. Android sets it once per host
  /// (`CollectionsFragment:351`, `SearchResultsShowingBoutiquesActivity:560`,
  /// `TabbedLandingPageFragment:137`) and every tile viewholder copies it into
  /// the intent's extras bundle.
  final String? fromPage;

  /// The control that was touched — `Search icon`, `Custom tile`. Null for a
  /// tile navigation: matched production payloads show Android's tile hosts
  /// send no `from_location`, so a Discover or landing-page tile leaves this
  /// unset and nothing reaches the wire.
  final String? fromLocation;

  /// This origin as the payload keys it stands for — the one place the
  /// field-to-wire-name mapping is written down, so an event builder merges
  /// the result instead of restating each field.
  ///
  /// A null field contributes nothing, which is what lets one accessor serve
  /// callers that supply different subsets: a Discover tile sets only
  /// [fromScreen] and [fromPage], the PLP search icon only [fromScreen] and
  /// [fromLocation], and neither ships the other's keys.
  Map<String, Object?> get analyticsProps => <String, Object?>{}
    ..putAnalyticsKey(AnalyticsProperties.fromScreen, fromScreen)
    ..putAnalyticsKey(AnalyticsProperties.fromPage, fromPage)
    ..putAnalyticsKey(AnalyticsProperties.fromLocation, fromLocation);
}

/// Assembles the `extra` map for a navigation that carries analytics context.
///
/// Exists so the four page-component widgets do not each hand-roll the same
/// map, and so a null stays a null rather than an empty map that reads as
/// "context supplied, but blank".
Map<String, dynamic>? navExtra({
  SourcePage? sourcePage,
  PdpEntryArgs? pdpEntryArgs,
  PlpEntryArgs? plpEntryArgs,
}) {
  final extra = <String, dynamic>{
    if (sourcePage != null) sourcePageKey: sourcePage,
    if (pdpEntryArgs != null) pdpEntryArgsKey: pdpEntryArgs,
    if (plpEntryArgs != null) plpEntryArgsKey: plpEntryArgs,
  };
  return extra.isEmpty ? null : extra;
}

/// Key under which a fully-built [PlpEntryArgs] travels in a [NavDestination]
/// `extra` map. See [pdpEntryArgsKey].
const String plpEntryArgsKey = 'plpEntryArgs';

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
    AppNavigator.goToCart(
      context,
      // A deeplink has no originating screen inside the app, so `from_screen`
      // is the `none` sentinel — Android's own fallback for an unknown one
      // (`logRecoClickedEvent`, and every other `!isEmpty(x) ? x : NONE`).
      // It was `FromLocations.deeplink`, which is a `from_location` value:
      // there is no `FromScreens.deeplink`, and Android has no deeplink
      // caller of `navigateToCart` to mirror. `from_location` already says
      // the entry was a deeplink, so nothing is lost.
      sourcePage: const SourcePage(
        fromScreen: AnalyticsDefaults.none,
        fromLocation: FromLocations.deeplink,
      ),
    );
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
    unawaited(_launch());
  }

  /// `launchUrl` reports failure by returning false, and throws when the
  /// platform rejects the intent. Both were dropped, so a `tel:` the device
  /// could not resolve looked identical to a tap that worked — which is how
  /// Call Us failed silently before `tel` was declared in the manifest's
  /// `<queries>`.
  Future<void> _launch() async {
    final uri = Uri.parse(url);
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        debugPrint('ExternalDestination: no handler for $uri');
      }
    } catch (e) {
      debugPrint('ExternalDestination: could not launch $uri — $e');
    }
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
      entry: _deeplinkEntry,
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
      entry: _deeplinkEntry,
    );
  }
}

/// Auth reached through an action URL — a deeplink, a message-bar CTA or a
/// hero tile. There is no originating screen to report: the URL is resolved
/// from a string, and by the time it lands here the surface that held it is
/// gone. `from_location: "Deeplink"` says that, rather than leaving both keys
/// at "none" and losing the distinction from a genuinely unknown entry.
const _deeplinkEntry = AuthEntryArgs(fromLocation: FromLocations.deeplink);

class WebViewDestination extends NavDestination {
  final String url;
  final String? pageTitle;

  const WebViewDestination({required this.url, this.pageTitle});

  @override
  void navigate(BuildContext context, {String? title, Map<String, dynamic>? extra}) {
    AppNavigator.goToWebView(context, url: url, title: title ?? pageTitle);
  }
}
