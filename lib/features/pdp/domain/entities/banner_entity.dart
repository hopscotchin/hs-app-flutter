import 'package:equatable/equatable.dart';

import 'media_entity.dart';

class BannerEntity extends Equatable {
  final String? actionUri;
  final String? id;
  final MediaEntity? media;
  final int? position;

  const BannerEntity({this.actionUri, this.id, this.media, this.position});

  @override
  List<Object?> get props => [actionUri, id, media, position];
}
