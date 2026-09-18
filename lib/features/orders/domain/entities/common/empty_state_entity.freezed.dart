// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'empty_state_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EmptyStateEntity {

 String? get title; BackendActionButtonEntity? get ctaAction;
/// Create a copy of EmptyStateEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmptyStateEntityCopyWith<EmptyStateEntity> get copyWith => _$EmptyStateEntityCopyWithImpl<EmptyStateEntity>(this as EmptyStateEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmptyStateEntity&&(identical(other.title, title) || other.title == title)&&(identical(other.ctaAction, ctaAction) || other.ctaAction == ctaAction));
}


@override
int get hashCode => Object.hash(runtimeType,title,ctaAction);

@override
String toString() {
  return 'EmptyStateEntity(title: $title, ctaAction: $ctaAction)';
}


}

/// @nodoc
abstract mixin class $EmptyStateEntityCopyWith<$Res>  {
  factory $EmptyStateEntityCopyWith(EmptyStateEntity value, $Res Function(EmptyStateEntity) _then) = _$EmptyStateEntityCopyWithImpl;
@useResult
$Res call({
 String? title, BackendActionButtonEntity? ctaAction
});




}
/// @nodoc
class _$EmptyStateEntityCopyWithImpl<$Res>
    implements $EmptyStateEntityCopyWith<$Res> {
  _$EmptyStateEntityCopyWithImpl(this._self, this._then);

  final EmptyStateEntity _self;
  final $Res Function(EmptyStateEntity) _then;

/// Create a copy of EmptyStateEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = freezed,Object? ctaAction = freezed,}) {
  return _then(_self.copyWith(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,ctaAction: freezed == ctaAction ? _self.ctaAction : ctaAction // ignore: cast_nullable_to_non_nullable
as BackendActionButtonEntity?,
  ));
}

}


/// Adds pattern-matching-related methods to [EmptyStateEntity].
extension EmptyStateEntityPatterns on EmptyStateEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EmptyStateEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EmptyStateEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EmptyStateEntity value)  $default,){
final _that = this;
switch (_that) {
case _EmptyStateEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EmptyStateEntity value)?  $default,){
final _that = this;
switch (_that) {
case _EmptyStateEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? title,  BackendActionButtonEntity? ctaAction)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EmptyStateEntity() when $default != null:
return $default(_that.title,_that.ctaAction);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? title,  BackendActionButtonEntity? ctaAction)  $default,) {final _that = this;
switch (_that) {
case _EmptyStateEntity():
return $default(_that.title,_that.ctaAction);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? title,  BackendActionButtonEntity? ctaAction)?  $default,) {final _that = this;
switch (_that) {
case _EmptyStateEntity() when $default != null:
return $default(_that.title,_that.ctaAction);case _:
  return null;

}
}

}

/// @nodoc


class _EmptyStateEntity implements EmptyStateEntity {
  const _EmptyStateEntity({this.title, this.ctaAction});
  

@override final  String? title;
@override final  BackendActionButtonEntity? ctaAction;

/// Create a copy of EmptyStateEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmptyStateEntityCopyWith<_EmptyStateEntity> get copyWith => __$EmptyStateEntityCopyWithImpl<_EmptyStateEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmptyStateEntity&&(identical(other.title, title) || other.title == title)&&(identical(other.ctaAction, ctaAction) || other.ctaAction == ctaAction));
}


@override
int get hashCode => Object.hash(runtimeType,title,ctaAction);

@override
String toString() {
  return 'EmptyStateEntity(title: $title, ctaAction: $ctaAction)';
}


}

/// @nodoc
abstract mixin class _$EmptyStateEntityCopyWith<$Res> implements $EmptyStateEntityCopyWith<$Res> {
  factory _$EmptyStateEntityCopyWith(_EmptyStateEntity value, $Res Function(_EmptyStateEntity) _then) = __$EmptyStateEntityCopyWithImpl;
@override @useResult
$Res call({
 String? title, BackendActionButtonEntity? ctaAction
});




}
/// @nodoc
class __$EmptyStateEntityCopyWithImpl<$Res>
    implements _$EmptyStateEntityCopyWith<$Res> {
  __$EmptyStateEntityCopyWithImpl(this._self, this._then);

  final _EmptyStateEntity _self;
  final $Res Function(_EmptyStateEntity) _then;

/// Create a copy of EmptyStateEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = freezed,Object? ctaAction = freezed,}) {
  return _then(_EmptyStateEntity(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,ctaAction: freezed == ctaAction ? _self.ctaAction : ctaAction // ignore: cast_nullable_to_non_nullable
as BackendActionButtonEntity?,
  ));
}


}

// dart format on
