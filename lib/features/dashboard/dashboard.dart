import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hs_app_flutter/components/spring/spring_bottom_nav_bar.dart';
import 'package:hs_app_flutter/core/constants/image_constants.dart';
import 'package:hs_app_flutter/features/account/presentation/bloc/account_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/colors.dart';

class DashboardPage extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const DashboardPage({super.key, required this.navigationShell});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with WidgetsBindingObserver {
  static const double _navHeight = 60;
  static const double _navTileRadius = 22;
  static const double _navIconSize = 18;
  static const double _bottomInsetFallback = 16;

  // Pre-built once: `BorderRadius.circular` allocates per call; the spring
  // animation pumps `tileDecoration` every frame. Hoisting to a const avoids
  // an allocation per nav-bar tile per frame.
  static const BorderRadius _tileBorderRadius = BorderRadius.all(
    Radius.circular(_navTileRadius),
  );

  // Nav-bar items never change after construction — build the list once
  // (lazy on first access) instead of allocating four NavBarItem + four
  // closure objects on every Scaffold rebuild.
  late final List<NavBarItem> _navItems = [
    _navItem(ImageConstants.discover, 'Home'),
    _navItem(ImageConstants.categories, 'Categories'),
    _navItem(ImageConstants.search, 'Search'),
    _navItem(ImageConstants.profile, 'Account'),
  ];

  late int _navIndex;

  @override
  void initState() {
    super.initState();
    _navIndex = _branchToNavIndex(widget.navigationShell.currentIndex);
    WidgetsBinding.instance.addObserver(this);
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
    super.dispose();
  }

  // DateTime? _lastResumedTime;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // if (state == AppLifecycleState.resumed) {
    //   final now = DateTime.now();

    //   if (_lastResumedTime == null ||
    //       now.difference(_lastResumedTime!) > const Duration(seconds: 5)) {
    //     final currentIndex = widget.navigationShell.currentIndex;
    //     _onTabResume(context, currentIndex);

    //     _lastResumedTime = now;
    //   }
    // }

    // below is enough if we don;t want to limit the refresh frequency, but it may cause too many refreshes when user switch between apps quickly

    if (state == AppLifecycleState.resumed) {
      _onTabResume(context, _navIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = Platform.isIOS
        ? _bottomInsetFallback
        : MediaQuery.viewPaddingOf(context).bottom;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppTheme.systemUiLight,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        extendBody: true,
        bottomNavigationBar: Padding(
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
        body: widget.navigationShell,
      ),
    );
  }

  NavBarItem _navItem(String asset, String label) => NavBarItem(
    buildIcon: (_, color, _) => SvgPicture.asset(
      asset,
      width: _navIconSize,
      height: _navIconSize,
      // ColorFilter implements value equality, so identical colors short-circuit
      // the SVG re-paint.
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    ),
    label: label,
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
    _onTabResume(context, navIndex);
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
