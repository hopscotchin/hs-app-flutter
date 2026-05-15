// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'verify_otp_response_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VerifyOtpResponseEntity {

 UserInfoEntity get user; AuthCredentialsEntity get auth; Map<String, dynamic>? get childCohorts; UserConfigEntity? get userConfig; String? get loginId; String? get action; String? get popUpMessage; List<MessageBarEntity> get messageBars;
/// Create a copy of VerifyOtpResponseEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VerifyOtpResponseEntityCopyWith<VerifyOtpResponseEntity> get copyWith => _$VerifyOtpResponseEntityCopyWithImpl<VerifyOtpResponseEntity>(this as VerifyOtpResponseEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VerifyOtpResponseEntity&&(identical(other.user, user) || other.user == user)&&(identical(other.auth, auth) || other.auth == auth)&&const DeepCollectionEquality().equals(other.childCohorts, childCohorts)&&(identical(other.userConfig, userConfig) || other.userConfig == userConfig)&&(identical(other.loginId, loginId) || other.loginId == loginId)&&(identical(other.action, action) || other.action == action)&&(identical(other.popUpMessage, popUpMessage) || other.popUpMessage == popUpMessage)&&const DeepCollectionEquality().equals(other.messageBars, messageBars));
}


@override
int get hashCode => Object.hash(runtimeType,user,auth,const DeepCollectionEquality().hash(childCohorts),userConfig,loginId,action,popUpMessage,const DeepCollectionEquality().hash(messageBars));

@override
String toString() {
  return 'VerifyOtpResponseEntity(user: $user, auth: $auth, childCohorts: $childCohorts, userConfig: $userConfig, loginId: $loginId, action: $action, popUpMessage: $popUpMessage, messageBars: $messageBars)';
}


}

/// @nodoc
abstract mixin class $VerifyOtpResponseEntityCopyWith<$Res>  {
  factory $VerifyOtpResponseEntityCopyWith(VerifyOtpResponseEntity value, $Res Function(VerifyOtpResponseEntity) _then) = _$VerifyOtpResponseEntityCopyWithImpl;
@useResult
$Res call({
 UserInfoEntity user, AuthCredentialsEntity auth, Map<String, dynamic>? childCohorts, UserConfigEntity? userConfig, String? loginId, String? action, String? popUpMessage, List<MessageBarEntity> messageBars
});


$UserInfoEntityCopyWith<$Res> get user;$AuthCredentialsEntityCopyWith<$Res> get auth;$UserConfigEntityCopyWith<$Res>? get userConfig;

}
/// @nodoc
class _$VerifyOtpResponseEntityCopyWithImpl<$Res>
    implements $VerifyOtpResponseEntityCopyWith<$Res> {
  _$VerifyOtpResponseEntityCopyWithImpl(this._self, this._then);

  final VerifyOtpResponseEntity _self;
  final $Res Function(VerifyOtpResponseEntity) _then;

/// Create a copy of VerifyOtpResponseEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? user = null,Object? auth = null,Object? childCohorts = freezed,Object? userConfig = freezed,Object? loginId = freezed,Object? action = freezed,Object? popUpMessage = freezed,Object? messageBars = null,}) {
  return _then(_self.copyWith(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserInfoEntity,auth: null == auth ? _self.auth : auth // ignore: cast_nullable_to_non_nullable
as AuthCredentialsEntity,childCohorts: freezed == childCohorts ? _self.childCohorts : childCohorts // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,userConfig: freezed == userConfig ? _self.userConfig : userConfig // ignore: cast_nullable_to_non_nullable
as UserConfigEntity?,loginId: freezed == loginId ? _self.loginId : loginId // ignore: cast_nullable_to_non_nullable
as String?,action: freezed == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String?,popUpMessage: freezed == popUpMessage ? _self.popUpMessage : popUpMessage // ignore: cast_nullable_to_non_nullable
as String?,messageBars: null == messageBars ? _self.messageBars : messageBars // ignore: cast_nullable_to_non_nullable
as List<MessageBarEntity>,
  ));
}
/// Create a copy of VerifyOtpResponseEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserInfoEntityCopyWith<$Res> get user {
  
  return $UserInfoEntityCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of VerifyOtpResponseEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthCredentialsEntityCopyWith<$Res> get auth {
  
  return $AuthCredentialsEntityCopyWith<$Res>(_self.auth, (value) {
    return _then(_self.copyWith(auth: value));
  });
}/// Create a copy of VerifyOtpResponseEntity
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


