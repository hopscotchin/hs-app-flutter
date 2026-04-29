import 'package:equatable/equatable.dart';

import '../../../../core/config/environment.dart';
import '../../data/models/app_config_response.dart';
import '../../data/models/customer_info_response.dart';

abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => [];
}

class SplashInitial extends SplashState {}

/// Waiting for the user to pick an environment (debug only).
class SplashEnvironmentSelection extends SplashState {
  final Environment currentEnvironment;

  const SplashEnvironmentSelection({required this.currentEnvironment});

  @override
  List<Object?> get props => [currentEnvironment];
}

class SplashLoading extends SplashState {
  final SplashLoadingStep step;

  const SplashLoading({this.step = SplashLoadingStep.starting});

  @override
  List<Object?> get props => [step];
}

class SplashLoaded extends SplashState {
  final AppConfigResponse? appConfig;
  final CustomerInfoResponse? customerInfo;

  const SplashLoaded({
    this.appConfig,
    this.customerInfo,
  });

  @override
  List<Object?> get props => [appConfig, customerInfo];
}

class SplashError extends SplashState {
  final String message;
  final SplashErrorType errorType;

  const SplashError({
    required this.message,
    this.errorType = SplashErrorType.unknown,
  });

  @override
  List<Object?> get props => [message, errorType];
}

class DeeplinkProcessing extends SplashState {
  final String deeplink;

  const DeeplinkProcessing({required this.deeplink});

  @override
  List<Object?> get props => [deeplink];
}

class DeeplinkProcessed extends SplashState {
  final String rawDeeplink;

  const DeeplinkProcessed({required this.rawDeeplink});

  @override
  List<Object?> get props => [rawDeeplink];
}

// Enums
enum SplashLoadingStep {
  starting,
  fetchingAppConfig,
  fetchingCustomerInfo,
  completed,
}

enum SplashErrorType {
  network,
  appConfig,
  customerInfo,
  unknown,
}
