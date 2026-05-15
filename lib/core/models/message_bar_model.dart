import '../entities/message_bar_entity.dart';

class MessageBarModel extends MessageBarEntity {
  const MessageBarModel({
    super.text,
    super.bgColor,
    super.textColor,
    super.type,
    super.message,
    super.alertMessage,
    super.messageType,
    super.actionLink,
    super.actionText,
    super.actionTextRight,
    super.actionLinkRight,
    super.isCriticalMessage,
    super.hasIcon,
    super.icon,
    super.redirectLink,
  });

  factory MessageBarModel.fromJson(Map<String, dynamic> json) {
    return MessageBarModel(
      text: json['text'] as String?,
      bgColor: json['bgColor'] as String? ?? json['backgroundColor'] as String?,
      textColor: json['textColor'] as String?,
      type: json['type'] as String?,
      message: json['message'] as String?,
      alertMessage: json['alertMessage'] as String?,
      messageType: json['messageType'] as String?,
      actionLink: json['actionLink'] as String?,
      actionText: json['actionText'] as String?,
      actionTextRight: json['actionTextRight'] as String?,
      actionLinkRight: json['actionLinkRight'] as String?,
      isCriticalMessage: json['isCriticalMessage'] as bool? ?? false,
      hasIcon: json['hasIcon'] as bool? ?? false,
      icon: json['icon'] as String?,
      redirectLink: json['redirectLink'] as String?,
    );
  }
}
