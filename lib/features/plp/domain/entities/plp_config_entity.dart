import 'package:equatable/equatable.dart';

class PlpConfigEntity extends Equatable {
  final TopBannerEntity? topBanner;

  const PlpConfigEntity({this.topBanner});

  @override
  List<Object?> get props => [topBanner];
}

class TopBannerEntity extends Equatable {
  final String? url;
  final String? mimeType;

  const TopBannerEntity({this.url, this.mimeType});

  @override
  List<Object?> get props => [url, mimeType];
}
