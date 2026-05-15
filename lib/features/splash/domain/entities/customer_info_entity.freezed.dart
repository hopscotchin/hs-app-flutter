// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_info_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CustomerInfoEntity {

 String? get actionURI; String? get actionText; int get cartItemCount; bool get isNewUser; bool get isLoggedIn; bool get hasGuestData; Map<String, dynamic>? get childCohorts; UserConfigEntity? get userConfig;
/// Create a copy of CustomerInfoEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerInfoEntityCopyWith<CustomerInfoEntity> get copyWith => _$CustomerInfoEntityCopyWithImpl<CustomerInfoEntity>(this as CustomerInfoEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerInfoEntity&&(identical(other.actionURI, actionURI) || other.actionURI == actionURI)&&(identical(other.actionText, actionText) || other.actionText == actionText)&&(identical(other.cartItemCount, cartItemCount) || other.cartItemCount == cartItemCount)&&(identical(other.isNewUser, isNewUser) || other.isNewUser == isNewUser)&&(identical(other.isLoggedIn, isLoggedIn) || other.isLoggedIn == isLoggedIn)&&(identical(other.hasGuestData, hasGuestData) || other.hasGuestData == hasGuestData)&&const DeepCollectionEquality().equals(other.childCohorts, childCohorts)&&(identical(other.userConfig, userConfig) || other.userConfig == userConfig));
}


@override
int get hashCode => Object.hash(runtimeType,actionURI,actionText,cartItemCount,isNewUser,isLoggedIn,hasGuestData,const DeepCollectionEquality().hash(childCohorts),userConfig);

@override
String toString() {
  return 'CustomerInfoEntity(actionURI: $actionURI, actionText: $actionText, cartItemCount: $cartItemCount, isNewUser: $isNewUser, isLoggedIn: $isLoggedIn, hasGuestData: $hasGuestData, childCohorts: $childCohorts, userConfig: $userConfig)';
}


}

/// @nodoc
abstract mixin class $CustomerInfoEntityCopyWith<$Res>  {
  factory $CustomerInfoEntityCopyWith(CustomerInfoEntity value, $Res Function(CustomerInfoEntity) _then) = _$CustomerInfoEntityCopyWithImpl;
@useResult
$Res call({
 String? actionURI, String? actionText, int cartItemCount, bool isNewUser, bool isLoggedIn, bool hasGuestData, Map<String, dynamic>? childCohorts, UserConfigEntity? userConfig
});


$UserConfigEntityCopyWith<$Res>? get userConfig;

}
/// @nodoc
class _$CustomerInfoEntityCopyWithImpl<$Res>
    implements $CustomerInfoEntityCopyWith<$Res> {
  _$CustomerInfoEntityCopyWithImpl(this._self, this._then);

  final CustomerInfoEntity _self;
  final $Res Function(CustomerInfoEntity) _then;

/// Create a copy of CustomerInfoEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? actionURI = freezed,Object? actionText = freezed,Object? cartItemCount = null,Object? isNewUser = null,Object? isLoggedIn = null,Object? hasGuestData = null,Object? childCohorts = freezed,Object? userConfig = freezed,}) {
  return _then(_self.copyWith(
actionURI: freezed == actionURI ? _self.actionURI : actionURI // ignore: cast_nullable_to_non_nullable
as String?,actionText: freezed == actionText ? _self.actionText : actionText // ignore: cast_nullable_to_non_nullable
as String?,cartItemCount: null == cartItemCount ? _self.cartItemCount : cartItemCount // ignore: cast_nullable_to_non_nullable
as int,isNewUser: null == isNewUser ? _self.isNewUser : isNewUser // ignore: cast_nullable_to_non_nullable
as bool,isLoggedIn: null == isLoggedIn ? _self.isLoggedIn : isLoggedIn // ignore: cast_nullable_to_non_nullable
as bool,hasGuestData: null == hasGuestData ? _self.hasGuestData : hasGuestData // ignore: cast_nullable_to_non_nullable
as bool,childCohorts: freezed == childCohorts ? _self.childCohorts : childCohorts // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,userConfig: freezed == userConfig ? _self.userConfig : userConfig // ignore: cast_nullable_to_non_nullable
as UserConfigEntity?,
  ));
}
/// Create a copy of CustomerInfoEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserConfigEntityCopyWith<$Res>? get userConfig {
    if (_self.userConfig == null) {
    return null;
  }

  return $UserConfigEntityCopyWith<$Res>(_self.userConfig!, (value) {
    return _then(_self.copyWith(userConfig: value));
  });
}
}


