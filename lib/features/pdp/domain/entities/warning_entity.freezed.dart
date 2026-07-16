// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'warning_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WarningEntity {

 String? get text; String? get textColor;
/// Create a copy of WarningEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WarningEntityCopyWith<WarningEntity> get copyWith => _$WarningEntityCopyWithImpl<WarningEntity>(this as WarningEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WarningEntity&&(identical(other.text, text) || other.text == text)&&(identical(other.textColor, textColor) || other.textColor == textColor));
}


@override
int get hashCode => Object.hash(runtimeType,text,textColor);

@override
String toString() {
  return 'WarningEntity(text: $text, textColor: $textColor)';
}


}

/// @nodoc
abstract mixin class $WarningEntityCopyWith<$Res>  {
  factory $WarningEntityCopyWith(WarningEntity value, $Res Function(WarningEntity) _then) = _$WarningEntityCopyWithImpl;
@useResult
$Res call({
 String? text, String? textColor
});




}
/// @nodoc
class _$WarningEntityCopyWithImpl<$Res>
    implements $WarningEntityCopyWith<$Res> {
  _$WarningEntityCopyWithImpl(this._self, this._then);

  final WarningEntity _self;
  final $Res Function(WarningEntity) _then;

/// Create a copy of WarningEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = freezed,Object? textColor = freezed,}) {
  return _then(_self.copyWith(
text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,textColor: freezed == textColor ? _self.textColor : textColor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WarningEntity].
extension WarningEntityPatterns on WarningEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WarningEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WarningEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WarningEntity value)  $default,){
final _that = this;
switch (_that) {
case _WarningEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WarningEntity value)?  $default,){
final _that = this;
switch (_that) {
case _WarningEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? text,  String? textColor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WarningEntity() when $default != null:
return $default(_that.text,_that.textColor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? text,  String? textColor)  $default,) {final _that = this;
switch (_that) {
case _WarningEntity():
return $default(_that.text,_that.textColor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? text,  String? textColor)?  $default,) {final _that = this;
switch (_that) {
case _WarningEntity() when $default != null:
return $default(_that.text,_that.textColor);case _:
  return null;

}
}

}

/// @nodoc


class _WarningEntity implements WarningEntity {
  const _WarningEntity({this.text, this.textColor});
  

@override final  String? text;
@override final  String? textColor;

/// Create a copy of WarningEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WarningEntityCopyWith<_WarningEntity> get copyWith => __$WarningEntityCopyWithImpl<_WarningEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WarningEntity&&(identical(other.text, text) || other.text == text)&&(identical(other.textColor, textColor) || other.textColor == textColor));
}


@override
int get hashCode => Object.hash(runtimeType,text,textColor);

@override
String toString() {
  return 'WarningEntity(text: $text, textColor: $textColor)';
}


}

/// @nodoc
abstract mixin class _$WarningEntityCopyWith<$Res> implements $WarningEntityCopyWith<$Res> {
  factory _$WarningEntityCopyWith(_WarningEntity value, $Res Function(_WarningEntity) _then) = __$WarningEntityCopyWithImpl;
@override @useResult
$Res call({
 String? text, String? textColor
});




}
/// @nodoc
class __$WarningEntityCopyWithImpl<$Res>
    implements _$WarningEntityCopyWith<$Res> {
  __$WarningEntityCopyWithImpl(this._self, this._then);

  final _WarningEntity _self;
  final $Res Function(_WarningEntity) _then;

/// Create a copy of WarningEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = freezed,Object? textColor = freezed,}) {
  return _then(_WarningEntity(
text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,textColor: freezed == textColor ? _self.textColor : textColor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
