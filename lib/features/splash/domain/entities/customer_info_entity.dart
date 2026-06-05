import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../auth/domain/entities/auth_credentials/auth_credentials_entity.dart';
import '../../../auth/domain/entities/user_config/user_config_entity.dart';
import '../../../auth/domain/entities/user_info/user_info_entity.dart';

part 'customer_info_entity.freezed.dart';

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
    UserInfoEntity? user,
    AuthCredentialsEntity? auth,
    UserConfigEntity? userConfig,
  }) = _CustomerInfoEntity;
}
