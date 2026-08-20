import 'package:flutter/material.dart';
import 'package:super_tooltip/super_tooltip.dart';

import '../core/entities/backend_action_entity.dart';
import '../core/extensions/string_extensions.dart';
import '../core/navigation/action_url_handler.dart';
import '../core/theme/colors.dart';
import 'app_bottom_sheet.dart';
import 'app_dialog.dart';

/// Wraps [child] with whatever interaction a backend-driven [action] calls
/// for — tooltip, bottom sheet, or dialog — so every call site that receives
/// this `{type, icon, content}` shape (price-summary info icons, cart-item
/// message bars, ...) shares one implementation instead of reinventing it.
///
/// Unknown/null [action] (or missing required content) renders [child]
/// unwrapped, with no interaction.
class ActionTrigger extends StatefulWidget {
  final BackendActionEntity? action;

  /// For tooltip actions, this is the *anchor* — the tooltip's arrow always
  /// points at wherever this widget renders, regardless of how much more
  /// content is wrapped around it via [tooltipBuilder]. Pass just the icon
  /// (not the whole row) to control precisely where the arrow shows up.
  final Widget child;

  /// Builds the actual tappable widget around the anchor — e.g. combine the
  /// anchor icon with adjacent label text so the whole row is tappable while
  /// the arrow still points only at the icon. `showTooltip` opens it
  /// programmatically; call it from a `GestureDetector`/`InkWell` anywhere
  /// in the returned widget (not just on [child] itself).
  ///
  /// Only consulted for tooltip actions. Ignored for bottomSheet/dialog,
  /// where [child] is already the whole tappable widget.
  final Widget Function(Widget anchor, VoidCallback showTooltip)? tooltipBuilder;

  // ── Tooltip positioning/spacing — tunable per call site ──────────────────
  // The arrow's horizontal position is NOT one of these: super_tooltip always
  // points it at wherever [child] actually sits on screen. To move the
  // arrow, change what you pass as [child] (see above) rather than these.
  final TooltipDirection tooltipDirection;
  final double tooltipVerticalOffset;
  final double tooltipArrowLength;
  final double tooltipArrowBaseWidth;
  final double? tooltipMaxWidth;

  const ActionTrigger({
    super.key,
    required this.action,
    required this.child,
    this.tooltipBuilder,
    this.tooltipDirection = TooltipDirection.up,
    this.tooltipVerticalOffset = 0,
    this.tooltipArrowLength = 12,
    this.tooltipArrowBaseWidth = 16,
    this.tooltipMaxWidth,
  });

  @override
  State<ActionTrigger> createState() => _ActionTriggerState();
}

class _ActionTriggerState extends State<ActionTrigger> {
  SuperTooltipController? _controller;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final action = widget.action;
    if (action == null) return widget.child;

    if (action.isTooltip && action.content?.text != null) {
      final hasBuilder = widget.tooltipBuilder != null;
      // Only needed when a builder decouples the tappable area from the
      // anchor — otherwise SuperTooltip's own built-in tap handling on
      // [child] is enough, no controller required.
      if (hasBuilder) _controller ??= SuperTooltipController();

      final anchor = SuperTooltip(
        controller: _controller,
        content: Text(
          action.content!.text!,
          style: TextStyle(color: action.content!.textColor.toColorOr(Colors.white), fontSize: 14),
        ),
        style: TooltipStyle(
          backgroundColor: action.content!.bgColor.toColorOr(AppColors.info),
          borderRadius: 8,
          borderColor: Colors.transparent,
          hasShadow: false,
        ),
        arrowConfig: ArrowConfiguration(
          length: widget.tooltipArrowLength,
          baseWidth: widget.tooltipArrowBaseWidth,
        ),
        positionConfig: PositionConfiguration(
          preferredDirection: widget.tooltipDirection,
          verticalOffset: widget.tooltipVerticalOffset,
        ),
        barrierConfig: const BarrierConfiguration(color: Colors.transparent),
        // Tapping the anchor alone still works even with a builder — both
        // paths drive the same controller, so either can open it.
        interactionConfig: const InteractionConfiguration(showOnTap: true),
        constraints: BoxConstraints(
          maxWidth: widget.tooltipMaxWidth ?? MediaQuery.sizeOf(context).width - 64,
        ),
        child: widget.child,
      );

      if (!hasBuilder) return anchor;
      return widget.tooltipBuilder!(anchor, () => _controller!.showTooltip());
    }

