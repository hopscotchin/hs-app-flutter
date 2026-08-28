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

    // The PDP's SafeArea has `bottom: false`, so the scroll view runs under the
    // system nav/gesture bar. The trailing spacer has to clear it, and its
    // height is device-dependent — roughly 34 for an iPhone home indicator, 24
    // for Android gesture nav, ~48 for 3-button nav — so a fixed value either
    // wastes space or clips the last row. `viewPadding` rather than `padding`:
    // it reports the inset even when something else (a keyboard) is covering
    // it. Same source as PdpContent's `_bottomInset`, which positions the
    // floating bar, so the two can't disagree.
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;

    return SliverMainAxisGroup(
      slivers: [
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sm)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            // `Center` wraps the Text so the paragraph gets the full row width to
            // align within — `textAlign` on its own leaves the title at the left
            // edge, because the Text shrink-wraps to its own width under loose
            // constraints.
            child: Center(
              child: Text(
                recommendations.pageMeta?.pageTitle ?? PdpStrings.productsYouMayLike,
                key: const ValueKey(PdpTestStrings.recommendedTitle),
                textAlign: TextAlign.center,
                style: AppTypographyV1.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF000000),
                  height: 1.0,
                ),
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sm)),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, rowIndex) {
            final start = rowIndex * _columns;
            final end = start + _columns > records.length ? records.length : start + _columns;
            // One row of the canonical grid — reused verbatim so tiles look and
            // behave exactly as in the eager grid, but built lazily per row.
            return ProductGridWidget(
              // Per-row prefix keeps tile indices unique across rows — each
              // grid keys its tiles from 0, so a shared prefix would collide.
              keyPrefix: '${PdpTestStrings.recommendedPrefix}_row_$rowIndex',
              gridData: ProductGridData(
                layoutInfo: const LayoutInfoData(columns: _columns, showProductInfo: true),
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
        SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg + bottomInset)),
      ],
    );
  }
}
