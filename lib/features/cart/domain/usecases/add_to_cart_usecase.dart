import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/add_to_cart_response_entity.dart';
import '../repositories/cart_repository.dart';

@lazySingleton
class AddToCartUseCase
    implements UseCase<AddToCartResponseEntity, AddToCartParams> {
  final CartRepository repository;

  AddToCartUseCase(this.repository);

  @override
  Future<Either<Failure, AddToCartResponseEntity>> call(
    AddToCartParams params,
  ) {
    if (params.fromBuyNow) {
      return repository.buyNow(params.skuId, params.quantity);
    }
    return repository.addToCart(params.skuId, params.quantity);
  }
}

class AddToCartParams extends Equatable {
  final String skuId;
  final int quantity;
  final bool fromBuyNow;

  const AddToCartParams({
    required this.skuId,
    this.quantity = 1,
    this.fromBuyNow = false,
  });

  @override
  List<Object?> get props => [skuId, quantity, fromBuyNow];
}
