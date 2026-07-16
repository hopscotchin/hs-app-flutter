import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_entity.freezed.dart';

@freezed
abstract class MediaEntity with _$MediaEntity {
  const factory MediaEntity({
    int? height,
    String? mimeType,
    String? url,
    int? width,
  }) = _MediaEntity;
}
