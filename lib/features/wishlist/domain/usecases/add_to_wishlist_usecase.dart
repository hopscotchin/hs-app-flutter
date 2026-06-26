import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/wishlist_response_entity.dart';
import '../repositories/wishlist_repository.dart';

@lazySingleton
class AddToWishlistUseCase implements UseCase<WishlistResponseEntity, AddToWishlistParams> {
  final WishlistRepository repository;

  AddToWishlistUseCase(this.repository);

  @override
  Future<Either<Failure, WishlistResponseEntity>> call(AddToWishlistParams params) {
    return repository.addToWishlist(params.productId, params.price, params.skuId);
  }
}

class AddToWishlistParams extends Equatable {
  final String productId;
  final int price;
  final String? skuId;

  const AddToWishlistParams({required this.productId, required this.price, this.skuId});

  @override
  List<Object?> get props => [productId, price, skuId];
}
