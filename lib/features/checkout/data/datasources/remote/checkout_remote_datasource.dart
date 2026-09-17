import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/network/api_client.dart';
import '../../models/init_juspay_model.dart';
import '../../models/order_confirmation_model.dart';
import '../../models/payment_retry_model.dart';
import '../../models/payment_status_model.dart';
import '../../models/place_order_model.dart';
import 'package:injectable/injectable.dart';

abstract class CheckoutRemoteDataSource {
  Future<PlaceOrderModel> placeOrder(
    String paymentCode,
    bool creditsApplied, {
    int? failedOrderId,
  });

  Future<InitJusPayModel> initPayment(
    int recordId,
    bool creditsApplied,
    bool quickPayEnabled,
  );

  Future<PaymentStatusModel> getPaymentStatus(int orderId);

  Future<PaymentRetryModel> getPaymentRetryDetail(int orderId);

  Future<PlaceOrderModel> retryPlaceOrder(
    String paymentCode,
    bool creditsApplied,
    int failedOrderId,
  );

  Future<void> markOrderFail(int orderId);

  Future<OrderConfirmationModel> getOrderConfirmation(int orderId);
}

@LazySingleton(as: CheckoutRemoteDataSource)
class CheckoutRemoteDataSourceImpl implements CheckoutRemoteDataSource {
  final ApiClient apiClient;

  CheckoutRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<PlaceOrderModel> placeOrder(
    String paymentCode,
    bool creditsApplied, {
    int? failedOrderId,
  }) async {
    final data = <String, dynamic>{
      'paymentCode': paymentCode,
      'creditsApplied': creditsApplied,
    };
    if (failedOrderId != null) data['failedOrderId'] = failedOrderId;

    final response = await apiClient.post(ApiConstants.placeOrder, data: data);
    return PlaceOrderModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<InitJusPayModel> initPayment(
    int recordId,
    bool creditsApplied,
    bool quickPayEnabled,
  ) async {
    final response = await apiClient.post(
      ApiConstants.initPayment,
      data: {
        'recordId': recordId,
        'creditsApplied': creditsApplied,
        'quickPayEnabled': quickPayEnabled,
        'paymentAction': 'paymentPage',
        'paymentGateway': 'JUSPAY',
      },
    );
    return InitJusPayModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<PaymentStatusModel> getPaymentStatus(int orderId) async {
    final response = await apiClient.get(
      '${ApiConstants.paymentStatus}/$orderId/payment-status',
    );
    return PaymentStatusModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<PaymentRetryModel> getPaymentRetryDetail(int orderId) async {
    final response = await apiClient.get(
      '${ApiConstants.paymentRetryDetail}/$orderId',
    );
    return PaymentRetryModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<PlaceOrderModel> retryPlaceOrder(
    String paymentCode,
    bool creditsApplied,
    int failedOrderId,
  ) async {
    final response = await apiClient.post(
      ApiConstants.retryPlaceOrder,
      data: {
        'paymentCode': paymentCode,
        'creditsApplied': creditsApplied,
        'failedOrderId': failedOrderId,
      },
    );
    return PlaceOrderModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> markOrderFail(int orderId) async {
    await apiClient.post(
      ApiConstants.markOrderFail,
      data: {'orderId': orderId},
    );
  }

  @override
  Future<OrderConfirmationModel> getOrderConfirmation(int orderId) async {
    final response = await apiClient.get(
      '${ApiConstants.orderConfirmation}/$orderId/confirmation',
    );
    return OrderConfirmationModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }
}
