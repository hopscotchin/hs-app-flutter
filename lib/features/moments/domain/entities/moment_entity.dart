import 'package:equatable/equatable.dart';

class MomentEntity extends Equatable {
  final String id;
  final String imageUrl;
  final int likes;
  final bool isLiked;
  final double? width;
  final double? height;
  final String? uploaderId;
  final String? uploaderName;
  final String? uploaderAvatar;
  final String? caption;
  final DateTime? createdAt;

  const MomentEntity({
    required this.id,
    required this.imageUrl,
    this.likes = 0,
    this.isLiked = false,
    this.width,
    this.height,
    this.uploaderId,
    this.uploaderName,
    this.uploaderAvatar,
    this.caption,
    this.createdAt,
  });

  double get aspectRatio {
    if (width != null && height != null && height! > 0) {
      return width! / height!;
    }
    return 1.0;
  }

  MomentEntity copyWith({
    String? id,
    String? imageUrl,
    int? likes,
    bool? isLiked,
    double? width,
    double? height,
    String? uploaderId,
    String? uploaderName,
    String? uploaderAvatar,
    String? caption,
    DateTime? createdAt,
  }) {
    return MomentEntity(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      likes: likes ?? this.likes,
      isLiked: isLiked ?? this.isLiked,
      width: width ?? this.width,
      height: height ?? this.height,
      uploaderId: uploaderId ?? this.uploaderId,
      uploaderName: uploaderName ?? this.uploaderName,
      uploaderAvatar: uploaderAvatar ?? this.uploaderAvatar,
      caption: caption ?? this.caption,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        imageUrl,
        likes,
        isLiked,
        width,
        height,
        uploaderId,
        uploaderName,
        uploaderAvatar,
        caption,
        createdAt,
      ];
}
