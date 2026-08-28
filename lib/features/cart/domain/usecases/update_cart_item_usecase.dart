import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/cart_entity.dart';
import '../repositories/cart_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class UpdateCartItemUseCase implements UseCase<CartEntity, UpdateCartItemParams> {
  final CartRepository repository;

  UpdateCartItemUseCase(this.repository);

  @override
  Future<Either<Failure, CartEntity>> call(UpdateCartItemParams params) {
    return repository.updateCartItem(
      params.sku,
      params.quantity,
      instantCheckout: params.instantCheckout,
      cancelToken: params.cancelToken,
    );
  }
}

class UpdateCartItemParams extends Equatable {
  final String sku;
  final int quantity;
  final bool instantCheckout;
  final CancelToken? cancelToken;

  const UpdateCartItemParams({
    required this.sku,
    required this.quantity,
    this.instantCheckout = false,
    this.cancelToken,
  });

  @override
  List<Object?> get props => [sku, quantity, instantCheckout];
  // cancelToken intentionally excluded — not a semantic field
}
