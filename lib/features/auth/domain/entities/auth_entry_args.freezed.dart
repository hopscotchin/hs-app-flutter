// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_entry_args.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthEntryArgs {

/// The screen the user came from — e.g. `FromScreens.account`,
/// `FromScreens.shoppingCart`.
///
/// Nullable, and null becomes `"none"` on the wire. That is Android's
/// behaviour too: every auth logger runs the value through an explicit
/// `!TextUtils.isEmpty(x) ? x : NONE` ternary, so the key is always present
/// and an unknown entry point is reported rather than dropped.
 String? get fromScreen;/// The control that opened the screen — e.g. `FromLocations.signInButton`,
/// `FromLocations.signUpButton`.
///
/// Same null handling as [fromScreen].
 String? get fromLocation;/// Why the user was sent to sign in — a `LoginRedirects.type*` key such as
/// `REDIRECT_PROMO`, or null when they navigated here themselves.
///
/// **Flutter populates this; Android does not.** Android reads the value
/// from an intent extra no caller ever writes (`LoginActivity.kt:83`), so
/// `from_redirect` is the literal `"none"` on 100% of its fires — dead
/// across four events, confirmed on a device capture. Approved 2026-09-02
/// to populate it on Flutter rather than reproduce a constant that carries
/// no dimension. Finding A1.
///
/// The **type key** goes on the wire, not the user-facing sentence
/// `LoginRedirects.lookup` returns: the key is the stable dimension, and it
/// is what Android's own `INTENT_FLAG_SIGN_ACTION` extra already carries.
 String? get fromRedirect;
/// Create a copy of AuthEntryArgs
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthEntryArgsCopyWith<AuthEntryArgs> get copyWith => _$AuthEntryArgsCopyWithImpl<AuthEntryArgs>(this as AuthEntryArgs, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthEntryArgs&&(identical(other.fromScreen, fromScreen) || other.fromScreen == fromScreen)&&(identical(other.fromLocation, fromLocation) || other.fromLocation == fromLocation)&&(identical(other.fromRedirect, fromRedirect) || other.fromRedirect == fromRedirect));
}


@override
int get hashCode => Object.hash(runtimeType,fromScreen,fromLocation,fromRedirect);

@override
String toString() {
  return 'AuthEntryArgs(fromScreen: $fromScreen, fromLocation: $fromLocation, fromRedirect: $fromRedirect)';
}


}

/// @nodoc
abstract mixin class $AuthEntryArgsCopyWith<$Res>  {
  factory $AuthEntryArgsCopyWith(AuthEntryArgs value, $Res Function(AuthEntryArgs) _then) = _$AuthEntryArgsCopyWithImpl;
@useResult
$Res call({
 String? fromScreen, String? fromLocation, String? fromRedirect
});




}
/// @nodoc
class _$AuthEntryArgsCopyWithImpl<$Res>
    implements $AuthEntryArgsCopyWith<$Res> {
  _$AuthEntryArgsCopyWithImpl(this._self, this._then);

  final AuthEntryArgs _self;
  final $Res Function(AuthEntryArgs) _then;

/// Create a copy of AuthEntryArgs
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fromScreen = freezed,Object? fromLocation = freezed,Object? fromRedirect = freezed,}) {
  return _then(_self.copyWith(
fromScreen: freezed == fromScreen ? _self.fromScreen : fromScreen // ignore: cast_nullable_to_non_nullable
as String?,fromLocation: freezed == fromLocation ? _self.fromLocation : fromLocation // ignore: cast_nullable_to_non_nullable
as String?,fromRedirect: freezed == fromRedirect ? _self.fromRedirect : fromRedirect // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthEntryArgs].
extension AuthEntryArgsPatterns on AuthEntryArgs {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthEntryArgs value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthEntryArgs() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthEntryArgs value)  $default,){
final _that = this;
switch (_that) {
case _AuthEntryArgs():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthEntryArgs value)?  $default,){
final _that = this;
switch (_that) {
case _AuthEntryArgs() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? fromScreen,  String? fromLocation,  String? fromRedirect)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthEntryArgs() when $default != null:
return $default(_that.fromScreen,_that.fromLocation,_that.fromRedirect);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? fromScreen,  String? fromLocation,  String? fromRedirect)  $default,) {final _that = this;
switch (_that) {
case _AuthEntryArgs():
return $default(_that.fromScreen,_that.fromLocation,_that.fromRedirect);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? fromScreen,  String? fromLocation,  String? fromRedirect)?  $default,) {final _that = this;
switch (_that) {
case _AuthEntryArgs() when $default != null:
return $default(_that.fromScreen,_that.fromLocation,_that.fromRedirect);case _:
  return null;

}
}

}

