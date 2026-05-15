import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../components/atoms/badge_icon.dart';
import '../../../../core/constants/image_constants.dart';
import '../../../../core/cubits/cart_count_cubit.dart';
import '../../../../core/router/app_navigator.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/typography.dart';
import '../../domain/entities/listing_header_entity.dart';
import '../../domain/entities/page_type.dart';
import '../../domain/entities/plp_config_entity.dart';
import '../bloc/plp_bloc.dart';
import 'plp_banner.dart';

typedef _AppBarData = ({
  int? totalRecords,
  String? screenName,
  ListingHeaderEntity? salePlanDetail,
  TopBannerEntity? topBanner,
});

class PlpSliverAppBar extends StatelessWidget {
  final PageType pageType;
  final String title;

  const PlpSliverAppBar({
    super.key,
    required this.pageType,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PlpBloc, PlpState, _AppBarData>(
      selector: (state) => (
        // totalRecords is null until first successful load — hides the count while loading
        totalRecords: state.status == PlpStatus.loaded
            ? state.totalRecords
            : null,
        screenName: state.screenName,
        salePlanDetail: state.salePlanDetail,
        topBanner: state.topBanner,
      ),
      builder: (context, data) {
        final hasBanner =
            data.salePlanDetail?.bannerImageUrl != null ||
            data.topBanner?.url != null;
        final banner = hasBanner
            ? PlpBanner(
                salePlanDetail: data.salePlanDetail,
                topBanner: data.topBanner,
                isBoutique: pageType == PageType.boutique,
                boutiqueTitle: pageType == PageType.boutique
                    ? (data.salePlanDetail?.name ?? data.screenName ?? title)
                    : null,
              )
            : null;

        final isBoutique = pageType == PageType.boutique && banner != null;
        final statusBarHeight = MediaQuery.paddingOf(context).top;
        final pageTitle =
            (data.screenName != null && data.screenName!.isNotEmpty)
            ? data.screenName!
            : title;

        if (isBoutique) {
          return _buildBoutiqueBar(context, banner, pageTitle, statusBarHeight);
        }
        return _buildStandardBar(context, pageTitle, data.totalRecords, banner);
      },
    );
  }

  SliverAppBar _buildBoutiqueBar(
    BuildContext context,
    Widget banner,
    String pageTitle,
    double statusBarHeight,
  ) {
    final expandedHeight = 160 + statusBarHeight;
    final collapsedHeight = kToolbarHeight + statusBarHeight;

    return SliverAppBar(
      automaticallyImplyLeading: false,
      centerTitle: false,
      pinned: false,
      stretch: true,
      floating: true,
      snap: true,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      expandedHeight: expandedHeight,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final t =
              ((constraints.maxHeight - collapsedHeight) /
                      (expandedHeight - collapsedHeight))
                  .clamp(0.0, 1.0);

          return Stack(
            fit: StackFit.expand,
            children: [
              FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: banner,
              ),
              Positioned(
                top: statusBarHeight,
                left: 0,
                right: 0,
                height: kToolbarHeight,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 24,
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            size: 20,
                            color: AppColors.textPrimary,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                    ),
                    if (t < 0.3)
                      Expanded(
                        child: Text(
                          pageTitle,
                          style: AppTypography.titleMedium.copyWith(
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    else
                      const Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 24,
                        child: IconButton(
                          icon: const Icon(
                            Icons.favorite_border,
                            size: 22,
                            color: AppColors.textPrimary,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 24,
                        child: _CartBadgeButton(
                          iconColor: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  SliverAppBar _buildStandardBar(
    BuildContext context,
    String pageTitle,
    int? totalRecords,
    Widget? banner,
  ) {
    return SliverAppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, size: 20),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Column(
        children: [
          Text(pageTitle, style: AppTypography.titleMedium),
          if (totalRecords != null)
            Text(
              '$totalRecords products',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
        ],
      ),
      centerTitle: true,
      pinned: false,
      floating: true,
      snap: true,
      backgroundColor: Colors.white,
      foregroundColor: AppColors.textPrimary,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.favorite_border, size: 22),
          onPressed: () {},
        ),
        const _CartBadgeButton(),
      ],
      expandedHeight: banner != null ? 200 : null,
      flexibleSpace: banner != null
          ? FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Padding(
                padding: const EdgeInsets.only(top: kToolbarHeight + 24),
                child: banner,
              ),
            )
          : null,
    );
  }
}

class _CartBadgeButton extends StatelessWidget {
  final Color? iconColor;

  const _CartBadgeButton({this.iconColor});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: BadgeIcon(
        count: context.watch<CartCountCubit>().state,
        child: SvgPicture.asset(ImageConstants.bag, width: 20, height: 20),
      ),
      onPressed: () => AppNavigator.goToCart(context),
    );
  }
}
