import '../../domain/entities/wish_list_entity.dart';

class WishListModel extends WishListEntity {
  const WishListModel({super.id, super.status});

  factory WishListModel.fromJson(Map<String, dynamic> json) {
    return WishListModel(
      id: json['id'] as String?,
      status: json['status'] as bool?,
    );
  }
}
