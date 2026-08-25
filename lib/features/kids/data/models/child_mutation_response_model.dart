import 'child_model.dart';

/// `POST v2/questionnaire/save-and-update` response — today the saved
/// child's own fields sit flat at the response root alongside the envelope
/// (`action`/`message`), matching the live `ActionResponse`/`ChildInfoDTO`
/// shape. PROFILE_KIDS_API_CONTRACT.md §3 proposes wrapping this under a
/// singular `child` key instead — swap the parsing here once that ships.
class ChildMutationResponseModel {
  const ChildMutationResponseModel({required this.action, this.message, this.child});

  final String? action;
  final String? message;
  final ChildModel? child;

  bool get isSuccessful => action?.toLowerCase() == 'success';

  factory ChildMutationResponseModel.fromJson(Map<String, dynamic> json) {
    return ChildMutationResponseModel(
      action: json['action'] as String?,
      message: json['message'] as String?,
      child: json['id'] != null ? ChildModel.fromJson(json) : null,
    );
  }
}
