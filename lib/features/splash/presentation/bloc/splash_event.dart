import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/config/environment.dart';

part 'splash_event.freezed.dart';

@freezed
sealed class SplashEvent with _$SplashEvent {
  const factory SplashEvent.initializeApp() = InitializeApp;
  const factory SplashEvent.selectEnvironment(Environment environment) = SelectEnvironment;
  const factory SplashEvent.handleDeeplink(String deeplink) = HandleDeeplink;
}