    if ((action.isBottomSheet || action.isDialog) && action.content?.description != null) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _show(context, action),
        child: widget.child,
      );
    }

    return widget.child;
  }

  void _show(BuildContext context, BackendActionEntity action) {
    final content = action.content!;
    if (action.isBottomSheet) {
      AppBottomSheet.show(
        context,
        title: content.title,
        description: content.description!,
        primaryAction: AppBottomSheetAction(
          label: content.leftAction?.label ?? 'Got It',
          style: _bottomSheetStyleFor(
            content.leftAction,
            fallback: AppBottomSheetButtonStyle.filled,
          ),
          onPressed: () => _runAction(context, content.leftAction?.actionUrl),
        ),
        secondaryAction: content.rightAction != null
            ? AppBottomSheetAction(
                label: content.rightAction!.label ?? 'Cancel',
                style: _bottomSheetStyleFor(
                  content.rightAction,
                  fallback: AppBottomSheetButtonStyle.outlined,
                ),
                onPressed: () => _runAction(context, content.rightAction!.actionUrl),
              )
            : null,
      );
      return;
    }

    AppDialog.show(
      context,
      title: content.title,
      description: content.description!,
      primaryAction: AppDialogAction(
        label: content.leftAction?.label ?? 'Got It',
        style: _dialogStyleFor(
          content.leftAction,
          fallback: AppDialogButtonStyle.filled,
        ),
        onPressed: () => _runAction(context, content.leftAction?.actionUrl),
      ),
      secondaryAction: content.rightAction != null
          ? AppDialogAction(
              label: content.rightAction!.label ?? 'Cancel',
              style: _dialogStyleFor(
                content.rightAction,
                fallback: AppDialogButtonStyle.outlined,
              ),
              onPressed: () => _runAction(context, content.rightAction!.actionUrl),
            )
          : null,
    );
  }

  // Backend-chosen `style` ("primary"/"secondary"/"tertiary") wins; a missing
  // or unrecognized value keeps the positional default (filled left, outlined
  // right) so existing payloads without a `style` render exactly as before.
  AppBottomSheetButtonStyle _bottomSheetStyleFor(
    BackendActionButtonEntity? button, {
    required AppBottomSheetButtonStyle fallback,
  }) {
    if (button == null) return fallback;
    if (button.isPrimaryStyle) return AppBottomSheetButtonStyle.filled;
    if (button.isSecondaryStyle) return AppBottomSheetButtonStyle.outlined;
    if (button.isTertiaryStyle) return AppBottomSheetButtonStyle.tertiary;
    return fallback;
  }

  AppDialogButtonStyle _dialogStyleFor(
    BackendActionButtonEntity? button, {
    required AppDialogButtonStyle fallback,
  }) {
    if (button == null) return fallback;
    if (button.isPrimaryStyle) return AppDialogButtonStyle.filled;
    if (button.isSecondaryStyle) return AppDialogButtonStyle.outlined;
    if (button.isTertiaryStyle) return AppDialogButtonStyle.tertiary;
    return fallback;
  }

  void _runAction(BuildContext context, String? actionUrl) {
    Navigator.of(context).pop();
    if (actionUrl == null || actionUrl.isEmpty || actionUrl == 'DISMISS') {
      return;
    }
    ActionUrlHandler.navigate(context, actionUrl);
  }
}
