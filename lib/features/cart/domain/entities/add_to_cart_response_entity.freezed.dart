// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_to_cart_response_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AddToCartResponseEntity {

 String? get action; String? get message; int? get cartItemQty;
/// Create a copy of AddToCartResponseEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddToCartResponseEntityCopyWith<AddToCartResponseEntity> get copyWith => _$AddToCartResponseEntityCopyWithImpl<AddToCartResponseEntity>(this as AddToCartResponseEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddToCartResponseEntity&&(identical(other.action, action) || other.action == action)&&(identical(other.message, message) || other.message == message)&&(identical(other.cartItemQty, cartItemQty) || other.cartItemQty == cartItemQty));
}


@override
int get hashCode => Object.hash(runtimeType,action,message,cartItemQty);

@override
String toString() {
  return 'AddToCartResponseEntity(action: $action, message: $message, cartItemQty: $cartItemQty)';
}


}

/// @nodoc
abstract mixin class $AddToCartResponseEntityCopyWith<$Res>  {
  factory $AddToCartResponseEntityCopyWith(AddToCartResponseEntity value, $Res Function(AddToCartResponseEntity) _then) = _$AddToCartResponseEntityCopyWithImpl;
@useResult
$Res call({
 String? action, String? message, int? cartItemQty
});




}
/// @nodoc
class _$AddToCartResponseEntityCopyWithImpl<$Res>
    implements $AddToCartResponseEntityCopyWith<$Res> {
  _$AddToCartResponseEntityCopyWithImpl(this._self, this._then);

  final AddToCartResponseEntity _self;
  final $Res Function(AddToCartResponseEntity) _then;

/// Create a copy of AddToCartResponseEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? action = freezed,Object? message = freezed,Object? cartItemQty = freezed,}) {
  return _then(_self.copyWith(
action: freezed == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,cartItemQty: freezed == cartItemQty ? _self.cartItemQty : cartItemQty // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [AddToCartResponseEntity].
extension AddToCartResponseEntityPatterns on AddToCartResponseEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AddToCartResponseEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AddToCartResponseEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AddToCartResponseEntity value)  $default,){
final _that = this;
switch (_that) {
case _AddToCartResponseEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AddToCartResponseEntity value)?  $default,){
final _that = this;
switch (_that) {
case _AddToCartResponseEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? action,  String? message,  int? cartItemQty)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AddToCartResponseEntity() when $default != null:
return $default(_that.action,_that.message,_that.cartItemQty);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? action,  String? message,  int? cartItemQty)  $default,) {final _that = this;
switch (_that) {
case _AddToCartResponseEntity():
return $default(_that.action,_that.message,_that.cartItemQty);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? action,  String? message,  int? cartItemQty)?  $default,) {final _that = this;
switch (_that) {
case _AddToCartResponseEntity() when $default != null:
return $default(_that.action,_that.message,_that.cartItemQty);case _:
  return null;

}
}

}

/// @nodoc


class _AddToCartResponseEntity implements AddToCartResponseEntity {
  const _AddToCartResponseEntity({this.action, this.message, this.cartItemQty});
  

@override final  String? action;
@override final  String? message;
@override final  int? cartItemQty;

/// Create a copy of AddToCartResponseEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddToCartResponseEntityCopyWith<_AddToCartResponseEntity> get copyWith => __$AddToCartResponseEntityCopyWithImpl<_AddToCartResponseEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddToCartResponseEntity&&(identical(other.action, action) || other.action == action)&&(identical(other.message, message) || other.message == message)&&(identical(other.cartItemQty, cartItemQty) || other.cartItemQty == cartItemQty));
}


@override
int get hashCode => Object.hash(runtimeType,action,message,cartItemQty);

@override
String toString() {
  return 'AddToCartResponseEntity(action: $action, message: $message, cartItemQty: $cartItemQty)';
}


}

/// @nodoc
abstract mixin class _$AddToCartResponseEntityCopyWith<$Res> implements $AddToCartResponseEntityCopyWith<$Res> {
  factory _$AddToCartResponseEntityCopyWith(_AddToCartResponseEntity value, $Res Function(_AddToCartResponseEntity) _then) = __$AddToCartResponseEntityCopyWithImpl;
@override @useResult
$Res call({
 String? action, String? message, int? cartItemQty
});




}
/// @nodoc
class __$AddToCartResponseEntityCopyWithImpl<$Res>
    implements _$AddToCartResponseEntityCopyWith<$Res> {
  __$AddToCartResponseEntityCopyWithImpl(this._self, this._then);

  final _AddToCartResponseEntity _self;
  final $Res Function(_AddToCartResponseEntity) _then;

/// Create a copy of AddToCartResponseEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? action = freezed,Object? message = freezed,Object? cartItemQty = freezed,}) {
  return _then(_AddToCartResponseEntity(
action: freezed == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,cartItemQty: freezed == cartItemQty ? _self.cartItemQty : cartItemQty // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
