// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_info_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserInfoEntity {

 String? get userId; String? get firstName; String? get lastName; String? get email; String? get mobile; bool get isLoggedIn; bool get isNewUser; String? get userName; String? get mobileStatus; int get cartItemCount;
/// Create a copy of UserInfoEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserInfoEntityCopyWith<UserInfoEntity> get copyWith => _$UserInfoEntityCopyWithImpl<UserInfoEntity>(this as UserInfoEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserInfoEntity&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.email, email) || other.email == email)&&(identical(other.mobile, mobile) || other.mobile == mobile)&&(identical(other.isLoggedIn, isLoggedIn) || other.isLoggedIn == isLoggedIn)&&(identical(other.isNewUser, isNewUser) || other.isNewUser == isNewUser)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.mobileStatus, mobileStatus) || other.mobileStatus == mobileStatus)&&(identical(other.cartItemCount, cartItemCount) || other.cartItemCount == cartItemCount));
}


@override
int get hashCode => Object.hash(runtimeType,userId,firstName,lastName,email,mobile,isLoggedIn,isNewUser,userName,mobileStatus,cartItemCount);

@override
String toString() {
  return 'UserInfoEntity(userId: $userId, firstName: $firstName, lastName: $lastName, email: $email, mobile: $mobile, isLoggedIn: $isLoggedIn, isNewUser: $isNewUser, userName: $userName, mobileStatus: $mobileStatus, cartItemCount: $cartItemCount)';
}


}

