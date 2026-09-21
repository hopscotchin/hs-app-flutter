// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'support_section_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SupportSectionEntity {

 String? get title; List<BackendActionButtonEntity> get ctaActions;
/// Create a copy of SupportSectionEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SupportSectionEntityCopyWith<SupportSectionEntity> get copyWith => _$SupportSectionEntityCopyWithImpl<SupportSectionEntity>(this as SupportSectionEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SupportSectionEntity&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other.ctaActions, ctaActions));
}


@override
int get hashCode => Object.hash(runtimeType,title,const DeepCollectionEquality().hash(ctaActions));

@override
String toString() {
  return 'SupportSectionEntity(title: $title, ctaActions: $ctaActions)';
}


}

/// @nodoc
abstract mixin class $SupportSectionEntityCopyWith<$Res>  {
  factory $SupportSectionEntityCopyWith(SupportSectionEntity value, $Res Function(SupportSectionEntity) _then) = _$SupportSectionEntityCopyWithImpl;
@useResult
$Res call({
 String? title, List<BackendActionButtonEntity> ctaActions
});




}
/// @nodoc
class _$SupportSectionEntityCopyWithImpl<$Res>
    implements $SupportSectionEntityCopyWith<$Res> {
  _$SupportSectionEntityCopyWithImpl(this._self, this._then);

  final SupportSectionEntity _self;
  final $Res Function(SupportSectionEntity) _then;

/// Create a copy of SupportSectionEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = freezed,Object? ctaActions = null,}) {
  return _then(_self.copyWith(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,ctaActions: null == ctaActions ? _self.ctaActions : ctaActions // ignore: cast_nullable_to_non_nullable
as List<BackendActionButtonEntity>,
  ));
}

}


/// Adds pattern-matching-related methods to [SupportSectionEntity].
extension SupportSectionEntityPatterns on SupportSectionEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SupportSectionEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SupportSectionEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SupportSectionEntity value)  $default,){
final _that = this;
switch (_that) {
case _SupportSectionEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SupportSectionEntity value)?  $default,){
final _that = this;
switch (_that) {
case _SupportSectionEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? title,  List<BackendActionButtonEntity> ctaActions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SupportSectionEntity() when $default != null:
return $default(_that.title,_that.ctaActions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? title,  List<BackendActionButtonEntity> ctaActions)  $default,) {final _that = this;
switch (_that) {
case _SupportSectionEntity():
return $default(_that.title,_that.ctaActions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? title,  List<BackendActionButtonEntity> ctaActions)?  $default,) {final _that = this;
switch (_that) {
case _SupportSectionEntity() when $default != null:
return $default(_that.title,_that.ctaActions);case _:
  return null;

}
}

}

/// @nodoc


class _SupportSectionEntity implements SupportSectionEntity {
  const _SupportSectionEntity({this.title, final  List<BackendActionButtonEntity> ctaActions = const <BackendActionButtonEntity>[]}): _ctaActions = ctaActions;
  

@override final  String? title;
 final  List<BackendActionButtonEntity> _ctaActions;
@override@JsonKey() List<BackendActionButtonEntity> get ctaActions {
  if (_ctaActions is EqualUnmodifiableListView) return _ctaActions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ctaActions);
}


/// Create a copy of SupportSectionEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SupportSectionEntityCopyWith<_SupportSectionEntity> get copyWith => __$SupportSectionEntityCopyWithImpl<_SupportSectionEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SupportSectionEntity&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other._ctaActions, _ctaActions));
}


@override
int get hashCode => Object.hash(runtimeType,title,const DeepCollectionEquality().hash(_ctaActions));

@override
String toString() {
  return 'SupportSectionEntity(title: $title, ctaActions: $ctaActions)';
}


}

/// @nodoc
abstract mixin class _$SupportSectionEntityCopyWith<$Res> implements $SupportSectionEntityCopyWith<$Res> {
  factory _$SupportSectionEntityCopyWith(_SupportSectionEntity value, $Res Function(_SupportSectionEntity) _then) = __$SupportSectionEntityCopyWithImpl;
@override @useResult
$Res call({
 String? title, List<BackendActionButtonEntity> ctaActions
});




}
/// @nodoc
class __$SupportSectionEntityCopyWithImpl<$Res>
    implements _$SupportSectionEntityCopyWith<$Res> {
  __$SupportSectionEntityCopyWithImpl(this._self, this._then);

  final _SupportSectionEntity _self;
  final $Res Function(_SupportSectionEntity) _then;

/// Create a copy of SupportSectionEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = freezed,Object? ctaActions = null,}) {
  return _then(_SupportSectionEntity(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,ctaActions: null == ctaActions ? _self._ctaActions : ctaActions // ignore: cast_nullable_to_non_nullable
as List<BackendActionButtonEntity>,
  ));
}


}

// dart format on
