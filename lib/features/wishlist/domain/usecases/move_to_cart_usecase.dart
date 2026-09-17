import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/move_to_cart_result_entity.dart';
import '../repositories/wishlist_repository.dart';

@lazySingleton
class MoveToCartUseCase
    implements UseCase<MoveToCartResultEntity, MoveToCartParams> {
  MoveToCartUseCase(this._repository);
  final WishlistRepository _repository;

  @override
  Future<Either<Failure, MoveToCartResultEntity>> call(
    MoveToCartParams params,
  ) => _repository.moveToCart(
    wishlistItemId: params.wishlistItemId,
    skuId: params.skuId,
    quantity: params.quantity,
  );
}

class MoveToCartParams extends Equatable {
  const MoveToCartParams({
    required this.wishlistItemId,
    required this.skuId,
    this.quantity = 1,
  });

  /// Wishlist entry id (`wishlistInfo.id` from the listing).
  final String wishlistItemId;
  final String skuId;
  final int quantity;

  @override
  List<Object?> get props => [wishlistItemId, skuId, quantity];
}
