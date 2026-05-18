import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hs_app_flutter/core/constants/image_constants.dart';
import 'package:hs_app_flutter/core/theme/typography/text_style_extensions.dart';

import '../../../../components/atoms/badge_icon.dart';
import '../../../../components/atoms/cached_image_widget.dart';
import '../../../../components/spring/spring_tab_bar.dart';
import '../../../../core/constants/strings/discover_strings.dart';
import '../../../../core/cubits/cart_count_cubit.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/app_navigator.dart';
import '../../../../core/services/pref_manager.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/typography/typography_v1.dart';

class CombinedHeaderDelegate extends SliverPersistentHeaderDelegate {
  const CombinedHeaderDelegate({
    required this.items,
    required this.initialIndex,
    required this.onTabSelected,
    required this.toolbarHeight,
    required this.tabsHeight,
    this.bgImageUrl,
    this.isImageDark = false,
  });

  final List<SpringTabItem> items;
  final int initialIndex;
  final ValueChanged<int> onTabSelected;
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
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0x08000000)),
                ),
              ),
              child: SpringTabBar(
                items: items,
                initialIndex: initialIndex,
                onTabSelected: onTabSelected,
                backgroundColor: Colors.transparent,
                isImageDark: isImageDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(CombinedHeaderDelegate old) =>
      old.bgImageUrl != bgImageUrl || old.isImageDark != isImageDark;
}

class _AppBarContent extends StatelessWidget {
  const _AppBarContent({this.isImageDark = false});

  final bool isImageDark;

  @override
  Widget build(BuildContext context) {
    final color = isImageDark ? Colors.white : null;
    final svgFilter = isImageDark
        ? const ColorFilter.mode(Colors.white, BlendMode.srcIn)
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
          Text(
            DiscoverStrings.hiGreeting(sl<PrefManager>().firstName),
            style: AppTypographyV1.titleSmall.brand().bold.copyWith(color: color),
          ),
          const SizedBox(width: 18),
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
