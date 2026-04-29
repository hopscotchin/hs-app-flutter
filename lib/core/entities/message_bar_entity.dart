import 'package:equatable/equatable.dart';

class MessageBarEntity extends Equatable {
  final String? text;
  final String? bgColor;
  final String? textColor;
  final String? type;
  final String? message;
  final String? alertMessage;
  final String? messageType;
  final String? actionLink;
  final String? actionText;
  final String? actionTextRight;
  final String? actionLinkRight;
  final bool isCriticalMessage;
  final bool hasIcon;
  final String? icon;

  const MessageBarEntity({
    this.text,
    this.bgColor,
    this.textColor,
    this.type,
    this.message,
    this.alertMessage,
    this.messageType,
    this.actionLink,
    this.actionText,
    this.actionTextRight,
    this.actionLinkRight,
    this.isCriticalMessage = false,
    this.hasIcon = false,
    this.icon,
  });

  /// Returns the display text, preferring [text] over [message] over [alertMessage].
  String? get displayText => text ?? message ?? alertMessage;

  @override
  List<Object?> get props => [
        text,
        bgColor,
        textColor,
        type,
        message,
        alertMessage,
        messageType,
        actionLink,
        actionText,
        actionTextRight,
        actionLinkRight,
        isCriticalMessage,
        hasIcon,
        icon,
      ];
}
