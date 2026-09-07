import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/cart_entity.dart';
import '../repositories/cart_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetCartUseCase implements UseCase<CartEntity, GetCartParams> {
  final CartRepository repository;

  GetCartUseCase(this.repository);

  @override
  Future<Either<Failure, CartEntity>> call(GetCartParams params) {
    return repository.getCart(
      isMergeCall: params.isMergeCall,
      instantCheckout: params.instantCheckout,
      cancelToken: params.cancelToken,
    );
  }
}

class GetCartParams extends Equatable {
  final bool isMergeCall;

  /// Scopes the fetch to the buy-now item alone — see [CartRepository.getCart].
  final bool instantCheckout;
  final CancelToken? cancelToken;

  const GetCartParams({this.isMergeCall = false, this.instantCheckout = false, this.cancelToken});

  @override
  List<Object?> get props => [isMergeCall];
  // cancelToken intentionally excluded — not a semantic field
}
