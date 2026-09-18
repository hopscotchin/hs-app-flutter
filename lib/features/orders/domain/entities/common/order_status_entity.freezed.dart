// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_status_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OrderStatusEntity {

 String? get icon; String? get title; String? get subtitle;/// An optional inline link after [title], rendered as "· Track".
///
/// Order details only. Replaces v8's `showTrackOrder`, an int 0|1 the
/// client turned into a hard-coded label and a hand-built destination —
/// both now arrive resolved.
///
/// Not the only thing that can sit at the end of that row: on a delivered
/// item the artboard puts the rating stars there instead, and those come
/// from the item's own `rating` block, not from here. The two are mutually
/// exclusive, and the page decides which to pass.
 BackendActionButtonEntity? get action;
/// Create a copy of OrderStatusEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderStatusEntityCopyWith<OrderStatusEntity> get copyWith => _$OrderStatusEntityCopyWithImpl<OrderStatusEntity>(this as OrderStatusEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderStatusEntity&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.action, action) || other.action == action));
}


@override
int get hashCode => Object.hash(runtimeType,icon,title,subtitle,action);

@override
String toString() {
  return 'OrderStatusEntity(icon: $icon, title: $title, subtitle: $subtitle, action: $action)';
}


}

/// @nodoc
abstract mixin class $OrderStatusEntityCopyWith<$Res>  {
  factory $OrderStatusEntityCopyWith(OrderStatusEntity value, $Res Function(OrderStatusEntity) _then) = _$OrderStatusEntityCopyWithImpl;
@useResult
$Res call({
 String? icon, String? title, String? subtitle, BackendActionButtonEntity? action
});




}
/// @nodoc
class _$OrderStatusEntityCopyWithImpl<$Res>
    implements $OrderStatusEntityCopyWith<$Res> {
  _$OrderStatusEntityCopyWithImpl(this._self, this._then);

  final OrderStatusEntity _self;
  final $Res Function(OrderStatusEntity) _then;

/// Create a copy of OrderStatusEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? icon = freezed,Object? title = freezed,Object? subtitle = freezed,Object? action = freezed,}) {
  return _then(_self.copyWith(
icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,action: freezed == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as BackendActionButtonEntity?,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderStatusEntity].
extension OrderStatusEntityPatterns on OrderStatusEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderStatusEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderStatusEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderStatusEntity value)  $default,){
final _that = this;
switch (_that) {
case _OrderStatusEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderStatusEntity value)?  $default,){
final _that = this;
switch (_that) {
case _OrderStatusEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? icon,  String? title,  String? subtitle,  BackendActionButtonEntity? action)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderStatusEntity() when $default != null:
return $default(_that.icon,_that.title,_that.subtitle,_that.action);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? icon,  String? title,  String? subtitle,  BackendActionButtonEntity? action)  $default,) {final _that = this;
switch (_that) {
case _OrderStatusEntity():
return $default(_that.icon,_that.title,_that.subtitle,_that.action);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? icon,  String? title,  String? subtitle,  BackendActionButtonEntity? action)?  $default,) {final _that = this;
switch (_that) {
case _OrderStatusEntity() when $default != null:
return $default(_that.icon,_that.title,_that.subtitle,_that.action);case _:
  return null;

}
}

}

/// @nodoc


class _OrderStatusEntity implements OrderStatusEntity {
  const _OrderStatusEntity({this.icon, this.title, this.subtitle, this.action});
  

@override final  String? icon;
@override final  String? title;
@override final  String? subtitle;
/// An optional inline link after [title], rendered as "· Track".
///
/// Order details only. Replaces v8's `showTrackOrder`, an int 0|1 the
/// client turned into a hard-coded label and a hand-built destination —
/// both now arrive resolved.
///
/// Not the only thing that can sit at the end of that row: on a delivered
/// item the artboard puts the rating stars there instead, and those come
/// from the item's own `rating` block, not from here. The two are mutually
/// exclusive, and the page decides which to pass.
@override final  BackendActionButtonEntity? action;

/// Create a copy of OrderStatusEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderStatusEntityCopyWith<_OrderStatusEntity> get copyWith => __$OrderStatusEntityCopyWithImpl<_OrderStatusEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderStatusEntity&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.action, action) || other.action == action));
}


@override
int get hashCode => Object.hash(runtimeType,icon,title,subtitle,action);

@override
String toString() {
  return 'OrderStatusEntity(icon: $icon, title: $title, subtitle: $subtitle, action: $action)';
}


}

/// @nodoc
abstract mixin class _$OrderStatusEntityCopyWith<$Res> implements $OrderStatusEntityCopyWith<$Res> {
  factory _$OrderStatusEntityCopyWith(_OrderStatusEntity value, $Res Function(_OrderStatusEntity) _then) = __$OrderStatusEntityCopyWithImpl;
@override @useResult
$Res call({
 String? icon, String? title, String? subtitle, BackendActionButtonEntity? action
});




}
/// @nodoc
class __$OrderStatusEntityCopyWithImpl<$Res>
    implements _$OrderStatusEntityCopyWith<$Res> {
  __$OrderStatusEntityCopyWithImpl(this._self, this._then);

  final _OrderStatusEntity _self;
  final $Res Function(_OrderStatusEntity) _then;

/// Create a copy of OrderStatusEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? icon = freezed,Object? title = freezed,Object? subtitle = freezed,Object? action = freezed,}) {
  return _then(_OrderStatusEntity(
icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,action: freezed == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as BackendActionButtonEntity?,
  ));
}


}

// dart format on
