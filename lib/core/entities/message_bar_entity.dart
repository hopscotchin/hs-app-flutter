import 'package:equatable/equatable.dart';

class MessageBarEntity extends Equatable {
  final String? text;
  final String? bgColor;
  final String? textColor;
  final String? type;
  final String? message;
  final String? alertMessage;
  final String? messageType;

  /// Optional heading rendered above [displayText]. May be plain text or the
  /// same small HTML subset as the message.
  ///
  /// Not simply `json['title']`: several live payloads (the cart credits bar
  /// among them) send `"title": "custom"` as a duplicate of [messageType], so
  /// the model filters those out. See `MessageBarModel.fromJson`.
  final String? title;
  final String? actionLink;
  final String? actionText;
  final String? actionTextRight;
  final String? actionLinkRight;
  final bool isCriticalMessage;
  final bool hasIcon;
  final String? icon;
  final String? redirectLink;

  const MessageBarEntity({
    this.text,
    this.bgColor,
    this.textColor,
    this.type,
    this.message,
    this.alertMessage,
    this.messageType,
    this.title,
    this.actionLink,
    this.actionText,
    this.actionTextRight,
    this.actionLinkRight,
    this.isCriticalMessage = false,
    this.hasIcon = false,
    this.icon,
    this.redirectLink,
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
    title,
    actionLink,
    actionText,
    actionTextRight,
    actionLinkRight,
    isCriticalMessage,
    hasIcon,
    icon,
    redirectLink,
  ];
}
