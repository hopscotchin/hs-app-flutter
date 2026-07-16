import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/cart_entity.dart';
import '../repositories/cart_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class RemovePromoCodeUseCase
    implements UseCase<CartEntity, RemovePromoCodeParams> {
  final CartRepository repository;

  RemovePromoCodeUseCase(this.repository);

  @override
  Future<Either<Failure, CartEntity>> call(RemovePromoCodeParams params) {
    return repository.removePromoCode(params.promoCode);
  }
}

class RemovePromoCodeParams extends Equatable {
  final String promoCode;

  const RemovePromoCodeParams({required this.promoCode});

  @override
  List<Object?> get props => [promoCode];
}
