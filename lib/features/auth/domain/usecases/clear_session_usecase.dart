import 'package:injectable/injectable.dart';

import '../repositories/session_repository.dart';

@lazySingleton
class ClearSessionUseCase {
  ClearSessionUseCase(this._repository);

  final SessionRepository _repository;

  Future<void> call() => _repository.clearSession();
}
