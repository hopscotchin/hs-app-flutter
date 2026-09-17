import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/place_order_entity.dart';
import '../repositories/checkout_repository.dart';

@lazySingleton
class RetryPlaceOrderUseCase
    implements UseCase<PlaceOrderEntity, RetryPlaceOrderParams> {
  final CheckoutRepository repository;

  RetryPlaceOrderUseCase(this.repository);

  @override
  Future<Either<Failure, PlaceOrderEntity>> call(RetryPlaceOrderParams params) {
    return repository.retryPlaceOrder(
      params.paymentCode,
      params.creditsApplied,
      params.failedOrderId,
    );
  }
}

class RetryPlaceOrderParams extends Equatable {
  final String paymentCode;
  final bool creditsApplied;
  final int failedOrderId;

  const RetryPlaceOrderParams({
    required this.paymentCode,
    required this.creditsApplied,
    required this.failedOrderId,
  });

  @override
  List<Object?> get props => [paymentCode, creditsApplied, failedOrderId];
}
