import 'package:flutter/material.dart';

import '../../../../../components/atoms/custom_image.dart';
import '../../../../../core/extensions/string_extensions.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../core/theme/spacing.dart';
import '../../../../../core/theme/typography/text_style_extensions.dart';
import '../../../../../core/theme/typography/typography_v1.dart';
import '../../../domain/entities/common/order_status_entity.dart';

/// The status block: a resolved icon and up to two resolved lines.
///
/// Built to `docs/orders/design/listing-spec.md` — icon 16, gap 8, the two
/// lines 4 apart, and the icon **centred** against the text block rather than
/// top-aligned.
///
/// Every status renders in the same neutral tokens. Android picks a background
/// from an integer `colorNumber` — red for cancelled, green for refunded, blue
/// for returned — and a text colour parsed out of `deliveryMessage.color`; none
/// of that is migrated. The redesign's legend carries no coloured chips, so the
/// only thing distinguishing one status from another is the icon, which arrives
/// as a URL.
///
/// Rendered with [CustomImage] rather than `CachedImageWidget`: the status
/// icons are SVGs and only [CustomImage] handles those.
///
/// Shared with order details and the return flow, which draw the same block.
class OrderStatusRow extends StatelessWidget {
  const OrderStatusRow({
    super.key,
    required this.status,
    this.titleKey,
    this.subtitleKey,
    this.actionKey,
    this.onActionTap,
    this.trailing,
  });

  final OrderStatusEntity status;
  final Key? titleKey;
  final Key? subtitleKey;
  final Key? actionKey;

  /// Fired with `status.action.actionUri` when the inline link is tapped.
  ///
  /// A callback rather than a bloc lookup: this is a leaf widget on a list of
  /// cards, and reaching for `context.read` inside one is what the architecture
  /// rules forbid. The page that owns the bloc decides what a tap means.
  final void Function(String actionUri)? onActionTap;

  /// Anything the surface wants at the end of the row instead of the link —
  /// order details puts the rating stars here once an item is delivered.
  ///
  /// Mutually exclusive with [status.action]: the artboard gives that slot to
  /// one element, and [trailing] wins because the caller is being explicit.
  final Widget? trailing;

  static const double _iconSize = 16;

  @override
  Widget build(BuildContext context) {
    final title = status.title;
    final subtitle = status.subtitle;
    final icon = status.icon;

    final base = AppTypographyV1.labelMedium.copyWith(
      color: AppColors.neutralGrey6,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (icon.isNotNullOrEmpty) ...[
          CustomImage(
            path: icon ?? '',
            width: _iconSize,
            height: _iconSize,
            fit: BoxFit.contain,
          ),
          AppSpacing.horizontalGapXs,
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title.isNotNullOrEmpty)
                _titleLine(title ?? '', base.medium.copyWith(height: 14 / 10)),
              if (title != null &&
                  title.isNotEmpty &&
                  subtitle != null &&
                  subtitle.isNotEmpty)
                AppSpacing.verticalGapXxs,
              if (subtitle.isNotNullOrEmpty)
                Text(
                  subtitle ?? '',
                  key: subtitleKey,
                  style: base.regular.copyWith(height: 12 / 10),
                ),
            ],
          ),
        ),
        if (trailing != null) ...[AppSpacing.horizontalGapXs, trailing!],
      ],
    );
  }

  /// The title, plus whatever shares its line.
  ///
  /// A [Row] rather than a plain [Text] only when something follows it, so the
  /// listing — which never sends an action — keeps the exact widget tree it had
  /// before details existed.
  Widget _titleLine(String title, TextStyle style) {
    final showAction = trailing == null && status.hasAction;
    if (!showAction) return Text(title, key: titleKey, style: style);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // The title yields first: on a narrow screen the link stays whole and
        // the status text ellipsises, because a half-rendered "Trac" is a
        // broken control where a truncated date is still readable.
        Flexible(
          child: Text(
            title,
            key: titleKey,
            style: style,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
          child: Text('·', style: style),
        ),
        InkWell(
          onTap: () => onActionTap?.call(status.action!.actionUri!),
          child: Text(
            status.action!.label ?? '',
            key: actionKey,
            style: style.copyWith(color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}
