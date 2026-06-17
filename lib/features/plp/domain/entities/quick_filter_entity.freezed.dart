// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quick_filter_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QuickFilterEntity {

 String? get filterKey; String? get label; bool get isApplied; Map<String, dynamic> get trackingMeta;
/// Create a copy of QuickFilterEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuickFilterEntityCopyWith<QuickFilterEntity> get copyWith => _$QuickFilterEntityCopyWithImpl<QuickFilterEntity>(this as QuickFilterEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuickFilterEntity&&(identical(other.filterKey, filterKey) || other.filterKey == filterKey)&&(identical(other.label, label) || other.label == label)&&(identical(other.isApplied, isApplied) || other.isApplied == isApplied)&&const DeepCollectionEquality().equals(other.trackingMeta, trackingMeta));
}


@override
int get hashCode => Object.hash(runtimeType,filterKey,label,isApplied,const DeepCollectionEquality().hash(trackingMeta));

@override
String toString() {
  return 'QuickFilterEntity(filterKey: $filterKey, label: $label, isApplied: $isApplied, trackingMeta: $trackingMeta)';
}


}

/// @nodoc
abstract mixin class $QuickFilterEntityCopyWith<$Res>  {
  factory $QuickFilterEntityCopyWith(QuickFilterEntity value, $Res Function(QuickFilterEntity) _then) = _$QuickFilterEntityCopyWithImpl;
@useResult
$Res call({
 String? filterKey, String? label, bool isApplied, Map<String, dynamic> trackingMeta
});




}
/// @nodoc
class _$QuickFilterEntityCopyWithImpl<$Res>
    implements $QuickFilterEntityCopyWith<$Res> {
  _$QuickFilterEntityCopyWithImpl(this._self, this._then);

  final QuickFilterEntity _self;
  final $Res Function(QuickFilterEntity) _then;

/// Create a copy of QuickFilterEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? filterKey = freezed,Object? label = freezed,Object? isApplied = null,Object? trackingMeta = null,}) {
  return _then(_self.copyWith(
filterKey: freezed == filterKey ? _self.filterKey : filterKey // ignore: cast_nullable_to_non_nullable
as String?,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,isApplied: null == isApplied ? _self.isApplied : isApplied // ignore: cast_nullable_to_non_nullable
as bool,trackingMeta: null == trackingMeta ? _self.trackingMeta : trackingMeta // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [QuickFilterEntity].
extension QuickFilterEntityPatterns on QuickFilterEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuickFilterEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuickFilterEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuickFilterEntity value)  $default,){
final _that = this;
switch (_that) {
case _QuickFilterEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuickFilterEntity value)?  $default,){
final _that = this;
switch (_that) {
case _QuickFilterEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? filterKey,  String? label,  bool isApplied,  Map<String, dynamic> trackingMeta)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuickFilterEntity() when $default != null:
return $default(_that.filterKey,_that.label,_that.isApplied,_that.trackingMeta);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? filterKey,  String? label,  bool isApplied,  Map<String, dynamic> trackingMeta)  $default,) {final _that = this;
switch (_that) {
case _QuickFilterEntity():
return $default(_that.filterKey,_that.label,_that.isApplied,_that.trackingMeta);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? filterKey,  String? label,  bool isApplied,  Map<String, dynamic> trackingMeta)?  $default,) {final _that = this;
switch (_that) {
case _QuickFilterEntity() when $default != null:
return $default(_that.filterKey,_that.label,_that.isApplied,_that.trackingMeta);case _:
  return null;

}
}

}

/// @nodoc


class _QuickFilterEntity implements QuickFilterEntity {
  const _QuickFilterEntity({this.filterKey, this.label, this.isApplied = false, final  Map<String, dynamic> trackingMeta = const <String, dynamic>{}}): _trackingMeta = trackingMeta;
  

@override final  String? filterKey;
@override final  String? label;
@override@JsonKey() final  bool isApplied;
 final  Map<String, dynamic> _trackingMeta;
@override@JsonKey() Map<String, dynamic> get trackingMeta {
  if (_trackingMeta is EqualUnmodifiableMapView) return _trackingMeta;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_trackingMeta);
}


/// Create a copy of QuickFilterEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuickFilterEntityCopyWith<_QuickFilterEntity> get copyWith => __$QuickFilterEntityCopyWithImpl<_QuickFilterEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuickFilterEntity&&(identical(other.filterKey, filterKey) || other.filterKey == filterKey)&&(identical(other.label, label) || other.label == label)&&(identical(other.isApplied, isApplied) || other.isApplied == isApplied)&&const DeepCollectionEquality().equals(other._trackingMeta, _trackingMeta));
}


@override
int get hashCode => Object.hash(runtimeType,filterKey,label,isApplied,const DeepCollectionEquality().hash(_trackingMeta));

@override
String toString() {
  return 'QuickFilterEntity(filterKey: $filterKey, label: $label, isApplied: $isApplied, trackingMeta: $trackingMeta)';
}


}

/// @nodoc
abstract mixin class _$QuickFilterEntityCopyWith<$Res> implements $QuickFilterEntityCopyWith<$Res> {
  factory _$QuickFilterEntityCopyWith(_QuickFilterEntity value, $Res Function(_QuickFilterEntity) _then) = __$QuickFilterEntityCopyWithImpl;
@override @useResult
$Res call({
 String? filterKey, String? label, bool isApplied, Map<String, dynamic> trackingMeta
});




}
/// @nodoc
class __$QuickFilterEntityCopyWithImpl<$Res>
    implements _$QuickFilterEntityCopyWith<$Res> {
  __$QuickFilterEntityCopyWithImpl(this._self, this._then);

  final _QuickFilterEntity _self;
  final $Res Function(_QuickFilterEntity) _then;

/// Create a copy of QuickFilterEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? filterKey = freezed,Object? label = freezed,Object? isApplied = null,Object? trackingMeta = null,}) {
  return _then(_QuickFilterEntity(
filterKey: freezed == filterKey ? _self.filterKey : filterKey // ignore: cast_nullable_to_non_nullable
as String?,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,isApplied: null == isApplied ? _self.isApplied : isApplied // ignore: cast_nullable_to_non_nullable
as bool,trackingMeta: null == trackingMeta ? _self._trackingMeta : trackingMeta // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}

// dart format on
