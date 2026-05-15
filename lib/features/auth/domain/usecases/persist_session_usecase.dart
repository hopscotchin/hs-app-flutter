import 'package:injectable/injectable.dart';

import '../entities/verfiy_otp_response/verify_otp_response_entity.dart';
import '../repositories/session_repository.dart';

@lazySingleton
class PersistSessionUseCase {
  PersistSessionUseCase(this._repository);

  final SessionRepository _repository;

  Future<void> call(VerifyOtpResponseEntity entity) =>
      _repository.saveSession(entity);
}
