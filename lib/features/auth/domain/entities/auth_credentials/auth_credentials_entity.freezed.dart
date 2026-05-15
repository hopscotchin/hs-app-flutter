// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_credentials_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthCredentialsEntity {

 String? get persistentTicket; String? get uuid;
/// Create a copy of AuthCredentialsEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthCredentialsEntityCopyWith<AuthCredentialsEntity> get copyWith => _$AuthCredentialsEntityCopyWithImpl<AuthCredentialsEntity>(this as AuthCredentialsEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthCredentialsEntity&&(identical(other.persistentTicket, persistentTicket) || other.persistentTicket == persistentTicket)&&(identical(other.uuid, uuid) || other.uuid == uuid));
}


@override
int get hashCode => Object.hash(runtimeType,persistentTicket,uuid);

@override
String toString() {
  return 'AuthCredentialsEntity(persistentTicket: $persistentTicket, uuid: $uuid)';
}


}

/// @nodoc
abstract mixin class $AuthCredentialsEntityCopyWith<$Res>  {
  factory $AuthCredentialsEntityCopyWith(AuthCredentialsEntity value, $Res Function(AuthCredentialsEntity) _then) = _$AuthCredentialsEntityCopyWithImpl;
@useResult
$Res call({
 String? persistentTicket, String? uuid
});




}
/// @nodoc
class _$AuthCredentialsEntityCopyWithImpl<$Res>
    implements $AuthCredentialsEntityCopyWith<$Res> {
  _$AuthCredentialsEntityCopyWithImpl(this._self, this._then);

  final AuthCredentialsEntity _self;
  final $Res Function(AuthCredentialsEntity) _then;

/// Create a copy of AuthCredentialsEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? persistentTicket = freezed,Object? uuid = freezed,}) {
  return _then(_self.copyWith(
persistentTicket: freezed == persistentTicket ? _self.persistentTicket : persistentTicket // ignore: cast_nullable_to_non_nullable
as String?,uuid: freezed == uuid ? _self.uuid : uuid // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthCredentialsEntity].
extension AuthCredentialsEntityPatterns on AuthCredentialsEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthCredentialsEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthCredentialsEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthCredentialsEntity value)  $default,){
final _that = this;
switch (_that) {
case _AuthCredentialsEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthCredentialsEntity value)?  $default,){
final _that = this;
switch (_that) {
case _AuthCredentialsEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? persistentTicket,  String? uuid)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthCredentialsEntity() when $default != null:
return $default(_that.persistentTicket,_that.uuid);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? persistentTicket,  String? uuid)  $default,) {final _that = this;
switch (_that) {
case _AuthCredentialsEntity():
return $default(_that.persistentTicket,_that.uuid);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? persistentTicket,  String? uuid)?  $default,) {final _that = this;
switch (_that) {
case _AuthCredentialsEntity() when $default != null:
return $default(_that.persistentTicket,_that.uuid);case _:
  return null;

}
}

}

/// @nodoc


class _AuthCredentialsEntity implements AuthCredentialsEntity {
  const _AuthCredentialsEntity({this.persistentTicket, this.uuid});
  

@override final  String? persistentTicket;
@override final  String? uuid;

/// Create a copy of AuthCredentialsEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthCredentialsEntityCopyWith<_AuthCredentialsEntity> get copyWith => __$AuthCredentialsEntityCopyWithImpl<_AuthCredentialsEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthCredentialsEntity&&(identical(other.persistentTicket, persistentTicket) || other.persistentTicket == persistentTicket)&&(identical(other.uuid, uuid) || other.uuid == uuid));
}


@override
int get hashCode => Object.hash(runtimeType,persistentTicket,uuid);

@override
String toString() {
  return 'AuthCredentialsEntity(persistentTicket: $persistentTicket, uuid: $uuid)';
}


}

/// @nodoc
abstract mixin class _$AuthCredentialsEntityCopyWith<$Res> implements $AuthCredentialsEntityCopyWith<$Res> {
  factory _$AuthCredentialsEntityCopyWith(_AuthCredentialsEntity value, $Res Function(_AuthCredentialsEntity) _then) = __$AuthCredentialsEntityCopyWithImpl;
@override @useResult
$Res call({
 String? persistentTicket, String? uuid
});




}
/// @nodoc
class __$AuthCredentialsEntityCopyWithImpl<$Res>
    implements _$AuthCredentialsEntityCopyWith<$Res> {
  __$AuthCredentialsEntityCopyWithImpl(this._self, this._then);

  final _AuthCredentialsEntity _self;
  final $Res Function(_AuthCredentialsEntity) _then;

/// Create a copy of AuthCredentialsEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? persistentTicket = freezed,Object? uuid = freezed,}) {
  return _then(_AuthCredentialsEntity(
persistentTicket: freezed == persistentTicket ? _self.persistentTicket : persistentTicket // ignore: cast_nullable_to_non_nullable
as String?,uuid: freezed == uuid ? _self.uuid : uuid // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
