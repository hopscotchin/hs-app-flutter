import '../../domain/entities/banner_entity.dart';
import 'media_model.dart';

class BannerModel extends BannerEntity {
  const BannerModel({super.actionUri, super.id, super.media, super.position});

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      actionUri: json['actionUri'] as String?,
      id: json['id']?.toString(),
      media: json['media'] != null
          ? MediaModel.fromJson(json['media'] as Map<String, dynamic>)
          : null,
      position: int.tryParse(json['position']?.toString() ?? ''),
    );
  }
}
