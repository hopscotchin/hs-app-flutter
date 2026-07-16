import 'package:flutter/material.dart';

import '../atoms/custom_image.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/typography/typography_v1.dart';
import '../../features/pdp/domain/entities/service_guarantee_entity.dart';

class IconLabelInfoRow extends StatelessWidget {
  const IconLabelInfoRow({super.key, required this.items});
  final List<ServiceGuaranteeEntity> items;

  @override
  Widget build(BuildContext context) {
    // Distribution by count (item/icon/label sizes stay fixed):
    //  • 1 item  → aligned to the start
    //  • 2 items → row split into two equal halves, each item centered in its half
    //  • 3 items → centered as a group with gaps between (unchanged)
    switch (items.length) {
      case 1:
        return Row(children: [IconLabelInfoItem(item: items.first)]);
      case 2:
        return Row(
          children: [
            for (final item in items)
              Expanded(
                child: Center(child: IconLabelInfoItem(item: item)),
              ),
          ],
        );
      default:
        return Row(
          children: [
            for (int i = 0; i < items.length; i++) ...[
              Expanded(
                child: Center(child: IconLabelInfoItem(item: items[i])),
              ),
            ],
          ],
        );
    }
  }
}

class IconLabelInfoItem extends StatelessWidget {
  const IconLabelInfoItem({super.key, required this.item});
  final ServiceGuaranteeEntity item;

  static const double _iconSize = 16;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 90, minHeight: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFFFFFFF),
              borderRadius: BorderRadius.all(Radius.circular(3.82)),
            ),
            child: Center(
              child: item.icon != null
                  ? CustomImage(
                      path: item.icon!,
                      width: _iconSize,
                      height: _iconSize,
                      fit: BoxFit.contain,
                    )
                  : const Icon(
                      Icons.verified_outlined,
                      size: _iconSize,
                      color: AppColors.brandDefault,
                    ),
            ),
          ),
          Expanded(
            child: Text(
              item.label ?? '',
              style: AppTypographyV1.labelMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: const Color(0x80000000),
                height: 14 / 10,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
