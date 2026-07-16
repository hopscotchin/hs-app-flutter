import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/wishlist_repository.dart';

@lazySingleton
class RemoveFromWishlistUseCase
    implements UseCase<void, RemoveFromWishlistParams> {
  RemoveFromWishlistUseCase(this._repository);

  final WishlistRepository _repository;

  @override
  Future<Either<Failure, void>> call(RemoveFromWishlistParams params) {
    return _repository.removeFromWishlist(params.wishlistId);
  }
}

class RemoveFromWishlistParams extends Equatable {
  const RemoveFromWishlistParams({required this.wishlistId});

  final String wishlistId;

  @override
  List<Object?> get props => [wishlistId];
}
