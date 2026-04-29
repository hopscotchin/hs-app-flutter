import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// Mixin that mimics Android's `onResume()` behavior for pages inside
/// a [StatefulShellRoute.indexedStack].
///
/// Fires [onRouteResume] whenever the GoRouter location transitions
/// **to** [routePath] — covering both bottom-nav tab switches and
/// pop-backs from pushed routes (PDP, PLP, WebView, etc.).
///
/// Usage:
/// ```dart
/// class _CartPageState extends State<CartPage> with RouteRefreshMixin {
///   @override
///   String get routePath => '/cart';
///
///   @override
///   void onRouteResume() {
///     context.read<CartBloc>().add(const RefreshCart());
///   }
/// }
/// ```
mixin RouteRefreshMixin<T extends StatefulWidget> on State<T> {
  /// The route path this page responds to (e.g. `/cart`, `/home`, `/account`).
  String get routePath;

  /// Called each time the page becomes the active route.
  void onRouteResume();

  GoRouteInformationProvider? _routeInfoProvider;
  bool _wasActive = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final router = GoRouter.of(context);
    final provider = router.routeInformationProvider;
    if (_routeInfoProvider != provider) {
      _routeInfoProvider?.removeListener(_onRouteChange);
      _routeInfoProvider = provider;
      _routeInfoProvider!.addListener(_onRouteChange);
      // Seed with the current location so the first real transition is detected.
      _wasActive = provider.value.uri.path == routePath;
    }
  }

  void _onRouteChange() {
    final location = _routeInfoProvider?.value.uri.path ?? '';
    final isActive = location == routePath;
    if (isActive && !_wasActive) {
      onRouteResume();
    }
    _wasActive = isActive;
  }

  @override
  void dispose() {
    _routeInfoProvider?.removeListener(_onRouteChange);
    super.dispose();
  }
}
