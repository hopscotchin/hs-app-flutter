import 'package:flutter/material.dart';

import '../../../../components/app_bottom_sheet.dart';
import '../../../../core/entities/backend_action_entity.dart';
import '../../../../core/navigation/action_url_handler.dart';

/// Shows the `bottomSheet` object that `/v3/promotion/apply` and
/// `/v3/promotion/remove` return on either outcome (e.g. "Invalid promotion" →
/// "Got It"). Shared by the offers sheet and the cart's promo section so both
/// render the backend's copy identically.
///
/// Each button closes the sheet, then follows its `action` as a deeplink unless
/// it is empty or `DISMISS` — the same handling `ActionTrigger` applies to this
/// `{title, description, leftAction, rightAction}` shape. Button emphasis comes
/// from the payload's `style`, falling back to filled-left / outlined-right.
Future<void> showPromoActionSheet(
  BuildContext context,
  BackendActionContentEntity content,
) {
  final description = content.description;
  if (description == null || description.isEmpty) return Future.value();

  return AppBottomSheet.show(
    context,
    title: content.title,
    description: description,
    primaryAction: AppBottomSheetAction(
      label: content.leftAction?.label ?? 'Got It',
      style: _styleFor(
        content.leftAction,
        fallback: AppBottomSheetButtonStyle.filled,
      ),
      onPressed: () => _run(context, content.leftAction?.actionUrl),
    ),
    secondaryAction: content.rightAction == null
        ? null
        : AppBottomSheetAction(
            label: content.rightAction!.label ?? 'Cancel',
            style: _styleFor(
              content.rightAction,
              fallback: AppBottomSheetButtonStyle.outlined,
            ),
            onPressed: () => _run(context, content.rightAction!.actionUrl),
          ),
  );
}

/// `primary` fills, `secondary` outlines. Anything else — including a missing
/// `style` — leaves the button at its positional default.
AppBottomSheetButtonStyle _styleFor(
  BackendActionButtonEntity? button, {
  required AppBottomSheetButtonStyle fallback,
}) {
  if (button == null) return fallback;
  if (button.isPrimaryStyle) return AppBottomSheetButtonStyle.filled;
  if (button.isSecondaryStyle) return AppBottomSheetButtonStyle.outlined;
  if (button.isTertiaryStyle) return AppBottomSheetButtonStyle.tertiary;
  return fallback;
}

void _run(BuildContext context, String? actionUrl) {
  Navigator.of(context).pop();
  if (actionUrl == null || actionUrl.isEmpty || actionUrl == 'DISMISS') return;
  ActionUrlHandler.navigate(context, actionUrl);
}
