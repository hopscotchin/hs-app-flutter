import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/config/environment.dart';
import '../../domain/entities/customer_info_entity.dart';

part 'splash_state.freezed.dart';

enum SplashStatus {
  initial,
  environmentSelection,
  loading,
  loaded,
  error,
  deeplinkProcessed,
}

enum SplashLoadingStep { starting, fetchingConfig, fetchingCustomerInfo }

enum SplashErrorType { network, appConfig, unknown }

@freezed
abstract class SplashState with _$SplashState {
  const factory SplashState({
    @Default(SplashStatus.initial) SplashStatus status,
    @Default(SplashLoadingStep.starting) SplashLoadingStep loadingStep,
    Environment? pendingEnvironment,
    CustomerInfoEntity? customerInfo,
    @Default('') String errorMessage,
    @Default(SplashErrorType.unknown) SplashErrorType errorType,
    String? processedDeeplink,
  }) = _SplashState;
}

extension SplashStateX on SplashState {
  bool get isLoaded => status == SplashStatus.loaded;
  bool get isError => status == SplashStatus.error;
  bool get isEnvironmentSelection => status == SplashStatus.environmentSelection;
}
