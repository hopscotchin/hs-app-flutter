// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LoginEntity {

 String? get userId; String? get firstName; String? get lastName; String? get userName; String? get persistentTicket; String? get loginId; int get timer; String? get email; String? get phoneNumber; int get otpLength; String? get profileImage; bool get isLoggedIn; bool get isRegister; int get cartItemQty; String? get mobileStatus; String? get popUpMessage; String? get action; MessageBarEntity? get messageBar;
/// Create a copy of LoginEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginEntityCopyWith<LoginEntity> get copyWith => _$LoginEntityCopyWithImpl<LoginEntity>(this as LoginEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginEntity&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.persistentTicket, persistentTicket) || other.persistentTicket == persistentTicket)&&(identical(other.loginId, loginId) || other.loginId == loginId)&&(identical(other.timer, timer) || other.timer == timer)&&(identical(other.email, email) || other.email == email)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.otpLength, otpLength) || other.otpLength == otpLength)&&(identical(other.profileImage, profileImage) || other.profileImage == profileImage)&&(identical(other.isLoggedIn, isLoggedIn) || other.isLoggedIn == isLoggedIn)&&(identical(other.isRegister, isRegister) || other.isRegister == isRegister)&&(identical(other.cartItemQty, cartItemQty) || other.cartItemQty == cartItemQty)&&(identical(other.mobileStatus, mobileStatus) || other.mobileStatus == mobileStatus)&&(identical(other.popUpMessage, popUpMessage) || other.popUpMessage == popUpMessage)&&(identical(other.action, action) || other.action == action)&&(identical(other.messageBar, messageBar) || other.messageBar == messageBar));
}


@override
int get hashCode => Object.hash(runtimeType,userId,firstName,lastName,userName,persistentTicket,loginId,timer,email,phoneNumber,otpLength,profileImage,isLoggedIn,isRegister,cartItemQty,mobileStatus,popUpMessage,action,messageBar);

@override
String toString() {
  return 'LoginEntity(userId: $userId, firstName: $firstName, lastName: $lastName, userName: $userName, persistentTicket: $persistentTicket, loginId: $loginId, timer: $timer, email: $email, phoneNumber: $phoneNumber, otpLength: $otpLength, profileImage: $profileImage, isLoggedIn: $isLoggedIn, isRegister: $isRegister, cartItemQty: $cartItemQty, mobileStatus: $mobileStatus, popUpMessage: $popUpMessage, action: $action, messageBar: $messageBar)';
}


}

/// @nodoc
abstract mixin class $LoginEntityCopyWith<$Res>  {
  factory $LoginEntityCopyWith(LoginEntity value, $Res Function(LoginEntity) _then) = _$LoginEntityCopyWithImpl;
@useResult
$Res call({
 String? userId, String? firstName, String? lastName, String? userName, String? persistentTicket, String? loginId, int timer, String? email, String? phoneNumber, int otpLength, String? profileImage, bool isLoggedIn, bool isRegister, int cartItemQty, String? mobileStatus, String? popUpMessage, String? action, MessageBarEntity? messageBar
});




}
/// @nodoc
class _$LoginEntityCopyWithImpl<$Res>
    implements $LoginEntityCopyWith<$Res> {
  _$LoginEntityCopyWithImpl(this._self, this._then);

  final LoginEntity _self;
  final $Res Function(LoginEntity) _then;

/// Create a copy of LoginEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = freezed,Object? firstName = freezed,Object? lastName = freezed,Object? userName = freezed,Object? persistentTicket = freezed,Object? loginId = freezed,Object? timer = null,Object? email = freezed,Object? phoneNumber = freezed,Object? otpLength = null,Object? profileImage = freezed,Object? isLoggedIn = null,Object? isRegister = null,Object? cartItemQty = null,Object? mobileStatus = freezed,Object? popUpMessage = freezed,Object? action = freezed,Object? messageBar = freezed,}) {
  return _then(_self.copyWith(
userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,userName: freezed == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String?,persistentTicket: freezed == persistentTicket ? _self.persistentTicket : persistentTicket // ignore: cast_nullable_to_non_nullable
as String?,loginId: freezed == loginId ? _self.loginId : loginId // ignore: cast_nullable_to_non_nullable
as String?,timer: null == timer ? _self.timer : timer // ignore: cast_nullable_to_non_nullable
as int,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,otpLength: null == otpLength ? _self.otpLength : otpLength // ignore: cast_nullable_to_non_nullable
as int,profileImage: freezed == profileImage ? _self.profileImage : profileImage // ignore: cast_nullable_to_non_nullable
as String?,isLoggedIn: null == isLoggedIn ? _self.isLoggedIn : isLoggedIn // ignore: cast_nullable_to_non_nullable
as bool,isRegister: null == isRegister ? _self.isRegister : isRegister // ignore: cast_nullable_to_non_nullable
as bool,cartItemQty: null == cartItemQty ? _self.cartItemQty : cartItemQty // ignore: cast_nullable_to_non_nullable
as int,mobileStatus: freezed == mobileStatus ? _self.mobileStatus : mobileStatus // ignore: cast_nullable_to_non_nullable
as String?,popUpMessage: freezed == popUpMessage ? _self.popUpMessage : popUpMessage // ignore: cast_nullable_to_non_nullable
as String?,action: freezed == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String?,messageBar: freezed == messageBar ? _self.messageBar : messageBar // ignore: cast_nullable_to_non_nullable
as MessageBarEntity?,
  ));
}

}


