import '../../../../../core/network/api_client.dart';
import '../../../../../core/constants/api_constants.dart';
import '../../models/categories_page_response_model.dart';
import 'package:injectable/injectable.dart';

abstract class CategoriesRemoteDataSource {
  Future<CategoriesPageResponseModel> getCategoriesPage();
}

@LazySingleton(as: CategoriesRemoteDataSource)
class CategoriesRemoteDataSourceImpl implements CategoriesRemoteDataSource {
  final ApiClient apiClient;

  CategoriesRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<CategoriesPageResponseModel> getCategoriesPage() async {
    final response = await apiClient.get(ApiConstants.categoriesPage);
    return CategoriesPageResponseModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }
}
