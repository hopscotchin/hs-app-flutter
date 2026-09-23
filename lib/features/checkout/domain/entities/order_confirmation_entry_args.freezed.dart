// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_confirmation_entry_args.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OrderConfirmationEntryArgs {

 OrderConfirmationEntity get orderConfirmationEntity; String? get fromScreen;
/// Create a copy of OrderConfirmationEntryArgs
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderConfirmationEntryArgsCopyWith<OrderConfirmationEntryArgs> get copyWith => _$OrderConfirmationEntryArgsCopyWithImpl<OrderConfirmationEntryArgs>(this as OrderConfirmationEntryArgs, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderConfirmationEntryArgs&&(identical(other.orderConfirmationEntity, orderConfirmationEntity) || other.orderConfirmationEntity == orderConfirmationEntity)&&(identical(other.fromScreen, fromScreen) || other.fromScreen == fromScreen));
}


@override
int get hashCode => Object.hash(runtimeType,orderConfirmationEntity,fromScreen);

@override
String toString() {
  return 'OrderConfirmationEntryArgs(orderConfirmationEntity: $orderConfirmationEntity, fromScreen: $fromScreen)';
}


}

/// @nodoc
abstract mixin class $OrderConfirmationEntryArgsCopyWith<$Res>  {
  factory $OrderConfirmationEntryArgsCopyWith(OrderConfirmationEntryArgs value, $Res Function(OrderConfirmationEntryArgs) _then) = _$OrderConfirmationEntryArgsCopyWithImpl;
@useResult
$Res call({
 OrderConfirmationEntity orderConfirmationEntity, String? fromScreen
});




}
/// @nodoc
class _$OrderConfirmationEntryArgsCopyWithImpl<$Res>
    implements $OrderConfirmationEntryArgsCopyWith<$Res> {
  _$OrderConfirmationEntryArgsCopyWithImpl(this._self, this._then);

  final OrderConfirmationEntryArgs _self;
  final $Res Function(OrderConfirmationEntryArgs) _then;

/// Create a copy of OrderConfirmationEntryArgs
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? orderConfirmationEntity = null,Object? fromScreen = freezed,}) {
  return _then(_self.copyWith(
orderConfirmationEntity: null == orderConfirmationEntity ? _self.orderConfirmationEntity : orderConfirmationEntity // ignore: cast_nullable_to_non_nullable
as OrderConfirmationEntity,fromScreen: freezed == fromScreen ? _self.fromScreen : fromScreen // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderConfirmationEntryArgs].
extension OrderConfirmationEntryArgsPatterns on OrderConfirmationEntryArgs {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderConfirmationEntryArgs value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderConfirmationEntryArgs() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderConfirmationEntryArgs value)  $default,){
final _that = this;
switch (_that) {
case _OrderConfirmationEntryArgs():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderConfirmationEntryArgs value)?  $default,){
final _that = this;
switch (_that) {
case _OrderConfirmationEntryArgs() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( OrderConfirmationEntity orderConfirmationEntity,  String? fromScreen)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderConfirmationEntryArgs() when $default != null:
return $default(_that.orderConfirmationEntity,_that.fromScreen);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( OrderConfirmationEntity orderConfirmationEntity,  String? fromScreen)  $default,) {final _that = this;
switch (_that) {
case _OrderConfirmationEntryArgs():
return $default(_that.orderConfirmationEntity,_that.fromScreen);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( OrderConfirmationEntity orderConfirmationEntity,  String? fromScreen)?  $default,) {final _that = this;
switch (_that) {
case _OrderConfirmationEntryArgs() when $default != null:
return $default(_that.orderConfirmationEntity,_that.fromScreen);case _:
  return null;

}
}

}

/// @nodoc


class _OrderConfirmationEntryArgs implements OrderConfirmationEntryArgs {
  const _OrderConfirmationEntryArgs({required this.orderConfirmationEntity, this.fromScreen});
  

@override final  OrderConfirmationEntity orderConfirmationEntity;
@override final  String? fromScreen;

/// Create a copy of OrderConfirmationEntryArgs
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderConfirmationEntryArgsCopyWith<_OrderConfirmationEntryArgs> get copyWith => __$OrderConfirmationEntryArgsCopyWithImpl<_OrderConfirmationEntryArgs>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderConfirmationEntryArgs&&(identical(other.orderConfirmationEntity, orderConfirmationEntity) || other.orderConfirmationEntity == orderConfirmationEntity)&&(identical(other.fromScreen, fromScreen) || other.fromScreen == fromScreen));
}


@override
int get hashCode => Object.hash(runtimeType,orderConfirmationEntity,fromScreen);

@override
String toString() {
  return 'OrderConfirmationEntryArgs(orderConfirmationEntity: $orderConfirmationEntity, fromScreen: $fromScreen)';
}


}

/// @nodoc
abstract mixin class _$OrderConfirmationEntryArgsCopyWith<$Res> implements $OrderConfirmationEntryArgsCopyWith<$Res> {
  factory _$OrderConfirmationEntryArgsCopyWith(_OrderConfirmationEntryArgs value, $Res Function(_OrderConfirmationEntryArgs) _then) = __$OrderConfirmationEntryArgsCopyWithImpl;
@override @useResult
$Res call({
 OrderConfirmationEntity orderConfirmationEntity, String? fromScreen
});




}
/// @nodoc
class __$OrderConfirmationEntryArgsCopyWithImpl<$Res>
    implements _$OrderConfirmationEntryArgsCopyWith<$Res> {
  __$OrderConfirmationEntryArgsCopyWithImpl(this._self, this._then);

  final _OrderConfirmationEntryArgs _self;
  final $Res Function(_OrderConfirmationEntryArgs) _then;

/// Create a copy of OrderConfirmationEntryArgs
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? orderConfirmationEntity = null,Object? fromScreen = freezed,}) {
  return _then(_OrderConfirmationEntryArgs(
orderConfirmationEntity: null == orderConfirmationEntity ? _self.orderConfirmationEntity : orderConfirmationEntity // ignore: cast_nullable_to_non_nullable
as OrderConfirmationEntity,fromScreen: freezed == fromScreen ? _self.fromScreen : fromScreen // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
