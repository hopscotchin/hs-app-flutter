import 'package:flutter/material.dart';
import 'package:hs_app_flutter/components/atoms/custom_image.dart';
import 'package:hs_app_flutter/core/extensions/string_extensions.dart';

import '../../core/constants/image_constants.dart';
import '../../core/entities/message_bar_entity.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../core/theme/typography/text_style_extensions.dart';
import '../../core/theme/typography/typography_v1.dart';

// ─── Compact style constants ─────────────────────────────────────────────────

const _kContentPadding = EdgeInsets.symmetric(horizontal: 12, vertical: 16);
const _kIconSize = 20.0;
const _kIconSpacing = 12.0;

/// Callback when an action link is tapped on a message bar.
/// [actionLink] is the link string, [messageBar] is the source entity.
typedef MessageBarActionCallback = void Function(String? actionLink, MessageBarEntity messageBar);

/// Renders a list of [MessageBarEntity] items.
class MessageBarsWidget extends StatelessWidget {
  final List<MessageBarEntity> messageBars;

  /// When true, renders bars as cards with rounded corners.
  /// When false (default), renders as full-width strips.
  final bool cardStyle;

  /// Optional callback when an action link is tapped.
  final MessageBarActionCallback? onAction;

  const MessageBarsWidget({
    super.key,
    required this.messageBars,
    this.cardStyle = false,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    if (messageBars.isEmpty) return const SizedBox.shrink();

    return Column(
      children: messageBars
          .where((bar) {
            final display = bar.displayText;
            return display != null && display.isNotEmpty;
          })
          .map((bar) => _MessageBarItem(bar: bar, cardStyle: cardStyle, onAction: onAction))
          .toList(),
    );
  }
}

// ─── Type enum matching Android MessageBarType ───────────────────────────────

enum _MessageBarType { error, info, success, warning, custom }

_MessageBarType _resolveType(MessageBarEntity bar) {
  final type = bar.messageType?.toLowerCase() ?? bar.type?.toLowerCase();
  return switch (type) {
    'error' => _MessageBarType.error,
    'info' => _MessageBarType.info,
    'success' => _MessageBarType.success,
    'warning' => _MessageBarType.warning,
    _ => _MessageBarType.custom,
  };
}

// ─── Type-specific defaults ──────────────────────────────────────────────────

Color _defaultBgColor(_MessageBarType type) {
  return switch (type) {
    _MessageBarType.error => AppColors.brandTertiary,
    _MessageBarType.info => AppColors.onInfo,
    _MessageBarType.success => AppColors.onSuccess,
    _MessageBarType.warning => AppColors.onWarning,
    _MessageBarType.custom => const Color(0xFFF5F5F5),
  };
}

/// SVG asset path for the type-specific icon. Custom type falls back to the
/// network icon provided by the entity, so this returns null.
String? _typeIconAsset(_MessageBarType type) {
  return switch (type) {
    _MessageBarType.error => ImageConstants.messageBarError,
    _MessageBarType.info => ImageConstants.messageBarInfo,
    _MessageBarType.success => ImageConstants.messageBarSuccess,
    _MessageBarType.warning => ImageConstants.messageBarWarning,
    _MessageBarType.custom => null,
  };
}

// ─── Single message bar item ─────────────────────────────────────────────────

class _MessageBarItem extends StatefulWidget {
  final MessageBarEntity bar;
  final bool cardStyle;
  final MessageBarActionCallback? onAction;

  const _MessageBarItem({required this.bar, required this.cardStyle, this.onAction});

  @override
  State<_MessageBarItem> createState() => _MessageBarItemState();
}

class _MessageBarItemState extends State<_MessageBarItem> {
  bool _dismissed = false;

  void _handleAction(String? link) {
    if (link != null && link.toLowerCase() == 'dismiss') {
      setState(() => _dismissed = true);
    }
    widget.onAction?.call(link, widget.bar);
  }

