import 'package:flutter/material.dart';
import 'package:hs_app_flutter/components/form/app_radio.dart';
import 'package:hs_app_flutter/core/constants/strings/plp_strings.dart';
import 'package:hs_app_flutter/core/theme/typography/text_style_extensions.dart';
import 'package:hs_app_flutter/core/theme/typography/typography_v1.dart';

import '../../../../core/theme/spacing.dart';
import '../../domain/entities/sorting_option_entity.dart';

class SortBottomSheet extends StatelessWidget {
  final List<SortingOptionEntity> sortingOptions;
  final void Function(int orderRule) onSelected;

  const SortBottomSheet({super.key, required this.sortingOptions, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, AppSpacing.md, AppSpacing.xs),
              child: Text(PlpStrings.sort, style: AppTypographyV1.titleMedium.bold.textPrimary()),
            ),
            ...sortingOptions.map((option) {
              return SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.xsm),
                  child: AppRadio.labeled(
                    isSelected: option.isSelected,
                    label: option.label ?? '',
                    onTap: () {
                      onSelected(option.orderRule);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              );
            }),
            AppSpacing.verticalGapSm,
          ],
        ),
      ),
    );
  }
}
