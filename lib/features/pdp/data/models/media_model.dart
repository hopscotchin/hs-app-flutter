import '../../domain/entities/media_entity.dart';

class MediaModel extends MediaEntity {
  const MediaModel({super.height, super.mimeType, super.url, super.width});

  factory MediaModel.fromJson(Map<String, dynamic> json) {
    return MediaModel(
      height: json['height'] as int?,
      mimeType: json['mimeType'] as String?,
      url: json['url'] as String?,
      width: json['width'] as int?,
    );
  }
}
