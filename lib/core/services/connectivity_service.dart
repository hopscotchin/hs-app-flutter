import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../network/connectivity/network_info.dart';

class ConnectivityService implements NetworkInfo {
  final Connectivity _connectivity;

  late final StreamController<bool> _controller;
  late final StreamSubscription<List<ConnectivityResult>> _subscription;
  bool _lastStatus = true;

  ConnectivityService({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity() {
    _controller = StreamController<bool>.broadcast();
    _subscription = _connectivity.onConnectivityChanged.listen(_onChanged);
  }

  Stream<bool> get onConnectivityChanged => _controller.stream;

  bool get lastStatus => _lastStatus;

  @override
  Future<bool> get isConnected => checkNow();

  Future<bool> checkNow() async {
    final results = await _connectivity.checkConnectivity();
    final connected = results.any((r) => r != ConnectivityResult.none);
    _lastStatus = connected;
    return connected;
  }

  void _onChanged(List<ConnectivityResult> results) {
    final connected = results.any((r) => r != ConnectivityResult.none);
    if (connected != _lastStatus) {
      _lastStatus = connected;
      _controller.add(connected);
    }
  }

  void dispose() {
    _subscription.cancel();
    _controller.close();
  }
}