/// Adds pattern-matching-related methods to [LoginEntity].
extension LoginEntityPatterns on LoginEntity {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoginEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoginEntity() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoginEntity value)  $default,){
final _that = this;
switch (_that) {
case _LoginEntity():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoginEntity value)?  $default,){
final _that = this;
switch (_that) {
case _LoginEntity() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? userId,  String? firstName,  String? lastName,  String? userName,  String? persistentTicket,  String? loginId,  int timer,  String? email,  String? phoneNumber,  int otpLength,  String? profileImage,  bool isLoggedIn,  bool isRegister,  int cartItemQty,  String? mobileStatus,  String? popUpMessage,  String? action,  MessageBarEntity? messageBar)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoginEntity() when $default != null:
return $default(_that.userId,_that.firstName,_that.lastName,_that.userName,_that.persistentTicket,_that.loginId,_that.timer,_that.email,_that.phoneNumber,_that.otpLength,_that.profileImage,_that.isLoggedIn,_that.isRegister,_that.cartItemQty,_that.mobileStatus,_that.popUpMessage,_that.action,_that.messageBar);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? userId,  String? firstName,  String? lastName,  String? userName,  String? persistentTicket,  String? loginId,  int timer,  String? email,  String? phoneNumber,  int otpLength,  String? profileImage,  bool isLoggedIn,  bool isRegister,  int cartItemQty,  String? mobileStatus,  String? popUpMessage,  String? action,  MessageBarEntity? messageBar)  $default,) {final _that = this;
switch (_that) {
case _LoginEntity():
return $default(_that.userId,_that.firstName,_that.lastName,_that.userName,_that.persistentTicket,_that.loginId,_that.timer,_that.email,_that.phoneNumber,_that.otpLength,_that.profileImage,_that.isLoggedIn,_that.isRegister,_that.cartItemQty,_that.mobileStatus,_that.popUpMessage,_that.action,_that.messageBar);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? userId,  String? firstName,  String? lastName,  String? userName,  String? persistentTicket,  String? loginId,  int timer,  String? email,  String? phoneNumber,  int otpLength,  String? profileImage,  bool isLoggedIn,  bool isRegister,  int cartItemQty,  String? mobileStatus,  String? popUpMessage,  String? action,  MessageBarEntity? messageBar)?  $default,) {final _that = this;
switch (_that) {
case _LoginEntity() when $default != null:
return $default(_that.userId,_that.firstName,_that.lastName,_that.userName,_that.persistentTicket,_that.loginId,_that.timer,_that.email,_that.phoneNumber,_that.otpLength,_that.profileImage,_that.isLoggedIn,_that.isRegister,_that.cartItemQty,_that.mobileStatus,_that.popUpMessage,_that.action,_that.messageBar);case _:
  return null;

}
}

}

/// @nodoc


class _LoginEntity implements LoginEntity {
  const _LoginEntity({this.userId, this.firstName, this.lastName, this.userName, this.persistentTicket, this.loginId, this.timer = 0, this.email, this.phoneNumber, this.otpLength = 6, this.profileImage, this.isLoggedIn = false, this.isRegister = false, this.cartItemQty = 0, this.mobileStatus, this.popUpMessage, this.action, this.messageBar});
  

@override final  String? userId;
@override final  String? firstName;
@override final  String? lastName;
@override final  String? userName;
@override final  String? persistentTicket;
@override final  String? loginId;
@override@JsonKey() final  int timer;
@override final  String? email;
@override final  String? phoneNumber;
@override@JsonKey() final  int otpLength;
@override final  String? profileImage;
@override@JsonKey() final  bool isLoggedIn;
@override@JsonKey() final  bool isRegister;
@override@JsonKey() final  int cartItemQty;
@override final  String? mobileStatus;
@override final  String? popUpMessage;
@override final  String? action;
@override final  MessageBarEntity? messageBar;

/// Create a copy of LoginEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoginEntityCopyWith<_LoginEntity> get copyWith => __$LoginEntityCopyWithImpl<_LoginEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoginEntity&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.persistentTicket, persistentTicket) || other.persistentTicket == persistentTicket)&&(identical(other.loginId, loginId) || other.loginId == loginId)&&(identical(other.timer, timer) || other.timer == timer)&&(identical(other.email, email) || other.email == email)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.otpLength, otpLength) || other.otpLength == otpLength)&&(identical(other.profileImage, profileImage) || other.profileImage == profileImage)&&(identical(other.isLoggedIn, isLoggedIn) || other.isLoggedIn == isLoggedIn)&&(identical(other.isRegister, isRegister) || other.isRegister == isRegister)&&(identical(other.cartItemQty, cartItemQty) || other.cartItemQty == cartItemQty)&&(identical(other.mobileStatus, mobileStatus) || other.mobileStatus == mobileStatus)&&(identical(other.popUpMessage, popUpMessage) || other.popUpMessage == popUpMessage)&&(identical(other.action, action) || other.action == action)&&(identical(other.messageBar, messageBar) || other.messageBar == messageBar));
}


