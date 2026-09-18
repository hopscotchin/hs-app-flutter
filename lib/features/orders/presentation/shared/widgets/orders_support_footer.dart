import 'package:flutter/material.dart';

import '../../../../../components/atoms/custom_image.dart';
import '../../../../../components/buttons/app_button_named.dart';
import '../../../../../components/buttons/button_enums.dart';
import '../../../../../core/constants/strings/auto_test_strings.dart';
import '../../../../../core/entities/backend_action_entity.dart';
import '../../../../../core/extensions/string_extensions.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../core/theme/spacing.dart';
import '../../../../../core/theme/typography/text_style_extensions.dart';
import '../../../../../core/theme/typography/typography_v1.dart';
import '../../../domain/entities/common/support_section_entity.dart';

/// "Need help with your order?" — the footer under the Orders list.
///
/// The buttons name a behaviour rather than a destination: `CALL_US` opens the
/// dialer on the number app config already provides, `HELP_CENTER` opens the
/// existing help-centre route. That is why the contract marks the whole block
/// app-config rather than per-response — it is identical on every orders
/// screen, and the number is not a property of any order.
///
/// An unrecognised `type` renders nothing, so a behaviour added by the backend
/// degrades quietly on older builds instead of throwing.
///
/// Orders tab only; the Gift Cards artboard ends after the last card. Android
/// appends it unconditionally from the shared fragment, so dropping it here
/// removes the only support entry point from that tab — worth confirming with
/// design.
class OrdersSupportFooter extends StatelessWidget {
  const OrdersSupportFooter({
    super.key,
    required this.support,
    required this.onAction,
  });

  final SupportSectionEntity support;

  /// Receives [BackendActionType.callUs] or [BackendActionType.helpCenter].
  final ValueChanged<BackendActionType> onAction;

  static const double _iconSize = 18;

  @override
  Widget build(BuildContext context) {
    // An unrecognised type stays out of the row rather than rendering a button
    // that does nothing, so a behaviour added by the backend degrades quietly.
    final buttons = support.ctaActions
        .where(
          (a) =>
              a.label.isNotNullOrEmpty &&
              a.actionType != BackendActionType.unknown,
        )
        .toList(growable: false);

    if (buttons.isEmpty) return const SizedBox.shrink();

    return Padding(
      // 32 above, from the last card — see the spec's page-column gaps.
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.sm,
        AppSpacing.xl,
        AppSpacing.sm,
        AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (support.title.isNotNullOrEmpty) ...[
            Text(
              support.title!,
              key: const ValueKey(OrdersTestStrings.supportTitle),
              textAlign: TextAlign.center,
              style: AppTypographyV1.labelLarge.regular.copyWith(
                color: AppColors.neutralBlack,
                height: 16 / 12,
              ),
            ),
            AppSpacing.verticalGapMd,
          ],
          Row(
            children: [
              for (final action in buttons) ...[
                Expanded(child: _button(action)),
                if (action != buttons.last) AppSpacing.horizontalGapXs,
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _button(BackendActionButtonEntity action) {
    final icon = action.iconUrl;
    return SecondaryButton.defaultType(
      key: ValueKey(_keyFor(action.actionType)),
      text: action.label ?? '',
      isFullWidth: true,
      size: ButtonSize.medium,
      leadingIcon: icon.isNotNullOrEmpty
          ? CustomImage(
              path: icon ?? '',
              width: _iconSize,
              height: _iconSize,
              fit: BoxFit.contain,
            )
          : null,
      onTap: () => onAction(action.actionType),
    );
  }

  String _keyFor(BackendActionType type) => switch (type) {
    BackendActionType.callUs => OrdersTestStrings.supportCallButton,
    BackendActionType.helpCenter => OrdersTestStrings.supportHelpButton,
    _ => 'orders_support_unknown_button',
  };
}
