import 'package:json_annotation/json_annotation.dart';

import '../../../../core/utils/json_parsers.dart';

part 'media_item_model.g.dart';

/// One entry in `records[].media[]`. Each entry has a `mimeType` of
/// `IMAGE` or `VIDEO`. PLP currently renders only `IMAGE` entries
/// (see `ListingProductModel.toEntity` — it filters to images for the
/// `imageUrls` field). Parsing remains future-proof: videos are
/// preserved in the model so an autoplay-in-tile feature can be added
/// without re-touching the data layer.
@JsonSerializable(createToJson: false)
class MediaItemModel {
  const MediaItemModel({this.mimeType, this.url});

  @JsonKey(fromJson: parseToStringOrNull)
  final String? mimeType;
  @JsonKey(fromJson: parseToStringOrNull)
  final String? url;

  factory MediaItemModel.fromJson(Map<String, dynamic> json) =>
      _$MediaItemModelFromJson(json);

  bool get isImage => mimeType?.toUpperCase() == 'IMAGE';
  bool get isVideo => mimeType?.toUpperCase() == 'VIDEO';
}
