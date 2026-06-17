import 'package:equatable/equatable.dart';

class MediaEntity extends Equatable {
  final int? height;
  final String? mimeType;
  final String? url;
  final int? width;

  const MediaEntity({this.height, this.mimeType, this.url, this.width});

  @override
  List<Object?> get props => [height, mimeType, url, width];
}
