import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Base class for all feature BLoCs.
///
/// Provides:
///  - A per-bloc [CancelToken] so in-flight Dio requests are cancelled when
///    the bloc is closed.
///  - [swapCancelToken] to cancel previous in-flight requests when a new
///    event of the same kind is received (e.g. typing a new search query,
///    pull-to-refresh while a load is in flight, pagination restart).
///
/// Every feature BLoC in this codebase MUST extend this class.
/// See: CODING_GUIDELINES.md §2.4
abstract class BaseBloc<E, S> extends Bloc<E, S> {
  BaseBloc(super.initialState);

  CancelToken? _cancelToken;

  /// Returns a fresh [CancelToken] and cancels the previous one if it
  /// existed. Use this at the start of any handler that calls the network.
  CancelToken swapCancelToken() {
    _cancelToken?.cancel('Cancelled by bloc: a newer request superseded it.');
    final token = CancelToken();
    _cancelToken = token;
    return token;
  }

  @override
  Future<void> close() {
    _cancelToken?.cancel('Bloc closed.');
    _cancelToken = null;
    return super.close();
  }
}
