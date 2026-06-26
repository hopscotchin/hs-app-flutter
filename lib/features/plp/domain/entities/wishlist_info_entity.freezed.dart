// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wishlist_info_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WishlistInfoEntity {

 int? get id; bool get isWishlisted; bool get canWishlist;
/// Create a copy of WishlistInfoEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WishlistInfoEntityCopyWith<WishlistInfoEntity> get copyWith => _$WishlistInfoEntityCopyWithImpl<WishlistInfoEntity>(this as WishlistInfoEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WishlistInfoEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.isWishlisted, isWishlisted) || other.isWishlisted == isWishlisted)&&(identical(other.canWishlist, canWishlist) || other.canWishlist == canWishlist));
}


@override
int get hashCode => Object.hash(runtimeType,id,isWishlisted,canWishlist);

@override
String toString() {
  return 'WishlistInfoEntity(id: $id, isWishlisted: $isWishlisted, canWishlist: $canWishlist)';
}


}

/// @nodoc
abstract mixin class $WishlistInfoEntityCopyWith<$Res>  {
  factory $WishlistInfoEntityCopyWith(WishlistInfoEntity value, $Res Function(WishlistInfoEntity) _then) = _$WishlistInfoEntityCopyWithImpl;
@useResult
$Res call({
 int? id, bool isWishlisted, bool canWishlist
});




}
/// @nodoc
class _$WishlistInfoEntityCopyWithImpl<$Res>
    implements $WishlistInfoEntityCopyWith<$Res> {
  _$WishlistInfoEntityCopyWithImpl(this._self, this._then);

  final WishlistInfoEntity _self;
  final $Res Function(WishlistInfoEntity) _then;

/// Create a copy of WishlistInfoEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? isWishlisted = null,Object? canWishlist = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,isWishlisted: null == isWishlisted ? _self.isWishlisted : isWishlisted // ignore: cast_nullable_to_non_nullable
as bool,canWishlist: null == canWishlist ? _self.canWishlist : canWishlist // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [WishlistInfoEntity].
extension WishlistInfoEntityPatterns on WishlistInfoEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WishlistInfoEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WishlistInfoEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WishlistInfoEntity value)  $default,){
final _that = this;
switch (_that) {
case _WishlistInfoEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WishlistInfoEntity value)?  $default,){
final _that = this;
switch (_that) {
case _WishlistInfoEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  bool isWishlisted,  bool canWishlist)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WishlistInfoEntity() when $default != null:
return $default(_that.id,_that.isWishlisted,_that.canWishlist);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  bool isWishlisted,  bool canWishlist)  $default,) {final _that = this;
switch (_that) {
case _WishlistInfoEntity():
return $default(_that.id,_that.isWishlisted,_that.canWishlist);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  bool isWishlisted,  bool canWishlist)?  $default,) {final _that = this;
switch (_that) {
case _WishlistInfoEntity() when $default != null:
return $default(_that.id,_that.isWishlisted,_that.canWishlist);case _:
  return null;

}
}

}

/// @nodoc


class _WishlistInfoEntity implements WishlistInfoEntity {
  const _WishlistInfoEntity({this.id, this.isWishlisted = false, this.canWishlist = false});
  

@override final  int? id;
@override@JsonKey() final  bool isWishlisted;
@override@JsonKey() final  bool canWishlist;

/// Create a copy of WishlistInfoEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WishlistInfoEntityCopyWith<_WishlistInfoEntity> get copyWith => __$WishlistInfoEntityCopyWithImpl<_WishlistInfoEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WishlistInfoEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.isWishlisted, isWishlisted) || other.isWishlisted == isWishlisted)&&(identical(other.canWishlist, canWishlist) || other.canWishlist == canWishlist));
}


@override
int get hashCode => Object.hash(runtimeType,id,isWishlisted,canWishlist);

@override
String toString() {
  return 'WishlistInfoEntity(id: $id, isWishlisted: $isWishlisted, canWishlist: $canWishlist)';
}


}

/// @nodoc
abstract mixin class _$WishlistInfoEntityCopyWith<$Res> implements $WishlistInfoEntityCopyWith<$Res> {
  factory _$WishlistInfoEntityCopyWith(_WishlistInfoEntity value, $Res Function(_WishlistInfoEntity) _then) = __$WishlistInfoEntityCopyWithImpl;
@override @useResult
$Res call({
 int? id, bool isWishlisted, bool canWishlist
});




}
/// @nodoc
class __$WishlistInfoEntityCopyWithImpl<$Res>
    implements _$WishlistInfoEntityCopyWith<$Res> {
  __$WishlistInfoEntityCopyWithImpl(this._self, this._then);

  final _WishlistInfoEntity _self;
  final $Res Function(_WishlistInfoEntity) _then;

/// Create a copy of WishlistInfoEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? isWishlisted = null,Object? canWishlist = null,}) {
  return _then(_WishlistInfoEntity(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,isWishlisted: null == isWishlisted ? _self.isWishlisted : isWishlisted // ignore: cast_nullable_to_non_nullable
as bool,canWishlist: null == canWishlist ? _self.canWishlist : canWishlist // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
