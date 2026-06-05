import 'package:json_annotation/json_annotation.dart';

import '../../../../core/network/models/action_response.dart';
import '../../../../core/utils/json_parsers.dart';
import '../../../auth/data/models/auth_credentials/auth_credentials_model.dart';
import '../../../auth/data/models/user_config/user_config_model.dart';
import '../../../auth/data/models/user_info/user_info_model.dart';
import '../../domain/entities/customer_info_entity.dart';

part 'customer_info_model.g.dart';

UserConfigModel? _userConfigFromJson(Object? json) =>
    json is Map<String, dynamic> ? UserConfigModel.fromJson(json) : null;

UserInfoModel? _userFromJson(Object? json) =>
    json is Map<String, dynamic> ? UserInfoModel.fromJson(json) : null;

AuthCredentialsModel? _authFromJson(Object? json) =>
    json is Map<String, dynamic> ? AuthCredentialsModel.fromJson(json) : null;

/// Data model for `GET customer/v3/info`.
@JsonSerializable(createToJson: false)
class CustomerInfoModel {
  const CustomerInfoModel({
    this.actionURI,
    this.actionText,
    this.cartItemCount = 0,
    this.isNewUser = false,
    this.isLoggedIn = false,
    this.hasGuestData = false,
    this.childCohorts,
    this.user,
    this.auth,
    this.userConfig,
  });

  @JsonKey(defaultValue: null)
  final String? actionURI;
  @JsonKey(defaultValue: null)
  final String? actionText;
  @JsonKey(fromJson: parseToInt, defaultValue: 0)
  final int cartItemCount;
  @JsonKey(fromJson: parseToBool, defaultValue: false)
  final bool isNewUser;
  @JsonKey(fromJson: parseToBool, defaultValue: false)
  final bool isLoggedIn;
  @JsonKey(fromJson: parseToBool, defaultValue: false)
  final bool hasGuestData;
  @JsonKey(defaultValue: null)
  final Map<String, dynamic>? childCohorts;
  @JsonKey(fromJson: _userFromJson)
  final UserInfoModel? user;
  @JsonKey(fromJson: _authFromJson)
  final AuthCredentialsModel? auth;
  @JsonKey(name: 'userConfig', fromJson: _userConfigFromJson)
  final UserConfigModel? userConfig;

  factory CustomerInfoModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerInfoModelFromJson(ActionResponse.validate(json));
}

extension CustomerInfoModelX on CustomerInfoModel {
  CustomerInfoEntity toEntity() => CustomerInfoEntity(
    actionURI: actionURI,
    actionText: actionText,
    cartItemCount: cartItemCount,
    isNewUser: isNewUser,
    isLoggedIn: isLoggedIn,
    hasGuestData: hasGuestData,
    childCohorts: childCohorts,
    user: user?.toEntity(),
    auth: auth?.toEntity(),
    userConfig: userConfig?.toEntity(),
  );
}
