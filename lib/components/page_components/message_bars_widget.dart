import 'package:flutter/material.dart';
import 'package:hs_app_flutter/components/atoms/custom_image.dart';
import 'package:hs_app_flutter/components/buttons/app_button_named.dart';
import 'package:hs_app_flutter/components/buttons/button_enums.dart';
import 'package:hs_app_flutter/core/extensions/string_extensions.dart';

import '../../core/constants/image_constants.dart';
import '../../core/constants/strings/auto_test_strings.dart';
import '../../core/entities/message_bar_entity.dart';
import '../../core/theme/colors.dart';
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
  final double spaceBetweenMessageBars;

  /// Screen-specific prefix for automation keys (e.g. `login`, `join_us`).
  /// When set, keys become `<keyPrefix>_<base>_<index>`.
  final String? keyPrefix;
  final (double, double)? iconSize;
  final TextStyle? textStyle;

  const MessageBarsWidget({
    super.key,
    required this.messageBars,
    this.cardStyle = false,
    this.onAction,
    this.keyPrefix,
    this.spaceBetweenMessageBars = 10,
    this.iconSize,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    if (messageBars.isEmpty) return const SizedBox.shrink();

    final visibleBars = messageBars.where((bar) {
      final display = bar.displayText;
      return display != null && display.isNotEmpty;
    }).toList();

    return Column(
      children: [
        for (var i = 0; i < visibleBars.length; i++)
          Padding(
            padding: EdgeInsets.symmetric(vertical: spaceBetweenMessageBars),
            child: _MessageBarItem(
              bar: visibleBars[i],
              cardStyle: cardStyle,
              onAction: onAction,
              index: i,
              keyPrefix: keyPrefix,
              iconSize: iconSize,
              textStyle: textStyle,
            ),
          ),
      ],
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
    _ => ImageConstants.messageBarInfo,
  };
}

// ─── Single message bar item ─────────────────────────────────────────────────

class _MessageBarItem extends StatefulWidget {
  final MessageBarEntity bar;
  final bool cardStyle;
  final MessageBarActionCallback? onAction;
  final int index;
  final String? keyPrefix;
  final (double, double)? iconSize;
  final TextStyle? textStyle;

  const _MessageBarItem({
    required this.bar,
    required this.cardStyle,
    required this.index,
    this.onAction,
    this.keyPrefix,
    this.iconSize,
    this.textStyle,
  });

  @override
  State<_MessageBarItem> createState() => _MessageBarItemState();
}

class _MessageBarItemState extends State<_MessageBarItem> {
  bool _dismissed = false;

  /// Builds an automation key: `<keyPrefix>_<base>_<index>`, or `<base>_<index>`
  /// when no screen prefix is supplied.
  ValueKey<String> _key(String base) {
    final prefix = widget.keyPrefix;
    final name = prefix == null ? base : '${prefix}_$base';
    return ValueKey('${name}_${widget.index}');
  }

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
    final textColor = bar.textColor.toColorOr(AppColors.neutralBlack);

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
                _buildIcon(bar, type, textColor, widget.iconSize),
                const SizedBox(width: _kIconSpacing),
              ],
              Expanded(
                child: hasTwoButtons
                    ? _buildPlainMessage(bar, textColor, widget.textStyle)
                    : _buildMessageWithInlineAction(bar, textColor, widget.textStyle),
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

  Widget _buildIcon(
    MessageBarEntity bar,
    _MessageBarType type,
    Color tintColor,
    (double, double)? iconSize,
  ) {
    if (type == _MessageBarType.custom) {
      return (bar.icon ?? '').contains('http')
          ? CustomImage(
              height: iconSize?.$1,
              width: iconSize?.$2,
              path: bar.icon ?? '',
              placeholder: const Icon(Icons.info),
              errorWidget: const Icon(Icons.info),
            )
          : const Icon(Icons.info);
    }

    return Padding(
      padding: const EdgeInsets.only(top: 1),
      child: CustomImage(
        path: _typeIconAsset(type)!,
        width: _kIconSize,
        height: _kIconSize,
        placeholder: const SizedBox.shrink(),
        errorWidget: const CustomImage(path: ImageConstants.messageBarInfo),
      ),
    );
  }

  // ─── Message text ────────────────────────────────────────────────────────

  TextStyle _messageTextStyle(Color textColor) =>
      AppTypographyV1.labelMedium.regular.copyWith(color: textColor);

  TextStyle get _actionTextStyle =>
      AppTypographyV1.labelMedium.bold.copyWith(color: AppColors.brandSecondary);

  Widget _buildPlainMessage(MessageBarEntity bar, Color textColor, TextStyle? textStyle) {
    return Text(
      bar.displayText!,
      key: _key(MessageBarTestStrings.messageBarMessageTextField),
      style: textStyle ?? _messageTextStyle(textColor),
    );
  }

  /// Message with optional action text stacked below.
  Widget _buildMessageWithInlineAction(
    MessageBarEntity bar,
    Color textColor,
    TextStyle? textStyle,
  ) {
    if (!bar.actionText.isNotNullOrEmpty) {
      return _buildPlainMessage(bar, textColor, textStyle);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          bar.displayText!,
          key: _key(MessageBarTestStrings.messageBarMessageTextField),
          style: textStyle ?? _messageTextStyle(textColor),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () => _handleAction(bar.actionLink),
          key: _key(MessageBarTestStrings.messageBarActionButton),
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
          child: SecondaryButton.defaultType(
            size: ButtonSize.medium,
            text: bar.actionText!,
            key: _key(MessageBarTestStrings.messageBarLeftButton),
            onTap: () => _handleAction(bar.actionLink),
          ),
        ),
        const SizedBox(width: 16),
        // Right button — filled (secondary color bg)
        Expanded(
          child: PrimaryButton.defaultType(
            text: bar.actionTextRight!,
            size: ButtonSize.medium,
            key: _key(MessageBarTestStrings.messageBarRightButton),
            onTap: () => _handleAction(bar.actionLinkRight),
          ),
        ),
      ],
    );
  }
}