/// Adds pattern-matching-related methods to [CustomerInfoEntity].
extension CustomerInfoEntityPatterns on CustomerInfoEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomerInfoEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomerInfoEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomerInfoEntity value)  $default,){
final _that = this;
switch (_that) {
case _CustomerInfoEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomerInfoEntity value)?  $default,){
final _that = this;
switch (_that) {
case _CustomerInfoEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? actionURI,  String? actionText,  int cartItemCount,  bool isNewUser,  bool isLoggedIn,  bool hasGuestData,  Map<String, dynamic>? childCohorts,  UserConfigEntity? userConfig)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomerInfoEntity() when $default != null:
return $default(_that.actionURI,_that.actionText,_that.cartItemCount,_that.isNewUser,_that.isLoggedIn,_that.hasGuestData,_that.childCohorts,_that.userConfig);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? actionURI,  String? actionText,  int cartItemCount,  bool isNewUser,  bool isLoggedIn,  bool hasGuestData,  Map<String, dynamic>? childCohorts,  UserConfigEntity? userConfig)  $default,) {final _that = this;
switch (_that) {
case _CustomerInfoEntity():
return $default(_that.actionURI,_that.actionText,_that.cartItemCount,_that.isNewUser,_that.isLoggedIn,_that.hasGuestData,_that.childCohorts,_that.userConfig);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? actionURI,  String? actionText,  int cartItemCount,  bool isNewUser,  bool isLoggedIn,  bool hasGuestData,  Map<String, dynamic>? childCohorts,  UserConfigEntity? userConfig)?  $default,) {final _that = this;
switch (_that) {
case _CustomerInfoEntity() when $default != null:
return $default(_that.actionURI,_that.actionText,_that.cartItemCount,_that.isNewUser,_that.isLoggedIn,_that.hasGuestData,_that.childCohorts,_that.userConfig);case _:
  return null;

}
}

}

/// @nodoc


class _CustomerInfoEntity implements CustomerInfoEntity {
  const _CustomerInfoEntity({this.actionURI, this.actionText, this.cartItemCount = 0, this.isNewUser = false, this.isLoggedIn = false, this.hasGuestData = false, final  Map<String, dynamic>? childCohorts, this.userConfig}): _childCohorts = childCohorts;
  

@override final  String? actionURI;
@override final  String? actionText;
@override@JsonKey() final  int cartItemCount;
@override@JsonKey() final  bool isNewUser;
@override@JsonKey() final  bool isLoggedIn;
@override@JsonKey() final  bool hasGuestData;
 final  Map<String, dynamic>? _childCohorts;
@override Map<String, dynamic>? get childCohorts {
  final value = _childCohorts;
  if (value == null) return null;
  if (_childCohorts is EqualUnmodifiableMapView) return _childCohorts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  UserConfigEntity? userConfig;

/// Create a copy of CustomerInfoEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerInfoEntityCopyWith<_CustomerInfoEntity> get copyWith => __$CustomerInfoEntityCopyWithImpl<_CustomerInfoEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomerInfoEntity&&(identical(other.actionURI, actionURI) || other.actionURI == actionURI)&&(identical(other.actionText, actionText) || other.actionText == actionText)&&(identical(other.cartItemCount, cartItemCount) || other.cartItemCount == cartItemCount)&&(identical(other.isNewUser, isNewUser) || other.isNewUser == isNewUser)&&(identical(other.isLoggedIn, isLoggedIn) || other.isLoggedIn == isLoggedIn)&&(identical(other.hasGuestData, hasGuestData) || other.hasGuestData == hasGuestData)&&const DeepCollectionEquality().equals(other._childCohorts, _childCohorts)&&(identical(other.userConfig, userConfig) || other.userConfig == userConfig));
}


@override
int get hashCode => Object.hash(runtimeType,actionURI,actionText,cartItemCount,isNewUser,isLoggedIn,hasGuestData,const DeepCollectionEquality().hash(_childCohorts),userConfig);

@override
String toString() {
  return 'CustomerInfoEntity(actionURI: $actionURI, actionText: $actionText, cartItemCount: $cartItemCount, isNewUser: $isNewUser, isLoggedIn: $isLoggedIn, hasGuestData: $hasGuestData, childCohorts: $childCohorts, userConfig: $userConfig)';
}


}

