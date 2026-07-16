import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/cart/domain/usecases/add_to_cart_usecase.dart';
import '../../features/discover/domain/entities/home_page_entity.dart';

enum ShopTheLookCartStatus { idle, loading, success, failure }

class ShopTheLookCartState extends Equatable {
  final ShopTheLookCartStatus status;
  final int addedCount;
  final int? cartItemQty;
  final String? errorMessage;

  const ShopTheLookCartState({
    this.status = ShopTheLookCartStatus.idle,
    this.addedCount = 0,
    this.cartItemQty,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [status, addedCount, cartItemQty, errorMessage];
}

class ShopTheLookCubit extends Cubit<ShopTheLookCartState> {
  final AddToCartUseCase _addToCartUseCase;

  ShopTheLookCubit(this._addToCartUseCase)
    : super(const ShopTheLookCartState());

  Future<void> addToCart(List<ShopTheLookSelection> selections) async {
    if (state.status == ShopTheLookCartStatus.loading) return;
    emit(const ShopTheLookCartState(status: ShopTheLookCartStatus.loading));

    var addedCount = 0;
    int? lastCartQty;
    String? lastError;

    for (final sel in selections) {
      if (sel.skuId == null) continue;
      final result = await _addToCartUseCase(
        AddToCartParams(skuId: sel.skuId!),
      );
      result.fold((f) => lastError = f.message, (entity) {
        addedCount++;
        lastCartQty = entity.cartItemQty;
      });
    }

    if (addedCount > 0) {
      emit(
        ShopTheLookCartState(
          status: ShopTheLookCartStatus.success,
          addedCount: addedCount,
          cartItemQty: lastCartQty,
        ),
      );
    } else {
      emit(
        ShopTheLookCartState(
          status: ShopTheLookCartStatus.failure,
          errorMessage: lastError ?? 'Failed to add items to bag',
        ),
      );
    }
  }
}
