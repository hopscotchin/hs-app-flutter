import '../../domain/entities/moment_entity.dart';

class MomentModel extends MomentEntity {
  const MomentModel({
    required super.id,
    required super.imageUrl,
    super.likes,
    super.isLiked,
    super.width,
    super.height,
    super.uploaderId,
    super.uploaderName,
    super.uploaderAvatar,
    super.caption,
    super.createdAt,
  });

  factory MomentModel.fromJson(Map<String, dynamic> json) {
    return MomentModel(
      id: json['id']?.toString() ?? '',
      imageUrl: json['imageUrl'] as String? ?? json['image'] as String? ?? '',
      likes: json['likes'] as int? ?? json['likeCount'] as int? ?? 0,
      isLiked: json['isLiked'] as bool? ?? json['liked'] as bool? ?? false,
      width: (json['width'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toDouble(),
      uploaderId: json['uploaderId']?.toString() ?? json['customerId']?.toString(),
      uploaderName: json['uploaderName'] as String? ?? json['customerName'] as String?,
      uploaderAvatar: json['uploaderAvatar'] as String? ?? json['customerImage'] as String?,
      caption: json['caption'] as String? ?? json['description'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }
}
