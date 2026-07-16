import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/cart_entity.dart';
import '../repositories/cart_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class MergeCartUseCase implements UseCase<CartEntity, NoParams> {
  final CartRepository repository;

  MergeCartUseCase(this.repository);

  @override
  Future<Either<Failure, CartEntity>> call(NoParams params) {
    return repository.mergeCart();
  }
}
