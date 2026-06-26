import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/wishlist_repository.dart';

@lazySingleton
class RemoveFromWishlistUseCase implements UseCase<void, RemoveFromWishlistParams> {
  final WishlistRepository repository;

  RemoveFromWishlistUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(RemoveFromWishlistParams params) {
    return repository.removeFromWishlist(params.wishlistId);
  }
}

class RemoveFromWishlistParams extends Equatable {
  final String wishlistId;

  const RemoveFromWishlistParams({required this.wishlistId});

  @override
  List<Object?> get props => [wishlistId];
}
