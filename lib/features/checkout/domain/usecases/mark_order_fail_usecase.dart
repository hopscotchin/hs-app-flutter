import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/checkout_repository.dart';

@lazySingleton
class MarkOrderFailUseCase implements UseCase<void, MarkOrderFailParams> {
  final CheckoutRepository repository;

  MarkOrderFailUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(MarkOrderFailParams params) {
    return repository.markOrderFail(params.orderId);
  }
}

class MarkOrderFailParams extends Equatable {
  final int orderId;

  const MarkOrderFailParams({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}