/// @nodoc
abstract mixin class $UserInfoEntityCopyWith<$Res>  {
  factory $UserInfoEntityCopyWith(UserInfoEntity value, $Res Function(UserInfoEntity) _then) = _$UserInfoEntityCopyWithImpl;
@useResult
$Res call({
 String? userId, String? firstName, String? lastName, String? email, String? mobile, bool isLoggedIn, bool isNewUser, String? userName, String? mobileStatus, int cartItemCount
});




}
/// @nodoc
class _$UserInfoEntityCopyWithImpl<$Res>
    implements $UserInfoEntityCopyWith<$Res> {
  _$UserInfoEntityCopyWithImpl(this._self, this._then);

  final UserInfoEntity _self;
  final $Res Function(UserInfoEntity) _then;

/// Create a copy of UserInfoEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = freezed,Object? firstName = freezed,Object? lastName = freezed,Object? email = freezed,Object? mobile = freezed,Object? isLoggedIn = null,Object? isNewUser = null,Object? userName = freezed,Object? mobileStatus = freezed,Object? cartItemCount = null,}) {
  return _then(_self.copyWith(
userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,mobile: freezed == mobile ? _self.mobile : mobile // ignore: cast_nullable_to_non_nullable
as String?,isLoggedIn: null == isLoggedIn ? _self.isLoggedIn : isLoggedIn // ignore: cast_nullable_to_non_nullable
as bool,isNewUser: null == isNewUser ? _self.isNewUser : isNewUser // ignore: cast_nullable_to_non_nullable
as bool,userName: freezed == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String?,mobileStatus: freezed == mobileStatus ? _self.mobileStatus : mobileStatus // ignore: cast_nullable_to_non_nullable
as String?,cartItemCount: null == cartItemCount ? _self.cartItemCount : cartItemCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [UserInfoEntity].
extension UserInfoEntityPatterns on UserInfoEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserInfoEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserInfoEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserInfoEntity value)  $default,){
final _that = this;
switch (_that) {
case _UserInfoEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserInfoEntity value)?  $default,){
final _that = this;
switch (_that) {
case _UserInfoEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? userId,  String? firstName,  String? lastName,  String? email,  String? mobile,  bool isLoggedIn,  bool isNewUser,  String? userName,  String? mobileStatus,  int cartItemCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserInfoEntity() when $default != null:
return $default(_that.userId,_that.firstName,_that.lastName,_that.email,_that.mobile,_that.isLoggedIn,_that.isNewUser,_that.userName,_that.mobileStatus,_that.cartItemCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? userId,  String? firstName,  String? lastName,  String? email,  String? mobile,  bool isLoggedIn,  bool isNewUser,  String? userName,  String? mobileStatus,  int cartItemCount)  $default,) {final _that = this;
switch (_that) {
case _UserInfoEntity():
return $default(_that.userId,_that.firstName,_that.lastName,_that.email,_that.mobile,_that.isLoggedIn,_that.isNewUser,_that.userName,_that.mobileStatus,_that.cartItemCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? userId,  String? firstName,  String? lastName,  String? email,  String? mobile,  bool isLoggedIn,  bool isNewUser,  String? userName,  String? mobileStatus,  int cartItemCount)?  $default,) {final _that = this;
switch (_that) {
case _UserInfoEntity() when $default != null:
return $default(_that.userId,_that.firstName,_that.lastName,_that.email,_that.mobile,_that.isLoggedIn,_that.isNewUser,_that.userName,_that.mobileStatus,_that.cartItemCount);case _:
  return null;

}
}

}

/// @nodoc


class _UserInfoEntity implements UserInfoEntity {
  const _UserInfoEntity({this.userId, this.firstName, this.lastName, this.email, this.mobile, this.isLoggedIn = false, this.isNewUser = false, this.userName, this.mobileStatus, this.cartItemCount = 0});
  

@override final  String? userId;
@override final  String? firstName;
@override final  String? lastName;
@override final  String? email;
@override final  String? mobile;
@override@JsonKey() final  bool isLoggedIn;
@override@JsonKey() final  bool isNewUser;
@override final  String? userName;
@override final  String? mobileStatus;
@override@JsonKey() final  int cartItemCount;

/// Create a copy of UserInfoEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserInfoEntityCopyWith<_UserInfoEntity> get copyWith => __$UserInfoEntityCopyWithImpl<_UserInfoEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserInfoEntity&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.email, email) || other.email == email)&&(identical(other.mobile, mobile) || other.mobile == mobile)&&(identical(other.isLoggedIn, isLoggedIn) || other.isLoggedIn == isLoggedIn)&&(identical(other.isNewUser, isNewUser) || other.isNewUser == isNewUser)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.mobileStatus, mobileStatus) || other.mobileStatus == mobileStatus)&&(identical(other.cartItemCount, cartItemCount) || other.cartItemCount == cartItemCount));
}


@override
int get hashCode => Object.hash(runtimeType,userId,firstName,lastName,email,mobile,isLoggedIn,isNewUser,userName,mobileStatus,cartItemCount);

@override
String toString() {
  return 'UserInfoEntity(userId: $userId, firstName: $firstName, lastName: $lastName, email: $email, mobile: $mobile, isLoggedIn: $isLoggedIn, isNewUser: $isNewUser, userName: $userName, mobileStatus: $mobileStatus, cartItemCount: $cartItemCount)';
}


}

/// @nodoc
abstract mixin class _$UserInfoEntityCopyWith<$Res> implements $UserInfoEntityCopyWith<$Res> {
  factory _$UserInfoEntityCopyWith(_UserInfoEntity value, $Res Function(_UserInfoEntity) _then) = __$UserInfoEntityCopyWithImpl;
@override @useResult
$Res call({
 String? userId, String? firstName, String? lastName, String? email, String? mobile, bool isLoggedIn, bool isNewUser, String? userName, String? mobileStatus, int cartItemCount
});




}
/// @nodoc
class __$UserInfoEntityCopyWithImpl<$Res>
    implements _$UserInfoEntityCopyWith<$Res> {
  __$UserInfoEntityCopyWithImpl(this._self, this._then);

  final _UserInfoEntity _self;
  final $Res Function(_UserInfoEntity) _then;

/// Create a copy of UserInfoEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = freezed,Object? firstName = freezed,Object? lastName = freezed,Object? email = freezed,Object? mobile = freezed,Object? isLoggedIn = null,Object? isNewUser = null,Object? userName = freezed,Object? mobileStatus = freezed,Object? cartItemCount = null,}) {
  return _then(_UserInfoEntity(
userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,mobile: freezed == mobile ? _self.mobile : mobile // ignore: cast_nullable_to_non_nullable
as String?,isLoggedIn: null == isLoggedIn ? _self.isLoggedIn : isLoggedIn // ignore: cast_nullable_to_non_nullable
as bool,isNewUser: null == isNewUser ? _self.isNewUser : isNewUser // ignore: cast_nullable_to_non_nullable
as bool,userName: freezed == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String?,mobileStatus: freezed == mobileStatus ? _self.mobileStatus : mobileStatus // ignore: cast_nullable_to_non_nullable
as String?,cartItemCount: null == cartItemCount ? _self.cartItemCount : cartItemCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
