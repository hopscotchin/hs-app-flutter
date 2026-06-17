// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tracking_meta_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TrackingMetaEntity {

 bool get clusteringExistsForListingPage; bool get excludePreorderFilterApplied; bool get hasXLTiles; int? get plpId;
/// Create a copy of TrackingMetaEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrackingMetaEntityCopyWith<TrackingMetaEntity> get copyWith => _$TrackingMetaEntityCopyWithImpl<TrackingMetaEntity>(this as TrackingMetaEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackingMetaEntity&&(identical(other.clusteringExistsForListingPage, clusteringExistsForListingPage) || other.clusteringExistsForListingPage == clusteringExistsForListingPage)&&(identical(other.excludePreorderFilterApplied, excludePreorderFilterApplied) || other.excludePreorderFilterApplied == excludePreorderFilterApplied)&&(identical(other.hasXLTiles, hasXLTiles) || other.hasXLTiles == hasXLTiles)&&(identical(other.plpId, plpId) || other.plpId == plpId));
}


@override
int get hashCode => Object.hash(runtimeType,clusteringExistsForListingPage,excludePreorderFilterApplied,hasXLTiles,plpId);

@override
String toString() {
  return 'TrackingMetaEntity(clusteringExistsForListingPage: $clusteringExistsForListingPage, excludePreorderFilterApplied: $excludePreorderFilterApplied, hasXLTiles: $hasXLTiles, plpId: $plpId)';
}


}

