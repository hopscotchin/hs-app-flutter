import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hs_app_flutter/components/atoms/badge_icon.dart';
import 'package:hs_app_flutter/components/atoms/circular_icon_button.dart';
import 'package:hs_app_flutter/components/atoms/custom_image.dart';
import 'package:hs_app_flutter/core/constants/image_constants.dart';
import 'package:hs_app_flutter/core/extensions/string_extensions.dart';
import 'package:hs_app_flutter/core/router/app_navigator.dart';
import 'package:hs_app_flutter/core/theme/theme.dart';
import 'package:hs_app_flutter/core/theme/typography/text_style_extensions.dart';
import 'package:hs_app_flutter/core/theme/typography/typography_v1.dart';

import '../../../../core/cubits/cart_count_cubit.dart';
import '../../domain/entities/banner_entity.dart';
import '../../domain/entities/page_type.dart';
import '../bloc/plp_bloc.dart';

typedef _AppBarData = ({
  int? totalRecords,
  String? screenName,
  String? screenSubtitle,
  BannerEntity? banner,
});

class PlpSliverAppBar extends StatelessWidget {
  final PageType pageType;
  final String title;

  const PlpSliverAppBar({super.key, required this.pageType, required this.title});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PlpBloc, PlpState, _AppBarData>(
      selector: (state) => (
        totalRecords: state.status == PlpStatus.loaded ? state.totalRecords : null,
        screenName: state.screenName,
        screenSubtitle: state.screenSubtitle,
        banner: state.banners.isNotEmpty ? state.banners.first : null,
      ),
      builder: (context, data) {
        final bannerUrl = data.banner?.imageUrl;

        final hasBanner =
            pageType == PageType.boutique && bannerUrl != null && bannerUrl.isNotEmpty;

        final pageTitle = (data.screenName?.isNotEmpty ?? false) ? data.screenName! : title;

        final pageSubtitle = (data.screenSubtitle?.isNotEmpty ?? false) ? data.screenSubtitle! : '';

        if (hasBanner) {
          return PlpSliverHeader(title: pageTitle, subtitle: pageSubtitle, banner: data.banner);
        }

        return _StandardSliverAppBar(title: pageTitle, subtitle: pageSubtitle);
      },
    );
  }
}

/// ─────────────────────────────────────────────────────────
/// STANDARD SLIVER APP BAR
/// ─────────────────────────────────────────────────────────

class _StandardSliverAppBar extends StatelessWidget {
  final String title;
  final String subtitle;

  const _StandardSliverAppBar({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      leading: IconButton(
        icon: const CustomImage(path: ImageConstants.arrowBack, height: 16),
        onPressed: () => Navigator.of(context).pop(),
      ),
      titleSpacing: 5,
      primary: true,
      title: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTypographyV1.bodySmall.bold.textPrimary()),
            if (subtitle.isNotNullOrEmpty) ...[
              Text(subtitle, style: AppTypographyV1.caption.medium.textPrimary()),
            ],
          ],
        ),
      ),
      centerTitle: false,
      pinned: false,
      floating: true,
      snap: true,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      foregroundColor: AppColors.textPrimary,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 60,
      actions: [
        BadgeIcon(
          iconSize: 18,
          icon: const CustomImage(path: ImageConstants.search, width: 20, height: 20),
          onTap: () => AppNavigator.goToSearch(context),
        ),
        BadgeIcon(
          iconSize: 18,
          icon: const CustomImage(path: ImageConstants.heart, width: 20, height: 20),
          count: 0,
          onTap: () {},
          iconColor: AppColors.textPrimary,
        ),
        const SizedBox(width: 3),
        BadgeIcon(
          iconSize: 18,
          icon: const CustomImage(path: ImageConstants.bag, width: 20, height: 20),
          count: context.watch<CartCountCubit>().state,
          onTap: () => AppNavigator.goToCart(context),
          iconColor: AppColors.textPrimary,
        ),
      ],
      actionsPadding: const EdgeInsets.only(right: 12),
    );
  }
}

/// ─────────────────────────────────────────────────────────
/// CUSTOM BANNER HEADER
/// ─────────────────────────────────────────────────────────

class PlpSliverHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final BannerEntity? banner;

  const PlpSliverHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.banner,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _PlpHeaderDelegate(title: title, subtitle: subtitle, banner: banner),
    );
  }
}

