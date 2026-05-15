import '../../domain/entities/plp_config_entity.dart';

class PlpConfigModel extends PlpConfigEntity {
  const PlpConfigModel({super.topBanner});

  factory PlpConfigModel.fromJson(Map<String, dynamic> json) {
    final topBannerJson = json['topBanner'] as Map<String, dynamic>?;
    return PlpConfigModel(
      topBanner: topBannerJson != null
          ? TopBannerModel.fromJson(topBannerJson)
          : null,
    );
  }
}

class TopBannerModel extends TopBannerEntity {
  const TopBannerModel({super.url, super.mimeType});

  factory TopBannerModel.fromJson(Map<String, dynamic> json) {
    return TopBannerModel(
      url: json['url'] as String?,
      mimeType: json['mimeType'] as String?,
    );
  }
}
