import 'child_model.dart';

/// `POST v3/questionnaire/save-and-update` response — the saved child's own
/// fields sit nested under a singular `child` key alongside the envelope
/// (`action`/`message`).
class ChildMutationResponseModel {
  const ChildMutationResponseModel({required this.action, this.message, this.child});

  final String? action;
  final String? message;
  final ChildModel? child;

  bool get isSuccessful => action?.toLowerCase() == 'success';

  factory ChildMutationResponseModel.fromJson(Map<String, dynamic> json) {
    final child = json['child'] as Map<String, dynamic>?;
    return ChildMutationResponseModel(
      action: json['action'] as String?,
      message: json['message'] as String?,
      child: child != null ? ChildModel.fromJson(child) : null,
    );
  }
}
