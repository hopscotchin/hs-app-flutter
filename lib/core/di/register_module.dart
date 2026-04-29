import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../network/network_client.dart';

/// Injectable module that exposes cross-cutting infrastructure to the DI
/// graph. Keeps codegen'd registrations (retrofit clients, services) from
/// having to know how to build a Dio — they just ask for one.
///
/// Consumed by retrofit-generated clients in feature data sources.
/// See: CODING_GUIDELINES.md §2.5
@module
abstract class RegisterModule {
  /// Returns the fully-configured [Dio] owned by the app's [NetworkClient]
  /// (auth header, cookie, logging, and retry interceptors already wired).
  ///
  /// IMPORTANT: do NOT construct a new [Dio] anywhere in feature code —
  /// always inject this one, otherwise interceptors will be bypassed.
  @lazySingleton
  Dio dio(NetworkClient networkClient) => networkClient.dio;
}
