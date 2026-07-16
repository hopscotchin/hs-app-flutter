import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/cart_entity.dart';
import '../repositories/cart_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class MoveToWishlistUseCase
    implements UseCase<CartEntity, MoveToWishlistParams> {
  final CartRepository repository;

  MoveToWishlistUseCase(this.repository);

  @override
  Future<Either<Failure, CartEntity>> call(MoveToWishlistParams params) {
    return repository.moveToWishlist(
      params.sku,
      productId: params.productId,
      price: params.price,
    );
  }
}

class MoveToWishlistParams extends Equatable {
  final String sku;
  final int? productId;
  final int? price;

  const MoveToWishlistParams({required this.sku, this.productId, this.price});

  @override
  List<Object?> get props => [sku, productId, price];
}
