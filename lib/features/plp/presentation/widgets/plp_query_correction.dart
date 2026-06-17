import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hs_app_flutter/core/constants/strings/plp_strings.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography/text_style_extensions.dart';
import '../../../../core/theme/typography/typography_v1.dart';
import '../../domain/entities/page_type.dart';
import '../../domain/entities/query_correction_entity.dart';
import '../bloc/plp_bloc.dart';

class PlpQueryCorrectionSliver extends StatelessWidget {
  const PlpQueryCorrectionSliver({super.key, required this.pageType, required this.plpId});

  final PageType pageType;
  final int plpId;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: BlocSelector<PlpBloc, PlpState, QueryCorrectionEntity?>(
        selector: (s) => s.queryCorrection,
        builder: (context, qc) {
          if (qc == null || !qc.isRenderable) {
            // SizedBox.shrink() in a SliverToBoxAdapter still creates a
            // zero-height sliver — costs nothing visually.
            return const SizedBox.shrink();
          }
          return _QueryCorrectionBlock(
            data: qc,
            onSuggestionTap: qc.isLowConfidence ? () => _applyCorrection(context, qc) : null,
          );
        },
      ),
    );
  }

  void _applyCorrection(BuildContext context, QueryCorrectionEntity qc) {
    final corrected = qc.searchFor;
    if (corrected == null || corrected.isEmpty) return;
    context.read<PlpBloc>().add(
      LoadPlpData(pageType: pageType, plpId: plpId, searchQuery: corrected),
    );
  }
}

class _QueryCorrectionBlock extends StatelessWidget {
  const _QueryCorrectionBlock({required this.data, this.onSuggestionTap});

  final QueryCorrectionEntity data;
  final VoidCallback? onSuggestionTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.xs,
        AppSpacing.md,
        AppSpacing.xs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if ((data.resultsOf?.isNotEmpty ?? false))
            Text(
              '${PlpStrings.showingResultsFor}${data.resultsOf!}',
              style: AppTypographyV1.labelLarge.medium.neutralGrey6(),
            ),

          if ((data.searchFor?.isNotEmpty ?? false)) ...[
            const SizedBox(height: 2),
            _buildLineTwo(data.searchFor!, data.confidence),
          ],
        ],
      ),
    );
  }

  Widget _buildLineTwo(String searchFor, int confidence) {
    if (confidence == 0) {
      return InkWell(
        onTap: onSuggestionTap,
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(text: 'Did you mean ', style: AppTypographyV1.bodySmall.textPrimary()),
              TextSpan(
                text: searchFor,
                style: AppTypographyV1.bodySmall.bold.copyWith(
                  color: AppColors.brandPrimary,
                  decorationColor: AppColors.brandPrimary,
                ),
              ),
            ],
          ),
        ),
      );
    }
    // High confidence / no results → plain "No results for ...".
    return Text('No results for $searchFor', style: AppTypographyV1.bodySmall.textPrimary());
  }
}
