// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plp_sorting_options_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlpSortingOptionsEntity {

 String get label; List<SortingOptionEntity> get options;
/// Create a copy of PlpSortingOptionsEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlpSortingOptionsEntityCopyWith<PlpSortingOptionsEntity> get copyWith => _$PlpSortingOptionsEntityCopyWithImpl<PlpSortingOptionsEntity>(this as PlpSortingOptionsEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlpSortingOptionsEntity&&(identical(other.label, label) || other.label == label)&&const DeepCollectionEquality().equals(other.options, options));
}


@override
int get hashCode => Object.hash(runtimeType,label,const DeepCollectionEquality().hash(options));

@override
String toString() {
  return 'PlpSortingOptionsEntity(label: $label, options: $options)';
}


}

/// @nodoc
abstract mixin class $PlpSortingOptionsEntityCopyWith<$Res>  {
  factory $PlpSortingOptionsEntityCopyWith(PlpSortingOptionsEntity value, $Res Function(PlpSortingOptionsEntity) _then) = _$PlpSortingOptionsEntityCopyWithImpl;
@useResult
$Res call({
 String label, List<SortingOptionEntity> options
});




}
/// @nodoc
class _$PlpSortingOptionsEntityCopyWithImpl<$Res>
    implements $PlpSortingOptionsEntityCopyWith<$Res> {
  _$PlpSortingOptionsEntityCopyWithImpl(this._self, this._then);

  final PlpSortingOptionsEntity _self;
  final $Res Function(PlpSortingOptionsEntity) _then;

/// Create a copy of PlpSortingOptionsEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? options = null,}) {
  return _then(_self.copyWith(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<SortingOptionEntity>,
  ));
}

}


/// Adds pattern-matching-related methods to [PlpSortingOptionsEntity].
extension PlpSortingOptionsEntityPatterns on PlpSortingOptionsEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlpSortingOptionsEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlpSortingOptionsEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlpSortingOptionsEntity value)  $default,){
final _that = this;
switch (_that) {
case _PlpSortingOptionsEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlpSortingOptionsEntity value)?  $default,){
final _that = this;
switch (_that) {
case _PlpSortingOptionsEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String label,  List<SortingOptionEntity> options)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlpSortingOptionsEntity() when $default != null:
return $default(_that.label,_that.options);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String label,  List<SortingOptionEntity> options)  $default,) {final _that = this;
switch (_that) {
case _PlpSortingOptionsEntity():
return $default(_that.label,_that.options);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String label,  List<SortingOptionEntity> options)?  $default,) {final _that = this;
switch (_that) {
case _PlpSortingOptionsEntity() when $default != null:
return $default(_that.label,_that.options);case _:
  return null;

}
}

}

/// @nodoc


class _PlpSortingOptionsEntity implements PlpSortingOptionsEntity {
  const _PlpSortingOptionsEntity({this.label = 'Sort By', final  List<SortingOptionEntity> options = const []}): _options = options;
  

@override@JsonKey() final  String label;
 final  List<SortingOptionEntity> _options;
@override@JsonKey() List<SortingOptionEntity> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}


/// Create a copy of PlpSortingOptionsEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlpSortingOptionsEntityCopyWith<_PlpSortingOptionsEntity> get copyWith => __$PlpSortingOptionsEntityCopyWithImpl<_PlpSortingOptionsEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlpSortingOptionsEntity&&(identical(other.label, label) || other.label == label)&&const DeepCollectionEquality().equals(other._options, _options));
}


@override
int get hashCode => Object.hash(runtimeType,label,const DeepCollectionEquality().hash(_options));

@override
String toString() {
  return 'PlpSortingOptionsEntity(label: $label, options: $options)';
}


}

/// @nodoc
abstract mixin class _$PlpSortingOptionsEntityCopyWith<$Res> implements $PlpSortingOptionsEntityCopyWith<$Res> {
  factory _$PlpSortingOptionsEntityCopyWith(_PlpSortingOptionsEntity value, $Res Function(_PlpSortingOptionsEntity) _then) = __$PlpSortingOptionsEntityCopyWithImpl;
@override @useResult
$Res call({
 String label, List<SortingOptionEntity> options
});




}
/// @nodoc
class __$PlpSortingOptionsEntityCopyWithImpl<$Res>
    implements _$PlpSortingOptionsEntityCopyWith<$Res> {
  __$PlpSortingOptionsEntityCopyWithImpl(this._self, this._then);

  final _PlpSortingOptionsEntity _self;
  final $Res Function(_PlpSortingOptionsEntity) _then;

/// Create a copy of PlpSortingOptionsEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? options = null,}) {
  return _then(_PlpSortingOptionsEntity(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<SortingOptionEntity>,
  ));
}


}

// dart format on
