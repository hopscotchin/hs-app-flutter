import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/cart_entity.dart';
import '../repositories/cart_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class RemoveCartItemUseCase
    implements UseCase<CartEntity, RemoveCartItemParams> {
  final CartRepository repository;

  RemoveCartItemUseCase(this.repository);

  @override
  Future<Either<Failure, CartEntity>> call(RemoveCartItemParams params) {
    return repository.removeCartItem(params.sku);
  }
}

class RemoveCartItemParams extends Equatable {
  final String sku;

  const RemoveCartItemParams({required this.sku});

  @override
  List<Object?> get props => [sku];
}
