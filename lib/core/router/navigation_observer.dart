import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

import '../analytics/attribution/order_attribution_helper.dart';
import '../analytics/constants/analytics_defaults.dart';
import '../analytics/constants/analytics_properties.dart';
import '../analytics/home/home_track_analytic_manager.dart';
import '../analytics/state/launch_timer.dart';
import '../constants/route_names.dart';
import '../di/injection.dart';

/// Route observer that owns *all* navigation-driven analytics state:
///
///   1. **Funnel switching** — entering a funnel-owning screen clears the
///      OrderAttribution `trackingMeta` blob + LP attribution deque and pins
///      `funnel` to that screen's value. Two entry paths:
///        * Out-of-shell funnel routes (cart, search) — handled by [didPush].
///        * Shell tabs (Discover, Categories, Account) — handled by
///          [setActiveFunnel] called from `Dashboard` on tab select /
///          initial mount, because `StatefulShellRoute.indexedStack` swaps
///          child widgets *without* pushing named routes through observers.
///   2. **LP context stack** — each `landingPage` push adds a fresh entry.
///      `LandingPageBloc.setLandingPageContext` fills its top's id/name once
///      the response arrives. On pop, the entry is removed and the new top
///      (if any) is reapplied so LP2 → back → LP1 restores LP1's identity
///      without any per-bloc resume hook.
///   3. **Automatic back-to-shell restore** — pop that leaves us underneath
///      the shell (previousRoute has no name) reapplies whichever funnel
///      the Dashboard last declared active via [setActiveFunnel].
///   4. **Navigation breadcrumb** — a bounded, most-recent-first ring of
///      five route names, stamped as a JSON array `nav_screens` on **every**
///      analytics event.
///
/// Does NOT fire Segment `*_viewed` events — those stay explicit in Blocs.
@lazySingleton
class AppNavigationObserver extends NavigatorObserver {
  AppNavigationObserver(this._orderAttribution, this._launchTimer);

  final OrderAttributionHelper _orderAttribution;
  final LaunchTimer _launchTimer;

  // Looked up lazily to break a DI cycle: HomeTrackAnalyticManager depends
  // on AnalyticsHelper which depends on this observer.
  HomeTrackAnalyticManager get _homeTrack => sl<HomeTrackAnalyticManager>();

  static const String _lpRoute = RouteNames.landingPageName;
  static const String _splashRoute = RouteNames.splashName;
  static const int _maxStackEntries = 5;

  /// Route names that resolve to a shell tab. If `didPop`'s previousRoute
  /// carries one of these (as opposed to a null-name shell page), treat
  /// it the same as "back on shell" so the funnel/attribution reset
  /// still fires. Defensive against GoRouter versions that name the shell
  /// branch page instead of leaving it anonymous.
  static const Set<String> _shellBranchRoutes = {
    RouteNames.homeName,
    RouteNames.categoriesName,
    RouteNames.accountName,
  };

  /// Out-of-shell funnel routes. Shell tabs (Discover/Categories/Account)
  /// don't push a named route on switch — [setActiveFunnel] drives those.
  static const Map<String, String> _funnelRoutes = {
    RouteNames.cartName: FromScreens.shoppingCart,
    RouteNames.searchName: FromScreens.searchResult,
  };

  /// Route name → analytics-friendly screen label. Only routes present in
  /// this map contribute an entry to `nav_screens`. Shell-branch routes
  /// are deliberately excluded — the Dashboard publishes those via
  /// [setActiveFunnel] to avoid duplicate entries between the branch
  /// push and the tab-switch signal.
  static const Map<String, String> _routeToScreenLabel = {
    RouteNames.splashName: FromScreens.splash,
    RouteNames.landingPageName: FromScreens.landingPage,
    RouteNames.cartName: FromScreens.shoppingCart,
    RouteNames.searchName: FromScreens.searchResult,
    RouteNames.plpName: FromScreens.plp,
    RouteNames.pdpName: FromScreens.product,
  };

  /// Bounded FIFO ring of route names, oldest → newest. Emitted as the
  /// `nav_screens` array on every event (most-recent first).
  final ListQueue<String> _screenStack = ListQueue<String>(_maxStackEntries);