/// @nodoc


class _AuthEntryArgs implements AuthEntryArgs {
  const _AuthEntryArgs({this.fromScreen, this.fromLocation, this.fromRedirect});
  

/// The screen the user came from — e.g. `FromScreens.account`,
/// `FromScreens.shoppingCart`.
///
/// Nullable, and null becomes `"none"` on the wire. That is Android's
/// behaviour too: every auth logger runs the value through an explicit
/// `!TextUtils.isEmpty(x) ? x : NONE` ternary, so the key is always present
/// and an unknown entry point is reported rather than dropped.
@override final  String? fromScreen;
/// The control that opened the screen — e.g. `FromLocations.signInButton`,
/// `FromLocations.signUpButton`.
///
/// Same null handling as [fromScreen].
@override final  String? fromLocation;
/// Why the user was sent to sign in — a `LoginRedirects.type*` key such as
/// `REDIRECT_PROMO`, or null when they navigated here themselves.
///
/// **Flutter populates this; Android does not.** Android reads the value
/// from an intent extra no caller ever writes (`LoginActivity.kt:83`), so
/// `from_redirect` is the literal `"none"` on 100% of its fires — dead
/// across four events, confirmed on a device capture. Approved 2026-09-02
/// to populate it on Flutter rather than reproduce a constant that carries
/// no dimension. Finding A1.
///
/// The **type key** goes on the wire, not the user-facing sentence
/// `LoginRedirects.lookup` returns: the key is the stable dimension, and it
/// is what Android's own `INTENT_FLAG_SIGN_ACTION` extra already carries.
@override final  String? fromRedirect;

/// Create a copy of AuthEntryArgs
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthEntryArgsCopyWith<_AuthEntryArgs> get copyWith => __$AuthEntryArgsCopyWithImpl<_AuthEntryArgs>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthEntryArgs&&(identical(other.fromScreen, fromScreen) || other.fromScreen == fromScreen)&&(identical(other.fromLocation, fromLocation) || other.fromLocation == fromLocation)&&(identical(other.fromRedirect, fromRedirect) || other.fromRedirect == fromRedirect));
}


@override
int get hashCode => Object.hash(runtimeType,fromScreen,fromLocation,fromRedirect);

@override
String toString() {
  return 'AuthEntryArgs(fromScreen: $fromScreen, fromLocation: $fromLocation, fromRedirect: $fromRedirect)';
}


}

/// @nodoc
abstract mixin class _$AuthEntryArgsCopyWith<$Res> implements $AuthEntryArgsCopyWith<$Res> {
  factory _$AuthEntryArgsCopyWith(_AuthEntryArgs value, $Res Function(_AuthEntryArgs) _then) = __$AuthEntryArgsCopyWithImpl;
@override @useResult
$Res call({
 String? fromScreen, String? fromLocation, String? fromRedirect
});




}
/// @nodoc
class __$AuthEntryArgsCopyWithImpl<$Res>
    implements _$AuthEntryArgsCopyWith<$Res> {
  __$AuthEntryArgsCopyWithImpl(this._self, this._then);

  final _AuthEntryArgs _self;
  final $Res Function(_AuthEntryArgs) _then;

/// Create a copy of AuthEntryArgs
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fromScreen = freezed,Object? fromLocation = freezed,Object? fromRedirect = freezed,}) {
  return _then(_AuthEntryArgs(
fromScreen: freezed == fromScreen ? _self.fromScreen : fromScreen // ignore: cast_nullable_to_non_nullable
as String?,fromLocation: freezed == fromLocation ? _self.fromLocation : fromLocation // ignore: cast_nullable_to_non_nullable
as String?,fromRedirect: freezed == fromRedirect ? _self.fromRedirect : fromRedirect // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
