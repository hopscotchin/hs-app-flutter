import '../../domain/entities/department_entity.dart';

class DepartmentModel extends DepartmentEntity {
  const DepartmentModel({
    required super.id,
    required super.label,
    super.imageUrl,
    super.actionUrl,
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    final labelData = json['label'];
    final label = labelData is Map<String, dynamic>
        ? (labelData['name'] as String? ?? '')
        : (labelData as String? ?? '');

    return DepartmentModel(
      id: json['id']?.toString() ?? '',
      label: label,
      imageUrl: json['imageUrl'] as String? ?? json['image'] as String?,
      actionUrl: json['actionUrl'] as String? ?? json['action'] as String?,
    );
  }
}
