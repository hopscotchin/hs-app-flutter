import '../models/login_model.dart';
import '../../domain/entities/auth_credentials/auth_credentials_entity.dart';
import '../../domain/entities/user_info/user_info_entity.dart';
import '../../domain/entities/verfiy_otp_response/verify_otp_response_entity.dart';

/// Converts the [LoginModel] response from the current `customer/v2/verifyotp-delegate`
/// endpoint into the proposed [VerifyOtpResponseEntity] structure.
///
/// DELETE this file once the backend ships `customer/v3/auth/verify-otp`.
class VerifyOtpTransformer {
  const VerifyOtpTransformer._();

  static VerifyOtpResponseEntity transform(LoginModel old) =>
      VerifyOtpResponseEntity(
        user: UserInfoEntity(
          userId: old.userId,
          firstName: old.firstName,
          lastName: old.lastName,
          email: old.email,
          mobile: old.phoneNumber,
          isLoggedIn: old.isLoggedIn,
          isNewUser: old.isRegister,
          userName: old.userName,
          mobileStatus: old.mobileStatus,
          cartItemCount: old.cartItemQty,
        ),
        auth: AuthCredentialsEntity(persistentTicket: old.persistentTicket),
        loginId: old.loginId,
        action: old.action,
        popUpMessage: old.popUpMessage,
      );
}
