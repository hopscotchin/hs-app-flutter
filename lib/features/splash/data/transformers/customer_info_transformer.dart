import '../models/customer_info_response.dart';
import '../../domain/entities/customer_info_entity.dart';

/// Converts the current [CustomerInfoResponse] from `GET customer/v2/info`
/// into the proposed [CustomerInfoEntity] structure.
///
/// DELETE this file once the backend ships `GET customer/v3/info`.
class CustomerInfoTransformer {
  const CustomerInfoTransformer._();

  static CustomerInfoEntity transform(CustomerInfoResponse old) =>
      CustomerInfoEntity(
        actionURI: old.actionURI,
        actionText: old.actionText,
        cartItemCount: old.cartItemQty,
        isNewUser: false,
        isLoggedIn: old.isLoggedIn,
        hasGuestData: old.hasGuestData,
      );
}
