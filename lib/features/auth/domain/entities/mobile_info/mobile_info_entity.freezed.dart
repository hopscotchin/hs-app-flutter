// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mobile_info_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MobileInfoEntity {

 String get number; bool get isVerified;
/// Create a copy of MobileInfoEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MobileInfoEntityCopyWith<MobileInfoEntity> get copyWith => _$MobileInfoEntityCopyWithImpl<MobileInfoEntity>(this as MobileInfoEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MobileInfoEntity&&(identical(other.number, number) || other.number == number)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified));
}


@override
int get hashCode => Object.hash(runtimeType,number,isVerified);

@override
String toString() {
  return 'MobileInfoEntity(number: $number, isVerified: $isVerified)';
}


}

/// @nodoc
abstract mixin class $MobileInfoEntityCopyWith<$Res>  {
  factory $MobileInfoEntityCopyWith(MobileInfoEntity value, $Res Function(MobileInfoEntity) _then) = _$MobileInfoEntityCopyWithImpl;
@useResult
$Res call({
 String number, bool isVerified
});




}
/// @nodoc
class _$MobileInfoEntityCopyWithImpl<$Res>
    implements $MobileInfoEntityCopyWith<$Res> {
  _$MobileInfoEntityCopyWithImpl(this._self, this._then);

  final MobileInfoEntity _self;
  final $Res Function(MobileInfoEntity) _then;

/// Create a copy of MobileInfoEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? number = null,Object? isVerified = null,}) {
  return _then(_self.copyWith(
number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as String,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MobileInfoEntity].
extension MobileInfoEntityPatterns on MobileInfoEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MobileInfoEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MobileInfoEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MobileInfoEntity value)  $default,){
final _that = this;
switch (_that) {
case _MobileInfoEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MobileInfoEntity value)?  $default,){
final _that = this;
switch (_that) {
case _MobileInfoEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String number,  bool isVerified)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MobileInfoEntity() when $default != null:
return $default(_that.number,_that.isVerified);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String number,  bool isVerified)  $default,) {final _that = this;
switch (_that) {
case _MobileInfoEntity():
return $default(_that.number,_that.isVerified);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String number,  bool isVerified)?  $default,) {final _that = this;
switch (_that) {
case _MobileInfoEntity() when $default != null:
return $default(_that.number,_that.isVerified);case _:
  return null;

}
}

}

/// @nodoc


class _MobileInfoEntity implements MobileInfoEntity {
  const _MobileInfoEntity({this.number = '', this.isVerified = false});
  

@override@JsonKey() final  String number;
@override@JsonKey() final  bool isVerified;

/// Create a copy of MobileInfoEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MobileInfoEntityCopyWith<_MobileInfoEntity> get copyWith => __$MobileInfoEntityCopyWithImpl<_MobileInfoEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MobileInfoEntity&&(identical(other.number, number) || other.number == number)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified));
}


@override
int get hashCode => Object.hash(runtimeType,number,isVerified);

@override
String toString() {
  return 'MobileInfoEntity(number: $number, isVerified: $isVerified)';
}


}

/// @nodoc
abstract mixin class _$MobileInfoEntityCopyWith<$Res> implements $MobileInfoEntityCopyWith<$Res> {
  factory _$MobileInfoEntityCopyWith(_MobileInfoEntity value, $Res Function(_MobileInfoEntity) _then) = __$MobileInfoEntityCopyWithImpl;
@override @useResult
$Res call({
 String number, bool isVerified
});




}
/// @nodoc
class __$MobileInfoEntityCopyWithImpl<$Res>
    implements _$MobileInfoEntityCopyWith<$Res> {
  __$MobileInfoEntityCopyWithImpl(this._self, this._then);

  final _MobileInfoEntity _self;
  final $Res Function(_MobileInfoEntity) _then;

/// Create a copy of MobileInfoEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? number = null,Object? isVerified = null,}) {
  return _then(_MobileInfoEntity(
number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as String,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
