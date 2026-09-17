import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/order_confirmation_entity.dart';
import '../repositories/checkout_repository.dart';

@lazySingleton
class GetOrderConfirmationUseCase
    implements UseCase<OrderConfirmationEntity, OrderConfirmationParams> {
  final CheckoutRepository repository;

  GetOrderConfirmationUseCase(this.repository);

  @override
  Future<Either<Failure, OrderConfirmationEntity>> call(
    OrderConfirmationParams params,
  ) {
    return repository.getOrderConfirmation(params.orderId);
  }
}

class OrderConfirmationParams extends Equatable {
  final int orderId;

  const OrderConfirmationParams({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}
