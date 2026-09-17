// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_state_entry_args.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PaymentStateEntryArgs {

 InitJusPayEntity get initJusPayEntity; int get orderId; bool get creditsApplied; bool get quickPayEnabled; String? get fromScreen; String? get paymentMode;
/// Create a copy of PaymentStateEntryArgs
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentStateEntryArgsCopyWith<PaymentStateEntryArgs> get copyWith => _$PaymentStateEntryArgsCopyWithImpl<PaymentStateEntryArgs>(this as PaymentStateEntryArgs, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentStateEntryArgs&&(identical(other.initJusPayEntity, initJusPayEntity) || other.initJusPayEntity == initJusPayEntity)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.creditsApplied, creditsApplied) || other.creditsApplied == creditsApplied)&&(identical(other.quickPayEnabled, quickPayEnabled) || other.quickPayEnabled == quickPayEnabled)&&(identical(other.fromScreen, fromScreen) || other.fromScreen == fromScreen)&&(identical(other.paymentMode, paymentMode) || other.paymentMode == paymentMode));
}


@override
int get hashCode => Object.hash(runtimeType,initJusPayEntity,orderId,creditsApplied,quickPayEnabled,fromScreen,paymentMode);

@override
String toString() {
  return 'PaymentStateEntryArgs(initJusPayEntity: $initJusPayEntity, orderId: $orderId, creditsApplied: $creditsApplied, quickPayEnabled: $quickPayEnabled, fromScreen: $fromScreen, paymentMode: $paymentMode)';
}


}