@override
int get hashCode => Object.hash(runtimeType,userId,firstName,lastName,userName,persistentTicket,loginId,timer,email,phoneNumber,otpLength,profileImage,isLoggedIn,isRegister,cartItemQty,mobileStatus,popUpMessage,action,messageBar);

@override
String toString() {
  return 'LoginEntity(userId: $userId, firstName: $firstName, lastName: $lastName, userName: $userName, persistentTicket: $persistentTicket, loginId: $loginId, timer: $timer, email: $email, phoneNumber: $phoneNumber, otpLength: $otpLength, profileImage: $profileImage, isLoggedIn: $isLoggedIn, isRegister: $isRegister, cartItemQty: $cartItemQty, mobileStatus: $mobileStatus, popUpMessage: $popUpMessage, action: $action, messageBar: $messageBar)';
}


}

/// @nodoc
abstract mixin class _$LoginEntityCopyWith<$Res> implements $LoginEntityCopyWith<$Res> {
  factory _$LoginEntityCopyWith(_LoginEntity value, $Res Function(_LoginEntity) _then) = __$LoginEntityCopyWithImpl;
@override @useResult
$Res call({
 String? userId, String? firstName, String? lastName, String? userName, String? persistentTicket, String? loginId, int timer, String? email, String? phoneNumber, int otpLength, String? profileImage, bool isLoggedIn, bool isRegister, int cartItemQty, String? mobileStatus, String? popUpMessage, String? action, MessageBarEntity? messageBar
});




}
/// @nodoc
class __$LoginEntityCopyWithImpl<$Res>
    implements _$LoginEntityCopyWith<$Res> {
  __$LoginEntityCopyWithImpl(this._self, this._then);

  final _LoginEntity _self;
  final $Res Function(_LoginEntity) _then;

/// Create a copy of LoginEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = freezed,Object? firstName = freezed,Object? lastName = freezed,Object? userName = freezed,Object? persistentTicket = freezed,Object? loginId = freezed,Object? timer = null,Object? email = freezed,Object? phoneNumber = freezed,Object? otpLength = null,Object? profileImage = freezed,Object? isLoggedIn = null,Object? isRegister = null,Object? cartItemQty = null,Object? mobileStatus = freezed,Object? popUpMessage = freezed,Object? action = freezed,Object? messageBar = freezed,}) {
  return _then(_LoginEntity(
userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,userName: freezed == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String?,persistentTicket: freezed == persistentTicket ? _self.persistentTicket : persistentTicket // ignore: cast_nullable_to_non_nullable
as String?,loginId: freezed == loginId ? _self.loginId : loginId // ignore: cast_nullable_to_non_nullable
as String?,timer: null == timer ? _self.timer : timer // ignore: cast_nullable_to_non_nullable
as int,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,otpLength: null == otpLength ? _self.otpLength : otpLength // ignore: cast_nullable_to_non_nullable
as int,profileImage: freezed == profileImage ? _self.profileImage : profileImage // ignore: cast_nullable_to_non_nullable
as String?,isLoggedIn: null == isLoggedIn ? _self.isLoggedIn : isLoggedIn // ignore: cast_nullable_to_non_nullable
as bool,isRegister: null == isRegister ? _self.isRegister : isRegister // ignore: cast_nullable_to_non_nullable
as bool,cartItemQty: null == cartItemQty ? _self.cartItemQty : cartItemQty // ignore: cast_nullable_to_non_nullable
as int,mobileStatus: freezed == mobileStatus ? _self.mobileStatus : mobileStatus // ignore: cast_nullable_to_non_nullable
as String?,popUpMessage: freezed == popUpMessage ? _self.popUpMessage : popUpMessage // ignore: cast_nullable_to_non_nullable
as String?,action: freezed == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String?,messageBar: freezed == messageBar ? _self.messageBar : messageBar // ignore: cast_nullable_to_non_nullable
as MessageBarEntity?,
  ));
}


}

// dart format on
