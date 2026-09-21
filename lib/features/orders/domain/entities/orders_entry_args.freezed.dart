// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'orders_entry_args.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OrdersEntryArgs {

 String? get fromScreen;
/// Create a copy of OrdersEntryArgs
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrdersEntryArgsCopyWith<OrdersEntryArgs> get copyWith => _$OrdersEntryArgsCopyWithImpl<OrdersEntryArgs>(this as OrdersEntryArgs, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrdersEntryArgs&&(identical(other.fromScreen, fromScreen) || other.fromScreen == fromScreen));
}


@override
int get hashCode => Object.hash(runtimeType,fromScreen);

@override
String toString() {
  return 'OrdersEntryArgs(fromScreen: $fromScreen)';
}


}

/// @nodoc
abstract mixin class $OrdersEntryArgsCopyWith<$Res>  {
  factory $OrdersEntryArgsCopyWith(OrdersEntryArgs value, $Res Function(OrdersEntryArgs) _then) = _$OrdersEntryArgsCopyWithImpl;
@useResult
$Res call({
 String? fromScreen
});




}
/// @nodoc
class _$OrdersEntryArgsCopyWithImpl<$Res>
    implements $OrdersEntryArgsCopyWith<$Res> {
  _$OrdersEntryArgsCopyWithImpl(this._self, this._then);

  final OrdersEntryArgs _self;
  final $Res Function(OrdersEntryArgs) _then;

/// Create a copy of OrdersEntryArgs
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fromScreen = freezed,}) {
  return _then(_self.copyWith(
fromScreen: freezed == fromScreen ? _self.fromScreen : fromScreen // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [OrdersEntryArgs].
extension OrdersEntryArgsPatterns on OrdersEntryArgs {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrdersEntryArgs value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrdersEntryArgs() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrdersEntryArgs value)  $default,){
final _that = this;
switch (_that) {
case _OrdersEntryArgs():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrdersEntryArgs value)?  $default,){
final _that = this;
switch (_that) {
case _OrdersEntryArgs() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? fromScreen)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrdersEntryArgs() when $default != null:
return $default(_that.fromScreen);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? fromScreen)  $default,) {final _that = this;
switch (_that) {
case _OrdersEntryArgs():
return $default(_that.fromScreen);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? fromScreen)?  $default,) {final _that = this;
switch (_that) {
case _OrdersEntryArgs() when $default != null:
return $default(_that.fromScreen);case _:
  return null;

}
}

}

/// @nodoc


class _OrdersEntryArgs implements OrdersEntryArgs {
  const _OrdersEntryArgs({this.fromScreen});
  

@override final  String? fromScreen;

/// Create a copy of OrdersEntryArgs
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrdersEntryArgsCopyWith<_OrdersEntryArgs> get copyWith => __$OrdersEntryArgsCopyWithImpl<_OrdersEntryArgs>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrdersEntryArgs&&(identical(other.fromScreen, fromScreen) || other.fromScreen == fromScreen));
}


@override
int get hashCode => Object.hash(runtimeType,fromScreen);

@override
String toString() {
  return 'OrdersEntryArgs(fromScreen: $fromScreen)';
}


}

/// @nodoc
abstract mixin class _$OrdersEntryArgsCopyWith<$Res> implements $OrdersEntryArgsCopyWith<$Res> {
  factory _$OrdersEntryArgsCopyWith(_OrdersEntryArgs value, $Res Function(_OrdersEntryArgs) _then) = __$OrdersEntryArgsCopyWithImpl;
@override @useResult
$Res call({
 String? fromScreen
});




}
/// @nodoc
class __$OrdersEntryArgsCopyWithImpl<$Res>
    implements _$OrdersEntryArgsCopyWith<$Res> {
  __$OrdersEntryArgsCopyWithImpl(this._self, this._then);

  final _OrdersEntryArgs _self;
  final $Res Function(_OrdersEntryArgs) _then;

/// Create a copy of OrdersEntryArgs
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fromScreen = freezed,}) {
  return _then(_OrdersEntryArgs(
fromScreen: freezed == fromScreen ? _self.fromScreen : fromScreen // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
