import 'dart:async';
import 'package:injectable/injectable.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/entities/message_bar_entity.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/json_parsers.dart';
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
import '../../data/services/payment_notification_service.dart';
import '../../data/services/payment_polling_service.dart';

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
  final PaymentNotificationService _notifications;
  final PaymentPollingService _polling;

  Timer? _pollingTimer;
  int _polledDuration = 0;
  bool _processingNotified = false;
  /// Latched once the flow aborts (backpress / user-abort / mark-failed).
  /// Blocks any late Juspay stragglers from restarting polling on a bloc
  /// that has already emitted [OrderMarkedFailed] and navigated away.
  bool _aborted = false;

  CheckoutBloc({
    required this.placeOrderUseCase,
    required this.initPaymentUseCase,
    required this.getPaymentStatusUseCase,
    required this.getPaymentRetryUseCase,
    required this.retryPlaceOrderUseCase,
    required this.markOrderFailUseCase,
    required this.getOrderConfirmationUseCase,
    required PaymentNotificationService notificationService,
    required PaymentPollingService pollingService,
  })  : _notifications = notificationService,
        _polling = pollingService,
        super(const CheckoutInitial()) {
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
    // Late Juspay stragglers after an abort — Juspay can fire secondary
    // events (e.g. loader hide / SDK cleanup) after the user backs out.
    // Nothing to do; the flow already navigated away.
    if (_aborted) return;

    final eventType = event.event.toLowerCase();

    // User pressed back or aborted — exit the payment flow immediately.
    // Mirrors Android `PaymentStateActivity.exitPaymentState`, which sets
    // RESULT_CANCELED and finishes without waiting on the mark-fail API.
    //
    // Emit synchronously so the state page's listener navigates now: adding
    // MarkOrderAsFailed via `add()` would sit at the tail of the event
    // queue behind any queued CheckPaymentStatus events (each of which
    // restarts polling), keeping the user pinned on the "Processing…" UI.
    if (eventType == 'backpressed' || eventType == 'user_aborted') {
      _aborted = true;
      _stopPolling();
      _stopProcessingUi();
      unawaited(_notifications.cancelAll());
      final orderId = parseToIntOrNull(event.payload['orderId']);
      if (orderId != null) {
        // Fire-and-forget — the UI doesn't wait on the server. Same pattern
        // Android uses (`PaymentStateActivity.kt` calls the API off the
        // exit path).
        unawaited(markOrderFailUseCase(MarkOrderFailParams(orderId: orderId)));
      }
      emit(const OrderMarkedFailed());
      return;
    }

    // Payment completed (charged, cod_initiated, or other) — check status
    final orderId = parseToIntOrNull(event.payload['orderId']);
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
          _stopProcessingUi();
          unawaited(_notifications.showSuccess(event.orderId));
          emit(PaymentStatusReceived(paymentStatusEntity: data));
          break;
        case ActionState.pending:
          // Start polling — foreground-service notification kicks in on the
          // first pending tick so the user sees continuous progress even
          // if they leave the app.
          _startPolling(event.orderId, data.retryTime, data.totalTime, emit);
          break;
        case ActionState.retryPayment:
          _stopProcessingUi();
          unawaited(_notifications.showRetry(event.orderId));
          add(LoadPaymentRetry(orderId: event.orderId));
          break;
        case ActionState.failure:
          _stopProcessingUi();
          unawaited(
            _notifications.showFailure(event.orderId, message: data.message),
          );
          add(LoadPaymentRetry(orderId: event.orderId));
          break;
        case null:
          _stopProcessingUi();
          if (data.paymentStatusEnum == PaymentState.success) {
            unawaited(_notifications.showSuccess(event.orderId));
          }
          emit(PaymentStatusReceived(paymentStatusEntity: data));
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

    // Foreground-service + "Processing payment…" notification. Idempotent —
    // this arm may re-fire on every pending tick, but startProcessing self-
    // guards on service.isRunning.
    if (!_processingNotified) {
      _processingNotified = true;
      unawaited(_polling.startProcessing(orderId));
    }

    _pollingTimer = Timer.periodic(Duration(milliseconds: interval), (_) {
      _polledDuration += interval;
      if (_polledDuration >= maxDuration) {
        _stopPolling();
        _stopProcessingUi();
        unawaited(_notifications.showRetry(orderId));
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

  /// Cancels the ongoing "Processing payment…" foreground notification.
  /// Result notifications (success/retry/failure) are the caller's job — the
  /// call sites in [_onCheckPaymentStatus] fire them alongside this cleanup.
  void _stopProcessingUi() {
    if (!_processingNotified) return;
    _processingNotified = false;
    unawaited(_polling.stopProcessing());
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
    _aborted = true;
    _stopPolling();
    _stopProcessingUi();
    unawaited(_notifications.cancelAll());
    // Fire the API in the background — UI navigates now (Android does the
    // same in PaymentStateActivity's exit path). Waiting on the server
    // would pin the user on "Processing payment…" while the request runs.
    unawaited(markOrderFailUseCase(MarkOrderFailParams(orderId: event.orderId)));
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
    _stopProcessingUi();
    return super.close();
  }
}
