import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../atoms/custom_image.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography/typography_v1.dart';
import '../../core/utils/text_fit.dart';

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

/// Lines a label may occupy. The measurement in [IconLabelInfoRow] and the
/// [Text] in [IconLabelInfoItem] must agree on this, or the row scales the
/// labels for a budget the Text does not honour.
const int _labelMaxLines = 2;

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

  /// The label style when a caller supplies none. Lives here rather than in
  /// [IconLabelInfoItem] so the row can measure the labels before building them.
  static TextStyle get defaultLabelStyle => AppTypographyV1.labelMedium.copyWith(
    fontWeight: FontWeight.w700,
    color: const Color(0x80000000),
    height: 14 / 10,
  );

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    // Every label is measured against the box it will actually get, and all of
    // them are given ONE shared size — so no label is ever truncated and the
    // three always match each other. Sizing each item on its own (a FittedBox,
    // or per-item measurement) would leave "7 Days Return" at full size beside a
    // shrunken "Cash On Delivery", which reads as a rendering bug rather than a
    // deliberate size.
    return LayoutBuilder(
      builder: (context, constraints) {
        // Merged over the ambient DefaultTextStyle because that is what Text
        // paints with: the theme contributes letterSpacing and the like, so
        // measuring the bare token underestimates every label and the shared
        // size comes out slightly too large.
        final baseStyle = DefaultTextStyle.of(context).style.merge(labelStyle ?? defaultLabelStyle);
        // Row splits into equal slots; an item is capped by itemMaxWidth, and
        // the icon tile takes its share before the label sees any.
        final slotWidth = constraints.maxWidth / items.length;
        final labelBox = math.min(slotWidth, itemMaxWidth) - tileSize;
        final scale = sharedTextFitScale(
          texts: [for (final item in items) item.label ?? ''],
          style: baseStyle,
          maxWidth: labelBox,
          textScaler: MediaQuery.textScalerOf(context),
          maxLines: _labelMaxLines,
        );
        final resolvedLabelStyle = baseStyle.copyWith(fontSize: baseStyle.fontSize! * scale);

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
                    labelStyle: resolvedLabelStyle,
                    fallbackIcon: fallbackIcon,
                    fallbackIconColor: fallbackIconColor,
                  ),
                ),
              ),
          ],
        );
      },
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
    final resolvedLabelStyle = labelStyle ?? IconLabelInfoRow.defaultLabelStyle;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth, minHeight: tileSize),
      // mainAxisSize.min so the icon and label hug each other and the parent
      // [Center] can centre the pair inside its slot — an Expanded label would
      // fill the slot instead, pinning the icon to its left edge.
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
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
          // Flexible, not a bare Text: a Row lays non-flex children out with
          // unbounded width, so the label never wrapped and never ellipsised —
          // it simply overflowed its slot (8.8px even with short labels at the
          // default text size). It also left maxLines, the ellipsis and the
          // row's shared sizing with no width to act against.
          //
          // Loose rather than Expanded so the label takes only what it needs,
          // which is what keeps the icon and label centred as a pair.
          Flexible(
            child: Text(
              item.label ?? '',
              style: resolvedLabelStyle,
              maxLines: _labelMaxLines,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
