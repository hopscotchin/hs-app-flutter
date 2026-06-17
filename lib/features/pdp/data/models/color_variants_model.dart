import '../../domain/entities/color_variants_entity.dart';

class ColorVariantsModel extends ColorVariantsEntity {
  const ColorVariantsModel({
    super.heading,
    super.mediaMetaData,
    super.variants,
  });

  factory ColorVariantsModel.fromJson(Map<String, dynamic> json) {
    return ColorVariantsModel(
      heading: json['heading'] as String?,
      mediaMetaData: json['mediaMetaData'] != null
          ? MediaMetaDataModel.fromJson(
              json['mediaMetaData'] as Map<String, dynamic>,
            )
          : null,
      variants:
          (json['variants'] as List<dynamic>?)
              ?.map(
                (e) => ColorVariantModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );
  }
}

class ColorVariantModel extends ColorVariantEntity {
  const ColorVariantModel({super.productId, super.colors, super.mediaUrl});

  factory ColorVariantModel.fromJson(Map<String, dynamic> json) {
    return ColorVariantModel(
      productId: json['productId'] as int?,
      colors:
          (json['colors'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      mediaUrl: json['mediaUrl'] as String?,
    );
  }
}

class MediaMetaDataModel extends MediaMetaDataEntity {
  const MediaMetaDataModel({super.width, super.height});

  factory MediaMetaDataModel.fromJson(Map<String, dynamic> json) {
    return MediaMetaDataModel(
      width: json['width'] as int?,
      height: json['height'] as int?,
    );
  }
}
