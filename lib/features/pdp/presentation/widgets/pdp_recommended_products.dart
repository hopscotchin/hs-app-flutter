import 'package:flutter/material.dart';

import '../../../../components/page_components/product_grid_widget.dart';
import '../../../../core/constants/strings/auto_test_strings.dart';
import '../../../../core/constants/strings/pdp_strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography/typography_v1.dart';
import '../../../../features/discover/domain/entities/home_page_entity.dart';
import '../../domain/entities/recommendations_entity.dart';

/// Recommendations rail for the PDP. Returns a **sliver** (not a box) so the
/// product grid can build lazily, one row at a time, as it scrolls into view —
/// the rail can grow to many pages, and building every tile eagerly caused a
/// visible hitch when it first appeared and on each "load more".
///
/// The visual output is unchanged: each row reuses [ProductGridWidget] with a
/// single row's worth of tiles, so the tile/row layout stays the single source
/// of truth and byte-for-byte identical to the eager grid used elsewhere.
class PdpRecommendedProducts extends StatelessWidget {
  const PdpRecommendedProducts({
    super.key,
    required this.recommendations,
    required this.isLoadingMore,
  });

  final RecommendationsEntity recommendations;
  final bool isLoadingMore;

  static const int _columns = 2;

  @override
  Widget build(BuildContext context) {
    final records = recommendations.records;
    if (records.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    final rowCount = (records.length / _columns).ceil();

    return SliverMainAxisGroup(
      slivers: [
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sm)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Text(
              recommendations.pageMeta?.pageTitle ??
                  PdpStrings.productsYouMayLike,
              key: const ValueKey(PdpTestStrings.recommendedTitle),
              style: AppTypographyV1.titleMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF000000),
                height: 1.0,
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sm)),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, rowIndex) {
            final start = rowIndex * _columns;
            final end = start + _columns > records.length
                ? records.length
                : start + _columns;
            // One row of the canonical grid — reused verbatim so tiles look and
            // behave exactly as in the eager grid, but built lazily per row.
            return ProductGridWidget(
              // Per-row prefix keeps tile indices unique across rows — each
              // grid keys its tiles from 0, so a shared prefix would collide.
              keyPrefix: '${PdpTestStrings.recommendedPrefix}_row_$rowIndex',
              gridData: ProductGridData(
                layoutInfo: const LayoutInfoData(
                  columns: _columns,
                  showProductInfo: true,
                ),
                tiles: records.sublist(start, end),
              ),
            );
          }, childCount: rowCount),
        ),
        if (isLoadingMore)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: CircularProgressIndicator(
                  key: ValueKey(PdpTestStrings.recommendedLoading),
                  strokeWidth: 2,
                  color: AppColors.neutralBlack,
                ),
              ),
            ),
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 150)),
      ],
    );
  }
}
