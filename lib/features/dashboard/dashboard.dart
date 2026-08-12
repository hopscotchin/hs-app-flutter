import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hs_app_flutter/components/spring/spring_bottom_nav_bar.dart';
import 'package:hs_app_flutter/core/analytics/constants/funnel.dart';
import 'package:hs_app_flutter/core/analytics/home/home_track_analytic_manager.dart';
import 'package:hs_app_flutter/core/analytics/state/checkout_timer.dart';
import 'package:hs_app_flutter/core/constants/image_constants.dart';
import 'package:hs_app_flutter/core/constants/strings/auto_test_strings.dart';
import 'package:hs_app_flutter/core/di/injection.dart';
import 'package:hs_app_flutter/core/router/navigation_observer.dart';
import 'package:hs_app_flutter/features/account/presentation/bloc/account_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/colors.dart';
import '../../core/constants/strings/discover_strings.dart';

class DashboardPage extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const DashboardPage({super.key, required this.navigationShell});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with WidgetsBindingObserver {
  static const double _navHeight = 64;
  static const double _navTileRadius = 18;
  static const double _navIconSize = 18;
  static const double _bottomInsetFallback = 16;

  /// Window within which a second back press exits the app.
  static const Duration _kBackPressInterval = Duration(milliseconds: 6000);

  /// How long the "press back again to exit" snackbar is visible. The
  /// confirmation window outlives the snackbar — same as Android's
  /// TOAST_SHORT vs BACK_PRESS_INTERVAL split.
  static const Duration _kBackSnackDuration = Duration(seconds: 2);
  static const int _kDiscoverNavIndex = 0;
  static const Offset _kHiddenOffset = Offset(0, 1.4);

  // Pre-built once: `BorderRadius.circular` allocates per call; the spring
  // animation pumps `tileDecoration` every frame. Hoisting to a const avoids
  // an allocation per nav-bar tile per frame.
  static const BorderRadius _tileBorderRadius = BorderRadius.all(Radius.circular(_navTileRadius));

  // Nav-bar items never change after construction — build the list once
  // (lazy on first access) instead of allocating four NavBarItem + four
  // closure objects on every Scaffold rebuild.
  late final List<NavBarItem> _navItems = [
    _navItem(ImageConstants.discover, 'Home', DashboardTestStrings.dashboardHomeNavItem),
    _navItem(ImageConstants.categories, 'Categories', DashboardTestStrings.dashboardCategoriesNavItem),
    _navItem(ImageConstants.search, 'Search', DashboardTestStrings.dashboardSearchNavItem),
    _navItem(ImageConstants.profile, 'Account', DashboardTestStrings.dashboardAccountNavItem),
  ];

  late int _navIndex;
  final ValueNotifier<bool> _navVisible = ValueNotifier<bool>(true);

  int _backPressCount = 2;
  DateTime? _lastBackPressedAt;

  @override
  void initState() {
    super.initState();
    _navIndex = _branchToNavIndex(widget.navigationShell.currentIndex);
    WidgetsBinding.instance.addObserver(this);
    // Publish the initial funnel so the nav observer knows what to restore
    // to when a pushed route (LP/PDP/cart/…) later pops back to the shell.
    _publishCurrentFunnel(_navIndex);
  }

  void _publishCurrentFunnel(int navIndex) {
    final funnel = _funnelForNavIndex(navIndex);
    if (funnel != null) sl<AppNavigationObserver>().setShellFunnel(funnel);
  }

