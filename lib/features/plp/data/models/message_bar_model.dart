import '../../domain/entities/message_bar_entity.dart';

class MessageBarModel extends MessageBarEntity {
  const MessageBarModel({
    super.icon,
    super.message,
    super.messageType,
    super.backgroundColor,
    super.hasIcon,
  });

  factory MessageBarModel.fromJson(Map<String, dynamic> json) {
    return MessageBarModel(
      icon: json['icon'] as String?,
      message: json['message'] as String?,
      messageType: json['messageType'] as String?,
      backgroundColor: json['backgroundColor'] as String?,
      hasIcon: json['hasIcon'] as bool? ?? (json['icon'] != null),
    );
  }
}
