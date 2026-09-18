import 'package:flutter/material.dart';

import '../../../../../components/atoms/auto_semantics.dart';
import '../../../../../components/atoms/custom_image.dart';
import '../../../../../components/buttons/app_button_named.dart';
import '../../../../../components/buttons/button_enums.dart';
import '../../../../../core/constants/strings/auto_test_strings.dart';
import '../../../../../core/extensions/string_extensions.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../core/theme/spacing.dart';
import '../../../../../core/theme/typography/text_style_extensions.dart';
import '../../../../../core/theme/typography/typography_v1.dart';
import '../../../../plp/domain/entities/notification_nudge_entity.dart';

/// The "Stay Updated!" card at the top of the Orders tab.
///
/// Built to `docs/orders/design/listing-spec.md`. Note the background is
/// `#E5E5EA` — a step darker than the `#F6F6F6` the item cards use — and the
/// bell sits in a white circle with a soft shadow rather than bare on the card.
///
/// Every string and the bell image come from the backend's `notificationNudge`
/// block, parsed by PLP's [NotificationNudgeEntity] unchanged — the block was
/// designed for PLP and needed no new fields here.
///
/// Orders tab only. The Gift Cards artboard goes from the tab bar straight to
/// the cards. Android shows the nudge on both, because it is bound above the
/// tab pager rather than inside either list, so this is a deliberate change.
///
/// Presentation only: it reports which button was pressed and leaves the
/// permission request and the analytics to the caller. The frequency rules on
/// the same block are the caller's to honour — this widget draws what it is
/// given.
/// Whether the nudge carries everything this card draws.
///
/// Android renders the card only when all five are non-empty. Rendering a
/// half-filled card would also fire `notification_permission_intent_shown` for
/// something the customer cannot act on, so the same test gates both.
extension NotificationNudgeRenderX on NotificationNudgeEntity {
  bool get isRenderable =>
      titleImage.isNotNullOrEmpty &&
      title.isNotNullOrEmpty &&
      description.isNotNullOrEmpty &&
      positiveButtonText.isNotNullOrEmpty &&
      negativeButtonText.isNotNullOrEmpty;
}

class NotificationNudgeCard extends StatefulWidget {
  const NotificationNudgeCard({
    super.key,
    required this.nudge,
    required this.onShown,
    required this.onAccept,
    required this.onDecline,
  });

  final NotificationNudgeEntity nudge;

  /// Called once, when this card is first inserted into the tree.
  ///
  /// `notification_permission_intent_shown` means "the customer was asked", so
  /// it fires from here rather than from a state listener: no card, no event,
  /// and nothing to keep in step. The caller makes it idempotent — both tabs
  /// can carry a nudge, and a tab can be rebuilt.
  final VoidCallback onShown;

  final VoidCallback onAccept;
  final VoidCallback onDecline;

  @override
  State<NotificationNudgeCard> createState() => _NotificationNudgeCardState();
}

class _NotificationNudgeCardState extends State<NotificationNudgeCard> {
  static const double _bellContainer = 32;
  static const double _bellIcon = 24;
  static const double _buttonHeight = 34;

  @override
  void initState() {
    super.initState();
    widget.onShown();
  }

  @override
  Widget build(BuildContext context) {
    final nudge = widget.nudge;
    final onAccept = widget.onAccept;
    final onDecline = widget.onDecline;
    final title = nudge.title;
    final description = nudge.description;
    final positive = nudge.positiveButtonText;
    final negative = nudge.negativeButtonText;

    return AutoSemantics(
      id: OrdersTestStrings.nudge,
      container: true,
      child: Container(
        key: const ValueKey(OrdersTestStrings.nudge),
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.lg,
          horizontal: AppSpacing.sm,
        ),
        decoration: const BoxDecoration(
          color: AppColors.neutralGrey2,
          borderRadius: AppSpacing.borderRadiusSm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (nudge.titleImage != null &&
                    nudge.titleImage!.isNotEmpty) ...[
                  _bell(nudge.titleImage!),
                  AppSpacing.horizontalGapSm,
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (title.isNotNullOrEmpty)
                        Text(
                          title ?? '',
                          key: const ValueKey(OrdersTestStrings.nudgeTitle),
                          style: AppTypographyV1.bodyRegular.bold.copyWith(
                            color: AppColors.neutralGrey6,
                            height: 19 / 14,
                          ),
                        ),
                      if (title != null &&
                          title.isNotEmpty &&
                          description != null &&
                          description.isNotEmpty)
                        AppSpacing.verticalGapSm,
                      if (description.isNotNullOrEmpty)
                        Text(
                          description ?? '',
                          style: AppTypographyV1.labelLarge.medium.copyWith(
                            color: AppColors.neutralGrey6,
                            height: 16 / 12,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            AppSpacing.verticalGapMd,
            SizedBox(
              height: _buttonHeight,
              child: Row(
                children: [
                  if (negative.isNotNullOrEmpty)
                    Expanded(
                      child: SecondaryButton.defaultType(
                        key: const ValueKey(
                          OrdersTestStrings.nudgeNegativeButton,
                        ),
                        text: negative ?? '',
                        isFullWidth: true,
                        size: ButtonSize.small,
                        onTap: onDecline,
                      ),
                    ),
                  if (negative != null &&
                      negative.isNotEmpty &&
                      positive != null &&
                      positive.isNotEmpty)
                    AppSpacing.horizontalGapSm,
                  if (positive.isNotNullOrEmpty)
                    Expanded(
                      child: PrimaryButton.defaultType(
                        key: const ValueKey(
                          OrdersTestStrings.nudgePositiveButton,
                        ),
                        text: positive ?? '',
                        isFullWidth: true,
                        size: ButtonSize.small,
                        onTap: onAccept,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// A 24pt bell centred in a 32pt white disc with a soft shadow. Without the
  /// disc the bell reads as floating on the grey.
  Widget _bell(String path) {
    return Container(
      width: _bellContainer,
      height: _bellContainer,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: Color(0x40000000), blurRadius: 4)],
      ),
      alignment: Alignment.center,
      child: CustomImage(
        path: path,
        width: _bellIcon,
        height: _bellIcon,
        fit: BoxFit.contain,
      ),
    );
  }
}
