import '../../../../../core/network/api_client.dart';
import '../../../../../core/constants/api_constants.dart';
import '../../models/department_response_model.dart';

abstract class CategoriesRemoteDataSource {
  Future<DepartmentResponseModel> getDepartments();
}

class CategoriesRemoteDataSourceImpl implements CategoriesRemoteDataSource {
  final ApiClient apiClient;

  CategoriesRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<DepartmentResponseModel> getDepartments() async {
    final response = await apiClient.get(ApiConstants.loadDepartments);
    return DepartmentResponseModel.fromJson(
        response.data as Map<String, dynamic>);
  }
}
