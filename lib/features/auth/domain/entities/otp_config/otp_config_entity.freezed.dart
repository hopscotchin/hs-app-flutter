// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'otp_config_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OtpConfigEntity {

 int get timerSeconds; int get length; String? get hint;
/// Create a copy of OtpConfigEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OtpConfigEntityCopyWith<OtpConfigEntity> get copyWith => _$OtpConfigEntityCopyWithImpl<OtpConfigEntity>(this as OtpConfigEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OtpConfigEntity&&(identical(other.timerSeconds, timerSeconds) || other.timerSeconds == timerSeconds)&&(identical(other.length, length) || other.length == length)&&(identical(other.hint, hint) || other.hint == hint));
}


@override
int get hashCode => Object.hash(runtimeType,timerSeconds,length,hint);

@override
String toString() {
  return 'OtpConfigEntity(timerSeconds: $timerSeconds, length: $length, hint: $hint)';
}


}

/// @nodoc
abstract mixin class $OtpConfigEntityCopyWith<$Res>  {
  factory $OtpConfigEntityCopyWith(OtpConfigEntity value, $Res Function(OtpConfigEntity) _then) = _$OtpConfigEntityCopyWithImpl;
@useResult
$Res call({
 int timerSeconds, int length, String? hint
});




}
/// @nodoc
class _$OtpConfigEntityCopyWithImpl<$Res>
    implements $OtpConfigEntityCopyWith<$Res> {
  _$OtpConfigEntityCopyWithImpl(this._self, this._then);

  final OtpConfigEntity _self;
  final $Res Function(OtpConfigEntity) _then;

/// Create a copy of OtpConfigEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? timerSeconds = null,Object? length = null,Object? hint = freezed,}) {
  return _then(_self.copyWith(
timerSeconds: null == timerSeconds ? _self.timerSeconds : timerSeconds // ignore: cast_nullable_to_non_nullable
as int,length: null == length ? _self.length : length // ignore: cast_nullable_to_non_nullable
as int,hint: freezed == hint ? _self.hint : hint // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [OtpConfigEntity].
extension OtpConfigEntityPatterns on OtpConfigEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OtpConfigEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OtpConfigEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OtpConfigEntity value)  $default,){
final _that = this;
switch (_that) {
case _OtpConfigEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OtpConfigEntity value)?  $default,){
final _that = this;
switch (_that) {
case _OtpConfigEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int timerSeconds,  int length,  String? hint)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OtpConfigEntity() when $default != null:
return $default(_that.timerSeconds,_that.length,_that.hint);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int timerSeconds,  int length,  String? hint)  $default,) {final _that = this;
switch (_that) {
case _OtpConfigEntity():
return $default(_that.timerSeconds,_that.length,_that.hint);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int timerSeconds,  int length,  String? hint)?  $default,) {final _that = this;
switch (_that) {
case _OtpConfigEntity() when $default != null:
return $default(_that.timerSeconds,_that.length,_that.hint);case _:
  return null;

}
}

}

/// @nodoc


class _OtpConfigEntity implements OtpConfigEntity {
  const _OtpConfigEntity({this.timerSeconds = 30, this.length = 6, this.hint});
  

@override@JsonKey() final  int timerSeconds;
@override@JsonKey() final  int length;
@override final  String? hint;

/// Create a copy of OtpConfigEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OtpConfigEntityCopyWith<_OtpConfigEntity> get copyWith => __$OtpConfigEntityCopyWithImpl<_OtpConfigEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OtpConfigEntity&&(identical(other.timerSeconds, timerSeconds) || other.timerSeconds == timerSeconds)&&(identical(other.length, length) || other.length == length)&&(identical(other.hint, hint) || other.hint == hint));
}


@override
int get hashCode => Object.hash(runtimeType,timerSeconds,length,hint);

@override
String toString() {
  return 'OtpConfigEntity(timerSeconds: $timerSeconds, length: $length, hint: $hint)';
}


}

/// @nodoc
abstract mixin class _$OtpConfigEntityCopyWith<$Res> implements $OtpConfigEntityCopyWith<$Res> {
  factory _$OtpConfigEntityCopyWith(_OtpConfigEntity value, $Res Function(_OtpConfigEntity) _then) = __$OtpConfigEntityCopyWithImpl;
@override @useResult
$Res call({
 int timerSeconds, int length, String? hint
});




}
/// @nodoc
class __$OtpConfigEntityCopyWithImpl<$Res>
    implements _$OtpConfigEntityCopyWith<$Res> {
  __$OtpConfigEntityCopyWithImpl(this._self, this._then);

  final _OtpConfigEntity _self;
  final $Res Function(_OtpConfigEntity) _then;

/// Create a copy of OtpConfigEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? timerSeconds = null,Object? length = null,Object? hint = freezed,}) {
  return _then(_OtpConfigEntity(
timerSeconds: null == timerSeconds ? _self.timerSeconds : timerSeconds // ignore: cast_nullable_to_non_nullable
as int,length: null == length ? _self.length : length // ignore: cast_nullable_to_non_nullable
as int,hint: freezed == hint ? _self.hint : hint // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
