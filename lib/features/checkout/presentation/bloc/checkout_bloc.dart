import 'dart:async';
import 'package:injectable/injectable.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/entities/message_bar_entity.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/init_juspay_entity.dart';
import '../../domain/entities/order_confirmation_entity.dart';
import '../../domain/entities/payment_retry_entity.dart';
import '../../domain/entities/payment_status_entity.dart';
import '../../domain/entities/place_order_entity.dart';
import '../../domain/usecases/get_order_confirmation_usecase.dart';
import '../../domain/usecases/get_payment_retry_usecase.dart';
import '../../domain/usecases/get_payment_status_usecase.dart';
import '../../domain/usecases/init_payment_usecase.dart';
import '../../domain/usecases/mark_order_fail_usecase.dart';
import '../../domain/usecases/place_order_usecase.dart';
import '../../domain/usecases/retry_place_order_usecase.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';

@injectable
class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final PlaceOrderUseCase placeOrderUseCase;
  final InitPaymentUseCase initPaymentUseCase;
  final GetPaymentStatusUseCase getPaymentStatusUseCase;
  final GetPaymentRetryUseCase getPaymentRetryUseCase;
  final RetryPlaceOrderUseCase retryPlaceOrderUseCase;
  final MarkOrderFailUseCase markOrderFailUseCase;
  final GetOrderConfirmationUseCase getOrderConfirmationUseCase;

  Timer? _pollingTimer;
  int _polledDuration = 0;

  CheckoutBloc({
    required this.placeOrderUseCase,
    required this.initPaymentUseCase,
    required this.getPaymentStatusUseCase,
    required this.getPaymentRetryUseCase,
    required this.retryPlaceOrderUseCase,
    required this.markOrderFailUseCase,
    required this.getOrderConfirmationUseCase,
  }) : super(const CheckoutInitial()) {
    on<PlaceOrder>(_onPlaceOrder);
    on<InitiatePayment>(_onInitiatePayment);
    on<JuspayCallbackReceived>(_onJuspayCallback);
    on<CheckPaymentStatus>(_onCheckPaymentStatus);
    on<LoadPaymentRetry>(_onLoadPaymentRetry);
    on<RetryPayment>(_onRetryPayment);
    on<MarkOrderAsFailed>(_onMarkOrderAsFailed);
    on<LoadOrderConfirmation>(_onLoadOrderConfirmation);
  }

  Future<void> _onPlaceOrder(
    PlaceOrder event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(const CheckoutLoading());

    final result = await placeOrderUseCase(
      PlaceOrderParams(
        paymentCode: event.paymentCode,
        creditsApplied: event.creditsApplied,
      ),
    );

    result.fold(
      (failure) => emit(
        CheckoutError(
          message: failure.message,
          messageBars: failure is ApiFailure ? failure.messageBars : const [],
        ),
      ),
      (data) {
        if (!data.isSuccessful) {
          emit(
            CheckoutError(
              message: data.message ?? 'Order placement failed',
              messageBars: data.messageBars,
            ),
          );
          return;
        }

        // COD or full credits — skip Juspay, go directly to confirmation
        if (event.fullCreditsApplied ||
            event.paymentCode == 'COD' ||
            event.paymentCode == 'OWP') {
          emit(
            PlaceOrderSuccess(placeOrderEntity: data, fullCreditsApplied: true),
          );
        } else {
          // Online payment — need to init Juspay
          emit(
            PlaceOrderSuccess(
              placeOrderEntity: data,
              fullCreditsApplied: false,
            ),
          );
        }
      },
    );
  }

  Future<void> _onInitiatePayment(
    InitiatePayment event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(const CheckoutLoading());

    final result = await initPaymentUseCase(
      InitPaymentParams(
        recordId: event.recordId,
        creditsApplied: event.creditsApplied,
        quickPayEnabled: event.quickPayEnabled,
      ),
    );

    result.fold(
      (failure) => emit(
        CheckoutError(
          message: failure.message,
          messageBars: failure is ApiFailure ? failure.messageBars : const [],
        ),
      ),
      (data) {
        emit(JuspayReady(initJusPayEntity: data));
      },
    );
  }

  Future<void> _onJuspayCallback(
    JuspayCallbackReceived event,
    Emitter<CheckoutState> emit,
  ) async {
    final eventType = event.event.toLowerCase();

    // User pressed back or aborted — mark order as failed and go back
    if (eventType == 'backpressed' || eventType == 'user_aborted') {
      final orderId = event.payload['orderId'] as int?;
      if (orderId != null) {
        add(MarkOrderAsFailed(orderId: orderId));
      } else {
        emit(const OrderMarkedFailed());
      }
      return;
    }

    // Payment completed (charged, cod_initiated, or other) — check status
    final orderId = event.payload['orderId'] as int?;
    if (orderId != null) {
      add(CheckPaymentStatus(orderId: orderId));
    } else {
      emit(const CheckoutError(message: 'Missing order ID from payment'));
    }
  }

  Future<void> _onCheckPaymentStatus(
    CheckPaymentStatus event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(const PaymentStatusLoading());

    final result = await getPaymentStatusUseCase(
      PaymentStatusParams(orderId: event.orderId),
    );

    result.fold((failure) => emit(CheckoutError(message: failure.message)), (
      data,
    ) {
      final actionState = data.actionStatus;

      switch (actionState) {
        case ActionState.success:
          emit(PaymentStatusReceived(paymentStatusEntity: data));
          break;
        case ActionState.pending:
          // Start polling
          _startPolling(event.orderId, data.retryTime, data.totalTime, emit);
          break;
        case ActionState.retryPayment:
          add(LoadPaymentRetry(orderId: event.orderId));
          break;
        case ActionState.failure:
          add(LoadPaymentRetry(orderId: event.orderId));
          break;
        case null:
          // If paymentStatus is success, treat it as success
          if (data.paymentStatusEnum == PaymentState.success) {
            emit(PaymentStatusReceived(paymentStatusEntity: data));
          } else {
            emit(PaymentStatusReceived(paymentStatusEntity: data));
          }
          break;
      }
    });
  }

  void _startPolling(
    int orderId,
    int? retryTimeMs,
    int? totalTimeMs,
    Emitter<CheckoutState> emit,
  ) {
    _stopPolling();
    _polledDuration = 0;
    final interval = retryTimeMs ?? 3000;
    final maxDuration = totalTimeMs ?? 30000;

    _pollingTimer = Timer.periodic(Duration(milliseconds: interval), (_) {
      _polledDuration += interval;
      if (_polledDuration >= maxDuration) {
        _stopPolling();
        // Timeout — load retry page
        add(LoadPaymentRetry(orderId: orderId));
      } else {
        add(CheckPaymentStatus(orderId: orderId));
      }
    });
  }

  void _stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  Future<void> _onLoadPaymentRetry(
    LoadPaymentRetry event,
    Emitter<CheckoutState> emit,
  ) async {
    _stopPolling();
    emit(const CheckoutLoading());

    final result = await getPaymentRetryUseCase(
      PaymentRetryParams(orderId: event.orderId),
    );

    result.fold(
      (failure) => emit(CheckoutError(message: failure.message)),
      (data) => emit(
        PaymentRetryLoaded(paymentRetryEntity: data, orderId: event.orderId),
      ),
    );
  }

  Future<void> _onRetryPayment(
    RetryPayment event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(const CheckoutLoading());

    final result = await retryPlaceOrderUseCase(
      RetryPlaceOrderParams(
        paymentCode: event.paymentCode,
        creditsApplied: event.creditsApplied,
        failedOrderId: event.failedOrderId,
      ),
    );

    result.fold(
      (failure) => emit(
        CheckoutError(
          message: failure.message,
          messageBars: failure is ApiFailure ? failure.messageBars : const [],
        ),
      ),
      (data) {
        if (!data.isSuccessful) {
          emit(
            CheckoutError(
              message: data.message ?? 'Retry failed',
              messageBars: data.messageBars,
            ),
          );
          return;
        }

        // COD retry
        if (event.paymentCode == 'COD') {
          emit(
            PlaceOrderSuccess(placeOrderEntity: data, fullCreditsApplied: true),
          );
        } else {
          emit(
            PlaceOrderSuccess(
              placeOrderEntity: data,
              fullCreditsApplied: false,
            ),
          );
        }
      },
    );
  }

  Future<void> _onMarkOrderAsFailed(
    MarkOrderAsFailed event,
    Emitter<CheckoutState> emit,
  ) async {
    await markOrderFailUseCase(MarkOrderFailParams(orderId: event.orderId));
    emit(const OrderMarkedFailed());
  }

  Future<void> _onLoadOrderConfirmation(
    LoadOrderConfirmation event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(const CheckoutLoading());

    final result = await getOrderConfirmationUseCase(
      OrderConfirmationParams(orderId: event.orderId),
    );

    result.fold(
      (failure) => emit(CheckoutError(message: failure.message)),
      (data) => emit(OrderConfirmationLoaded(orderConfirmationEntity: data)),
    );
  }

  @override
  Future<void> close() {
    _stopPolling();
    return super.close();
  }
}
