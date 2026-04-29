import '../../../../../core/network/api_client.dart';
import '../../../../../core/constants/api_constants.dart';
import '../../models/moment_model.dart';
import '../../models/moment_response_model.dart';

abstract class MomentsRemoteDataSource {
  Future<MomentResponseModel> getMoments({int page = 0});
  Future<MomentModel> likeMoment(String momentId);
}

class MomentsRemoteDataSourceImpl implements MomentsRemoteDataSource {
  final ApiClient apiClient;

  MomentsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<MomentResponseModel> getMoments({int page = 0}) async {
    final response = await apiClient.get(
      ApiConstants.momentsFeed,
      queryParameters: {'page': page},
    );
    return MomentResponseModel.fromJson(
        response.data as Map<String, dynamic>);
  }

  @override
  Future<MomentModel> likeMoment(String momentId) async {
    final response = await apiClient.post(
      '${ApiConstants.momentsLike}/$momentId/like',
    );
    return MomentModel.fromJson(response.data as Map<String, dynamic>);
  }
}
