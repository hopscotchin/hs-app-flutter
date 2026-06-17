// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pincode_check_result_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PincodeCheckResultEntity {

 bool get isSuccessful; String get popUpMessage; List<MessageBarEntity> get messageBars;
/// Create a copy of PincodeCheckResultEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PincodeCheckResultEntityCopyWith<PincodeCheckResultEntity> get copyWith => _$PincodeCheckResultEntityCopyWithImpl<PincodeCheckResultEntity>(this as PincodeCheckResultEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PincodeCheckResultEntity&&(identical(other.isSuccessful, isSuccessful) || other.isSuccessful == isSuccessful)&&(identical(other.popUpMessage, popUpMessage) || other.popUpMessage == popUpMessage)&&const DeepCollectionEquality().equals(other.messageBars, messageBars));
}


@override
int get hashCode => Object.hash(runtimeType,isSuccessful,popUpMessage,const DeepCollectionEquality().hash(messageBars));

@override
String toString() {
  return 'PincodeCheckResultEntity(isSuccessful: $isSuccessful, popUpMessage: $popUpMessage, messageBars: $messageBars)';
}


}

/// @nodoc
abstract mixin class $PincodeCheckResultEntityCopyWith<$Res>  {
  factory $PincodeCheckResultEntityCopyWith(PincodeCheckResultEntity value, $Res Function(PincodeCheckResultEntity) _then) = _$PincodeCheckResultEntityCopyWithImpl;
@useResult
$Res call({
 bool isSuccessful, String popUpMessage, List<MessageBarEntity> messageBars
});




}
/// @nodoc
class _$PincodeCheckResultEntityCopyWithImpl<$Res>
    implements $PincodeCheckResultEntityCopyWith<$Res> {
  _$PincodeCheckResultEntityCopyWithImpl(this._self, this._then);

  final PincodeCheckResultEntity _self;
  final $Res Function(PincodeCheckResultEntity) _then;

/// Create a copy of PincodeCheckResultEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isSuccessful = null,Object? popUpMessage = null,Object? messageBars = null,}) {
  return _then(_self.copyWith(
isSuccessful: null == isSuccessful ? _self.isSuccessful : isSuccessful // ignore: cast_nullable_to_non_nullable
as bool,popUpMessage: null == popUpMessage ? _self.popUpMessage : popUpMessage // ignore: cast_nullable_to_non_nullable
as String,messageBars: null == messageBars ? _self.messageBars : messageBars // ignore: cast_nullable_to_non_nullable
as List<MessageBarEntity>,
  ));
}

}


/// Adds pattern-matching-related methods to [PincodeCheckResultEntity].
extension PincodeCheckResultEntityPatterns on PincodeCheckResultEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PincodeCheckResultEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PincodeCheckResultEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PincodeCheckResultEntity value)  $default,){
final _that = this;
switch (_that) {
case _PincodeCheckResultEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PincodeCheckResultEntity value)?  $default,){
final _that = this;
switch (_that) {
case _PincodeCheckResultEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isSuccessful,  String popUpMessage,  List<MessageBarEntity> messageBars)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PincodeCheckResultEntity() when $default != null:
return $default(_that.isSuccessful,_that.popUpMessage,_that.messageBars);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isSuccessful,  String popUpMessage,  List<MessageBarEntity> messageBars)  $default,) {final _that = this;
switch (_that) {
case _PincodeCheckResultEntity():
return $default(_that.isSuccessful,_that.popUpMessage,_that.messageBars);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isSuccessful,  String popUpMessage,  List<MessageBarEntity> messageBars)?  $default,) {final _that = this;
switch (_that) {
case _PincodeCheckResultEntity() when $default != null:
return $default(_that.isSuccessful,_that.popUpMessage,_that.messageBars);case _:
  return null;

}
}

}

/// @nodoc


class _PincodeCheckResultEntity implements PincodeCheckResultEntity {
  const _PincodeCheckResultEntity({this.isSuccessful = false, this.popUpMessage = '', final  List<MessageBarEntity> messageBars = const <MessageBarEntity>[]}): _messageBars = messageBars;
  

@override@JsonKey() final  bool isSuccessful;
@override@JsonKey() final  String popUpMessage;
 final  List<MessageBarEntity> _messageBars;
@override@JsonKey() List<MessageBarEntity> get messageBars {
  if (_messageBars is EqualUnmodifiableListView) return _messageBars;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messageBars);
}


/// Create a copy of PincodeCheckResultEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PincodeCheckResultEntityCopyWith<_PincodeCheckResultEntity> get copyWith => __$PincodeCheckResultEntityCopyWithImpl<_PincodeCheckResultEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PincodeCheckResultEntity&&(identical(other.isSuccessful, isSuccessful) || other.isSuccessful == isSuccessful)&&(identical(other.popUpMessage, popUpMessage) || other.popUpMessage == popUpMessage)&&const DeepCollectionEquality().equals(other._messageBars, _messageBars));
}


@override
int get hashCode => Object.hash(runtimeType,isSuccessful,popUpMessage,const DeepCollectionEquality().hash(_messageBars));

@override
String toString() {
  return 'PincodeCheckResultEntity(isSuccessful: $isSuccessful, popUpMessage: $popUpMessage, messageBars: $messageBars)';
}


}

/// @nodoc
abstract mixin class _$PincodeCheckResultEntityCopyWith<$Res> implements $PincodeCheckResultEntityCopyWith<$Res> {
  factory _$PincodeCheckResultEntityCopyWith(_PincodeCheckResultEntity value, $Res Function(_PincodeCheckResultEntity) _then) = __$PincodeCheckResultEntityCopyWithImpl;
@override @useResult
$Res call({
 bool isSuccessful, String popUpMessage, List<MessageBarEntity> messageBars
});




}
/// @nodoc
class __$PincodeCheckResultEntityCopyWithImpl<$Res>
    implements _$PincodeCheckResultEntityCopyWith<$Res> {
  __$PincodeCheckResultEntityCopyWithImpl(this._self, this._then);

  final _PincodeCheckResultEntity _self;
  final $Res Function(_PincodeCheckResultEntity) _then;

/// Create a copy of PincodeCheckResultEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isSuccessful = null,Object? popUpMessage = null,Object? messageBars = null,}) {
  return _then(_PincodeCheckResultEntity(
isSuccessful: null == isSuccessful ? _self.isSuccessful : isSuccessful // ignore: cast_nullable_to_non_nullable
as bool,popUpMessage: null == popUpMessage ? _self.popUpMessage : popUpMessage // ignore: cast_nullable_to_non_nullable
as String,messageBars: null == messageBars ? _self._messageBars : messageBars // ignore: cast_nullable_to_non_nullable
as List<MessageBarEntity>,
  ));
}


}

// dart format on
