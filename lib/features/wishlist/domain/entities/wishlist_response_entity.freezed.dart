// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wishlist_response_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WishlistResponseEntity {

 String? get action; String? get message; String? get wishlistItemId;
/// Create a copy of WishlistResponseEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WishlistResponseEntityCopyWith<WishlistResponseEntity> get copyWith => _$WishlistResponseEntityCopyWithImpl<WishlistResponseEntity>(this as WishlistResponseEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WishlistResponseEntity&&(identical(other.action, action) || other.action == action)&&(identical(other.message, message) || other.message == message)&&(identical(other.wishlistItemId, wishlistItemId) || other.wishlistItemId == wishlistItemId));
}


@override
int get hashCode => Object.hash(runtimeType,action,message,wishlistItemId);

@override
String toString() {
  return 'WishlistResponseEntity(action: $action, message: $message, wishlistItemId: $wishlistItemId)';
}


}

/// @nodoc
abstract mixin class $WishlistResponseEntityCopyWith<$Res>  {
  factory $WishlistResponseEntityCopyWith(WishlistResponseEntity value, $Res Function(WishlistResponseEntity) _then) = _$WishlistResponseEntityCopyWithImpl;
@useResult
$Res call({
 String? action, String? message, String? wishlistItemId
});




}
/// @nodoc
class _$WishlistResponseEntityCopyWithImpl<$Res>
    implements $WishlistResponseEntityCopyWith<$Res> {
  _$WishlistResponseEntityCopyWithImpl(this._self, this._then);

  final WishlistResponseEntity _self;
  final $Res Function(WishlistResponseEntity) _then;

/// Create a copy of WishlistResponseEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? action = freezed,Object? message = freezed,Object? wishlistItemId = freezed,}) {
  return _then(_self.copyWith(
action: freezed == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,wishlistItemId: freezed == wishlistItemId ? _self.wishlistItemId : wishlistItemId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WishlistResponseEntity].
extension WishlistResponseEntityPatterns on WishlistResponseEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WishlistResponseEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WishlistResponseEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WishlistResponseEntity value)  $default,){
final _that = this;
switch (_that) {
case _WishlistResponseEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WishlistResponseEntity value)?  $default,){
final _that = this;
switch (_that) {
case _WishlistResponseEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? action,  String? message,  String? wishlistItemId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WishlistResponseEntity() when $default != null:
return $default(_that.action,_that.message,_that.wishlistItemId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? action,  String? message,  String? wishlistItemId)  $default,) {final _that = this;
switch (_that) {
case _WishlistResponseEntity():
return $default(_that.action,_that.message,_that.wishlistItemId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? action,  String? message,  String? wishlistItemId)?  $default,) {final _that = this;
switch (_that) {
case _WishlistResponseEntity() when $default != null:
return $default(_that.action,_that.message,_that.wishlistItemId);case _:
  return null;

}
}

}

/// @nodoc


class _WishlistResponseEntity implements WishlistResponseEntity {
  const _WishlistResponseEntity({this.action, this.message, this.wishlistItemId});
  

@override final  String? action;
@override final  String? message;
@override final  String? wishlistItemId;

/// Create a copy of WishlistResponseEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WishlistResponseEntityCopyWith<_WishlistResponseEntity> get copyWith => __$WishlistResponseEntityCopyWithImpl<_WishlistResponseEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WishlistResponseEntity&&(identical(other.action, action) || other.action == action)&&(identical(other.message, message) || other.message == message)&&(identical(other.wishlistItemId, wishlistItemId) || other.wishlistItemId == wishlistItemId));
}


@override
int get hashCode => Object.hash(runtimeType,action,message,wishlistItemId);

@override
String toString() {
  return 'WishlistResponseEntity(action: $action, message: $message, wishlistItemId: $wishlistItemId)';
}


}

/// @nodoc
abstract mixin class _$WishlistResponseEntityCopyWith<$Res> implements $WishlistResponseEntityCopyWith<$Res> {
  factory _$WishlistResponseEntityCopyWith(_WishlistResponseEntity value, $Res Function(_WishlistResponseEntity) _then) = __$WishlistResponseEntityCopyWithImpl;
@override @useResult
$Res call({
 String? action, String? message, String? wishlistItemId
});




}
/// @nodoc
class __$WishlistResponseEntityCopyWithImpl<$Res>
    implements _$WishlistResponseEntityCopyWith<$Res> {
  __$WishlistResponseEntityCopyWithImpl(this._self, this._then);

  final _WishlistResponseEntity _self;
  final $Res Function(_WishlistResponseEntity) _then;

/// Create a copy of WishlistResponseEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? action = freezed,Object? message = freezed,Object? wishlistItemId = freezed,}) {
  return _then(_WishlistResponseEntity(
action: freezed == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,wishlistItemId: freezed == wishlistItemId ? _self.wishlistItemId : wishlistItemId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
