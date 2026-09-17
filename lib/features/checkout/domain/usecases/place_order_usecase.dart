import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/place_order_entity.dart';
import '../repositories/checkout_repository.dart';

@lazySingleton
class PlaceOrderUseCase implements UseCase<PlaceOrderEntity, PlaceOrderParams> {
  final CheckoutRepository repository;

  PlaceOrderUseCase(this.repository);

  @override
  Future<Either<Failure, PlaceOrderEntity>> call(PlaceOrderParams params) {
    return repository.placeOrder(
      params.paymentCode,
      params.creditsApplied,
      failedOrderId: params.failedOrderId,
    );
  }
}

class PlaceOrderParams extends Equatable {
  final String paymentCode;
  final bool creditsApplied;
  final int? failedOrderId;

  const PlaceOrderParams({
    required this.paymentCode,
    required this.creditsApplied,
    this.failedOrderId,
  });

  @override
  List<Object?> get props => [paymentCode, creditsApplied, failedOrderId];
}
