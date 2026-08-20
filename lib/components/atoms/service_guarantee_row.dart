import 'package:flutter/material.dart';

import '../../core/entities/service_guarantee_entity.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/typography/text_style_extensions.dart';
import '../../core/theme/typography/typography_v1.dart';
import 'custom_image.dart';

/// Row of trust/assurance badges (icon above a 2-line label), evenly spaced.
///
/// Backend-driven — used by both Cart ("serviceLevelGuarantee") and PDP
/// ("serviceGuarantee"), which share the same `{icon, label}` shape.
///
/// [keyPrefix] scopes automation keys per host screen, e.g. `cart_slg` or
/// `pdp_slg` → `<prefix>_item_<i>_icon` / `<prefix>_item_<i>_label`.
class ServiceGuaranteeRow extends StatelessWidget {
  final List<ServiceGuaranteeEntity> items;
  final String? keyPrefix;

  const ServiceGuaranteeRow({super.key, required this.items, this.keyPrefix});

  static const double _iconSize = 28;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      color: AppColors.whiteColor,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.take(3).toList().asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return Expanded(child: _buildItem(index, item));
        }).toList(),
      ),
    );
  }

  Widget _buildItem(int index, ServiceGuaranteeEntity item) {
    final prefix = keyPrefix;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        (item.icon?.isNotEmpty ?? false)
            ? CustomImage(
                key: prefix != null ? ValueKey('${prefix}_item_${index}_icon') : null,
                path: item.icon!,
                width: _iconSize,
                height: _iconSize,
                errorWidget: const Icon(
                  Icons.verified_outlined,
                  size: _iconSize,
                  color: AppColors.brandPrimary,
                ),
              )
            : const Icon(Icons.verified_outlined, size: _iconSize, color: AppColors.brandPrimary),
        const SizedBox(height: AppSpacing.sm),
        Text(
          item.label ?? '',
          key: prefix != null ? ValueKey('${prefix}_item_${index}_label') : null,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTypographyV1.labelLarge.medium.textSecondary(),
        ),
      ],
    );
  }
}
