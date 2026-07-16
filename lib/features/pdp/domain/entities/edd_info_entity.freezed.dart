// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'edd_info_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EddInfoEntity {

 String? get destination; String? get edd; String? get orderSla;
/// Create a copy of EddInfoEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EddInfoEntityCopyWith<EddInfoEntity> get copyWith => _$EddInfoEntityCopyWithImpl<EddInfoEntity>(this as EddInfoEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EddInfoEntity&&(identical(other.destination, destination) || other.destination == destination)&&(identical(other.edd, edd) || other.edd == edd)&&(identical(other.orderSla, orderSla) || other.orderSla == orderSla));
}


@override
int get hashCode => Object.hash(runtimeType,destination,edd,orderSla);

@override
String toString() {
  return 'EddInfoEntity(destination: $destination, edd: $edd, orderSla: $orderSla)';
}


}

/// @nodoc
abstract mixin class $EddInfoEntityCopyWith<$Res>  {
  factory $EddInfoEntityCopyWith(EddInfoEntity value, $Res Function(EddInfoEntity) _then) = _$EddInfoEntityCopyWithImpl;
@useResult
$Res call({
 String? destination, String? edd, String? orderSla
});




}
/// @nodoc
class _$EddInfoEntityCopyWithImpl<$Res>
    implements $EddInfoEntityCopyWith<$Res> {
  _$EddInfoEntityCopyWithImpl(this._self, this._then);

  final EddInfoEntity _self;
  final $Res Function(EddInfoEntity) _then;

/// Create a copy of EddInfoEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? destination = freezed,Object? edd = freezed,Object? orderSla = freezed,}) {
  return _then(_self.copyWith(
destination: freezed == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as String?,edd: freezed == edd ? _self.edd : edd // ignore: cast_nullable_to_non_nullable
as String?,orderSla: freezed == orderSla ? _self.orderSla : orderSla // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [EddInfoEntity].
extension EddInfoEntityPatterns on EddInfoEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EddInfoEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EddInfoEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EddInfoEntity value)  $default,){
final _that = this;
switch (_that) {
case _EddInfoEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EddInfoEntity value)?  $default,){
final _that = this;
switch (_that) {
case _EddInfoEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? destination,  String? edd,  String? orderSla)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EddInfoEntity() when $default != null:
return $default(_that.destination,_that.edd,_that.orderSla);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? destination,  String? edd,  String? orderSla)  $default,) {final _that = this;
switch (_that) {
case _EddInfoEntity():
return $default(_that.destination,_that.edd,_that.orderSla);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? destination,  String? edd,  String? orderSla)?  $default,) {final _that = this;
switch (_that) {
case _EddInfoEntity() when $default != null:
return $default(_that.destination,_that.edd,_that.orderSla);case _:
  return null;

}
}

}

/// @nodoc


class _EddInfoEntity implements EddInfoEntity {
  const _EddInfoEntity({this.destination, this.edd, this.orderSla});
  

@override final  String? destination;
@override final  String? edd;
@override final  String? orderSla;

/// Create a copy of EddInfoEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EddInfoEntityCopyWith<_EddInfoEntity> get copyWith => __$EddInfoEntityCopyWithImpl<_EddInfoEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EddInfoEntity&&(identical(other.destination, destination) || other.destination == destination)&&(identical(other.edd, edd) || other.edd == edd)&&(identical(other.orderSla, orderSla) || other.orderSla == orderSla));
}


@override
int get hashCode => Object.hash(runtimeType,destination,edd,orderSla);

@override
String toString() {
  return 'EddInfoEntity(destination: $destination, edd: $edd, orderSla: $orderSla)';
}


}

/// @nodoc
abstract mixin class _$EddInfoEntityCopyWith<$Res> implements $EddInfoEntityCopyWith<$Res> {
  factory _$EddInfoEntityCopyWith(_EddInfoEntity value, $Res Function(_EddInfoEntity) _then) = __$EddInfoEntityCopyWithImpl;
@override @useResult
$Res call({
 String? destination, String? edd, String? orderSla
});




}
/// @nodoc
class __$EddInfoEntityCopyWithImpl<$Res>
    implements _$EddInfoEntityCopyWith<$Res> {
  __$EddInfoEntityCopyWithImpl(this._self, this._then);

  final _EddInfoEntity _self;
  final $Res Function(_EddInfoEntity) _then;

/// Create a copy of EddInfoEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? destination = freezed,Object? edd = freezed,Object? orderSla = freezed,}) {
  return _then(_EddInfoEntity(
destination: freezed == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as String?,edd: freezed == edd ? _self.edd : edd // ignore: cast_nullable_to_non_nullable
as String?,orderSla: freezed == orderSla ? _self.orderSla : orderSla // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
