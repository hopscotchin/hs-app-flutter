// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wishlist_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WishlistState {

 Map<String, String?> get items; Set<String> get inFlight; int get feedbackTick; String? get feedbackMessage; bool get feedbackIsError;
/// Create a copy of WishlistState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WishlistStateCopyWith<WishlistState> get copyWith => _$WishlistStateCopyWithImpl<WishlistState>(this as WishlistState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WishlistState&&const DeepCollectionEquality().equals(other.items, items)&&const DeepCollectionEquality().equals(other.inFlight, inFlight)&&(identical(other.feedbackTick, feedbackTick) || other.feedbackTick == feedbackTick)&&(identical(other.feedbackMessage, feedbackMessage) || other.feedbackMessage == feedbackMessage)&&(identical(other.feedbackIsError, feedbackIsError) || other.feedbackIsError == feedbackIsError));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),const DeepCollectionEquality().hash(inFlight),feedbackTick,feedbackMessage,feedbackIsError);

@override
String toString() {
  return 'WishlistState(items: $items, inFlight: $inFlight, feedbackTick: $feedbackTick, feedbackMessage: $feedbackMessage, feedbackIsError: $feedbackIsError)';
}


}

/// @nodoc
abstract mixin class $WishlistStateCopyWith<$Res>  {
  factory $WishlistStateCopyWith(WishlistState value, $Res Function(WishlistState) _then) = _$WishlistStateCopyWithImpl;
@useResult
$Res call({
 Map<String, String?> items, Set<String> inFlight, int feedbackTick, String? feedbackMessage, bool feedbackIsError
});




}
/// @nodoc
class _$WishlistStateCopyWithImpl<$Res>
    implements $WishlistStateCopyWith<$Res> {
  _$WishlistStateCopyWithImpl(this._self, this._then);

  final WishlistState _self;
  final $Res Function(WishlistState) _then;

/// Create a copy of WishlistState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? inFlight = null,Object? feedbackTick = null,Object? feedbackMessage = freezed,Object? feedbackIsError = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as Map<String, String?>,inFlight: null == inFlight ? _self.inFlight : inFlight // ignore: cast_nullable_to_non_nullable
as Set<String>,feedbackTick: null == feedbackTick ? _self.feedbackTick : feedbackTick // ignore: cast_nullable_to_non_nullable
as int,feedbackMessage: freezed == feedbackMessage ? _self.feedbackMessage : feedbackMessage // ignore: cast_nullable_to_non_nullable
as String?,feedbackIsError: null == feedbackIsError ? _self.feedbackIsError : feedbackIsError // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [WishlistState].
extension WishlistStatePatterns on WishlistState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WishlistState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WishlistState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WishlistState value)  $default,){
final _that = this;
switch (_that) {
case _WishlistState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WishlistState value)?  $default,){
final _that = this;
switch (_that) {
case _WishlistState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, String?> items,  Set<String> inFlight,  int feedbackTick,  String? feedbackMessage,  bool feedbackIsError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WishlistState() when $default != null:
return $default(_that.items,_that.inFlight,_that.feedbackTick,_that.feedbackMessage,_that.feedbackIsError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, String?> items,  Set<String> inFlight,  int feedbackTick,  String? feedbackMessage,  bool feedbackIsError)  $default,) {final _that = this;
switch (_that) {
case _WishlistState():
return $default(_that.items,_that.inFlight,_that.feedbackTick,_that.feedbackMessage,_that.feedbackIsError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, String?> items,  Set<String> inFlight,  int feedbackTick,  String? feedbackMessage,  bool feedbackIsError)?  $default,) {final _that = this;
switch (_that) {
case _WishlistState() when $default != null:
return $default(_that.items,_that.inFlight,_that.feedbackTick,_that.feedbackMessage,_that.feedbackIsError);case _:
  return null;

}
}

}

/// @nodoc


class _WishlistState implements WishlistState {
  const _WishlistState({final  Map<String, String?> items = const <String, String?>{}, final  Set<String> inFlight = const <String>{}, this.feedbackTick = 0, this.feedbackMessage, this.feedbackIsError = false}): _items = items,_inFlight = inFlight;
  

 final  Map<String, String?> _items;
@override@JsonKey() Map<String, String?> get items {
  if (_items is EqualUnmodifiableMapView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_items);
}

 final  Set<String> _inFlight;
@override@JsonKey() Set<String> get inFlight {
  if (_inFlight is EqualUnmodifiableSetView) return _inFlight;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_inFlight);
}

@override@JsonKey() final  int feedbackTick;
@override final  String? feedbackMessage;
@override@JsonKey() final  bool feedbackIsError;

/// Create a copy of WishlistState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WishlistStateCopyWith<_WishlistState> get copyWith => __$WishlistStateCopyWithImpl<_WishlistState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WishlistState&&const DeepCollectionEquality().equals(other._items, _items)&&const DeepCollectionEquality().equals(other._inFlight, _inFlight)&&(identical(other.feedbackTick, feedbackTick) || other.feedbackTick == feedbackTick)&&(identical(other.feedbackMessage, feedbackMessage) || other.feedbackMessage == feedbackMessage)&&(identical(other.feedbackIsError, feedbackIsError) || other.feedbackIsError == feedbackIsError));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),const DeepCollectionEquality().hash(_inFlight),feedbackTick,feedbackMessage,feedbackIsError);

@override
String toString() {
  return 'WishlistState(items: $items, inFlight: $inFlight, feedbackTick: $feedbackTick, feedbackMessage: $feedbackMessage, feedbackIsError: $feedbackIsError)';
}


}

/// @nodoc
abstract mixin class _$WishlistStateCopyWith<$Res> implements $WishlistStateCopyWith<$Res> {
  factory _$WishlistStateCopyWith(_WishlistState value, $Res Function(_WishlistState) _then) = __$WishlistStateCopyWithImpl;
@override @useResult
$Res call({
 Map<String, String?> items, Set<String> inFlight, int feedbackTick, String? feedbackMessage, bool feedbackIsError
});




}
/// @nodoc
class __$WishlistStateCopyWithImpl<$Res>
    implements _$WishlistStateCopyWith<$Res> {
  __$WishlistStateCopyWithImpl(this._self, this._then);

  final _WishlistState _self;
  final $Res Function(_WishlistState) _then;

/// Create a copy of WishlistState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? inFlight = null,Object? feedbackTick = null,Object? feedbackMessage = freezed,Object? feedbackIsError = null,}) {
  return _then(_WishlistState(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as Map<String, String?>,inFlight: null == inFlight ? _self._inFlight : inFlight // ignore: cast_nullable_to_non_nullable
as Set<String>,feedbackTick: null == feedbackTick ? _self.feedbackTick : feedbackTick // ignore: cast_nullable_to_non_nullable
as int,feedbackMessage: freezed == feedbackMessage ? _self.feedbackMessage : feedbackMessage // ignore: cast_nullable_to_non_nullable
as String?,feedbackIsError: null == feedbackIsError ? _self.feedbackIsError : feedbackIsError // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