  @override
  Widget build(BuildContext context) {
    if (_dismissed) return const SizedBox.shrink();

    final bar = widget.bar;
    final type = _resolveType(bar);

    // Resolve colors — API-provided values override type defaults.
    final bgColor = bar.bgColor?.toColor ?? _defaultBgColor(type);
    final textColor = bar.textColor.toColor ?? AppColors.neutralBlack;

    // Resolve icon visibility — typed bars always show their icon; custom bars
    // gate on the hasIcon flag and require a network icon to be present.
    final showIcon = type == _MessageBarType.custom
        ? (bar.hasIcon && bar.icon.isNotNullOrEmpty)
        : true;

    final hasTwoButtons = bar.actionText.isNotNullOrEmpty && bar.actionTextRight.isNotNullOrEmpty;

    final content = Padding(
      padding: _kContentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon + message row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (showIcon) ...[
                _buildIcon(bar, type, textColor),
                const SizedBox(width: _kIconSpacing),
              ],
              Expanded(
                child: hasTwoButtons
                    ? _buildPlainMessage(bar, textColor)
                    : _buildMessageWithInlineAction(bar, textColor),
              ),
            ],
          ),

          // Two-button row (when both actionText and actionTextRight exist)
          if (hasTwoButtons) ...[const SizedBox(height: 20), _buildTwoButtons(bar)],
        ],
      ),
    );

    if (widget.cardStyle) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(4)),
        child: content,
      );
    }

    return Container(width: double.infinity, color: bgColor, child: content);
  }

  // ─── Icon ────────────────────────────────────────────────────────────────

  Widget _buildIcon(MessageBarEntity bar, _MessageBarType type, Color tintColor) {
    if (type == _MessageBarType.custom) {
      return CustomImage(path: bar.icon!);
    }

    return Padding(
      padding: const EdgeInsets.only(top: 1),
      child: CustomImage(path: _typeIconAsset(type)!, width: _kIconSize, height: _kIconSize),
    );
  }

  // ─── Message text ────────────────────────────────────────────────────────

  TextStyle _messageTextStyle(Color textColor) =>
      AppTypographyV1.labelMedium.regular.copyWith(color: textColor);

  TextStyle get _actionTextStyle =>
      AppTypographyV1.labelMedium.bold.copyWith(color: AppColors.brandSecondary);

  Widget _buildPlainMessage(MessageBarEntity bar, Color textColor) {
    return Text(bar.displayText!, style: _messageTextStyle(textColor));
  }

  /// Message with optional action text stacked below.
  Widget _buildMessageWithInlineAction(MessageBarEntity bar, Color textColor) {
    if (!bar.actionText.isNotNullOrEmpty) {
      return _buildPlainMessage(bar, textColor);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(bar.displayText!, style: _messageTextStyle(textColor)),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () => _handleAction(bar.actionLink),
          child: Text(bar.actionText!, style: _actionTextStyle),
        ),
      ],
    );
  }

  // ─── Two-button layout ──────────────────────────────────────────────────

  Widget _buildTwoButtons(MessageBarEntity bar) {
    return Row(
      children: [
        // Left button — outlined (secondary color border)
        Expanded(
          child: _outlineButton(text: bar.actionText!, onTap: () => _handleAction(bar.actionLink)),
        ),
        const SizedBox(width: 16),
        // Right button — filled (secondary color bg)
        Expanded(
          child: _filledButton(
            text: bar.actionTextRight!,
            onTap: () => _handleAction(bar.actionLinkRight),
          ),
        ),
      ],
    );
  }

  Widget _outlineButton({required String text, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.secondary),
          borderRadius: BorderRadius.circular(4),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: AppTypography.labelLarge.copyWith(color: AppColors.secondary, letterSpacing: 0.04),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _filledButton({required String text, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(4),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: AppTypography.labelLarge.copyWith(color: Colors.white, letterSpacing: 0.04),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