  @override
  void didUpdateWidget(DashboardPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // External branch change (deep link, state restore) that doesn't correspond
    // to our current nav selection — resync. Local taps don't trigger this
    // because `_navToBranchIndex(_navIndex)` already matches the new branch.
    final branch = widget.navigationShell.currentIndex;
    if (branch != _navToBranchIndex(_navIndex)) {
      _navIndex = _branchToNavIndex(branch);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _navVisible.dispose();
    super.dispose();
  }

  void _flushCarouselScrolls() {
    unawaited(sl<HomeTrackAnalyticManager>().flushCarouselScrolls());
  }

  /// Map nav-bar index → [Funnel]. Nav 2 & 3 currently mirrors Categories —
  /// Search opens as a pushed route from within Categories, so the observer
  /// handles its funnel on `didPush` — Dashboard skips it here.
  Funnel? _funnelForNavIndex(int navIndex) => switch (navIndex) {
    0 => Funnel.discover,
    1 => Funnel.categories,
    2 => Funnel.categories,
    3 => Funnel.account,
    _ => null,
  };

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Accumulate the just-finished background stint onto the checkout
      // funnel's `background_time`. Guarded inside CheckoutTimer against
      // a stray resume with no prior pause.
      sl<CheckoutTimer>().setBackgroundEnd();
      _onTabResume(context, _navIndex);
    } else if (state == AppLifecycleState.paused) {
      // Anchor pause start for checkout funnel `background_time`.
      sl<CheckoutTimer>().setBackgroundStart();
      if (_navIndex == _kDiscoverNavIndex) _flushCarouselScrolls();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = Platform.isIOS
        ? _bottomInsetFallback
        : MediaQuery.viewPaddingOf(context).bottom;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppTheme.systemUiLight,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (didPop) return;
          _handleBackPress();
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          extendBody: true,
          bottomNavigationBar: ValueListenableBuilder<bool>(
            valueListenable: _navVisible,
            child: Padding(
              padding: EdgeInsets.only(bottom: bottomInset),
              child: SpringBottomNavBar(
                items: _navItems,
                initialIndex: _navIndex,
                height: _navHeight,
                backgroundColor: Colors.transparent,
                activeColor: AppColors.brandDefault,
                inactiveColor: AppColors.secondaryInActive,
                tileDecoration: _tileDecoration,
                onTabSelected: _onTabSelected,
              ),
            ),
            builder: (_, visible, child) => AnimatedSlide(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeInOut,
              offset: visible ? Offset.zero : _kHiddenOffset,
              child: child,
            ),
          ),
          body: NotificationListener<UserScrollNotification>(
            onNotification: _onUserScroll,
            child: widget.navigationShell,
          ),
        ),
      ),
    );
  }

  bool _onUserScroll(UserScrollNotification n) {
    if (_navIndex != _kDiscoverNavIndex) return false;
    // Ignore horizontal scrollables (carousels) — they shouldn't drive
    // the vertical nav-bar slide.
    if (n.metrics.axis != Axis.vertical) return false;
    if (n.direction == ScrollDirection.reverse && _navVisible.value) {
      _navVisible.value = false;
    } else if (n.direction == ScrollDirection.forward && !_navVisible.value) {
      _navVisible.value = true;
    }
    return false;
  }

  void _handleBackPress() {
    final now = DateTime.now();
    if (_lastBackPressedAt != null && now.difference(_lastBackPressedAt!) > _kBackPressInterval) {
      _backPressCount = 2;
    }

    if (_backPressCount >= 2) {
      _lastBackPressedAt = now;
      _backPressCount--;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text(DiscoverStrings.backButtonHit),
            duration: _kBackSnackDuration,
          ),
        );
      return;
    }
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    SystemNavigator.pop();
  }

  NavBarItem _navItem(String asset, String label, String testKey) => NavBarItem(
    buildIcon: (_, color, _) => SvgPicture.asset(
      asset,
      width: _navIconSize,
      height: _navIconSize,
      // ColorFilter implements value equality, so identical colors short-circuit
      // the SVG re-paint.
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    ),
    label: label,
    tileKey: ValueKey(testKey),
  );

  // withOpacity keeps RGB fixed at the light lavender; only alpha changes.
  // Color.lerp(transparent, ...) would lerp from black RGB, causing a grey
  // cast at mid-transition values.
  BoxDecoration _tileDecoration(double expansion) => BoxDecoration(
    color: AppColors.secondaryExtra.withValues(alpha: expansion),
    borderRadius: _tileBorderRadius,
  );

  void _onTabSelected(int navIndex) {
    setState(() => _navIndex = navIndex);
    // Reset bar visibility through the notifier so the AnimatedSlide rebuild
    // is isolated from the Dashboard tree rebuild driven by the setState.
    _navVisible.value = true;
    _onTabResume(context, navIndex);
    // Publish the new funnel — the observer flushes pending carousel scrolls
    // and clears LP attribution as part of applying it, so no explicit calls
    // are needed here.
    _publishCurrentFunnel(navIndex);
    final branchIndex = _navToBranchIndex(navIndex);
    widget.navigationShell.goBranch(
      branchIndex,
      initialLocation: branchIndex == widget.navigationShell.currentIndex,
    );
  }

  /// Nav bar has 4 items but the shell only has 3 branches.
  /// Search (nav 2) re-uses the Categories branch (1).
  int _navToBranchIndex(int navIndex) => switch (navIndex) {
    2 => 1, // Search → Categories branch
    3 => 2, // Account
    _ => navIndex, // Home(0), Categories(1) map 1:1
  };

  /// Inverse mapping used to initialise the nav bar highlight from the
  /// router's current branch index after a deep link or app-resume.
  int _branchToNavIndex(int branchIndex) => switch (branchIndex) {
    2 => 3, // Account branch → nav item 3
    _ => branchIndex, // 0 and 1 map 1:1
  };

  /// Called both from the nav bar tap (nav index) and from [didChangeAppLifecycleState]
  /// (branch index). Pass nav index — use [_branchToNavIndex] at call sites
  /// that only have a branch index.
  void _onTabResume(BuildContext context, int navIndex) {
    if (navIndex == 3) {
      context.read<AccountBloc>().add(const LoadAccount());
    }
  }
}
