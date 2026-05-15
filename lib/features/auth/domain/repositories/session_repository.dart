import '../entities/verfiy_otp_response/verify_otp_response_entity.dart';

abstract class SessionRepository {
  Future<void> saveSession(VerifyOtpResponseEntity entity);
  Future<void> clearSession();
}
