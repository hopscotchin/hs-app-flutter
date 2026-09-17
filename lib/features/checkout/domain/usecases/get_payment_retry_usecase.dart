import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/payment_retry_entity.dart';
import '../repositories/checkout_repository.dart';

@lazySingleton
class GetPaymentRetryUseCase
    implements UseCase<PaymentRetryEntity, PaymentRetryParams> {
  final CheckoutRepository repository;

  GetPaymentRetryUseCase(this.repository);

  @override
  Future<Either<Failure, PaymentRetryEntity>> call(PaymentRetryParams params) {
    return repository.getPaymentRetryDetail(params.orderId);
  }
}

class PaymentRetryParams extends Equatable {
  final int orderId;

  const PaymentRetryParams({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}
