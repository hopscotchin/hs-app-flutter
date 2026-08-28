import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/cart_entity.dart';
import '../repositories/cart_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class RemoveCartItemUseCase implements UseCase<CartEntity, RemoveCartItemParams> {
  final CartRepository repository;

  RemoveCartItemUseCase(this.repository);

  @override
  Future<Either<Failure, CartEntity>> call(RemoveCartItemParams params) {
    return repository.removeCartItem(
      params.sku,
      instantCheckout: params.instantCheckout,
      cancelToken: params.cancelToken,
    );
  }
}

class RemoveCartItemParams extends Equatable {
  final String sku;
  final bool instantCheckout;
  final CancelToken? cancelToken;

  const RemoveCartItemParams({required this.sku, this.instantCheckout = false, this.cancelToken});

  @override
  List<Object?> get props => [sku, instantCheckout];
  // cancelToken intentionally excluded — not a semantic field
}
