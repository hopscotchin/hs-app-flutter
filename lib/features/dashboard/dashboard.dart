import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hs_app_flutter/components/spring/spring_bottom_nav_bar.dart';
import 'package:hs_app_flutter/core/constants/image_constants.dart';
import 'package:hs_app_flutter/features/account/presentation/bloc/account_bloc.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';

class DashboardPage extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const DashboardPage({super.key, required this.navigationShell});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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
      _onTabResume(context, _branchToNavIndex(widget.navigationShell.currentIndex));
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = _buildNavItems(context);

    return MediaQuery.removePadding(
      context: context,
      removeBottom: true,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            widget.navigationShell,
            Positioned(
              left: 0,
              right: 0,
              bottom: 16,
              child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
              child: Container(
                height: 64,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: AppColors.baseDefault,
                  borderRadius: BorderRadius.circular(24),
                  border: BoxBorder.all(color: AppColors.neutralGrey1, width: 1),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1A000000),
                      blurRadius: 16,
                      offset: Offset(2, 8),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(AppSpacing.xxs),
                child: SpringBottomNavBar(
                  items: items,
                  initialIndex: _branchToNavIndex(widget.navigationShell.currentIndex),
                  height: 60,
                  backgroundColor: Colors.transparent,
                  activeColor: AppColors.brandDefault,
                  inactiveColor: AppColors.secondaryInActive,
                  tileDecoration: (e) => BoxDecoration(
                    // withOpacity keeps RGB fixed at the light lavender; only alpha
                    // changes. Color.lerp(transparent, ...) would lerp from black RGB
                    // causing a grey cast at mid-transition values.
                    color: AppColors.secondaryExtra.withValues(alpha: e),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  onTabSelected: (navIndex) {
                    _onTabResume(context, navIndex);
                    final branchIndex = _navToBranchIndex(navIndex);
                    widget.navigationShell.goBranch(
                      branchIndex,
                      initialLocation: branchIndex == widget.navigationShell.currentIndex,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }

  List<NavBarItem> _buildNavItems(BuildContext context) => [
        NavBarItem(
          buildIcon: (_, color, _) => SvgPicture.asset(
            ImageConstants.discover,
            width: 18,
            height: 18,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
          label: 'Home',
        ),
        NavBarItem(
          buildIcon: (_, color, _) => SvgPicture.asset(
            ImageConstants.categories,
            width: 18,
            height: 18,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
          label: 'Categories',
        ),
        NavBarItem(
          buildIcon: (_, color, _) => SvgPicture.asset(
            ImageConstants.search,
            width: 18,
            height: 18,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
          label: 'Search',
        ),
        NavBarItem(
          buildIcon: (_, color, _) => SvgPicture.asset(
            ImageConstants.profile,
            width: 18,
            height: 18,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
          label: 'Account',
        ),
      ];

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
      context.read<AccountBloc>().add(LoadAccount());
    }
  }
}
