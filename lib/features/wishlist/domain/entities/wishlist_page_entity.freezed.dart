// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wishlist_page_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WishlistPageEntity {

 int get totalRecords; bool get hasNextPage; List<WishlistProductEntity> get items;/// Opaque analytics blob from the response — spread onto `wishlist_viewed`
/// verbatim. The backend owns every key; the client never reads one.
 Map<String, dynamic> get trackingMeta;
/// Create a copy of WishlistPageEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WishlistPageEntityCopyWith<WishlistPageEntity> get copyWith => _$WishlistPageEntityCopyWithImpl<WishlistPageEntity>(this as WishlistPageEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WishlistPageEntity&&(identical(other.totalRecords, totalRecords) || other.totalRecords == totalRecords)&&(identical(other.hasNextPage, hasNextPage) || other.hasNextPage == hasNextPage)&&const DeepCollectionEquality().equals(other.items, items)&&const DeepCollectionEquality().equals(other.trackingMeta, trackingMeta));
}


@override
int get hashCode => Object.hash(runtimeType,totalRecords,hasNextPage,const DeepCollectionEquality().hash(items),const DeepCollectionEquality().hash(trackingMeta));

@override
String toString() {
  return 'WishlistPageEntity(totalRecords: $totalRecords, hasNextPage: $hasNextPage, items: $items, trackingMeta: $trackingMeta)';
}


}

/// @nodoc
abstract mixin class $WishlistPageEntityCopyWith<$Res>  {
  factory $WishlistPageEntityCopyWith(WishlistPageEntity value, $Res Function(WishlistPageEntity) _then) = _$WishlistPageEntityCopyWithImpl;
@useResult
$Res call({
 int totalRecords, bool hasNextPage, List<WishlistProductEntity> items, Map<String, dynamic> trackingMeta
});




}
/// @nodoc
class _$WishlistPageEntityCopyWithImpl<$Res>
    implements $WishlistPageEntityCopyWith<$Res> {
  _$WishlistPageEntityCopyWithImpl(this._self, this._then);

  final WishlistPageEntity _self;
  final $Res Function(WishlistPageEntity) _then;

/// Create a copy of WishlistPageEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalRecords = null,Object? hasNextPage = null,Object? items = null,Object? trackingMeta = null,}) {
  return _then(_self.copyWith(
totalRecords: null == totalRecords ? _self.totalRecords : totalRecords // ignore: cast_nullable_to_non_nullable
as int,hasNextPage: null == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<WishlistProductEntity>,trackingMeta: null == trackingMeta ? _self.trackingMeta : trackingMeta // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [WishlistPageEntity].
extension WishlistPageEntityPatterns on WishlistPageEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WishlistPageEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WishlistPageEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WishlistPageEntity value)  $default,){
final _that = this;
switch (_that) {
case _WishlistPageEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WishlistPageEntity value)?  $default,){
final _that = this;
switch (_that) {
case _WishlistPageEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalRecords,  bool hasNextPage,  List<WishlistProductEntity> items,  Map<String, dynamic> trackingMeta)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WishlistPageEntity() when $default != null:
return $default(_that.totalRecords,_that.hasNextPage,_that.items,_that.trackingMeta);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalRecords,  bool hasNextPage,  List<WishlistProductEntity> items,  Map<String, dynamic> trackingMeta)  $default,) {final _that = this;
switch (_that) {
case _WishlistPageEntity():
return $default(_that.totalRecords,_that.hasNextPage,_that.items,_that.trackingMeta);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalRecords,  bool hasNextPage,  List<WishlistProductEntity> items,  Map<String, dynamic> trackingMeta)?  $default,) {final _that = this;
switch (_that) {
case _WishlistPageEntity() when $default != null:
return $default(_that.totalRecords,_that.hasNextPage,_that.items,_that.trackingMeta);case _:
  return null;

}
}

}

/// @nodoc


class _WishlistPageEntity extends WishlistPageEntity {
  const _WishlistPageEntity({this.totalRecords = 0, this.hasNextPage = false, final  List<WishlistProductEntity> items = const <WishlistProductEntity>[], final  Map<String, dynamic> trackingMeta = const <String, dynamic>{}}): _items = items,_trackingMeta = trackingMeta,super._();
  

@override@JsonKey() final  int totalRecords;
@override@JsonKey() final  bool hasNextPage;
 final  List<WishlistProductEntity> _items;
@override@JsonKey() List<WishlistProductEntity> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

/// Opaque analytics blob from the response — spread onto `wishlist_viewed`
/// verbatim. The backend owns every key; the client never reads one.
 final  Map<String, dynamic> _trackingMeta;
/// Opaque analytics blob from the response — spread onto `wishlist_viewed`
/// verbatim. The backend owns every key; the client never reads one.
@override@JsonKey() Map<String, dynamic> get trackingMeta {
  if (_trackingMeta is EqualUnmodifiableMapView) return _trackingMeta;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_trackingMeta);
}


/// Create a copy of WishlistPageEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WishlistPageEntityCopyWith<_WishlistPageEntity> get copyWith => __$WishlistPageEntityCopyWithImpl<_WishlistPageEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WishlistPageEntity&&(identical(other.totalRecords, totalRecords) || other.totalRecords == totalRecords)&&(identical(other.hasNextPage, hasNextPage) || other.hasNextPage == hasNextPage)&&const DeepCollectionEquality().equals(other._items, _items)&&const DeepCollectionEquality().equals(other._trackingMeta, _trackingMeta));
}


@override
int get hashCode => Object.hash(runtimeType,totalRecords,hasNextPage,const DeepCollectionEquality().hash(_items),const DeepCollectionEquality().hash(_trackingMeta));

@override
String toString() {
  return 'WishlistPageEntity(totalRecords: $totalRecords, hasNextPage: $hasNextPage, items: $items, trackingMeta: $trackingMeta)';
}


}

/// @nodoc
abstract mixin class _$WishlistPageEntityCopyWith<$Res> implements $WishlistPageEntityCopyWith<$Res> {
  factory _$WishlistPageEntityCopyWith(_WishlistPageEntity value, $Res Function(_WishlistPageEntity) _then) = __$WishlistPageEntityCopyWithImpl;
@override @useResult
$Res call({
 int totalRecords, bool hasNextPage, List<WishlistProductEntity> items, Map<String, dynamic> trackingMeta
});




}
/// @nodoc
class __$WishlistPageEntityCopyWithImpl<$Res>
    implements _$WishlistPageEntityCopyWith<$Res> {
  __$WishlistPageEntityCopyWithImpl(this._self, this._then);

  final _WishlistPageEntity _self;
  final $Res Function(_WishlistPageEntity) _then;

/// Create a copy of WishlistPageEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalRecords = null,Object? hasNextPage = null,Object? items = null,Object? trackingMeta = null,}) {
  return _then(_WishlistPageEntity(
totalRecords: null == totalRecords ? _self.totalRecords : totalRecords // ignore: cast_nullable_to_non_nullable
as int,hasNextPage: null == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<WishlistProductEntity>,trackingMeta: null == trackingMeta ? _self._trackingMeta : trackingMeta // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}

// dart format on