/// @nodoc
abstract mixin class $PaymentStateEntryArgsCopyWith<$Res>  {
  factory $PaymentStateEntryArgsCopyWith(PaymentStateEntryArgs value, $Res Function(PaymentStateEntryArgs) _then) = _$PaymentStateEntryArgsCopyWithImpl;
@useResult
$Res call({
 InitJusPayEntity initJusPayEntity, int orderId, bool creditsApplied, bool quickPayEnabled, String? fromScreen, String? paymentMode
});




}
/// @nodoc
class _$PaymentStateEntryArgsCopyWithImpl<$Res>
    implements $PaymentStateEntryArgsCopyWith<$Res> {
  _$PaymentStateEntryArgsCopyWithImpl(this._self, this._then);

  final PaymentStateEntryArgs _self;
  final $Res Function(PaymentStateEntryArgs) _then;

/// Create a copy of PaymentStateEntryArgs
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? initJusPayEntity = null,Object? orderId = null,Object? creditsApplied = null,Object? quickPayEnabled = null,Object? fromScreen = freezed,Object? paymentMode = freezed,}) {
  return _then(_self.copyWith(
initJusPayEntity: null == initJusPayEntity ? _self.initJusPayEntity : initJusPayEntity // ignore: cast_nullable_to_non_nullable
as InitJusPayEntity,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as int,creditsApplied: null == creditsApplied ? _self.creditsApplied : creditsApplied // ignore: cast_nullable_to_non_nullable
as bool,quickPayEnabled: null == quickPayEnabled ? _self.quickPayEnabled : quickPayEnabled // ignore: cast_nullable_to_non_nullable
as bool,fromScreen: freezed == fromScreen ? _self.fromScreen : fromScreen // ignore: cast_nullable_to_non_nullable
as String?,paymentMode: freezed == paymentMode ? _self.paymentMode : paymentMode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PaymentStateEntryArgs].
extension PaymentStateEntryArgsPatterns on PaymentStateEntryArgs {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentStateEntryArgs value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentStateEntryArgs() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentStateEntryArgs value)  $default,){
final _that = this;
switch (_that) {
case _PaymentStateEntryArgs():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentStateEntryArgs value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentStateEntryArgs() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( InitJusPayEntity initJusPayEntity,  int orderId,  bool creditsApplied,  bool quickPayEnabled,  String? fromScreen,  String? paymentMode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentStateEntryArgs() when $default != null:
return $default(_that.initJusPayEntity,_that.orderId,_that.creditsApplied,_that.quickPayEnabled,_that.fromScreen,_that.paymentMode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( InitJusPayEntity initJusPayEntity,  int orderId,  bool creditsApplied,  bool quickPayEnabled,  String? fromScreen,  String? paymentMode)  $default,) {final _that = this;
switch (_that) {
case _PaymentStateEntryArgs():
return $default(_that.initJusPayEntity,_that.orderId,_that.creditsApplied,_that.quickPayEnabled,_that.fromScreen,_that.paymentMode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( InitJusPayEntity initJusPayEntity,  int orderId,  bool creditsApplied,  bool quickPayEnabled,  String? fromScreen,  String? paymentMode)?  $default,) {final _that = this;
switch (_that) {
case _PaymentStateEntryArgs() when $default != null:
return $default(_that.initJusPayEntity,_that.orderId,_that.creditsApplied,_that.quickPayEnabled,_that.fromScreen,_that.paymentMode);case _:
  return null;

}
}

}

/// @nodoc


class _PaymentStateEntryArgs implements PaymentStateEntryArgs {
  const _PaymentStateEntryArgs({required this.initJusPayEntity, required this.orderId, required this.creditsApplied, this.quickPayEnabled = false, this.fromScreen, this.paymentMode});
  

@override final  InitJusPayEntity initJusPayEntity;
@override final  int orderId;
@override final  bool creditsApplied;
@override@JsonKey() final  bool quickPayEnabled;
@override final  String? fromScreen;
@override final  String? paymentMode;

/// Create a copy of PaymentStateEntryArgs
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentStateEntryArgsCopyWith<_PaymentStateEntryArgs> get copyWith => __$PaymentStateEntryArgsCopyWithImpl<_PaymentStateEntryArgs>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentStateEntryArgs&&(identical(other.initJusPayEntity, initJusPayEntity) || other.initJusPayEntity == initJusPayEntity)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.creditsApplied, creditsApplied) || other.creditsApplied == creditsApplied)&&(identical(other.quickPayEnabled, quickPayEnabled) || other.quickPayEnabled == quickPayEnabled)&&(identical(other.fromScreen, fromScreen) || other.fromScreen == fromScreen)&&(identical(other.paymentMode, paymentMode) || other.paymentMode == paymentMode));
}


@override
int get hashCode => Object.hash(runtimeType,initJusPayEntity,orderId,creditsApplied,quickPayEnabled,fromScreen,paymentMode);

@override
String toString() {
  return 'PaymentStateEntryArgs(initJusPayEntity: $initJusPayEntity, orderId: $orderId, creditsApplied: $creditsApplied, quickPayEnabled: $quickPayEnabled, fromScreen: $fromScreen, paymentMode: $paymentMode)';
}


}

/// @nodoc
abstract mixin class _$PaymentStateEntryArgsCopyWith<$Res> implements $PaymentStateEntryArgsCopyWith<$Res> {
  factory _$PaymentStateEntryArgsCopyWith(_PaymentStateEntryArgs value, $Res Function(_PaymentStateEntryArgs) _then) = __$PaymentStateEntryArgsCopyWithImpl;
@override @useResult
$Res call({
 InitJusPayEntity initJusPayEntity, int orderId, bool creditsApplied, bool quickPayEnabled, String? fromScreen, String? paymentMode
});




}
/// @nodoc
class __$PaymentStateEntryArgsCopyWithImpl<$Res>
    implements _$PaymentStateEntryArgsCopyWith<$Res> {
  __$PaymentStateEntryArgsCopyWithImpl(this._self, this._then);

  final _PaymentStateEntryArgs _self;
  final $Res Function(_PaymentStateEntryArgs) _then;

/// Create a copy of PaymentStateEntryArgs
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? initJusPayEntity = null,Object? orderId = null,Object? creditsApplied = null,Object? quickPayEnabled = null,Object? fromScreen = freezed,Object? paymentMode = freezed,}) {
  return _then(_PaymentStateEntryArgs(
initJusPayEntity: null == initJusPayEntity ? _self.initJusPayEntity : initJusPayEntity // ignore: cast_nullable_to_non_nullable
as InitJusPayEntity,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as int,creditsApplied: null == creditsApplied ? _self.creditsApplied : creditsApplied // ignore: cast_nullable_to_non_nullable
as bool,quickPayEnabled: null == quickPayEnabled ? _self.quickPayEnabled : quickPayEnabled // ignore: cast_nullable_to_non_nullable
as bool,fromScreen: freezed == fromScreen ? _self.fromScreen : fromScreen // ignore: cast_nullable_to_non_nullable
as String?,paymentMode: freezed == paymentMode ? _self.paymentMode : paymentMode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
