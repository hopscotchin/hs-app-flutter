import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/analytics/attribution/order_attribution_helper.dart';
import '../../../../core/base/base_bloc.dart';
import '../../../../core/config/environment.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/services/pref_manager.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../address/data/managers/address_cache_manager.dart';
import '../../../address/domain/entities/address_source.dart';
import '../../../address/domain/usecases/get_addresses_usecase.dart';
import '../../domain/entities/customer_info_entity.dart';
import '../../domain/usecases/get_app_config_usecase.dart';
import '../../domain/usecases/get_customer_info_usecase.dart';
import '../../domain/usecases/handle_deeplink_usecase.dart';
import '../../domain/usecases/reconfigure_network_usecase.dart';
import 'splash_event.dart';
import 'splash_state.dart';

@injectable
class SplashBloc extends BaseBloc<SplashEvent, SplashState> {
  SplashBloc(
    this._getAppConfig,
    this._getCustomerInfo,
    this._handleDeeplink,
    this._reconfigureNetwork,
    this._prefManager,
    this.addressCache,
    this._getAddresses,
    this._orderAttribution,
  ) : super(const SplashState()) {
    on<InitializeApp>(_onInitializeApp);
    on<SelectEnvironment>(_onSelectEnvironment);
    on<HandleDeeplink>(_onHandleDeeplink);
  }

  final GetAppConfigUseCase _getAppConfig;
  final GetCustomerInfoUseCase _getCustomerInfo;
  final HandleDeeplinkUseCase _handleDeeplink;
  final ReconfigureNetworkUseCase _reconfigureNetwork;
  final PrefManager _prefManager;
  final AddressCacheManager addressCache;
  final GetAddressesUseCase _getAddresses;
  final OrderAttributionHelper _orderAttribution;

  Future<void> _onInitializeApp(InitializeApp event, Emitter<SplashState> emit) async {
    // Wipe stale funnel attribution at cold start. Mirrors Android
    // `SplashActivity.java:151` — `OrderAttributionHelper.clearAttributionData()`
    // followed by a fresh empty struct. Without this, a funnel set in the
    // previous app session bleeds into the first tile click of this session.
    await _orderAttribution.clear();
    // Show the environment picker only in debug builds AND only when the
    // user isn't already signed in.
    if (!kReleaseMode && !_prefManager.isLoggedIn) {
      emit(
        state.copyWith(
          status: SplashStatus.environmentSelection,
          pendingEnvironment: EnvironmentConfig.current,
        ),
      );
      return;
    }
    await _fetchInitialData(emit);
  }

  Future<void> _onSelectEnvironment(SelectEnvironment event, Emitter<SplashState> emit) async {
    _reconfigureNetwork.call(event.environment);
    await _fetchInitialData(emit);
  }

  Future<void> _fetchInitialData(Emitter<SplashState> emit) async {
    emit(
      state.copyWith(status: SplashStatus.loading, loadingStep: SplashLoadingStep.fetchingConfig),
    );

    swapCancelToken();

    // Non-blocking prefetch: cache addresses for warm reads later.
    unawaited(_prefetchAddresses());

    final results = await Future.wait([
      _getAppConfig.call(NoParams()),
      _getCustomerInfo.call(NoParams()),
    ], eagerError: false);

    final appConfigResult = results[0] as Either<Failure, Unit>;
    final customerInfoResult = results[1] as Either<Failure, CustomerInfoEntity>;

    final appConfigFailure = appConfigResult.fold<Failure?>((f) => f, (_) => null);
    if (appConfigFailure != null) {
      if (appConfigFailure is RequestCancelledFailure) return;
      emit(
        state.copyWith(
          status: SplashStatus.error,
          errorMessage: appConfigFailure.message,
          errorType: _errorType(appConfigFailure, isAppConfig: true),
        ),
      );
      return;
    }

    final customerInfoFailure = customerInfoResult.fold<Failure?>((f) => f, (_) => null);
    if (customerInfoFailure != null) {
      if (customerInfoFailure is RequestCancelledFailure) return;
      emit(
        state.copyWith(
          status: SplashStatus.error,
          errorMessage: customerInfoFailure.message,
          errorType: _errorType(customerInfoFailure),
        ),
      );
      return;
    }

    final customerInfo = customerInfoResult.fold<CustomerInfoEntity?>((_) => null, (e) => e);
    emit(state.copyWith(status: SplashStatus.loaded, customerInfo: customerInfo));
  }

  Future<void> _prefetchAddresses() async {
    final result = await _getAddresses.call(
      const GetAddressesParams(source: AddressSource.delivery),
    );
    await result.fold(
      (_) async {
        // Silent: addresses prefetch must not block or fail splash.
      },
      (list) => addressCache.setAll(list.rawItems),
    );
  }

  Future<void> _onHandleDeeplink(HandleDeeplink event, Emitter<SplashState> emit) async {
    swapCancelToken();
    final result = await _handleDeeplink.call(DeeplinkParams(deeplink: event.deeplink));
    result.fold(
      (f) {
        if (f is RequestCancelledFailure) return;
      },
      (_) => emit(
        state.copyWith(status: SplashStatus.deeplinkProcessed, processedDeeplink: event.deeplink),
      ),
    );
  }

  SplashErrorType _errorType(Failure failure, {bool isAppConfig = false}) {
    if (failure is ConnectionFailure || failure is TimeoutFailure || failure is NetworkFailure) {
      return SplashErrorType.network;
    }
    if (isAppConfig && (failure is ServerFailure || failure is InternalServerFailure)) {
      return SplashErrorType.appConfig;
    }
    return SplashErrorType.unknown;
  }
}
