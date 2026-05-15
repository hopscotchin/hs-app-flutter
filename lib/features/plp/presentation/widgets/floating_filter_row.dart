import 'package:flutter/material.dart';

import '../../../../components/atoms/cached_image_widget.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../domain/entities/floating_filter_entity.dart';

class FloatingFilterRow extends StatefulWidget {
  final FloatingFilterSectionEntity section;
  final void Function(String key, String value) onTileSelected;

  const FloatingFilterRow({
    super.key,
    required this.section,
    required this.onTileSelected,
  });

  @override
  State<FloatingFilterRow> createState() => _FloatingFilterRowState();
}

class _FloatingFilterRowState extends State<FloatingFilterRow>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final section = widget.section;
    return Container(
      color: const Color(0xFFF0F0F0),
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (section.title != null && section.title!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(
                left: AppSpacing.md,
                top: 10,
                bottom: AppSpacing.lmd,
              ),
              child: Text(
                section.title!.toUpperCase(),
                style: AppTypography.titleSmall.copyWith(
                  fontWeight: AppTypography.semiBold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          SizedBox(
            height: _tileHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              itemCount: section.tiles.length,
              separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
              itemBuilder: (context, index) => _buildTile(section.tiles[index]),
            ),
          ),
        ],
      ),
    );
  }

  double get _tileHeight {
    if (widget.section.tileHeight != null && widget.section.tileHeight! > 0) {
      return widget.section.tileHeight!.toDouble().clamp(36, 56);
    }
    return 44;
  }

  Widget _buildTile(FloatingFilterTileEntity tile) {
    final isImageTile = tile.imageUrl != null && tile.imageUrl!.isNotEmpty;
    return GestureDetector(
      onTap: () {
        final param = tile.param;
        final id = tile.id;
        if (param != null && id != null) {
          widget.onTileSelected(param, id);
        }
      },
      child: isImageTile ? _buildImageTile(tile) : _buildTextTile(tile),
    );
  }

  Widget _buildImageTile(FloatingFilterTileEntity tile) {
    final width = (widget.section.tileWidth?.toDouble() ?? _tileHeight * 2)
        .clamp(40, 160)
        .toDouble();
    return ClipRRect(
      borderRadius: AppSpacing.borderRadiusSm,
      child: SizedBox(
        width: width,
        height: _tileHeight,
        child: CachedImageWidget(imageUrl: tile.imageUrl!, fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildTextTile(FloatingFilterTileEntity tile) {
    final bgColor = _parseColor(tile.bgColor) ?? Colors.white;
    final textColor = _parseColor(tile.color) ?? AppColors.primary;
    final label = tile.text ?? tile.name ?? '';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppSpacing.borderRadiusXs,
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: AppTypography.labelLarge.copyWith(
          color: textColor,
          fontWeight: AppTypography.semiBold,
        ),
      ),
    );
  }

  static Color? _parseColor(String? hex) {
    if (hex == null || hex.isEmpty) return null;
    final cleaned = hex.replaceFirst('#', '');
    final value = int.tryParse('FF$cleaned', radix: 16);
    if (value == null) return null;
    return Color(value);
  }
}
