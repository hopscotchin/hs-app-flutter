import '../../../../core/network/models/action_response.dart';

class AddToCartResponseEntity extends ActionResponse {
  final int? cartItemQty;

  const AddToCartResponseEntity({
    super.action,
    super.message,
    this.cartItemQty,
  });

  AddToCartResponseEntity.fromJson(super.json, {this.cartItemQty})
    : super.fromJson();

  @override
  List<Object?> get props => [action, message, cartItemQty];
}
