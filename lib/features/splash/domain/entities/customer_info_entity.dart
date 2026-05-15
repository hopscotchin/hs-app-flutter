import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../auth/domain/entities/user_config/user_config_entity.dart';

part 'customer_info_entity.freezed.dart';

/// Domain entity for the proposed `GET customer/v3/info` response.
///
/// Renamed fields vs current API:
///   - cartItemQty   → cartItemCount
///   - isRegister    → isNewUser
///   - appConfigUser → userConfig
@freezed
abstract class CustomerInfoEntity with _$CustomerInfoEntity {
  const factory CustomerInfoEntity({
    String? actionURI,
    String? actionText,
    @Default(0) int cartItemCount,
    @Default(false) bool isNewUser,
    @Default(false) bool isLoggedIn,
    @Default(false) bool hasGuestData,
    Map<String, dynamic>? childCohorts,
    UserConfigEntity? userConfig,
  }) = _CustomerInfoEntity;
}