/// Adds pattern-matching-related methods to [VerifyOtpResponseEntity].
extension VerifyOtpResponseEntityPatterns on VerifyOtpResponseEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VerifyOtpResponseEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VerifyOtpResponseEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VerifyOtpResponseEntity value)  $default,){
final _that = this;
switch (_that) {
case _VerifyOtpResponseEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VerifyOtpResponseEntity value)?  $default,){
final _that = this;
switch (_that) {
case _VerifyOtpResponseEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( UserInfoEntity user,  AuthCredentialsEntity auth,  Map<String, dynamic>? childCohorts,  UserConfigEntity? userConfig,  String? loginId,  String? action,  String? popUpMessage,  List<MessageBarEntity> messageBars)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VerifyOtpResponseEntity() when $default != null:
return $default(_that.user,_that.auth,_that.childCohorts,_that.userConfig,_that.loginId,_that.action,_that.popUpMessage,_that.messageBars);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( UserInfoEntity user,  AuthCredentialsEntity auth,  Map<String, dynamic>? childCohorts,  UserConfigEntity? userConfig,  String? loginId,  String? action,  String? popUpMessage,  List<MessageBarEntity> messageBars)  $default,) {final _that = this;
switch (_that) {
case _VerifyOtpResponseEntity():
return $default(_that.user,_that.auth,_that.childCohorts,_that.userConfig,_that.loginId,_that.action,_that.popUpMessage,_that.messageBars);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( UserInfoEntity user,  AuthCredentialsEntity auth,  Map<String, dynamic>? childCohorts,  UserConfigEntity? userConfig,  String? loginId,  String? action,  String? popUpMessage,  List<MessageBarEntity> messageBars)?  $default,) {final _that = this;
switch (_that) {
case _VerifyOtpResponseEntity() when $default != null:
return $default(_that.user,_that.auth,_that.childCohorts,_that.userConfig,_that.loginId,_that.action,_that.popUpMessage,_that.messageBars);case _:
  return null;

}
}

}

/// @nodoc


class _VerifyOtpResponseEntity implements VerifyOtpResponseEntity {
  const _VerifyOtpResponseEntity({required this.user, required this.auth, final  Map<String, dynamic>? childCohorts, this.userConfig, this.loginId, this.action, this.popUpMessage, final  List<MessageBarEntity> messageBars = const []}): _childCohorts = childCohorts,_messageBars = messageBars;
  

@override final  UserInfoEntity user;
@override final  AuthCredentialsEntity auth;
 final  Map<String, dynamic>? _childCohorts;
@override Map<String, dynamic>? get childCohorts {
  final value = _childCohorts;
  if (value == null) return null;
  if (_childCohorts is EqualUnmodifiableMapView) return _childCohorts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  UserConfigEntity? userConfig;
@override final  String? loginId;
@override final  String? action;
@override final  String? popUpMessage;
 final  List<MessageBarEntity> _messageBars;
@override@JsonKey() List<MessageBarEntity> get messageBars {
  if (_messageBars is EqualUnmodifiableListView) return _messageBars;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messageBars);
}


/// Create a copy of VerifyOtpResponseEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VerifyOtpResponseEntityCopyWith<_VerifyOtpResponseEntity> get copyWith => __$VerifyOtpResponseEntityCopyWithImpl<_VerifyOtpResponseEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VerifyOtpResponseEntity&&(identical(other.user, user) || other.user == user)&&(identical(other.auth, auth) || other.auth == auth)&&const DeepCollectionEquality().equals(other._childCohorts, _childCohorts)&&(identical(other.userConfig, userConfig) || other.userConfig == userConfig)&&(identical(other.loginId, loginId) || other.loginId == loginId)&&(identical(other.action, action) || other.action == action)&&(identical(other.popUpMessage, popUpMessage) || other.popUpMessage == popUpMessage)&&const DeepCollectionEquality().equals(other._messageBars, _messageBars));
}


@override
int get hashCode => Object.hash(runtimeType,user,auth,const DeepCollectionEquality().hash(_childCohorts),userConfig,loginId,action,popUpMessage,const DeepCollectionEquality().hash(_messageBars));

@override
String toString() {
  return 'VerifyOtpResponseEntity(user: $user, auth: $auth, childCohorts: $childCohorts, userConfig: $userConfig, loginId: $loginId, action: $action, popUpMessage: $popUpMessage, messageBars: $messageBars)';
}


}