/// @nodoc
abstract mixin class $TrackingMetaEntityCopyWith<$Res>  {
  factory $TrackingMetaEntityCopyWith(TrackingMetaEntity value, $Res Function(TrackingMetaEntity) _then) = _$TrackingMetaEntityCopyWithImpl;
@useResult
$Res call({
 bool clusteringExistsForListingPage, bool excludePreorderFilterApplied, bool hasXLTiles, int? plpId
});




}
/// @nodoc
class _$TrackingMetaEntityCopyWithImpl<$Res>
    implements $TrackingMetaEntityCopyWith<$Res> {
  _$TrackingMetaEntityCopyWithImpl(this._self, this._then);

  final TrackingMetaEntity _self;
  final $Res Function(TrackingMetaEntity) _then;

/// Create a copy of TrackingMetaEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? clusteringExistsForListingPage = null,Object? excludePreorderFilterApplied = null,Object? hasXLTiles = null,Object? plpId = freezed,}) {
  return _then(_self.copyWith(
clusteringExistsForListingPage: null == clusteringExistsForListingPage ? _self.clusteringExistsForListingPage : clusteringExistsForListingPage // ignore: cast_nullable_to_non_nullable
as bool,excludePreorderFilterApplied: null == excludePreorderFilterApplied ? _self.excludePreorderFilterApplied : excludePreorderFilterApplied // ignore: cast_nullable_to_non_nullable
as bool,hasXLTiles: null == hasXLTiles ? _self.hasXLTiles : hasXLTiles // ignore: cast_nullable_to_non_nullable
as bool,plpId: freezed == plpId ? _self.plpId : plpId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [TrackingMetaEntity].
extension TrackingMetaEntityPatterns on TrackingMetaEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrackingMetaEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrackingMetaEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrackingMetaEntity value)  $default,){
final _that = this;
switch (_that) {
case _TrackingMetaEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrackingMetaEntity value)?  $default,){
final _that = this;
switch (_that) {
case _TrackingMetaEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool clusteringExistsForListingPage,  bool excludePreorderFilterApplied,  bool hasXLTiles,  int? plpId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrackingMetaEntity() when $default != null:
return $default(_that.clusteringExistsForListingPage,_that.excludePreorderFilterApplied,_that.hasXLTiles,_that.plpId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool clusteringExistsForListingPage,  bool excludePreorderFilterApplied,  bool hasXLTiles,  int? plpId)  $default,) {final _that = this;
switch (_that) {
case _TrackingMetaEntity():
return $default(_that.clusteringExistsForListingPage,_that.excludePreorderFilterApplied,_that.hasXLTiles,_that.plpId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool clusteringExistsForListingPage,  bool excludePreorderFilterApplied,  bool hasXLTiles,  int? plpId)?  $default,) {final _that = this;
switch (_that) {
case _TrackingMetaEntity() when $default != null:
return $default(_that.clusteringExistsForListingPage,_that.excludePreorderFilterApplied,_that.hasXLTiles,_that.plpId);case _:
  return null;

}
}

}

/// @nodoc


class _TrackingMetaEntity implements TrackingMetaEntity {
  const _TrackingMetaEntity({this.clusteringExistsForListingPage = false, this.excludePreorderFilterApplied = false, this.hasXLTiles = false, this.plpId});
  

@override@JsonKey() final  bool clusteringExistsForListingPage;
@override@JsonKey() final  bool excludePreorderFilterApplied;
@override@JsonKey() final  bool hasXLTiles;
@override final  int? plpId;

/// Create a copy of TrackingMetaEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrackingMetaEntityCopyWith<_TrackingMetaEntity> get copyWith => __$TrackingMetaEntityCopyWithImpl<_TrackingMetaEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrackingMetaEntity&&(identical(other.clusteringExistsForListingPage, clusteringExistsForListingPage) || other.clusteringExistsForListingPage == clusteringExistsForListingPage)&&(identical(other.excludePreorderFilterApplied, excludePreorderFilterApplied) || other.excludePreorderFilterApplied == excludePreorderFilterApplied)&&(identical(other.hasXLTiles, hasXLTiles) || other.hasXLTiles == hasXLTiles)&&(identical(other.plpId, plpId) || other.plpId == plpId));
}


@override
int get hashCode => Object.hash(runtimeType,clusteringExistsForListingPage,excludePreorderFilterApplied,hasXLTiles,plpId);

@override
String toString() {
  return 'TrackingMetaEntity(clusteringExistsForListingPage: $clusteringExistsForListingPage, excludePreorderFilterApplied: $excludePreorderFilterApplied, hasXLTiles: $hasXLTiles, plpId: $plpId)';
}


}

/// @nodoc
abstract mixin class _$TrackingMetaEntityCopyWith<$Res> implements $TrackingMetaEntityCopyWith<$Res> {
  factory _$TrackingMetaEntityCopyWith(_TrackingMetaEntity value, $Res Function(_TrackingMetaEntity) _then) = __$TrackingMetaEntityCopyWithImpl;
@override @useResult
$Res call({
 bool clusteringExistsForListingPage, bool excludePreorderFilterApplied, bool hasXLTiles, int? plpId
});




}
/// @nodoc
class __$TrackingMetaEntityCopyWithImpl<$Res>
    implements _$TrackingMetaEntityCopyWith<$Res> {
  __$TrackingMetaEntityCopyWithImpl(this._self, this._then);

  final _TrackingMetaEntity _self;
  final $Res Function(_TrackingMetaEntity) _then;

/// Create a copy of TrackingMetaEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? clusteringExistsForListingPage = null,Object? excludePreorderFilterApplied = null,Object? hasXLTiles = null,Object? plpId = freezed,}) {
  return _then(_TrackingMetaEntity(
clusteringExistsForListingPage: null == clusteringExistsForListingPage ? _self.clusteringExistsForListingPage : clusteringExistsForListingPage // ignore: cast_nullable_to_non_nullable
as bool,excludePreorderFilterApplied: null == excludePreorderFilterApplied ? _self.excludePreorderFilterApplied : excludePreorderFilterApplied // ignore: cast_nullable_to_non_nullable
as bool,hasXLTiles: null == hasXLTiles ? _self.hasXLTiles : hasXLTiles // ignore: cast_nullable_to_non_nullable
as bool,plpId: freezed == plpId ? _self.plpId : plpId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
