// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'orders_page_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OrdersPageEntity {

 int get totalRecords; List<OrderInfoEntity> get items;
/// Create a copy of OrdersPageEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrdersPageEntityCopyWith<OrdersPageEntity> get copyWith => _$OrdersPageEntityCopyWithImpl<OrdersPageEntity>(this as OrdersPageEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrdersPageEntity&&(identical(other.totalRecords, totalRecords) || other.totalRecords == totalRecords)&&const DeepCollectionEquality().equals(other.items, items));
}


@override
int get hashCode => Object.hash(runtimeType,totalRecords,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'OrdersPageEntity(totalRecords: $totalRecords, items: $items)';
}


}

/// @nodoc
abstract mixin class $OrdersPageEntityCopyWith<$Res>  {
  factory $OrdersPageEntityCopyWith(OrdersPageEntity value, $Res Function(OrdersPageEntity) _then) = _$OrdersPageEntityCopyWithImpl;
@useResult
$Res call({
 int totalRecords, List<OrderInfoEntity> items
});




}
/// @nodoc
class _$OrdersPageEntityCopyWithImpl<$Res>
    implements $OrdersPageEntityCopyWith<$Res> {
  _$OrdersPageEntityCopyWithImpl(this._self, this._then);

  final OrdersPageEntity _self;
  final $Res Function(OrdersPageEntity) _then;

/// Create a copy of OrdersPageEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalRecords = null,Object? items = null,}) {
  return _then(_self.copyWith(
totalRecords: null == totalRecords ? _self.totalRecords : totalRecords // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<OrderInfoEntity>,
  ));
}

}


/// Adds pattern-matching-related methods to [OrdersPageEntity].
extension OrdersPageEntityPatterns on OrdersPageEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrdersPageEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrdersPageEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrdersPageEntity value)  $default,){
final _that = this;
switch (_that) {
case _OrdersPageEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrdersPageEntity value)?  $default,){
final _that = this;
switch (_that) {
case _OrdersPageEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalRecords,  List<OrderInfoEntity> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrdersPageEntity() when $default != null:
return $default(_that.totalRecords,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalRecords,  List<OrderInfoEntity> items)  $default,) {final _that = this;
switch (_that) {
case _OrdersPageEntity():
return $default(_that.totalRecords,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalRecords,  List<OrderInfoEntity> items)?  $default,) {final _that = this;
switch (_that) {
case _OrdersPageEntity() when $default != null:
return $default(_that.totalRecords,_that.items);case _:
  return null;

}
}

}

/// @nodoc


class _OrdersPageEntity extends OrdersPageEntity {
  const _OrdersPageEntity({this.totalRecords = 0, final  List<OrderInfoEntity> items = const <OrderInfoEntity>[]}): _items = items,super._();
  

@override@JsonKey() final  int totalRecords;
 final  List<OrderInfoEntity> _items;
@override@JsonKey() List<OrderInfoEntity> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of OrdersPageEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrdersPageEntityCopyWith<_OrdersPageEntity> get copyWith => __$OrdersPageEntityCopyWithImpl<_OrdersPageEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrdersPageEntity&&(identical(other.totalRecords, totalRecords) || other.totalRecords == totalRecords)&&const DeepCollectionEquality().equals(other._items, _items));
}


@override
int get hashCode => Object.hash(runtimeType,totalRecords,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'OrdersPageEntity(totalRecords: $totalRecords, items: $items)';
}


}

/// @nodoc
abstract mixin class _$OrdersPageEntityCopyWith<$Res> implements $OrdersPageEntityCopyWith<$Res> {
  factory _$OrdersPageEntityCopyWith(_OrdersPageEntity value, $Res Function(_OrdersPageEntity) _then) = __$OrdersPageEntityCopyWithImpl;
@override @useResult
$Res call({
 int totalRecords, List<OrderInfoEntity> items
});




}
/// @nodoc
class __$OrdersPageEntityCopyWithImpl<$Res>
    implements _$OrdersPageEntityCopyWith<$Res> {
  __$OrdersPageEntityCopyWithImpl(this._self, this._then);

  final _OrdersPageEntity _self;
  final $Res Function(_OrdersPageEntity) _then;

/// Create a copy of OrdersPageEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalRecords = null,Object? items = null,}) {
  return _then(_OrdersPageEntity(
totalRecords: null == totalRecords ? _self.totalRecords : totalRecords // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<OrderInfoEntity>,
  ));
}


}

// dart format on
