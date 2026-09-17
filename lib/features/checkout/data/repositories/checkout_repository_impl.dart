import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/mixins/safe_api_call.dart';
import '../../../../core/network/connectivity/network_info.dart';
import '../../domain/entities/init_juspay_entity.dart';
import '../../domain/entities/order_confirmation_entity.dart';
import '../../domain/entities/payment_retry_entity.dart';
import '../../domain/entities/payment_status_entity.dart';
import '../../domain/entities/place_order_entity.dart';
import '../../domain/repositories/checkout_repository.dart';
import '../datasources/remote/checkout_remote_datasource.dart';

@LazySingleton(as: CheckoutRepository)
class CheckoutRepositoryImpl with SafeApiCall implements CheckoutRepository {
  final CheckoutRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  CheckoutRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, PlaceOrderEntity>> placeOrder(
    String paymentCode,
    bool creditsApplied, {
    int? failedOrderId,
  }) {
    return safeApiCall(
      networkInfo,
      () => remoteDataSource.placeOrder(
        paymentCode,
        creditsApplied,
        failedOrderId: failedOrderId,
      ),
    );
  }

  @override
  Future<Either<Failure, InitJusPayEntity>> initPayment(
    int recordId,
    bool creditsApplied,
    bool quickPayEnabled,
  ) {
    return safeApiCall(
      networkInfo,
      () => remoteDataSource.initPayment(
        recordId,
        creditsApplied,
        quickPayEnabled,
      ),
    );
  }

  @override
  Future<Either<Failure, PaymentStatusEntity>> getPaymentStatus(int orderId) {
    return safeApiCall(
      networkInfo,
      () => remoteDataSource.getPaymentStatus(orderId),
    );
  }

  @override
  Future<Either<Failure, PaymentRetryEntity>> getPaymentRetryDetail(
    int orderId,
  ) {
    return safeApiCall(
      networkInfo,
      () => remoteDataSource.getPaymentRetryDetail(orderId),
    );
  }

  @override
  Future<Either<Failure, PlaceOrderEntity>> retryPlaceOrder(
    String paymentCode,
    bool creditsApplied,
    int failedOrderId,
  ) {
    return safeApiCall(
      networkInfo,
      () => remoteDataSource.retryPlaceOrder(
        paymentCode,
        creditsApplied,
        failedOrderId,
      ),
    );
  }

  @override
  Future<Either<Failure, void>> markOrderFail(int orderId) {
    return safeApiCall(
      networkInfo,
      () => remoteDataSource.markOrderFail(orderId),
    );
  }

  @override
  Future<Either<Failure, OrderConfirmationEntity>> getOrderConfirmation(
    int orderId,
  ) {
    return safeApiCall(
      networkInfo,
      () => remoteDataSource.getOrderConfirmation(orderId),
    );
  }
}