/// @nodoc
abstract mixin class _$VerifyOtpResponseEntityCopyWith<$Res> implements $VerifyOtpResponseEntityCopyWith<$Res> {
  factory _$VerifyOtpResponseEntityCopyWith(_VerifyOtpResponseEntity value, $Res Function(_VerifyOtpResponseEntity) _then) = __$VerifyOtpResponseEntityCopyWithImpl;
@override @useResult
$Res call({
 UserInfoEntity user, AuthCredentialsEntity auth, Map<String, dynamic>? childCohorts, UserConfigEntity? userConfig, String? loginId, String? action, String? popUpMessage, List<MessageBarEntity> messageBars
});


@override $UserInfoEntityCopyWith<$Res> get user;@override $AuthCredentialsEntityCopyWith<$Res> get auth;@override $UserConfigEntityCopyWith<$Res>? get userConfig;

}
/// @nodoc
class __$VerifyOtpResponseEntityCopyWithImpl<$Res>
    implements _$VerifyOtpResponseEntityCopyWith<$Res> {
  __$VerifyOtpResponseEntityCopyWithImpl(this._self, this._then);

  final _VerifyOtpResponseEntity _self;
  final $Res Function(_VerifyOtpResponseEntity) _then;

/// Create a copy of VerifyOtpResponseEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? user = null,Object? auth = null,Object? childCohorts = freezed,Object? userConfig = freezed,Object? loginId = freezed,Object? action = freezed,Object? popUpMessage = freezed,Object? messageBars = null,}) {
  return _then(_VerifyOtpResponseEntity(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserInfoEntity,auth: null == auth ? _self.auth : auth // ignore: cast_nullable_to_non_nullable
as AuthCredentialsEntity,childCohorts: freezed == childCohorts ? _self._childCohorts : childCohorts // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,userConfig: freezed == userConfig ? _self.userConfig : userConfig // ignore: cast_nullable_to_non_nullable
as UserConfigEntity?,loginId: freezed == loginId ? _self.loginId : loginId // ignore: cast_nullable_to_non_nullable
as String?,action: freezed == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String?,popUpMessage: freezed == popUpMessage ? _self.popUpMessage : popUpMessage // ignore: cast_nullable_to_non_nullable
as String?,messageBars: null == messageBars ? _self._messageBars : messageBars // ignore: cast_nullable_to_non_nullable
as List<MessageBarEntity>,
  ));
}

/// Create a copy of VerifyOtpResponseEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserInfoEntityCopyWith<$Res> get user {
  
  return $UserInfoEntityCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of VerifyOtpResponseEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthCredentialsEntityCopyWith<$Res> get auth {
  
  return $AuthCredentialsEntityCopyWith<$Res>(_self.auth, (value) {
    return _then(_self.copyWith(auth: value));
  });
}/// Create a copy of VerifyOtpResponseEntity
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
