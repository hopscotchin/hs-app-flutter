import '../../../../core/network/models/action_response.dart';
import 'department_model.dart';

class DepartmentResponseModel extends ActionResponse {
  final List<DepartmentModel> departments;

  const DepartmentResponseModel({required this.departments});

  DepartmentResponseModel.fromJson(super.json)
      : departments = _parseDepartments(json),
        super.fromJson();

  static List<DepartmentModel> _parseDepartments(Map<String, dynamic> json) {
    final rawList = json['departmentData'] as List<dynamic>? ??
        json['departments'] as List<dynamic>? ??
        json['data'] as List<dynamic>? ??
        [];
    return rawList
        .map((e) => DepartmentModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  List<Object?> get props => [action, departments];
}
