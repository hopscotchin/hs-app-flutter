import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hs_app_flutter/components/atoms/custom_image.dart';
import 'package:hs_app_flutter/core/entities/service_guarantee_entity.dart';
import 'package:hs_app_flutter/core/theme/colors.dart';
import 'package:hs_app_flutter/core/theme/spacing.dart';
import 'package:hs_app_flutter/core/theme/typography/text_style_extensions.dart';
import 'package:hs_app_flutter/core/theme/typography/typography_v1.dart';

import '../../../../core/constants/strings/auto_test_strings.dart';

class SlgWidget extends StatelessWidget {
  final List<ServiceGuaranteeEntity> items;
  const SlgWidget({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.whiteColor,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 0),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.mapIndexed((index, item) {
          return Expanded(
            child: Padding(
              key: ValueKey('${CartTestStrings.slgScreen}_item_$index'),
              padding: EdgeInsets.only(right: index == items.length - 1 ? 0 : AppSpacing.sm),
              child: _buildItem(item),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildItem(ServiceGuaranteeEntity item) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CustomImage(path: item.icon!, width: AppSpacing.iconMd, height: AppSpacing.iconMd),
        Flexible(
          child: Text(
            (item.label ?? '').replaceAll(' ', '\n'),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypographyV1.labelMedium.bold.copyWith(color: const Color(0x80000000)),
          ),
        ),
      ],
    );
  }
}
