import '../../domain/entities/listing_header_entity.dart';

class ListingHeaderModel extends ListingHeaderEntity {
  const ListingHeaderModel({
    super.id,
    super.name,
    super.bannerImageUrl,
    super.bannerImageHeight,
    super.bannerImageWidth,
    super.description,
    super.tagline,
  });

  factory ListingHeaderModel.fromJson(Map<String, dynamic> json) {
    return ListingHeaderModel(
      id: json['id']?.toString(),
      name: json['name'] as String?,
      bannerImageUrl: json['bannerImageUrl'] as String?,
      bannerImageHeight: (json['bannerImageHeight'] as num?)?.toInt(),
      bannerImageWidth: (json['bannerImageWidth'] as num?)?.toInt(),
      description: json['description'] as String?,
      tagline: json['tagline'] as String?,
    );
  }
}
