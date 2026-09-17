// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'move_to_cart_result_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MoveToCartResultEntity {

 int? get cartItemQty;
/// Create a copy of MoveToCartResultEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MoveToCartResultEntityCopyWith<MoveToCartResultEntity> get copyWith => _$MoveToCartResultEntityCopyWithImpl<MoveToCartResultEntity>(this as MoveToCartResultEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MoveToCartResultEntity&&(identical(other.cartItemQty, cartItemQty) || other.cartItemQty == cartItemQty));
}


@override
int get hashCode => Object.hash(runtimeType,cartItemQty);

@override
String toString() {
  return 'MoveToCartResultEntity(cartItemQty: $cartItemQty)';
}


}

/// @nodoc
abstract mixin class $MoveToCartResultEntityCopyWith<$Res>  {
  factory $MoveToCartResultEntityCopyWith(MoveToCartResultEntity value, $Res Function(MoveToCartResultEntity) _then) = _$MoveToCartResultEntityCopyWithImpl;
@useResult
$Res call({
 int? cartItemQty
});




}
/// @nodoc
class _$MoveToCartResultEntityCopyWithImpl<$Res>
    implements $MoveToCartResultEntityCopyWith<$Res> {
  _$MoveToCartResultEntityCopyWithImpl(this._self, this._then);

  final MoveToCartResultEntity _self;
  final $Res Function(MoveToCartResultEntity) _then;

/// Create a copy of MoveToCartResultEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cartItemQty = freezed,}) {
  return _then(_self.copyWith(
cartItemQty: freezed == cartItemQty ? _self.cartItemQty : cartItemQty // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [MoveToCartResultEntity].
extension MoveToCartResultEntityPatterns on MoveToCartResultEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MoveToCartResultEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MoveToCartResultEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MoveToCartResultEntity value)  $default,){
final _that = this;
switch (_that) {
case _MoveToCartResultEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MoveToCartResultEntity value)?  $default,){
final _that = this;
switch (_that) {
case _MoveToCartResultEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? cartItemQty)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MoveToCartResultEntity() when $default != null:
return $default(_that.cartItemQty);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? cartItemQty)  $default,) {final _that = this;
switch (_that) {
case _MoveToCartResultEntity():
return $default(_that.cartItemQty);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? cartItemQty)?  $default,) {final _that = this;
switch (_that) {
case _MoveToCartResultEntity() when $default != null:
return $default(_that.cartItemQty);case _:
  return null;

}
}

}

/// @nodoc


class _MoveToCartResultEntity implements MoveToCartResultEntity {
  const _MoveToCartResultEntity({this.cartItemQty});
  

@override final  int? cartItemQty;

/// Create a copy of MoveToCartResultEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MoveToCartResultEntityCopyWith<_MoveToCartResultEntity> get copyWith => __$MoveToCartResultEntityCopyWithImpl<_MoveToCartResultEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MoveToCartResultEntity&&(identical(other.cartItemQty, cartItemQty) || other.cartItemQty == cartItemQty));
}


@override
int get hashCode => Object.hash(runtimeType,cartItemQty);

@override
String toString() {
  return 'MoveToCartResultEntity(cartItemQty: $cartItemQty)';
}


}

/// @nodoc
abstract mixin class _$MoveToCartResultEntityCopyWith<$Res> implements $MoveToCartResultEntityCopyWith<$Res> {
  factory _$MoveToCartResultEntityCopyWith(_MoveToCartResultEntity value, $Res Function(_MoveToCartResultEntity) _then) = __$MoveToCartResultEntityCopyWithImpl;
@override @useResult
$Res call({
 int? cartItemQty
});




}
/// @nodoc
class __$MoveToCartResultEntityCopyWithImpl<$Res>
    implements _$MoveToCartResultEntityCopyWith<$Res> {
  __$MoveToCartResultEntityCopyWithImpl(this._self, this._then);

  final _MoveToCartResultEntity _self;
  final $Res Function(_MoveToCartResultEntity) _then;

/// Create a copy of MoveToCartResultEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cartItemQty = freezed,}) {
  return _then(_MoveToCartResultEntity(
cartItemQty: freezed == cartItemQty ? _self.cartItemQty : cartItemQty // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
