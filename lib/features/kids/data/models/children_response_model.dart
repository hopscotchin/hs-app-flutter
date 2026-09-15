import '../../domain/entities/kids_list_content_entity.dart';
import 'child_model.dart';
import 'kids_list_content_model.dart';

/// `GET v2/questionnaire/list` response. The live envelope wraps the array
/// under a `children` key.
///
/// `content` is a newly-proposed sibling object (not yet shipped either —
/// see §3) carrying the My Kids list screen's backend-driven copy + footer
/// avatar images; missing entirely from today's live response, so it always
/// resolves via [KidsListContentModel.fromJson]'s fallback when absent.
class ChildrenResponseModel {
  const ChildrenResponseModel({
    required this.action,
    this.message,
    required this.children,
    required this.content,
  });

  final String? action;
  final String? message;
  final List<ChildModel> children;
  final KidsListContentEntity content;

  bool get isSuccessful => action?.toLowerCase() == 'success';

  factory ChildrenResponseModel.fromJson(Map<String, dynamic> json) {
    final list = (json['children'] as List<dynamic>?) ?? const [];
    return ChildrenResponseModel(
      action: json['action'] as String?,
      message: json['message'] as String?,
      children: list.map((e) => ChildModel.fromJson(e as Map<String, dynamic>)).toList(),
      content: KidsListContentModel.fromJson(json['content'] as Map<String, dynamic>?),
    );
  }
}
