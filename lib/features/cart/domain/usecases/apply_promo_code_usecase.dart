import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/cart_entity.dart';
import '../repositories/cart_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ApplyPromoCodeUseCase
    implements UseCase<CartEntity, ApplyPromoCodeParams> {
  final CartRepository repository;

  ApplyPromoCodeUseCase(this.repository);

  @override
  Future<Either<Failure, CartEntity>> call(ApplyPromoCodeParams params) {
    return repository.applyPromoCode(params.promoCode);
  }
}

class ApplyPromoCodeParams extends Equatable {
  final String promoCode;

  const ApplyPromoCodeParams({required this.promoCode});

  @override
  List<Object?> get props => [promoCode];
}
