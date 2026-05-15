import '../models/login_model.dart';
import '../../domain/entities/otp_config/otp_config_entity.dart';
import '../../domain/entities/signup_otp_response/signup_otp_response_entity.dart';

/// Converts the [LoginModel] response from the current `customer/signup/send/otp`
/// endpoint into the proposed [SignupOtpResponseEntity] structure.
///
/// DELETE this file once the backend ships `customer/v3/auth/signup/send-otp`.
class SignupOtpTransformer {
  const SignupOtpTransformer._();

  static SignupOtpResponseEntity transform(LoginModel old) =>
      SignupOtpResponseEntity(
        otp: OtpConfigEntity(timerSeconds: old.timer, length: old.otpLength),
        loginId: old.loginId,
        mobile: old.phoneNumber,
        email: old.email,
        action: old.action,
        popUpMessage: old.popUpMessage,
      );
}
