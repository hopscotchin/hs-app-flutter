import '../../../../core/network/models/action_response.dart';
import 'moment_model.dart';

class MomentResponseModel extends ActionResponse {
  final List<MomentModel> moments;

  const MomentResponseModel({required this.moments});

  MomentResponseModel.fromJson(super.json)
      : moments = _parseMoments(json),
        super.fromJson();

  static List<MomentModel> _parseMoments(Map<String, dynamic> json) {
    final rawList = json['momentsPhotos'] as List<dynamic>? ??
        json['photos'] as List<dynamic>? ??
        json['data'] as List<dynamic>? ??
        [];
    return rawList
        .map((e) => MomentModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  List<Object?> get props => [action, moments];
}