  /// LP visit stack — one entry per live `landingPage` route on the
  /// Navigator. Top holds the currently visible LP's identity.
  final List<_LpContext> _lpContextStack = <_LpContext>[];

  /// Whichever shell tab is currently active — the target we restore to
  /// when a pushed route pops back to the shell. `Dashboard` publishes it.
  String _currentShellFunnel = FromScreens.discover;

  String? _currentRoute;
  String? get currentRoute => _currentRoute;

  /// Fires every time a funnel context is (re)applied — funnel push, back
  /// to shell, or tab switch. Consumers (e.g. `DiscoverPage`) use this to
  /// re-hydrate the shared tracker's `pageComponents` from their bloc
  /// state, since the tracker is a shared singleton and the outgoing
  /// screen's writes are still sitting on it.
  void Function(String funnel)? onFunnelActivated;

  /// Called by `Dashboard` on initial mount and every tab switch. Applies
  /// the funnel exactly like an out-of-shell funnel push would — clears
  /// trackingMeta + LP deque, sets funnel, sets `fromHomePage` based on
  /// whether we're on Discover.
  void setActiveFunnel(String funnel) {
    _currentShellFunnel = funnel;
    // Flush any pending carousel scrolls from the outgoing tab before we
    // switch attribution — otherwise a scroll queued on Discover would ship
    // stamped with the incoming tab's funnel.
    unawaited(_homeTrack.flushCarouselScrolls());
    _pushScreen(funnel);
    _applyFunnel(funnel);
  }

  /// Called by `LandingPageBloc` once the LP response arrives. Fills the top
  /// LP context entry so downstream events emit `lp_id` / `lp_name`, and
  /// re-writes `extraData` for the immediate follow-up impressions.
  ///
  /// **Does NOT touch attribution.** LP-attribution promotion happens on
  /// tile CLICK inside the LP (via
  /// `OrderAttributionHelper.applyLpPromotion`), not on LP open — matches
  /// Android's `LPAttributionHelper.addLPAttributionData` call sites, all
  /// of which are click handlers.
  void setLandingPageContext({required String? name, required String? id}) {
    if (_lpContextStack.isEmpty) {
      // Defensive — LP bloc emitted before push observer callback. Push a
      // fresh entry so we don't lose the identity.
      _lpContextStack.add(_LpContext());
    }
    final top = _lpContextStack.last
      ..name = name
      ..id = id;
    _homeTrack.extraData = ExtraData(
      fromHomePage: false,
      landingPageName: top.name,
      landingPageId: top.id,
    );
  }

