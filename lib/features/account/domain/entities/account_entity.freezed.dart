// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AccountEntity {

 String? get customerId; String? get name; String? get email; String? get phone; String? get avatarUrl; bool get isLoggedIn; bool get hasGuestData; double? get credit;
/// Create a copy of AccountEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountEntityCopyWith<AccountEntity> get copyWith => _$AccountEntityCopyWithImpl<AccountEntity>(this as AccountEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountEntity&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.isLoggedIn, isLoggedIn) || other.isLoggedIn == isLoggedIn)&&(identical(other.hasGuestData, hasGuestData) || other.hasGuestData == hasGuestData)&&(identical(other.credit, credit) || other.credit == credit));
}


@override
int get hashCode => Object.hash(runtimeType,customerId,name,email,phone,avatarUrl,isLoggedIn,hasGuestData,credit);

@override
String toString() {
  return 'AccountEntity(customerId: $customerId, name: $name, email: $email, phone: $phone, avatarUrl: $avatarUrl, isLoggedIn: $isLoggedIn, hasGuestData: $hasGuestData, credit: $credit)';
}


}

/// @nodoc
abstract mixin class $AccountEntityCopyWith<$Res>  {
  factory $AccountEntityCopyWith(AccountEntity value, $Res Function(AccountEntity) _then) = _$AccountEntityCopyWithImpl;
@useResult
$Res call({
 String? customerId, String? name, String? email, String? phone, String? avatarUrl, bool isLoggedIn, bool hasGuestData, double? credit
});




}
/// @nodoc
class _$AccountEntityCopyWithImpl<$Res>
    implements $AccountEntityCopyWith<$Res> {
  _$AccountEntityCopyWithImpl(this._self, this._then);

  final AccountEntity _self;
  final $Res Function(AccountEntity) _then;

/// Create a copy of AccountEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? customerId = freezed,Object? name = freezed,Object? email = freezed,Object? phone = freezed,Object? avatarUrl = freezed,Object? isLoggedIn = null,Object? hasGuestData = null,Object? credit = freezed,}) {
  return _then(_self.copyWith(
customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,isLoggedIn: null == isLoggedIn ? _self.isLoggedIn : isLoggedIn // ignore: cast_nullable_to_non_nullable
as bool,hasGuestData: null == hasGuestData ? _self.hasGuestData : hasGuestData // ignore: cast_nullable_to_non_nullable
as bool,credit: freezed == credit ? _self.credit : credit // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [AccountEntity].
extension AccountEntityPatterns on AccountEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountEntity value)  $default,){
final _that = this;
switch (_that) {
case _AccountEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountEntity value)?  $default,){
final _that = this;
switch (_that) {
case _AccountEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? customerId,  String? name,  String? email,  String? phone,  String? avatarUrl,  bool isLoggedIn,  bool hasGuestData,  double? credit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountEntity() when $default != null:
return $default(_that.customerId,_that.name,_that.email,_that.phone,_that.avatarUrl,_that.isLoggedIn,_that.hasGuestData,_that.credit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? customerId,  String? name,  String? email,  String? phone,  String? avatarUrl,  bool isLoggedIn,  bool hasGuestData,  double? credit)  $default,) {final _that = this;
switch (_that) {
case _AccountEntity():
return $default(_that.customerId,_that.name,_that.email,_that.phone,_that.avatarUrl,_that.isLoggedIn,_that.hasGuestData,_that.credit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? customerId,  String? name,  String? email,  String? phone,  String? avatarUrl,  bool isLoggedIn,  bool hasGuestData,  double? credit)?  $default,) {final _that = this;
switch (_that) {
case _AccountEntity() when $default != null:
return $default(_that.customerId,_that.name,_that.email,_that.phone,_that.avatarUrl,_that.isLoggedIn,_that.hasGuestData,_that.credit);case _:
  return null;

}
}

}

/// @nodoc


class _AccountEntity implements AccountEntity {
  const _AccountEntity({this.customerId, this.name, this.email, this.phone, this.avatarUrl, this.isLoggedIn = false, this.hasGuestData = false, this.credit});
  

@override final  String? customerId;
@override final  String? name;
@override final  String? email;
@override final  String? phone;
@override final  String? avatarUrl;
@override@JsonKey() final  bool isLoggedIn;
@override@JsonKey() final  bool hasGuestData;
@override final  double? credit;

/// Create a copy of AccountEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountEntityCopyWith<_AccountEntity> get copyWith => __$AccountEntityCopyWithImpl<_AccountEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountEntity&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.isLoggedIn, isLoggedIn) || other.isLoggedIn == isLoggedIn)&&(identical(other.hasGuestData, hasGuestData) || other.hasGuestData == hasGuestData)&&(identical(other.credit, credit) || other.credit == credit));
}


@override
int get hashCode => Object.hash(runtimeType,customerId,name,email,phone,avatarUrl,isLoggedIn,hasGuestData,credit);

@override
String toString() {
  return 'AccountEntity(customerId: $customerId, name: $name, email: $email, phone: $phone, avatarUrl: $avatarUrl, isLoggedIn: $isLoggedIn, hasGuestData: $hasGuestData, credit: $credit)';
}


}

/// @nodoc
abstract mixin class _$AccountEntityCopyWith<$Res> implements $AccountEntityCopyWith<$Res> {
  factory _$AccountEntityCopyWith(_AccountEntity value, $Res Function(_AccountEntity) _then) = __$AccountEntityCopyWithImpl;
@override @useResult
$Res call({
 String? customerId, String? name, String? email, String? phone, String? avatarUrl, bool isLoggedIn, bool hasGuestData, double? credit
});




}
/// @nodoc
class __$AccountEntityCopyWithImpl<$Res>
    implements _$AccountEntityCopyWith<$Res> {
  __$AccountEntityCopyWithImpl(this._self, this._then);

  final _AccountEntity _self;
  final $Res Function(_AccountEntity) _then;

/// Create a copy of AccountEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? customerId = freezed,Object? name = freezed,Object? email = freezed,Object? phone = freezed,Object? avatarUrl = freezed,Object? isLoggedIn = null,Object? hasGuestData = null,Object? credit = freezed,}) {
  return _then(_AccountEntity(
customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,isLoggedIn: null == isLoggedIn ? _self.isLoggedIn : isLoggedIn // ignore: cast_nullable_to_non_nullable
as bool,hasGuestData: null == hasGuestData ? _self.hasGuestData : hasGuestData // ignore: cast_nullable_to_non_nullable
as bool,credit: freezed == credit ? _self.credit : credit // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
