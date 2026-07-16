// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_actions_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CartActionsState {

 Set<String> get addedSkus; Set<String> get inFlight; int get feedbackTick; String? get feedbackMessage; bool get feedbackIsError;
/// Create a copy of CartActionsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CartActionsStateCopyWith<CartActionsState> get copyWith => _$CartActionsStateCopyWithImpl<CartActionsState>(this as CartActionsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CartActionsState&&const DeepCollectionEquality().equals(other.addedSkus, addedSkus)&&const DeepCollectionEquality().equals(other.inFlight, inFlight)&&(identical(other.feedbackTick, feedbackTick) || other.feedbackTick == feedbackTick)&&(identical(other.feedbackMessage, feedbackMessage) || other.feedbackMessage == feedbackMessage)&&(identical(other.feedbackIsError, feedbackIsError) || other.feedbackIsError == feedbackIsError));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(addedSkus),const DeepCollectionEquality().hash(inFlight),feedbackTick,feedbackMessage,feedbackIsError);

@override
String toString() {
  return 'CartActionsState(addedSkus: $addedSkus, inFlight: $inFlight, feedbackTick: $feedbackTick, feedbackMessage: $feedbackMessage, feedbackIsError: $feedbackIsError)';
}


}

/// @nodoc
abstract mixin class $CartActionsStateCopyWith<$Res>  {
  factory $CartActionsStateCopyWith(CartActionsState value, $Res Function(CartActionsState) _then) = _$CartActionsStateCopyWithImpl;
@useResult
$Res call({
 Set<String> addedSkus, Set<String> inFlight, int feedbackTick, String? feedbackMessage, bool feedbackIsError
});




}
/// @nodoc
class _$CartActionsStateCopyWithImpl<$Res>
    implements $CartActionsStateCopyWith<$Res> {
  _$CartActionsStateCopyWithImpl(this._self, this._then);

  final CartActionsState _self;
  final $Res Function(CartActionsState) _then;

/// Create a copy of CartActionsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? addedSkus = null,Object? inFlight = null,Object? feedbackTick = null,Object? feedbackMessage = freezed,Object? feedbackIsError = null,}) {
  return _then(_self.copyWith(
addedSkus: null == addedSkus ? _self.addedSkus : addedSkus // ignore: cast_nullable_to_non_nullable
as Set<String>,inFlight: null == inFlight ? _self.inFlight : inFlight // ignore: cast_nullable_to_non_nullable
as Set<String>,feedbackTick: null == feedbackTick ? _self.feedbackTick : feedbackTick // ignore: cast_nullable_to_non_nullable
as int,feedbackMessage: freezed == feedbackMessage ? _self.feedbackMessage : feedbackMessage // ignore: cast_nullable_to_non_nullable
as String?,feedbackIsError: null == feedbackIsError ? _self.feedbackIsError : feedbackIsError // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CartActionsState].
extension CartActionsStatePatterns on CartActionsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CartActionsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CartActionsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CartActionsState value)  $default,){
final _that = this;
switch (_that) {
case _CartActionsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CartActionsState value)?  $default,){
final _that = this;
switch (_that) {
case _CartActionsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Set<String> addedSkus,  Set<String> inFlight,  int feedbackTick,  String? feedbackMessage,  bool feedbackIsError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CartActionsState() when $default != null:
return $default(_that.addedSkus,_that.inFlight,_that.feedbackTick,_that.feedbackMessage,_that.feedbackIsError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Set<String> addedSkus,  Set<String> inFlight,  int feedbackTick,  String? feedbackMessage,  bool feedbackIsError)  $default,) {final _that = this;
switch (_that) {
case _CartActionsState():
return $default(_that.addedSkus,_that.inFlight,_that.feedbackTick,_that.feedbackMessage,_that.feedbackIsError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Set<String> addedSkus,  Set<String> inFlight,  int feedbackTick,  String? feedbackMessage,  bool feedbackIsError)?  $default,) {final _that = this;
switch (_that) {
case _CartActionsState() when $default != null:
return $default(_that.addedSkus,_that.inFlight,_that.feedbackTick,_that.feedbackMessage,_that.feedbackIsError);case _:
  return null;

}
}

}

/// @nodoc


class _CartActionsState implements CartActionsState {
  const _CartActionsState({final  Set<String> addedSkus = const <String>{}, final  Set<String> inFlight = const <String>{}, this.feedbackTick = 0, this.feedbackMessage, this.feedbackIsError = false}): _addedSkus = addedSkus,_inFlight = inFlight;
  

 final  Set<String> _addedSkus;
@override@JsonKey() Set<String> get addedSkus {
  if (_addedSkus is EqualUnmodifiableSetView) return _addedSkus;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_addedSkus);
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

/// Create a copy of CartActionsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CartActionsStateCopyWith<_CartActionsState> get copyWith => __$CartActionsStateCopyWithImpl<_CartActionsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CartActionsState&&const DeepCollectionEquality().equals(other._addedSkus, _addedSkus)&&const DeepCollectionEquality().equals(other._inFlight, _inFlight)&&(identical(other.feedbackTick, feedbackTick) || other.feedbackTick == feedbackTick)&&(identical(other.feedbackMessage, feedbackMessage) || other.feedbackMessage == feedbackMessage)&&(identical(other.feedbackIsError, feedbackIsError) || other.feedbackIsError == feedbackIsError));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_addedSkus),const DeepCollectionEquality().hash(_inFlight),feedbackTick,feedbackMessage,feedbackIsError);

@override
String toString() {
  return 'CartActionsState(addedSkus: $addedSkus, inFlight: $inFlight, feedbackTick: $feedbackTick, feedbackMessage: $feedbackMessage, feedbackIsError: $feedbackIsError)';
}


}

/// @nodoc
abstract mixin class _$CartActionsStateCopyWith<$Res> implements $CartActionsStateCopyWith<$Res> {
  factory _$CartActionsStateCopyWith(_CartActionsState value, $Res Function(_CartActionsState) _then) = __$CartActionsStateCopyWithImpl;
@override @useResult
$Res call({
 Set<String> addedSkus, Set<String> inFlight, int feedbackTick, String? feedbackMessage, bool feedbackIsError
});




}
/// @nodoc
class __$CartActionsStateCopyWithImpl<$Res>
    implements _$CartActionsStateCopyWith<$Res> {
  __$CartActionsStateCopyWithImpl(this._self, this._then);

  final _CartActionsState _self;
  final $Res Function(_CartActionsState) _then;

/// Create a copy of CartActionsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? addedSkus = null,Object? inFlight = null,Object? feedbackTick = null,Object? feedbackMessage = freezed,Object? feedbackIsError = null,}) {
  return _then(_CartActionsState(
addedSkus: null == addedSkus ? _self._addedSkus : addedSkus // ignore: cast_nullable_to_non_nullable
as Set<String>,inFlight: null == inFlight ? _self._inFlight : inFlight // ignore: cast_nullable_to_non_nullable
as Set<String>,feedbackTick: null == feedbackTick ? _self.feedbackTick : feedbackTick // ignore: cast_nullable_to_non_nullable
as int,feedbackMessage: freezed == feedbackMessage ? _self.feedbackMessage : feedbackMessage // ignore: cast_nullable_to_non_nullable
as String?,feedbackIsError: null == feedbackIsError ? _self.feedbackIsError : feedbackIsError // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
