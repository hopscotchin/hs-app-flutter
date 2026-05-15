import 'package:equatable/equatable.dart';

import '../../entities/message_bar_entity.dart';
import '../../error/exceptions.dart';
import '../../models/message_bar_model.dart';

/// Deprecated: extending this class in models and entities is being phased out.
/// Instead, declare only the fields your feature needs (action, messageBars,
/// popUpMessage) directly in the model and entity.
/// The static [validate] method may still be used as a standalone utility.
@Deprecated(
  'Extend ActionResponse is being phased out. '
  'Declare only needed response fields (action, messageBars, popUpMessage) directly. '
  'Use ActionResponse.validate() as a standalone call if needed.',
)
abstract class ActionResponse extends Equatable {
  static const String success = 'success';
  static const String failure = 'failure';

  final String? action;
  final String? message;
  final String? actionURI;
  final String? errorType;
  final String? errorMsg;
  final String? displayType;
  final String? actionText;
  final int? sessionId;
  final String? userType;
  final String? popUpMessage;
  final MessageBarEntity? messageBar;
  final List<MessageBarEntity> messageBars;

  const ActionResponse({
    this.action,
    this.message,
    this.actionURI,
    this.errorType,
    this.errorMsg,
    this.displayType,
    this.actionText,
    this.sessionId,
    this.userType,
    this.popUpMessage,
    this.messageBar,
    this.messageBars = const [],
  });

  /// Generative constructor that auto-parses base fields from JSON.
  /// Child classes call `super.fromJson(json)` so they never need to
  /// manually forward action, message, etc. — just like plain Kotlin.
  ActionResponse.fromJson(Map<String, dynamic> json)
    : action = json['action'] as String?,
      message = json['message'] is String ? json['message'] as String : null,
      actionURI = json['actionURI'] as String?,
      errorType = json['errorType'] as String?,
      errorMsg = json['errorMsg'] as String?,
      displayType = json['displayType'] as String?,
      actionText = json['actionText'] as String?,
      sessionId = json['sessionId'] is int
          ? json['sessionId'] as int
          : int.tryParse(json['sessionId']?.toString() ?? ''),
      userType = json['userType'] as String?,
      popUpMessage = json['popUpMessage'] as String?,
      messageBar = json['messageBar'] != null
          ? MessageBarModel.fromJson(json['messageBar'] as Map<String, dynamic>)
          : null,
      messageBars =
          (json['messageBars'] as List<dynamic>?)
              ?.map((e) => MessageBarModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [];

  bool get isSuccessful =>
      action != null && action!.toLowerCase() == ActionResponse.success;

  /// Validates the response action. Throws [ApiFailureException] when the
  /// API explicitly returns a non-success action.
  static Map<String, dynamic> validate(Map<String, dynamic> json) {
    final action = json['action'] as String?;
    if (action != null && action.toLowerCase() != success) {
      final message =
          json['message'] as String? ??
          json['errorMessage'] as String? ??
          json['errorMsg'] as String? ??
          'Uh-oh! Request failed. Please try again.';

      final List<dynamic> rawBars = [];
      if (json['messageBar'] is Map<String, dynamic>) {
        rawBars.add(json['messageBar']);
      }
      if (json['messageBars'] is List) {
        rawBars.addAll(json['messageBars'] as List);
      }

      throw ApiFailureException(message: message, rawMessageBars: rawBars);
    }
    return json;
  }
}
