// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_retry_entry_args.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PaymentRetryEntryArgs {

 PaymentRetryEntity get paymentRetryEntity; int get orderId; String? get fromScreen; String? get previousPaymentMode;
/// Create a copy of PaymentRetryEntryArgs
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentRetryEntryArgsCopyWith<PaymentRetryEntryArgs> get copyWith => _$PaymentRetryEntryArgsCopyWithImpl<PaymentRetryEntryArgs>(this as PaymentRetryEntryArgs, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentRetryEntryArgs&&(identical(other.paymentRetryEntity, paymentRetryEntity) || other.paymentRetryEntity == paymentRetryEntity)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.fromScreen, fromScreen) || other.fromScreen == fromScreen)&&(identical(other.previousPaymentMode, previousPaymentMode) || other.previousPaymentMode == previousPaymentMode));
}


@override
int get hashCode => Object.hash(runtimeType,paymentRetryEntity,orderId,fromScreen,previousPaymentMode);

@override
String toString() {
  return 'PaymentRetryEntryArgs(paymentRetryEntity: $paymentRetryEntity, orderId: $orderId, fromScreen: $fromScreen, previousPaymentMode: $previousPaymentMode)';
}


}

/// @nodoc
abstract mixin class $PaymentRetryEntryArgsCopyWith<$Res>  {
  factory $PaymentRetryEntryArgsCopyWith(PaymentRetryEntryArgs value, $Res Function(PaymentRetryEntryArgs) _then) = _$PaymentRetryEntryArgsCopyWithImpl;
@useResult
$Res call({
 PaymentRetryEntity paymentRetryEntity, int orderId, String? fromScreen, String? previousPaymentMode
});




}
/// @nodoc
class _$PaymentRetryEntryArgsCopyWithImpl<$Res>
    implements $PaymentRetryEntryArgsCopyWith<$Res> {
  _$PaymentRetryEntryArgsCopyWithImpl(this._self, this._then);

  final PaymentRetryEntryArgs _self;
  final $Res Function(PaymentRetryEntryArgs) _then;

/// Create a copy of PaymentRetryEntryArgs
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? paymentRetryEntity = null,Object? orderId = null,Object? fromScreen = freezed,Object? previousPaymentMode = freezed,}) {
  return _then(_self.copyWith(
paymentRetryEntity: null == paymentRetryEntity ? _self.paymentRetryEntity : paymentRetryEntity // ignore: cast_nullable_to_non_nullable
as PaymentRetryEntity,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as int,fromScreen: freezed == fromScreen ? _self.fromScreen : fromScreen // ignore: cast_nullable_to_non_nullable
as String?,previousPaymentMode: freezed == previousPaymentMode ? _self.previousPaymentMode : previousPaymentMode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PaymentRetryEntryArgs].
extension PaymentRetryEntryArgsPatterns on PaymentRetryEntryArgs {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentRetryEntryArgs value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentRetryEntryArgs() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentRetryEntryArgs value)  $default,){
final _that = this;
switch (_that) {
case _PaymentRetryEntryArgs():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentRetryEntryArgs value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentRetryEntryArgs() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PaymentRetryEntity paymentRetryEntity,  int orderId,  String? fromScreen,  String? previousPaymentMode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentRetryEntryArgs() when $default != null:
return $default(_that.paymentRetryEntity,_that.orderId,_that.fromScreen,_that.previousPaymentMode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PaymentRetryEntity paymentRetryEntity,  int orderId,  String? fromScreen,  String? previousPaymentMode)  $default,) {final _that = this;
switch (_that) {
case _PaymentRetryEntryArgs():
return $default(_that.paymentRetryEntity,_that.orderId,_that.fromScreen,_that.previousPaymentMode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PaymentRetryEntity paymentRetryEntity,  int orderId,  String? fromScreen,  String? previousPaymentMode)?  $default,) {final _that = this;
switch (_that) {
case _PaymentRetryEntryArgs() when $default != null:
return $default(_that.paymentRetryEntity,_that.orderId,_that.fromScreen,_that.previousPaymentMode);case _:
  return null;

}
}

}

/// @nodoc


class _PaymentRetryEntryArgs implements PaymentRetryEntryArgs {
  const _PaymentRetryEntryArgs({required this.paymentRetryEntity, required this.orderId, this.fromScreen, this.previousPaymentMode});
  

@override final  PaymentRetryEntity paymentRetryEntity;
@override final  int orderId;
@override final  String? fromScreen;
@override final  String? previousPaymentMode;

/// Create a copy of PaymentRetryEntryArgs
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentRetryEntryArgsCopyWith<_PaymentRetryEntryArgs> get copyWith => __$PaymentRetryEntryArgsCopyWithImpl<_PaymentRetryEntryArgs>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentRetryEntryArgs&&(identical(other.paymentRetryEntity, paymentRetryEntity) || other.paymentRetryEntity == paymentRetryEntity)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.fromScreen, fromScreen) || other.fromScreen == fromScreen)&&(identical(other.previousPaymentMode, previousPaymentMode) || other.previousPaymentMode == previousPaymentMode));
}


@override
int get hashCode => Object.hash(runtimeType,paymentRetryEntity,orderId,fromScreen,previousPaymentMode);

@override
String toString() {
  return 'PaymentRetryEntryArgs(paymentRetryEntity: $paymentRetryEntity, orderId: $orderId, fromScreen: $fromScreen, previousPaymentMode: $previousPaymentMode)';
}


}

/// @nodoc
abstract mixin class _$PaymentRetryEntryArgsCopyWith<$Res> implements $PaymentRetryEntryArgsCopyWith<$Res> {
  factory _$PaymentRetryEntryArgsCopyWith(_PaymentRetryEntryArgs value, $Res Function(_PaymentRetryEntryArgs) _then) = __$PaymentRetryEntryArgsCopyWithImpl;
@override @useResult
$Res call({
 PaymentRetryEntity paymentRetryEntity, int orderId, String? fromScreen, String? previousPaymentMode
});




}
/// @nodoc
class __$PaymentRetryEntryArgsCopyWithImpl<$Res>
    implements _$PaymentRetryEntryArgsCopyWith<$Res> {
  __$PaymentRetryEntryArgsCopyWithImpl(this._self, this._then);

  final _PaymentRetryEntryArgs _self;
  final $Res Function(_PaymentRetryEntryArgs) _then;

/// Create a copy of PaymentRetryEntryArgs
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? paymentRetryEntity = null,Object? orderId = null,Object? fromScreen = freezed,Object? previousPaymentMode = freezed,}) {
  return _then(_PaymentRetryEntryArgs(
paymentRetryEntity: null == paymentRetryEntity ? _self.paymentRetryEntity : paymentRetryEntity // ignore: cast_nullable_to_non_nullable
as PaymentRetryEntity,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as int,fromScreen: freezed == fromScreen ? _self.fromScreen : fromScreen // ignore: cast_nullable_to_non_nullable
as String?,previousPaymentMode: freezed == previousPaymentMode ? _self.previousPaymentMode : previousPaymentMode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
