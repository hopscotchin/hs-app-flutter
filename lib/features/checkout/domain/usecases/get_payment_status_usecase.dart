import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/payment_status_entity.dart';
import '../repositories/checkout_repository.dart';

@lazySingleton
class GetPaymentStatusUseCase
    implements UseCase<PaymentStatusEntity, PaymentStatusParams> {
  final CheckoutRepository repository;

  GetPaymentStatusUseCase(this.repository);

  @override
  Future<Either<Failure, PaymentStatusEntity>> call(
    PaymentStatusParams params,
  ) {
    return repository.getPaymentStatus(params.orderId);
  }
}

class PaymentStatusParams extends Equatable {
  final int orderId;

  const PaymentStatusParams({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}
