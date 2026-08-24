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
    super.title,
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
      // Passed through as-is. Note some payloads echo the type marker here
      // (`"title": "custom"` beside `"messageType": "custom"`); those render
      // as a heading. Filter in the widget if that shows up in a design.
      title: json['title'] as String?,
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

  /// Collects the bars a response carries, from **either** wire key.
  ///
  /// Endpoints are inconsistent: some send a single `messageBar` object, some a
  /// `messageBars` array, a few send both. `messageBar` is taken first so the
  /// primary bar leads. Mirrors the order `ActionResponse.validate` uses when
  /// it packs bars onto an `ApiFailureException`, so an error surfaced through
  /// either route reads the same.
  static List<MessageBarEntity> collectFrom(Map<String, dynamic> json) {
    final bars = <MessageBarEntity>[];
    final single = json['messageBar'];
    if (single is Map<String, dynamic>) bars.add(MessageBarModel.fromJson(single));
    final many = json['messageBars'];
    if (many is List) {
      bars.addAll(many.whereType<Map<String, dynamic>>().map(MessageBarModel.fromJson));
    }
    return bars;
  }
}