class _PlpHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String title;
  final String subtitle;
  final BannerEntity? banner;

  const _PlpHeaderDelegate({required this.title, required this.subtitle, required this.banner});

  static const double _toolbarHeight = kToolbarHeight;
  static const double _expandedHeight = 300;

  @override
  double get minExtent => _toolbarHeight;

  @override
  double get maxExtent => _expandedHeight;

  static const _largeTitleFadeOutStart = 0.50;
  static const _largeTitleFadeOutEnd = 0.60;
  static const _collapsedTitleFadeInStart = 0.60;
  static const _collapsedTitleFadeInEnd = 0.60;

  static const _toolbarFadeStart = 0.62;
  static const _toolbarFadeDuration = 0.38;

  static const _overlayFadeDivider = 0.92;

  static const _safeAreaFadeDuration = 0.08;

  static const _largeTitleScaleReduction = 0.025;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    /// Device safe-area padding (status bar / notch height)
    final topPadding = MediaQuery.paddingOf(context).top;

    /// Header collapse progress:
    /// 0.0 -> fully expanded
    /// 1.0 -> fully collapsed
    final progress = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);

    final largeTitleOpacity = Curves.easeIn.transform(
      ((_largeTitleFadeOutEnd - progress) / (_largeTitleFadeOutEnd - _largeTitleFadeOutStart))
          .clamp(0.0, 1.0),
    );

    final collapsedTitleOpacity = Curves.easeOut.transform(
      ((progress - _collapsedTitleFadeInStart) /
              (_collapsedTitleFadeInEnd - _collapsedTitleFadeInStart))
          .clamp(0.0, 1.0),
    );

    /// Toolbar/safe-area white background transition.
    /// Only fades near the final collapse state.
    final topBackgroundOpacity = Curves.linearToEaseOut.transform(
      ((progress - _toolbarFadeStart) / _toolbarFadeDuration).clamp(0.0, 1.0),
    );

    /// Bottom dark gradient opacity used for large title readability.
    /// Fades out while scrolling upward.
    final overlayOpacity = Curves.easeOut.transform(
      ((1 - progress) / _overlayFadeDivider).clamp(0.0, 1.0),
    );

    /// Prefer banner alt text when available.
    final displayTitle = (banner?.altText?.isNotEmpty ?? false) ? banner!.altText! : title;

    /// Safe-area white background opacity.
    /// Appears only very close to full collapse.
    final safeAreaOpacity = Curves.easeOut.transform(
      ((progress - _overlayFadeDivider) / _safeAreaFadeDuration).clamp(0.0, 1.0),
    );

    return Material(
      color: Colors.transparent,
      child: Stack(
        fit: StackFit.expand,
        children: [
          /// IMAGE
          Positioned.fill(
            child: RepaintBoundary(
              child: CustomImage(path: banner?.imageUrl ?? '', fit: BoxFit.cover),
            ),
          ),

          /// DARK OVERLAY
          Positioned(
            top: topPadding + _toolbarHeight,
            left: 0,
            right: 0,
            bottom: 0,
            child: IgnorePointer(
              child: Opacity(
                opacity: overlayOpacity * (1 - (topBackgroundOpacity * 0.9)),
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      stops: [0.4, 1.0],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black54],
                    ),
                  ),
                ),
              ),
            ),
          ),

          /// SAFE AREA BG
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: topPadding + 20,
            child: IgnorePointer(
              child: ColoredBox(color: Colors.white.withValues(alpha: safeAreaOpacity)),
            ),
          ),

          Positioned(
            left: 24,
            right: 24,
            bottom: 36,
            child: IgnorePointer(
              child: Opacity(
                opacity: largeTitleOpacity,
                child: Align(
                  alignment: Alignment.center,
                  child: Transform.translate(
                    offset: Offset(0, progress * 4),
                    child: Transform.scale(
                      alignment: Alignment.center,
                      scale: 1 - (progress * _largeTitleScaleReduction),
                      child: Text(
                        displayTitle,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypographyV1.titleMedium.bold.textSeconday(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          /// TOOLBAR
          Positioned(
            top: topPadding,
            left: 0,
            right: 0,
            height: _toolbarHeight,
            child: Row(
              children: [
                const SizedBox(width: 8),
                CircleIconButton(
                  onTap: () => Navigator.of(context).pop(),
                  child: const CustomImage(path: ImageConstants.arrowBack, height: 18),
                ),

                const SizedBox(width: AppSpacing.xs),

                Expanded(
                  child: Opacity(
                    opacity: collapsedTitleOpacity,
                    child: Text(
                      displayTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypographyV1.bodySmall.bold.textSeconday(),
                    ),
                  ),
                ),

                CircleIconButton(
                  onTap: () => AppNavigator.goToSearch(context),
                  child: const CustomImage(path: ImageConstants.search, width: 20, height: 20),
                ),

                const SizedBox(width: 8),

                CircleIconButton(
                  onTap: () {},
                  child: const CustomImage(path: ImageConstants.heart, width: 20, height: 20),
                ),

                const SizedBox(width: 8),

                CircleIconButton(
                  onTap: () => AppNavigator.goToCart(context),
                  child: const CustomImage(path: ImageConstants.bag, width: 20, height: 20),
                ),
                const SizedBox(width: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _PlpHeaderDelegate oldDelegate) {
    return oldDelegate.title != title ||
        oldDelegate.subtitle != subtitle ||
        oldDelegate.banner != banner;
  }
}
