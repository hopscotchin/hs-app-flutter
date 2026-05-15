import 'package:flutter/material.dart';

import '../../../../components/atoms/cached_image_widget.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../domain/entities/listing_header_entity.dart';
import '../../domain/entities/plp_config_entity.dart';

class PlpBanner extends StatelessWidget {
  final ListingHeaderEntity? salePlanDetail;
  final TopBannerEntity? topBanner;
  final bool isBoutique;
  final String? boutiqueTitle;

  const PlpBanner({
    super.key,
    this.salePlanDetail,
    this.topBanner,
    this.isBoutique = false,
    this.boutiqueTitle,
  });

  String? get _bannerUrl {
    if (salePlanDetail?.bannerImageUrl != null &&
        salePlanDetail!.bannerImageUrl!.isNotEmpty) {
      return salePlanDetail!.bannerImageUrl;
    }
    if (topBanner?.url != null && topBanner!.url!.isNotEmpty) {
      return topBanner!.url;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final url = _bannerUrl;
    if (url == null) return const SizedBox.shrink();

    final image = CachedImageWidget(
      imageUrl: url,
      width: double.infinity,
      fit: BoxFit.cover,
    );

    if (!isBoutique) return image;

    // Boutique: full-bleed image with scrims for icon/title visibility
    return Stack(
      fit: StackFit.expand,
      children: [
        image,
        // Top scrim for toolbar icons
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment(0, -0.4),
              colors: [
                Color(0x59000000), // ~35% black
                Colors.transparent,
              ],
            ),
          ),
        ),
        // Bottom scrim + title
        if (boutiqueTitle != null && boutiqueTitle!.isNotEmpty)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Color(0x8A000000), // ~54% black
                    Colors.transparent,
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.xl,
                  AppSpacing.md,
                  AppSpacing.sm,
                ),
                child: Center(
                  child: Text(
                    boutiqueTitle!,
                    style: AppTypography.headlineMedium.copyWith(
                      color: Colors.white,
                      fontWeight: AppTypography.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
