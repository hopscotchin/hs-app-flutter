// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recommendations_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RecommendationsEntity {

 List<ListingProductEntity> get records; PageMetaEntity? get pageMeta;
/// Create a copy of RecommendationsEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecommendationsEntityCopyWith<RecommendationsEntity> get copyWith => _$RecommendationsEntityCopyWithImpl<RecommendationsEntity>(this as RecommendationsEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecommendationsEntity&&const DeepCollectionEquality().equals(other.records, records)&&(identical(other.pageMeta, pageMeta) || other.pageMeta == pageMeta));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(records),pageMeta);

@override
String toString() {
  return 'RecommendationsEntity(records: $records, pageMeta: $pageMeta)';
}


}

/// @nodoc
abstract mixin class $RecommendationsEntityCopyWith<$Res>  {
  factory $RecommendationsEntityCopyWith(RecommendationsEntity value, $Res Function(RecommendationsEntity) _then) = _$RecommendationsEntityCopyWithImpl;
@useResult
$Res call({
 List<ListingProductEntity> records, PageMetaEntity? pageMeta
});


$PageMetaEntityCopyWith<$Res>? get pageMeta;

}
/// @nodoc
class _$RecommendationsEntityCopyWithImpl<$Res>
    implements $RecommendationsEntityCopyWith<$Res> {
  _$RecommendationsEntityCopyWithImpl(this._self, this._then);

  final RecommendationsEntity _self;
  final $Res Function(RecommendationsEntity) _then;

/// Create a copy of RecommendationsEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? records = null,Object? pageMeta = freezed,}) {
  return _then(_self.copyWith(
records: null == records ? _self.records : records // ignore: cast_nullable_to_non_nullable
as List<ListingProductEntity>,pageMeta: freezed == pageMeta ? _self.pageMeta : pageMeta // ignore: cast_nullable_to_non_nullable
as PageMetaEntity?,
  ));
}
/// Create a copy of RecommendationsEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PageMetaEntityCopyWith<$Res>? get pageMeta {
    if (_self.pageMeta == null) {
    return null;
  }

  return $PageMetaEntityCopyWith<$Res>(_self.pageMeta!, (value) {
    return _then(_self.copyWith(pageMeta: value));
  });
}
}


/// Adds pattern-matching-related methods to [RecommendationsEntity].
extension RecommendationsEntityPatterns on RecommendationsEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecommendationsEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecommendationsEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecommendationsEntity value)  $default,){
final _that = this;
switch (_that) {
case _RecommendationsEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecommendationsEntity value)?  $default,){
final _that = this;
switch (_that) {
case _RecommendationsEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ListingProductEntity> records,  PageMetaEntity? pageMeta)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecommendationsEntity() when $default != null:
return $default(_that.records,_that.pageMeta);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ListingProductEntity> records,  PageMetaEntity? pageMeta)  $default,) {final _that = this;
switch (_that) {
case _RecommendationsEntity():
return $default(_that.records,_that.pageMeta);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ListingProductEntity> records,  PageMetaEntity? pageMeta)?  $default,) {final _that = this;
switch (_that) {
case _RecommendationsEntity() when $default != null:
return $default(_that.records,_that.pageMeta);case _:
  return null;

}
}

}

/// @nodoc


class _RecommendationsEntity implements RecommendationsEntity {
  const _RecommendationsEntity({final  List<ListingProductEntity> records = const [], this.pageMeta}): _records = records;
  

 final  List<ListingProductEntity> _records;
@override@JsonKey() List<ListingProductEntity> get records {
  if (_records is EqualUnmodifiableListView) return _records;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_records);
}

@override final  PageMetaEntity? pageMeta;

/// Create a copy of RecommendationsEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecommendationsEntityCopyWith<_RecommendationsEntity> get copyWith => __$RecommendationsEntityCopyWithImpl<_RecommendationsEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecommendationsEntity&&const DeepCollectionEquality().equals(other._records, _records)&&(identical(other.pageMeta, pageMeta) || other.pageMeta == pageMeta));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_records),pageMeta);

@override
String toString() {
  return 'RecommendationsEntity(records: $records, pageMeta: $pageMeta)';
}


}

/// @nodoc
abstract mixin class _$RecommendationsEntityCopyWith<$Res> implements $RecommendationsEntityCopyWith<$Res> {
  factory _$RecommendationsEntityCopyWith(_RecommendationsEntity value, $Res Function(_RecommendationsEntity) _then) = __$RecommendationsEntityCopyWithImpl;
@override @useResult
$Res call({
 List<ListingProductEntity> records, PageMetaEntity? pageMeta
});


@override $PageMetaEntityCopyWith<$Res>? get pageMeta;

}
/// @nodoc
class __$RecommendationsEntityCopyWithImpl<$Res>
    implements _$RecommendationsEntityCopyWith<$Res> {
  __$RecommendationsEntityCopyWithImpl(this._self, this._then);

  final _RecommendationsEntity _self;
  final $Res Function(_RecommendationsEntity) _then;

/// Create a copy of RecommendationsEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? records = null,Object? pageMeta = freezed,}) {
  return _then(_RecommendationsEntity(
records: null == records ? _self._records : records // ignore: cast_nullable_to_non_nullable
as List<ListingProductEntity>,pageMeta: freezed == pageMeta ? _self.pageMeta : pageMeta // ignore: cast_nullable_to_non_nullable
as PageMetaEntity?,
  ));
}

/// Create a copy of RecommendationsEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PageMetaEntityCopyWith<$Res>? get pageMeta {
    if (_self.pageMeta == null) {
    return null;
  }

  return $PageMetaEntityCopyWith<$Res>(_self.pageMeta!, (value) {
    return _then(_self.copyWith(pageMeta: value));
  });
}
}

// dart format on
