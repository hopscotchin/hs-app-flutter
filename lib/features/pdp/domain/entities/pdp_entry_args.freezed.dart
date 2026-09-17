// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pdp_entry_args.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PdpEntryArgs {

/// e.g. `FromScreens.plp`, `FromScreens.discover`.
 String? get fromScreen;/// e.g. `FromPage.recommendation`, `FromPage.recentlyViewed`.
 String? get fromPage;/// Size of the feed the user came from, or null when the PDP was not opened
/// from a feed.
///
/// Nullable rather than defaulting to 0: a default of 0 used to be invisible
/// because the `num <= 0` rule discarded it, and with that rule gone it would
/// assert "the feed had no items" on every PDP opened outside a feed. Null means
/// unknown and is dropped; 0 would be a claim.
 int? get fromFeedSize;
/// Create a copy of PdpEntryArgs
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PdpEntryArgsCopyWith<PdpEntryArgs> get copyWith => _$PdpEntryArgsCopyWithImpl<PdpEntryArgs>(this as PdpEntryArgs, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PdpEntryArgs&&(identical(other.fromScreen, fromScreen) || other.fromScreen == fromScreen)&&(identical(other.fromPage, fromPage) || other.fromPage == fromPage)&&(identical(other.fromFeedSize, fromFeedSize) || other.fromFeedSize == fromFeedSize));
}


@override
int get hashCode => Object.hash(runtimeType,fromScreen,fromPage,fromFeedSize);

@override
String toString() {
  return 'PdpEntryArgs(fromScreen: $fromScreen, fromPage: $fromPage, fromFeedSize: $fromFeedSize)';
}


}

/// @nodoc
abstract mixin class $PdpEntryArgsCopyWith<$Res>  {
  factory $PdpEntryArgsCopyWith(PdpEntryArgs value, $Res Function(PdpEntryArgs) _then) = _$PdpEntryArgsCopyWithImpl;
@useResult
$Res call({
 String? fromScreen, String? fromPage, int? fromFeedSize
});




}
/// @nodoc
class _$PdpEntryArgsCopyWithImpl<$Res>
    implements $PdpEntryArgsCopyWith<$Res> {
  _$PdpEntryArgsCopyWithImpl(this._self, this._then);

  final PdpEntryArgs _self;
  final $Res Function(PdpEntryArgs) _then;

/// Create a copy of PdpEntryArgs
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fromScreen = freezed,Object? fromPage = freezed,Object? fromFeedSize = freezed,}) {
  return _then(_self.copyWith(
fromScreen: freezed == fromScreen ? _self.fromScreen : fromScreen // ignore: cast_nullable_to_non_nullable
as String?,fromPage: freezed == fromPage ? _self.fromPage : fromPage // ignore: cast_nullable_to_non_nullable
as String?,fromFeedSize: freezed == fromFeedSize ? _self.fromFeedSize : fromFeedSize // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [PdpEntryArgs].
extension PdpEntryArgsPatterns on PdpEntryArgs {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PdpEntryArgs value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PdpEntryArgs() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PdpEntryArgs value)  $default,){
final _that = this;
switch (_that) {
case _PdpEntryArgs():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PdpEntryArgs value)?  $default,){
final _that = this;
switch (_that) {
case _PdpEntryArgs() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? fromScreen,  String? fromPage,  int? fromFeedSize)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PdpEntryArgs() when $default != null:
return $default(_that.fromScreen,_that.fromPage,_that.fromFeedSize);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? fromScreen,  String? fromPage,  int? fromFeedSize)  $default,) {final _that = this;
switch (_that) {
case _PdpEntryArgs():
return $default(_that.fromScreen,_that.fromPage,_that.fromFeedSize);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? fromScreen,  String? fromPage,  int? fromFeedSize)?  $default,) {final _that = this;
switch (_that) {
case _PdpEntryArgs() when $default != null:
return $default(_that.fromScreen,_that.fromPage,_that.fromFeedSize);case _:
  return null;

}
}

}

/// @nodoc


class _PdpEntryArgs implements PdpEntryArgs {
  const _PdpEntryArgs({this.fromScreen, this.fromPage, this.fromFeedSize});
  

/// e.g. `FromScreens.plp`, `FromScreens.discover`.
@override final  String? fromScreen;
/// e.g. `FromPage.recommendation`, `FromPage.recentlyViewed`.
@override final  String? fromPage;
/// Size of the feed the user came from, or null when the PDP was not opened
/// from a feed.
///
/// Nullable rather than defaulting to 0: a default of 0 used to be invisible
/// because the `num <= 0` rule discarded it, and with that rule gone it would
/// assert "the feed had no items" on every PDP opened outside a feed. Null means
/// unknown and is dropped; 0 would be a claim.
@override final  int? fromFeedSize;

/// Create a copy of PdpEntryArgs
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PdpEntryArgsCopyWith<_PdpEntryArgs> get copyWith => __$PdpEntryArgsCopyWithImpl<_PdpEntryArgs>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PdpEntryArgs&&(identical(other.fromScreen, fromScreen) || other.fromScreen == fromScreen)&&(identical(other.fromPage, fromPage) || other.fromPage == fromPage)&&(identical(other.fromFeedSize, fromFeedSize) || other.fromFeedSize == fromFeedSize));
}


@override
int get hashCode => Object.hash(runtimeType,fromScreen,fromPage,fromFeedSize);

@override
String toString() {
  return 'PdpEntryArgs(fromScreen: $fromScreen, fromPage: $fromPage, fromFeedSize: $fromFeedSize)';
}


}

/// @nodoc
abstract mixin class _$PdpEntryArgsCopyWith<$Res> implements $PdpEntryArgsCopyWith<$Res> {
  factory _$PdpEntryArgsCopyWith(_PdpEntryArgs value, $Res Function(_PdpEntryArgs) _then) = __$PdpEntryArgsCopyWithImpl;
@override @useResult
$Res call({
 String? fromScreen, String? fromPage, int? fromFeedSize
});




}
/// @nodoc
class __$PdpEntryArgsCopyWithImpl<$Res>
    implements _$PdpEntryArgsCopyWith<$Res> {
  __$PdpEntryArgsCopyWithImpl(this._self, this._then);

  final _PdpEntryArgs _self;
  final $Res Function(_PdpEntryArgs) _then;

/// Create a copy of PdpEntryArgs
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fromScreen = freezed,Object? fromPage = freezed,Object? fromFeedSize = freezed,}) {
  return _then(_PdpEntryArgs(
fromScreen: freezed == fromScreen ? _self.fromScreen : fromScreen // ignore: cast_nullable_to_non_nullable
as String?,fromPage: freezed == fromPage ? _self.fromPage : fromPage // ignore: cast_nullable_to_non_nullable
as String?,fromFeedSize: freezed == fromFeedSize ? _self.fromFeedSize : fromFeedSize // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
