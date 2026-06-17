import 'package:equatable/equatable.dart';

class ListingHeaderEntity extends Equatable {
  final String? id;
  final String? name;
  final String? bannerImageUrl;
  final int? bannerImageHeight;
  final int? bannerImageWidth;
  final String? description;
  final String? tagline;

  const ListingHeaderEntity({
    this.id,
    this.name,
    this.bannerImageUrl,
    this.bannerImageHeight,
    this.bannerImageWidth,
    this.description,
    this.tagline,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    bannerImageUrl,
    bannerImageHeight,
    bannerImageWidth,
    description,
    tagline,
  ];
}
