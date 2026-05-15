import '../models/login_model.dart';
import '../../domain/entities/otp_config/otp_config_entity.dart';
import '../../domain/entities/send_otp_response/send_otp_response_entity.dart';

/// Converts the [LoginModel] response from the current `customer/validate-sendotp`
/// endpoint into the proposed [SendOtpResponseEntity] structure.
///
/// DELETE this file once the backend ships `customer/v3/auth/send-otp`.
class SendOtpTransformer {
  const SendOtpTransformer._();

  static SendOtpResponseEntity transform(LoginModel old) =>
      SendOtpResponseEntity(
        otp: OtpConfigEntity(timerSeconds: old.timer, length: old.otpLength),
        loginId: old.loginId,
        action: old.action,
        popUpMessage: old.popUpMessage,
      );
}
