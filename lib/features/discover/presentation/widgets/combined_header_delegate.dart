import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hs_app_flutter/core/constants/image_constants.dart';
import 'package:hs_app_flutter/core/theme/typography/text_style_extensions.dart';

import '../../../../components/atoms/badge_icon.dart';
import '../../../../components/atoms/cached_image_widget.dart';
import '../../../../core/constants/strings/discover_strings.dart';
import '../../../../core/cubits/cart_count_cubit.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/app_navigator.dart';
import '../../../../core/services/pref_manager.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/typography/typography_v1.dart';

class CombinedHeaderDelegate extends SliverPersistentHeaderDelegate {
  const CombinedHeaderDelegate({
    required this.labels,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.onTabTapped,
    required this.toolbarHeight,
    required this.tabsHeight,
    this.bgImageUrl,
    this.isImageDark = false,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final VoidCallback onTabTapped;
  final double toolbarHeight;
  final double tabsHeight;
  final String? bgImageUrl;
  final bool isImageDark;

  @override
  double get minExtent => tabsHeight;

  @override
  double get maxExtent => toolbarHeight + tabsHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final t = (shrinkOffset / toolbarHeight).clamp(0.0, 1.0);

    return ClipRect(
      child: Stack(
        children: [
          if (bgImageUrl != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: maxExtent,
              child: CachedImageWidget(imageUrl: bgImageUrl!),
            )
          else
            const Positioned.fill(
              child: ColoredBox(color: AppColors.baseDefault),
            ),
          // Skip the app-bar layer once it's fully collapsed — at t == 1.0 the
          // Opacity would otherwise allocate an offscreen buffer to render a
          // fully-transparent subtree every scroll frame.
          if (t < 1.0)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: toolbarHeight,
              child: Transform.translate(
                offset: Offset(0, -shrinkOffset),
                child: Opacity(
                  opacity: 1.0 - t,
                  child: _AppBarContent(isImageDark: isImageDark),
                ),
              ),
            ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: tabsHeight,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.neutralBlack.withValues(alpha: 0.03),
                  ),
                ),
              ),
              // Reserve the strip height before sortingOptions arrive so the
              // tabs slot doesn't pop into existence and shove content down.
              // RepaintBoundary so the tab strip's paint layer isn't redrawn
              // on every scroll frame (the persistent header rebuilds for the
              // app-bar fade — the tabs themselves don't change with scroll).
              child: labels.isEmpty
                  ? const SizedBox.shrink()
                  : RepaintBoundary(
                      child: _TabsRow(
                        labels: labels,
                        selectedIndex: selectedIndex,
                        onTabSelected: onTabSelected,
                        onTabTapped: onTabTapped,
                        isImageDark: isImageDark,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(CombinedHeaderDelegate old) {
    if (old.bgImageUrl != bgImageUrl) return true;
    if (old.isImageDark != isImageDark) return true;
    if (old.selectedIndex != selectedIndex) return true;
    if (old.labels.length != labels.length) return true;
    for (int i = 0; i < labels.length; i++) {
      if (old.labels[i] != labels[i]) return true;
    }
    return false;
  }
}

class _TabsRow extends StatelessWidget {
  const _TabsRow({
    required this.labels,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.onTabTapped,
    required this.isImageDark,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final VoidCallback onTabTapped;
  final bool isImageDark;

  @override
  Widget build(BuildContext context) {
    final activeFg = isImageDark
        ? AppColors.brandDefault
        : AppColors.textPrimary;
    final inactiveFg = isImageDark
        ? AppColors.secondaryExtra
        : AppColors.neutralGrey5;
    final activeBg = isImageDark
        ? AppColors.baseDefault
        : AppColors.secondaryExtra;

    final clamped = selectedIndex.clamp(0, labels.length - 1);

    // Hoist per-build invariants out of the generate loop so we allocate
    // each style/decoration once instead of per segment.
    final activeStyle = AppTypographyV1.bodyLarge.bold.copyWith(
      color: activeFg,
    );
    final inactiveStyle = AppTypographyV1.bodyLarge.regular.copyWith(
      color: inactiveFg,
    );
    final activePillDecoration = BoxDecoration(
      color: activeBg,
      borderRadius: const BorderRadius.all(Radius.circular(2)),
    );

    // Listener catches every pointer-up — including re-taps on the currently
    // selected segment, which SegmentedButton.onSelectionChanged ignores —
    // so the scroll-to-top affordance still works.
    return Listener(
      onPointerUp: (_) => onTabTapped(),
      child: SegmentedButton<int>(
        segments: List<ButtonSegment<int>>.generate(labels.length, (i) {
          final isSelected = i == clamped;
          return ButtonSegment<int>(
            value: i,
            // Render the pill inside the label so it hugs the text rather than
            // filling the equal-width segment. Centered so the strip reads as
            // a single balanced row.
            label: Align(
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: isSelected ? activePillDecoration : null,
                child: Text(
                  labels[i],
                  style: isSelected ? activeStyle : inactiveStyle,
                ),
              ),
            ),
          );
        }),
        selected: <int>{clamped},
        showSelectedIcon: false,
        expandedInsets: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        onSelectionChanged: (Set<int> selection) {
          if (selection.isNotEmpty) onTabSelected(selection.first);
        },
        style: const ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(AppColors.transparent),
          overlayColor: WidgetStatePropertyAll(AppColors.transparent),
          side: WidgetStatePropertyAll(BorderSide.none),
          shape: WidgetStatePropertyAll(RoundedRectangleBorder()),
          padding: WidgetStatePropertyAll(EdgeInsets.zero),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }
}

class _AppBarContent extends StatelessWidget {
  const _AppBarContent({this.isImageDark = false});

  final bool isImageDark;

  @override
  Widget build(BuildContext context) {
    final svgFilter = isImageDark
        ? const ColorFilter.mode(AppColors.baseDefault, BlendMode.srcIn)
        : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          RepaintBoundary(
            child: SvgPicture.asset(
              ImageConstants.hsLogo,
              height: 50,
              placeholderBuilder: (_) => const SizedBox(height: 46),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {},
            child: RepaintBoundary(
              child: SvgPicture.asset(
                ImageConstants.heart,
                height: 20,
                width: 20,
                colorFilter: svgFilter,
                placeholderBuilder: (_) =>
                    const SizedBox(height: 20, width: 20),
              ),
            ),
          ),
          const SizedBox(width: 18),
          GestureDetector(
            onTap: () => AppNavigator.goToCart(context),
            child: BadgeIcon(
              count: context.watch<CartCountCubit>().state,
              child: SvgPicture.asset(
                ImageConstants.bag,
                height: 20,
                width: 20,
                colorFilter: svgFilter,
                placeholderBuilder: (_) => const SizedBox(height: 20, width: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
