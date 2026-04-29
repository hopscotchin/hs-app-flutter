import 'package:equatable/equatable.dart';

import '../../../../core/config/environment.dart';

abstract class SplashEvent extends Equatable {
  const SplashEvent();

  @override
  List<Object?> get props => [];
}

class InitializeApp extends SplashEvent {}

class SelectEnvironment extends SplashEvent {
  final Environment environment;

  const SelectEnvironment({required this.environment});

  @override
  List<Object?> get props => [environment];
}

class HandleDeeplink extends SplashEvent {
  final String deeplink;

  const HandleDeeplink({required this.deeplink});

  @override
  List<Object?> get props => [deeplink];
}
