import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/image_constants.dart';
import '../../core/entities/message_bar_entity.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../core/theme/typography/text_style_extensions.dart';
import '../../core/theme/typography/typography_v1.dart';

/// Controls the visual density and typography of [MessageBarsWidget].
///
/// Use [MessageBarsStyle.standard] for the default full-width style and
/// [MessageBarsStyle.compact] for tighter padding and smaller typography.
class MessageBarsStyle {
  final EdgeInsets contentPadding;
  final double iconSize;
  final double iconSpacing;

  /// Base text style for the message body — color is applied per-bar at render time.
  final TextStyle messageStyle;

  /// Fully resolved text style for the action link, including color.
  final TextStyle actionStyle;

  /// When true, the action link is rendered below the message (stacked).
  /// When false, it is inlined as a span within the message.
  final bool stackedAction;

  /// Override background color for error-type bars. Null uses the default.
  final Color? errorBgColor;

  MessageBarsStyle({
    required this.contentPadding,
    required this.iconSize,
    required this.iconSpacing,
    required this.messageStyle,
    required this.actionStyle,
    required this.stackedAction,
    this.errorBgColor,
  });

  static MessageBarsStyle standard() => MessageBarsStyle(
    contentPadding: const EdgeInsets.all(16),
    iconSize: 18,
    iconSpacing: 16,
    messageStyle: AppTypography.bodyMedium,
    actionStyle: AppTypography.bodyMedium.copyWith(
      color: AppColors.secondary,
      fontWeight: AppTypography.semiBold,
    ),
    stackedAction: false,
  );

  static MessageBarsStyle compact() => MessageBarsStyle(
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    iconSize: 20,
    iconSpacing: 12,
    messageStyle: AppTypographyV1.labelMedium.regular,
    actionStyle: AppTypographyV1.labelMedium.bold.copyWith(color: AppColors.brandSecondary),
    stackedAction: true,
    errorBgColor: AppColors.brandTertiary,
  );
}

/// Callback when an action link is tapped on a message bar.
/// [actionLink] is the link string, [messageBar] is the source entity.
typedef MessageBarActionCallback = void Function(String? actionLink, MessageBarEntity messageBar);

/// Renders a list of [MessageBarEntity] items.
class MessageBarsWidget extends StatelessWidget {
  final List<MessageBarEntity> messageBars;

  /// When true, renders bars as cards with margin and rounded corners.
  /// When false (default), renders as full-width strips.
  final bool cardStyle;

  /// Optional callback when an action link is tapped.
  final MessageBarActionCallback? onAction;

  /// Visual style controlling padding, typography, and colors.
  /// Defaults to [MessageBarsStyle.standard] when null.
  final MessageBarsStyle? style;

  const MessageBarsWidget({
    super.key,
    required this.messageBars,
    this.cardStyle = false,
    this.onAction,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    if (messageBars.isEmpty) return const SizedBox.shrink();

    final resolvedStyle = style ?? MessageBarsStyle.standard();
    return Column(
      children: messageBars
          .where((bar) {
            final display = bar.displayText;
            return display != null && display.isNotEmpty;
          })
          .map(
            (bar) => _MessageBarItem(
              bar: bar,
              cardStyle: cardStyle,
              style: resolvedStyle,
              onAction: onAction,
            ),
          )
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

Color _defaultBgColor(_MessageBarType type, MessageBarsStyle style) {
  if (style.errorBgColor != null && type == _MessageBarType.error) {
    return style.errorBgColor!;
  }
  return switch (type) {
    _MessageBarType.error => AppColors.onError,
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
  final MessageBarsStyle style;
  final MessageBarActionCallback? onAction;

  const _MessageBarItem({
    required this.bar,
    required this.cardStyle,
    required this.style,
    this.onAction,
  });

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
    final bgColor = _parseColor(bar.bgColor) ?? _defaultBgColor(type, widget.style);
    final textColor = _parseColor(bar.textColor) ?? AppColors.neutralBlack;

    // Resolve icon visibility — type-specific bars always show their asset;
    // custom bars only show when the entity provides a network icon.
    final showIcon = type == _MessageBarType.custom ? _isNotEmpty(bar.icon) : true;

    final hasTwoButtons = _isNotEmpty(bar.actionText) && _isNotEmpty(bar.actionTextRight);

    final content = Padding(
      padding: widget.style.contentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon + message row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (showIcon) ...[
                _buildIcon(bar, type, textColor),
                SizedBox(width: widget.style.iconSpacing),
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
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(4)),
        child: content,
      );
    }

    return Container(width: double.infinity, color: bgColor, child: content);
  }

  // ─── Icon ────────────────────────────────────────────────────────────────

  Widget _buildIcon(MessageBarEntity bar, _MessageBarType type, Color tintColor) {
    if (type == _MessageBarType.custom) {
      return Image.network(
        bar.icon!,
        width: widget.style.iconSize,
        height: widget.style.iconSize,
        errorBuilder: (_, _, _) =>
            Icon(Icons.info_outline, size: widget.style.iconSize, color: tintColor),
      );
    }

    final size = widget.style.iconSize;
    return Padding(
      padding: const EdgeInsets.only(top: 1),
      child: SvgPicture.asset(
        _typeIconAsset(type)!,
        width: size,
        height: size,
      ),
    );
  }

  // ─── Message text ────────────────────────────────────────────────────────

  TextStyle _messageTextStyle(Color textColor) =>
      widget.style.messageStyle.copyWith(color: textColor);

  Widget _buildPlainMessage(MessageBarEntity bar, Color textColor) {
    return Text(bar.displayText!, style: _messageTextStyle(textColor));
  }

  /// Message with optional inline action text appended (Android spannable style).
  Widget _buildMessageWithInlineAction(MessageBarEntity bar, Color textColor) {
    if (!_isNotEmpty(bar.actionText)) {
      return _buildPlainMessage(bar, textColor);
    }

    final actionStyle = widget.style.actionStyle;

    if (widget.style.stackedAction) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(bar.displayText!, style: _messageTextStyle(textColor)),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () => _handleAction(bar.actionLink),
            child: Text(bar.actionText!, style: actionStyle),
          ),
        ],
      );
    }

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: bar.displayText!, style: _messageTextStyle(textColor)),
          const TextSpan(text: ' '),
          TextSpan(
            text: bar.actionText!,
            style: actionStyle,
            recognizer: TapGestureRecognizer()..onTap = () => _handleAction(bar.actionLink),
          ),
        ],
      ),
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

  // ─── Helpers ─────────────────────────────────────────────────────────────

  static bool _isNotEmpty(String? s) => s != null && s.isNotEmpty;

  static Color? _parseColor(String? colorStr) {
    if (colorStr == null || colorStr.isEmpty) return null;
    try {
      var hex = colorStr.replaceFirst('#', '');
      if (hex.length == 6) hex = 'FF$hex';
      return Color(int.parse(hex, radix: 16));
    } catch (_) {
      return null;
    }
  }
}
