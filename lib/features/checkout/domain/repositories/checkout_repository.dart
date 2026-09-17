import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/init_juspay_entity.dart';
import '../entities/order_confirmation_entity.dart';
import '../entities/payment_retry_entity.dart';
import '../entities/payment_status_entity.dart';
import '../entities/place_order_entity.dart';

abstract class CheckoutRepository {
  Future<Either<Failure, PlaceOrderEntity>> placeOrder(
    String paymentCode,
    bool creditsApplied, {
    int? failedOrderId,
  });

  Future<Either<Failure, InitJusPayEntity>> initPayment(
    int recordId,
    bool creditsApplied,
    bool quickPayEnabled,
  );

  Future<Either<Failure, PaymentStatusEntity>> getPaymentStatus(int orderId);

  Future<Either<Failure, PaymentRetryEntity>> getPaymentRetryDetail(
    int orderId,
  );

  Future<Either<Failure, PlaceOrderEntity>> retryPlaceOrder(
    String paymentCode,
    bool creditsApplied,
    int failedOrderId,
  );

  Future<Either<Failure, void>> markOrderFail(int orderId);

  Future<Either<Failure, OrderConfirmationEntity>> getOrderConfirmation(
    int orderId,
  );
}
