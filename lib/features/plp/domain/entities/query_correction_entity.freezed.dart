// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'query_correction_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QueryCorrectionEntity {

 String? get resultsOf; String? get searchFor; int get confidence;
/// Create a copy of QueryCorrectionEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QueryCorrectionEntityCopyWith<QueryCorrectionEntity> get copyWith => _$QueryCorrectionEntityCopyWithImpl<QueryCorrectionEntity>(this as QueryCorrectionEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QueryCorrectionEntity&&(identical(other.resultsOf, resultsOf) || other.resultsOf == resultsOf)&&(identical(other.searchFor, searchFor) || other.searchFor == searchFor)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}


@override
int get hashCode => Object.hash(runtimeType,resultsOf,searchFor,confidence);

@override
String toString() {
  return 'QueryCorrectionEntity(resultsOf: $resultsOf, searchFor: $searchFor, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class $QueryCorrectionEntityCopyWith<$Res>  {
  factory $QueryCorrectionEntityCopyWith(QueryCorrectionEntity value, $Res Function(QueryCorrectionEntity) _then) = _$QueryCorrectionEntityCopyWithImpl;
@useResult
$Res call({
 String? resultsOf, String? searchFor, int confidence
});




}
/// @nodoc
class _$QueryCorrectionEntityCopyWithImpl<$Res>
    implements $QueryCorrectionEntityCopyWith<$Res> {
  _$QueryCorrectionEntityCopyWithImpl(this._self, this._then);

  final QueryCorrectionEntity _self;
  final $Res Function(QueryCorrectionEntity) _then;

/// Create a copy of QueryCorrectionEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? resultsOf = freezed,Object? searchFor = freezed,Object? confidence = null,}) {
  return _then(_self.copyWith(
resultsOf: freezed == resultsOf ? _self.resultsOf : resultsOf // ignore: cast_nullable_to_non_nullable
as String?,searchFor: freezed == searchFor ? _self.searchFor : searchFor // ignore: cast_nullable_to_non_nullable
as String?,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [QueryCorrectionEntity].
extension QueryCorrectionEntityPatterns on QueryCorrectionEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QueryCorrectionEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QueryCorrectionEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QueryCorrectionEntity value)  $default,){
final _that = this;
switch (_that) {
case _QueryCorrectionEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QueryCorrectionEntity value)?  $default,){
final _that = this;
switch (_that) {
case _QueryCorrectionEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? resultsOf,  String? searchFor,  int confidence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QueryCorrectionEntity() when $default != null:
return $default(_that.resultsOf,_that.searchFor,_that.confidence);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? resultsOf,  String? searchFor,  int confidence)  $default,) {final _that = this;
switch (_that) {
case _QueryCorrectionEntity():
return $default(_that.resultsOf,_that.searchFor,_that.confidence);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? resultsOf,  String? searchFor,  int confidence)?  $default,) {final _that = this;
switch (_that) {
case _QueryCorrectionEntity() when $default != null:
return $default(_that.resultsOf,_that.searchFor,_that.confidence);case _:
  return null;

}
}

}

/// @nodoc


class _QueryCorrectionEntity implements QueryCorrectionEntity {
  const _QueryCorrectionEntity({this.resultsOf, this.searchFor, this.confidence = -2});
  

@override final  String? resultsOf;
@override final  String? searchFor;
@override@JsonKey() final  int confidence;

/// Create a copy of QueryCorrectionEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QueryCorrectionEntityCopyWith<_QueryCorrectionEntity> get copyWith => __$QueryCorrectionEntityCopyWithImpl<_QueryCorrectionEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QueryCorrectionEntity&&(identical(other.resultsOf, resultsOf) || other.resultsOf == resultsOf)&&(identical(other.searchFor, searchFor) || other.searchFor == searchFor)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}


@override
int get hashCode => Object.hash(runtimeType,resultsOf,searchFor,confidence);

@override
String toString() {
  return 'QueryCorrectionEntity(resultsOf: $resultsOf, searchFor: $searchFor, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class _$QueryCorrectionEntityCopyWith<$Res> implements $QueryCorrectionEntityCopyWith<$Res> {
  factory _$QueryCorrectionEntityCopyWith(_QueryCorrectionEntity value, $Res Function(_QueryCorrectionEntity) _then) = __$QueryCorrectionEntityCopyWithImpl;
@override @useResult
$Res call({
 String? resultsOf, String? searchFor, int confidence
});




}
/// @nodoc
class __$QueryCorrectionEntityCopyWithImpl<$Res>
    implements _$QueryCorrectionEntityCopyWith<$Res> {
  __$QueryCorrectionEntityCopyWithImpl(this._self, this._then);

  final _QueryCorrectionEntity _self;
  final $Res Function(_QueryCorrectionEntity) _then;

/// Create a copy of QueryCorrectionEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? resultsOf = freezed,Object? searchFor = freezed,Object? confidence = null,}) {
  return _then(_QueryCorrectionEntity(
resultsOf: freezed == resultsOf ? _self.resultsOf : resultsOf // ignore: cast_nullable_to_non_nullable
as String?,searchFor: freezed == searchFor ? _self.searchFor : searchFor // ignore: cast_nullable_to_non_nullable
as String?,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
