import 'package:dio/dio.dart';

import '../../constants/api_constants.dart';
import '../../services/pref_manager.dart';
import 'auth_header_interceptor.dart';

/// Intercepts 401 responses and transparently re-authenticates using the
/// stored persistent ticket, then retries the original request exactly once.
///
/// Uses [QueuedInterceptor] so that multiple simultaneous 401s are serialised:
/// the first failure performs the auto-login; subsequent failures detect that
/// the stored ticket has already changed and go straight to retry.
class AutoLoginInterceptor extends QueuedInterceptor {
  AutoLoginInterceptor({
    required Dio mainDio,
    required AuthHeaderInterceptor authHeaderInterceptor,
  })  : _mainDio = mainDio,
        _authHeaderInterceptor = authHeaderInterceptor {
    // Separate Dio for the auto-login call itself — shares AuthHeaderInterceptor
    // for device/client headers but intentionally excludes AutoLoginInterceptor
    // to prevent a deadlock when the queue is held.
    _authDio = Dio(BaseOptions(baseUrl: mainDio.options.baseUrl));
    _authDio.interceptors.add(authHeaderInterceptor);
  }

  final Dio _mainDio;
  final AuthHeaderInterceptor _authHeaderInterceptor;
  late final Dio _authDio;

  PrefManager? _prefManager;

  void bindPrefManager(PrefManager prefManager) =>
      _prefManager = prefManager;

  /// Must be called alongside [NetworkClient.onEnvironmentChanged] so the
  /// auth Dio uses the correct base URL in non-production environments.
  void updateBaseUrl(String baseUrl) => _authDio.options.baseUrl = baseUrl;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    // Guard: never retry more than once per request.
    if (err.requestOptions.extra['_autoLoginRetried'] == true) {
      return handler.next(err);
    }

    // No ticket stored — nothing we can do.
    final storedTicket =
        _prefManager?.persistentTicket ?? _authHeaderInterceptor.persistentTicket;
    if (storedTicket == null || storedTicket.isEmpty) {
      return handler.next(err);
    }

    // If the stored ticket already differs from the one used in the failed
    // request, a concurrent auto-login already refreshed it — skip straight
    // to retry with the freshly stored ticket.
    final usedTicket =
        err.requestOptions.headers['hs-persistent-ticket'] as String?;
    if (usedTicket != null && usedTicket != storedTicket) {
      return _retry(err, handler);
    }

    try {
      final response = await _authDio.post<Map<String, dynamic>>(
        ApiConstants.autoLogin,
        data: <String, dynamic>{'persistentTicket': storedTicket},
      );

      final data = response.data;
      if (data == null) return handler.next(err);

      final action = ((data['action'] as String?) ?? '').toUpperCase();
      if (!action.contains('SUCCESS')) return handler.next(err);

      // Extract new ticket — handle both response shapes:
      //   • { auth: { persistentTicket: '...' } }  (Flutter verify-OTP shape)
      //   • { persistentTicket: '...' }             (Android auto-login shape)
      final authMap = data['auth'];
      final newTicket =
          (authMap is Map<String, dynamic>
              ? authMap['persistentTicket'] as String?
              : null) ??
          data['persistentTicket'] as String?;

      if (newTicket != null && newTicket.isNotEmpty) {
        _authHeaderInterceptor.setPersistentTicket(newTicket);
        await _prefManager?.setPersistentTicket(newTicket);
      }

      return _retry(err, handler);
    } catch (_) {
      return handler.next(err);
    }
  }

  Future<void> _retry(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    try {
      final opts = err.requestOptions;
      final retryResponse = await _mainDio.fetch<dynamic>(
        opts.copyWith(
          extra: <String, dynamic>{
            ...opts.extra,
            '_autoLoginRetried': true,
          },
        ),
      );
      handler.resolve(retryResponse);
    } catch (retryErr) {
      handler.next(retryErr is DioException ? retryErr : err);
    }
  }
}
