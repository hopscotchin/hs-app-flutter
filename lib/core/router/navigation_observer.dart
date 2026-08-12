import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

import '../analytics/attribution/attribution_data.dart';
import '../analytics/attribution/order_attribution_helper.dart';
import '../analytics/constants/analytics_defaults.dart';
import '../analytics/constants/analytics_properties.dart';
import '../analytics/constants/funnel.dart';
import '../analytics/home/home_track_analytic_manager.dart';
import '../analytics/state/launch_timer.dart';
import '../constants/route_names.dart';
import '../di/injection.dart';

/// Route observer that owns *all* navigation-driven analytics state:
///
///   1. **Funnel switching** — entering a funnel-owning screen wipes the
///      OrderAttribution slice, wipes the LP attribution deque, and pins
///      `funnel` to the new value. Two entry paths:
///        * Out-of-shell funnel routes (`cart`, `search`) — handled by
///          [didPush], which consults [_funnelRoutes] to map the pushed
///          route name to a [Funnel].
///        * Shell tabs (Discover, Categories, Account) — handled by
///          [setShellFunnel] called from `Dashboard` on tab select /
///          initial mount, because `StatefulShellRoute.indexedStack` swaps
///          child widgets *without* pushing named routes through observers.
///   2. **LP context stack** — each `landingPage` push adds a fresh entry.
///      `LandingPageBloc.setLandingPageContext` fills its top's id/name once
///      the response arrives. On pop, the entry is removed and the new top
///      (if any) is reapplied so LP2 → back → LP1 restores LP1's identity
///      without any per-bloc resume hook.
///   3. **Automatic back-to-shell restore** — a pop that leaves us
///      underneath the shell (previousRoute nameless or one of the shell
///      branches) reapplies whichever [Funnel] the Dashboard last declared
///      active via [setShellFunnel].
///   4. **Navigation breadcrumb** — a bounded, most-recent-first ring of
///      five route names, stamped as a JSON array `nav_screens` on **every**
///      analytics event.
///   5. **LIFO attribution restore** — each `_funnelRoutes` push snapshots
///      the current [AttributionData] BEFORE the wipe; the matching pop
///      restores it. Fixes `PLP → Search → back → PLP → PDP`: without the
///      restore, the Search push would clear the HP click context and the
///      PDP click on the resurfaced PLP would ship without HP attribution.
///      `setShellFunnel` clears the stack (tab-switch is explicit intent,
///      not a resume).
///
/// A single private worker — [_applyFunnel] — runs every funnel transition:
/// it delegates to `OrderAttributionHelper.setFunnel`, wipes the LP deque,
/// resets visibility bookkeeping, updates the tracker's [ExtraData], and
/// notifies [onFunnelActivated] listeners.
///
/// Two callers reach it:
///   * [setShellFunnel] — public. Called by `Dashboard` on tab tap. Also
///     updates [_currentShellFunnel] (the "which shell tab am I on?"
///     memory used by back-to-shell restore).
///   * [_onActive] — private. Called from [didPush] for `cart` / `search`
///     etc. — leaves [_currentShellFunnel] alone since the shell tab
///     didn't actually change.
///
/// The old `setActiveFunnel(String)` API has been renamed to
/// [setShellFunnel] with the [Funnel] type for stricter call-site checks
/// and to distinguish "declare shell tab" from "apply funnel side-effects".
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

  /// Route names that resolve to a shell tab, mapped to their [Funnel].
  /// Used both to detect "back to shell" pops (previousRoute is one of
  /// these names) and — if we ever needed it — to answer "which funnel
  /// is that shell branch". `StatefulShellRoute` versions that name the
  /// shell branch page instead of leaving it nameless are handled here.
  static const Map<String, Funnel> _shellBranchToFunnel = {
    RouteNames.homeName: Funnel.discover,
    RouteNames.categoriesName: Funnel.categories,
    RouteNames.accountName: Funnel.account,
  };

  /// Out-of-shell funnel routes pushed via `context.pushNamed`. Shell tabs
  /// don't push a named route on switch — [setShellFunnel] drives those.
  static const Map<String, Funnel> _funnelRoutes = {
    RouteNames.cartName: Funnel.cart,
    RouteNames.searchName: Funnel.search,
  };

  /// Route name → analytics-friendly screen label. Only routes present in
  /// this map contribute an entry to `nav_screens`. Shell-branch routes
  /// are deliberately excluded — the Dashboard publishes those via
  /// [setShellFunnel] to avoid duplicate entries between the branch push
  /// and the tab-switch signal.
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

  /// Route-scoped [AttributionData] snapshots — one entry per live
  /// [_funnelRoutes] push on the Navigator. Top holds the pre-push state
  /// of the topmost funnel route. Popped and restored to
  /// [OrderAttributionHelper] on pop/remove of the matching route. See
  /// the class docstring for the flagship scenario.
  final List<AttributionData?> _attributionSnapshotStack =
      <AttributionData?>[];

  /// Whichever shell tab is currently active — the target we restore to
  /// when a pushed route pops back to the shell. Written by
  /// [setShellFunnel] from the Dashboard.
  Funnel _currentShellFunnel = Funnel.discover;

  String? _currentRoute;
  String? get currentRoute => _currentRoute;

  /// Fires every time a funnel is (re)applied — shell tab switch, back to
  /// shell, or out-of-shell funnel push. Consumers (e.g. `DiscoverPage`)
  /// use this to re-hydrate the shared tracker's `pageComponents` and
  /// re-seed the sortbar from their local tab-selection state.
  void Function(Funnel funnel)? onFunnelActivated;

  /// Called by `Dashboard` on initial mount and every tab switch — this is
  /// how the shell-tab funnel becomes known to the observer. Updates
  /// [_currentShellFunnel] (the back-to-shell restore target) AND runs the
  /// funnel-transition side-effects via [_applyFunnel].
  void setShellFunnel(Funnel funnel) {
    _currentShellFunnel = funnel;
    // Tab switch is an explicit context change — the user isn't intending
    // to resume any pushed funnel route, so drop any pending snapshots.
    // GoRouter typically pops pushed routes when a tab switches; if a
    // stale `didPop` fires after this, the empty stack just no-ops.
    _attributionSnapshotStack.clear();
    // Flush any pending carousel scrolls from the outgoing tab before we
    // switch attribution — otherwise a scroll queued on Discover would
    // ship stamped with the incoming tab's funnel.
    unawaited(_homeTrack.flushCarouselScrolls());
    _pushScreen(funnel.wire);
    _applyFunnel(funnel);
  }

  /// Called by `LandingPageBloc` once the LP response arrives. Fills the
  /// top LP context entry so downstream events emit `lp_id` / `lp_name`,
  /// and re-writes `extraData` for the immediate follow-up impressions.
  ///
  /// **Does NOT touch attribution.** LP-attribution promotion happens on
  /// tile CLICK inside the LP, not on LP open — matches Android's
  /// `LPAttributionHelper.addLPAttributionData` call sites, all of which
  /// are click handlers.
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
      _attributionSnapshotStack.clear();
    } else {
      // First non-splash route commits to the Navigator — Android's
      // `Activity.onCreate` equivalent. LaunchTimer.logTtl is idempotent
      // (first push wins; subsequent screen pushes during the same cold
      // start don't overwrite) and self-guards on _isStopped.
      _launchTimer.logTtl();
      if (name == _lpRoute) {
        _lpContextStack.add(_LpContext());
      }
      // Snapshot BEFORE `_onActive` fires — otherwise the funnel-switch
      // wipe inside `_applyFunnel` overwrites the state we want to save.
      if (_funnelRoutes.containsKey(name)) {
        _attributionSnapshotStack.add(_orderAttribution.getCurrent());
      }
    }
    _onActive(name);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route is! PageRoute) return;
    _logDebug('pop', route);
    unawaited(_homeTrack.flushCarouselScrolls());
    final name = route.settings.name;
    if (name == _lpRoute && _lpContextStack.isNotEmpty) {
      _lpContextStack.removeLast();
    }
    _restoreAttributionIfFunnelRoute(name);
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
    _restoreAttributionIfFunnelRoute(route.settings.name);
    _onPopBack(previousRoute?.settings.name);
  }

  // ─── internals ─────────────────────────────────────────────────────

  /// Handle "surfacing back to this route" events (didPop's previousRoute,
  /// didReplace's newRoute, didRemove's previousRoute). A null name here
  /// means the underlying shell just surfaced — reapply the active shell
  /// funnel. On push, use [_onActive] directly.
  void _onPopBack(String? name) {
    if (name == null || _shellBranchToFunnel.containsKey(name)) {
      _currentRoute = name;
      // Record the back-to-shell in the nav breadcrumb so `nav_screens`
      // reflects the return trip. Dedupe (`_pushScreen`) skips the append
      // if the trail already ends on the same funnel, so a shell → shell
      // no-op won't duplicate.
      _pushScreen(_currentShellFunnel.wire);
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

  /// Run the funnel-transition side-effects. Called by [setShellFunnel]
  /// (tab switch), [_onPopBack] (back-to-shell), and [_onActive] (funnel-
  /// owning route push).
  ///
  ///   • `OrderAttributionHelper.setFunnel` — resets HP slice, keeps only
  ///     the new funnel (see helper docstring).
  ///   • `_homeTrack.clearLpAttribution` — wipes the LP click deque.
  ///   • `_homeTrack.resetVisibilityState` — clears per-screen scroll /
  ///     visible-set bookkeeping so the incoming screen re-fires
  ///     impressions from a clean slate.
  ///   • `_homeTrack.extraData` — sets `fromHomePage` per funnel identity.
  ///   • `onFunnelActivated` — hooks for screens that need to hydrate on
  ///     activation (DiscoverPage re-loads pageComponents + sortbar).
  void _applyFunnel(Funnel funnel) {
    _orderAttribution.setFunnel(funnel);
    _homeTrack.clearLpAttribution();
    _homeTrack.resetVisibilityState();
    _homeTrack.extraData = ExtraData(
      fromHomePage: funnel == Funnel.discover,
    );
    onFunnelActivated?.call(funnel);
  }

  /// Pop the top attribution snapshot and restore it. Called from
  /// `didPop` / `didRemove` when the outgoing route is a funnel-owning
  /// push (see [_funnelRoutes]).
  ///
  /// The restore happens BEFORE `_onPopBack` so that a subsequent
  /// `_applyFunnel(_currentShellFunnel)` triggered by a back-to-shell
  /// finds the funnel already matching (setFunnel early-returns) and
  /// preserves the restored `trackingMeta` / `sortBar`.
  void _restoreAttributionIfFunnelRoute(String? name) {
    if (name == null || !_funnelRoutes.containsKey(name)) return;
    if (_attributionSnapshotStack.isEmpty) return;
    _orderAttribution.restore(_attributionSnapshotStack.removeLast());
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