/// @nodoc
abstract mixin class _$CustomerInfoEntityCopyWith<$Res> implements $CustomerInfoEntityCopyWith<$Res> {
  factory _$CustomerInfoEntityCopyWith(_CustomerInfoEntity value, $Res Function(_CustomerInfoEntity) _then) = __$CustomerInfoEntityCopyWithImpl;
@override @useResult
$Res call({
 String? actionURI, String? actionText, int cartItemCount, bool isNewUser, bool isLoggedIn, bool hasGuestData, Map<String, dynamic>? childCohorts, UserConfigEntity? userConfig
});


@override $UserConfigEntityCopyWith<$Res>? get userConfig;

}
/// @nodoc
class __$CustomerInfoEntityCopyWithImpl<$Res>
    implements _$CustomerInfoEntityCopyWith<$Res> {
  __$CustomerInfoEntityCopyWithImpl(this._self, this._then);

  final _CustomerInfoEntity _self;
  final $Res Function(_CustomerInfoEntity) _then;

/// Create a copy of CustomerInfoEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? actionURI = freezed,Object? actionText = freezed,Object? cartItemCount = null,Object? isNewUser = null,Object? isLoggedIn = null,Object? hasGuestData = null,Object? childCohorts = freezed,Object? userConfig = freezed,}) {
  return _then(_CustomerInfoEntity(
actionURI: freezed == actionURI ? _self.actionURI : actionURI // ignore: cast_nullable_to_non_nullable
as String?,actionText: freezed == actionText ? _self.actionText : actionText // ignore: cast_nullable_to_non_nullable
as String?,cartItemCount: null == cartItemCount ? _self.cartItemCount : cartItemCount // ignore: cast_nullable_to_non_nullable
as int,isNewUser: null == isNewUser ? _self.isNewUser : isNewUser // ignore: cast_nullable_to_non_nullable
as bool,isLoggedIn: null == isLoggedIn ? _self.isLoggedIn : isLoggedIn // ignore: cast_nullable_to_non_nullable
as bool,hasGuestData: null == hasGuestData ? _self.hasGuestData : hasGuestData // ignore: cast_nullable_to_non_nullable
as bool,childCohorts: freezed == childCohorts ? _self._childCohorts : childCohorts // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,userConfig: freezed == userConfig ? _self.userConfig : userConfig // ignore: cast_nullable_to_non_nullable
as UserConfigEntity?,
  ));
}

/// Create a copy of CustomerInfoEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserConfigEntityCopyWith<$Res>? get userConfig {
    if (_self.userConfig == null) {
    return null;
  }

  return $UserConfigEntityCopyWith<$Res>(_self.userConfig!, (value) {
    return _then(_self.copyWith(userConfig: value));
  });
}
}

// dart format on