  /// Merged into every analytics event. Emitted as a JSON array so the
  /// downstream analytics destinations get one property, not five.
  Map<String, Object?> get navigationTrackerParams {
    if (_screenStack.isEmpty) return const <String, Object?>{};
    return <String, Object?>{
      AnalyticsProperties.navScreens:
          _screenStack.toList().reversed.toList(growable: false),
    };
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // Screen-level events only. Dialogs, modal bottom sheets, snackbars,
    // and route transitions (which are PopupRoute / DialogRoute — NOT
    // PageRoute) must NOT trigger funnel/attribution reset.
    if (route is! PageRoute) return;
    _logDebug('push', route);
    unawaited(_homeTrack.flushCarouselScrolls());
    final name = route.settings.name;
    // Unrecognized nameless PageRoute — a Talker debug page, an ad-hoc
    // `Navigator.push(MaterialPageRoute(...))` somewhere, etc. Do NOT
    // apply funnel here: it's a fullscreen push we know nothing about;
    // treating it as "back to shell" would wipe attribution + swap the
    // tracker's pageComponents via the Discover funnel callback.
    if (name == null) return;
    if (name == _splashRoute) {
      // Cold start / logout re-entry — wipe the trail so the next session
      // starts clean.
      _screenStack.clear();
      _lpContextStack.clear();
    } else {
      // First non-splash route commits to the Navigator — Android's
      // `Activity.onCreate` equivalent. LaunchTimer.logTtl is idempotent
      // (first push wins; subsequent screen pushes during the same cold
      // start don't overwrite) and self-guards on _isStopped.
      _launchTimer.logTtl();
      if (name == _lpRoute) {
        _lpContextStack.add(_LpContext());
      }
    }
    _onActive(name);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route is! PageRoute) return;
    _logDebug('pop', route);
    unawaited(_homeTrack.flushCarouselScrolls());
    if (route.settings.name == _lpRoute && _lpContextStack.isNotEmpty) {
      _lpContextStack.removeLast();
    }
    _onPopBack(previousRoute?.settings.name);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute is! PageRoute) return;
    _logDebug('replace', newRoute);
    // A replace surfaces `newRoute` — same shell-resurface semantics as pop.
    _onPopBack(newRoute.settings.name);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route is! PageRoute) return;
    _logDebug('remove', route);
    _onPopBack(previousRoute?.settings.name);
  }

  // ─── internals ─────────────────────────────────────────────────────

  /// Handle "surfacing back to this route" events (didPop's previousRoute,
  /// didReplace's newRoute, didRemove's previousRoute). A null name here
  /// means the underlying shell just surfaced — reapply the active shell
  /// funnel. On push, use [_onActive] directly.
  void _onPopBack(String? name) {
    if (name == null || _shellBranchRoutes.contains(name)) {
      _currentRoute = name;
      _applyFunnel(_currentShellFunnel);
      return;
    }
    _onActive(name);
  }

  void _onActive(String? name) {
    _currentRoute = name;
    if (name == null) return; // guarded above by callers

    // Only push screen-level routes to the nav trail. Technical routes
    // (PDP/PLP/checkout/orders/…) and shell branches are skipped.
    final label = _routeToScreenLabel[name];
    if (label != null) _pushScreen(label);

    if (name == _lpRoute) {
      // Restore LP identity from the top of the LP stack. On fresh push
      // the top is empty (nulls) and the bloc fills it via
      // setLandingPageContext once the response lands.
      final top = _lpContextStack.isNotEmpty ? _lpContextStack.last : null;
      _homeTrack.extraData = ExtraData(
        fromHomePage: false,
        landingPageName: top?.name,
        landingPageId: top?.id,
      );
      // Reset visibility bookkeeping so LP resume (pop-back from a route
      // that overlaid the LP — Talker, PLP, PDP, another LP, …) re-fires
      // impressions on the next VisibilityDetector callback.
      _homeTrack.resetVisibilityState();
      return;
    }

    final funnel = _funnelRoutes[name];
    if (funnel != null) {
      _applyFunnel(funnel);
      return;
    }
    // Non-funnel pushed route (PDP, PLP, checkout, …) — inherit whatever
    // context the previous screen owned. Attribution accumulates via
    // logTileClick.
  }

  void _applyFunnel(String funnel) {
    // Two-store attribution:
    //   • OrderAttribution: `setFunnel` updates funnel identity only —
    //     HP click trackingMeta persists across funnel switch (matches
    //     Android null-preserves-fields behavior).
    //   • LpAttribution: `clearLpAttribution` wipes the LP click deque
    //     (matches Android `CollectionsFragment.onResume`).
    unawaited(_orderAttribution.setFunnel(funnel));
    unawaited(_homeTrack.clearLpAttribution());
    // Wipe the previous screen's visible-set / scroll snapshots so the
    // incoming screen re-fires impressions from a clean slate. Preserves
    // pageComponents — the callback below hydrates them.
    _homeTrack.resetVisibilityState();
    _homeTrack.extraData = ExtraData(
      fromHomePage: funnel == FromScreens.discover,
    );
    onFunnelActivated?.call(funnel);
  }

  void _pushScreen(String name) {
    if (_screenStack.isNotEmpty && _screenStack.last == name) return;
    _screenStack.addLast(name);
    while (_screenStack.length > _maxStackEntries) {
      _screenStack.removeFirst();
    }
  }

  void _logDebug(String verb, Route<dynamic>? route) {
    if (!kDebugMode) return;
    final name = route?.settings.name ?? '<unnamed>';
    debugPrint('[nav] $verb → $name');
  }
}

class _LpContext {
  String? name;
  String? id;
}
