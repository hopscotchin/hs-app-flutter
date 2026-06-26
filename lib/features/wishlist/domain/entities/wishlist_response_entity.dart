import '../../../../core/network/models/action_response.dart';

class WishlistResponseEntity extends ActionResponse {
  final String? wishlistItemId;

  const WishlistResponseEntity({super.action, super.message, this.wishlistItemId});

  WishlistResponseEntity.fromJson(super.json, {this.wishlistItemId}) : super.fromJson();

  @override
  List<Object?> get props => [action, message, wishlistItemId];
}
