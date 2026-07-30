import 'package:flutter/material.dart';

import '../atoms/custom_image.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography/typography_v1.dart';

/// Presentation-owned data for a single [IconLabelInfoItem].
///
/// Kept deliberately free of any feature/domain type so this component can be
/// reused anywhere. Callers map their own model into this at the call site.
class IconLabelInfo {
  const IconLabelInfo({this.icon, this.label});

  /// Icon image path (asset or network). When null, [IconLabelInfoRow.fallbackIcon]
  /// is shown instead.
  final String? icon;
  final String? label;
}

/// A row of icon + label chips, each slot sized equally and centered.
class IconLabelInfoRow extends StatelessWidget {
  const IconLabelInfoRow({
    super.key,
    required this.items,
    this.iconSize = 16,
    this.itemMaxWidth = 90,
    this.tileSize = 40,
    this.tileColor = const Color(0xFFFFFFFF),
    this.tileRadius = 3.82,
    this.labelStyle,
    this.fallbackIcon = Icons.verified_outlined,
    this.fallbackIconColor = AppColors.brandDefault,
  });

  final List<IconLabelInfo> items;
  final double iconSize;
  final double itemMaxWidth;
  final double tileSize;
  final Color tileColor;
  final double tileRadius;

  /// Overrides the default label text style when provided.
  final TextStyle? labelStyle;
  final IconData fallbackIcon;
  final Color fallbackIconColor;

  @override
  Widget build(BuildContext context) {
    // Row split into equal parts, each item centered in its slot.
    return Row(
      children: [
        for (final item in items)
          Expanded(
            child: Center(
              child: IconLabelInfoItem(
                item: item,
                iconSize: iconSize,
                maxWidth: itemMaxWidth,
                tileSize: tileSize,
                tileColor: tileColor,
                tileRadius: tileRadius,
                labelStyle: labelStyle,
                fallbackIcon: fallbackIcon,
                fallbackIconColor: fallbackIconColor,
              ),
            ),
          ),
      ],
    );
  }
}

class IconLabelInfoItem extends StatelessWidget {
  const IconLabelInfoItem({
    super.key,
    required this.item,
    this.iconSize = 16,
    this.maxWidth = 90,
    this.tileSize = 40,
    this.tileColor = const Color(0xFFFFFFFF),
    this.tileRadius = 3.82,
    this.labelStyle,
    this.fallbackIcon = Icons.verified_outlined,
    this.fallbackIconColor = AppColors.brandDefault,
  });

  final IconLabelInfo item;
  final double iconSize;
  final double maxWidth;
  final double tileSize;
  final Color tileColor;
  final double tileRadius;
  final TextStyle? labelStyle;
  final IconData fallbackIcon;
  final Color fallbackIconColor;

  @override
  Widget build(BuildContext context) {
    final resolvedLabelStyle =
        labelStyle ??
        AppTypographyV1.labelMedium.copyWith(
          fontWeight: FontWeight.w700,
          color: const Color(0x80000000),
          height: 14 / 10,
        );

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth, minHeight: tileSize),
      // Fixed-width slot: the Expanded label consumes all free space, so there
      // is nothing for a main-axis alignment to distribute. Centering of the
      // item within its slot is done by the parent [Center].
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: tileSize,
            height: tileSize,
            decoration: BoxDecoration(
              color: tileColor,
              borderRadius: BorderRadius.all(Radius.circular(tileRadius)),
            ),
            child: Center(
              child: item.icon != null
                  ? CustomImage(
                      path: item.icon!,
                      width: iconSize,
                      height: iconSize,
                      fit: BoxFit.contain,
                    )
                  : Icon(fallbackIcon, size: iconSize, color: fallbackIconColor),
            ),
          ),
          Expanded(
            child: Text(
              item.label ?? '',
              style: resolvedLabelStyle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
