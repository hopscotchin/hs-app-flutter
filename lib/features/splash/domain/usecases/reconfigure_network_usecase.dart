import 'package:injectable/injectable.dart' hide Environment;

import '../../../../core/config/environment.dart';
import '../../../../core/network/network_client.dart';

@lazySingleton
class ReconfigureNetworkUseCase {
  ReconfigureNetworkUseCase(this._networkClient);

  final NetworkClient _networkClient;

  void call(Environment environment) {
    EnvironmentConfig.setEnvironment(environment);
    _networkClient.onEnvironmentChanged();
  }
}
