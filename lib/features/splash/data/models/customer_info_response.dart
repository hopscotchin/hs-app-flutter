import '../../../../core/network/models/action_response.dart';

/// Typed model for the `/customer/v2/info` API response.
///
/// Mirrors Android's `LoginResponse` fields that are persisted by
/// `UserUtil.saveUserInfo`.
class CustomerInfoResponse extends ActionResponse {
  final String? userId;
  final String? firstName;
  final String? lastName;
  final String? userName;
  final String? email;
  final String? phoneNumber;
  final String? gender;
  final String? profileImage;
  final String? persistentTicket;
  final String? mobileStatus;
  final bool isLoggedIn;
  final bool hasGuestData;
  final int cartItemQty;

  const CustomerInfoResponse({
    this.userId,
    this.firstName,
    this.lastName,
    this.userName,
    this.email,
    this.phoneNumber,
    this.gender,
    this.profileImage,
    this.persistentTicket,
    this.mobileStatus,
    this.isLoggedIn = false,
    this.hasGuestData = false,
    this.cartItemQty = 0,
  });

  CustomerInfoResponse.fromJson(super.json)
      : userId = json['userId'] as String?,
        firstName = json['firstName'] as String?,
        lastName = json['lastName'] as String?,
        userName = json['userName'] as String?,
        email = json['email'] as String?,
        phoneNumber = json['phoneNumber'] as String?,
        gender = json['gender'] as String?,
        profileImage = json['profileImage'] as String?,
        persistentTicket = json['persistentTicket'] as String?,
        mobileStatus = json['mobileStatus'] as String?,
        isLoggedIn = json['isLoggedIn'] as bool? ?? false,
        hasGuestData = json['hasGuestData'] as bool? ?? false,
        cartItemQty = json['cartItemQty'] as int? ?? 0,
        super.fromJson();

  @override
  List<Object?> get props => [
        action,
        userId,
        firstName,
        lastName,
        userName,
        email,
        phoneNumber,
        gender,
        profileImage,
        persistentTicket,
        mobileStatus,
        isLoggedIn,
        hasGuestData,
        cartItemQty,
      ];
}
