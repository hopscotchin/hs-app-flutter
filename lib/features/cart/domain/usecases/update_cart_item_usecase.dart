import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/cart_entity.dart';
import '../repositories/cart_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class UpdateCartItemUseCase
    implements UseCase<CartEntity, UpdateCartItemParams> {
  final CartRepository repository;

  UpdateCartItemUseCase(this.repository);

  @override
  Future<Either<Failure, CartEntity>> call(UpdateCartItemParams params) {
    return repository.updateCartItem(params.sku, params.quantity);
  }
}

class UpdateCartItemParams extends Equatable {
  final String sku;
  final int quantity;

  const UpdateCartItemParams({required this.sku, required this.quantity});

  @override
  List<Object?> get props => [sku, quantity];
}
