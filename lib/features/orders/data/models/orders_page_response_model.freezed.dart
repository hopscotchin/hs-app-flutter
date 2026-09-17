// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'orders_page_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OrdersPageResponseModel {

@JsonKey(fromJson: parseToInt) int get totalRecords; List<OrderInfoModel> get items;
/// Create a copy of OrdersPageResponseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrdersPageResponseModelCopyWith<OrdersPageResponseModel> get copyWith => _$OrdersPageResponseModelCopyWithImpl<OrdersPageResponseModel>(this as OrdersPageResponseModel, _$identity);

  /// Serializes this OrdersPageResponseModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrdersPageResponseModel&&(identical(other.totalRecords, totalRecords) || other.totalRecords == totalRecords)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalRecords,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'OrdersPageResponseModel(totalRecords: $totalRecords, items: $items)';
}


}

/// @nodoc
abstract mixin class $OrdersPageResponseModelCopyWith<$Res>  {
  factory $OrdersPageResponseModelCopyWith(OrdersPageResponseModel value, $Res Function(OrdersPageResponseModel) _then) = _$OrdersPageResponseModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: parseToInt) int totalRecords, List<OrderInfoModel> items
});




}
/// @nodoc
class _$OrdersPageResponseModelCopyWithImpl<$Res>
    implements $OrdersPageResponseModelCopyWith<$Res> {
  _$OrdersPageResponseModelCopyWithImpl(this._self, this._then);

  final OrdersPageResponseModel _self;
  final $Res Function(OrdersPageResponseModel) _then;

/// Create a copy of OrdersPageResponseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalRecords = null,Object? items = null,}) {
  return _then(_self.copyWith(
totalRecords: null == totalRecords ? _self.totalRecords : totalRecords // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<OrderInfoModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [OrdersPageResponseModel].
extension OrdersPageResponseModelPatterns on OrdersPageResponseModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrdersPageResponseModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrdersPageResponseModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrdersPageResponseModel value)  $default,){
final _that = this;
switch (_that) {
case _OrdersPageResponseModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrdersPageResponseModel value)?  $default,){
final _that = this;
switch (_that) {
case _OrdersPageResponseModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: parseToInt)  int totalRecords,  List<OrderInfoModel> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrdersPageResponseModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: parseToInt)  int totalRecords,  List<OrderInfoModel> items)  $default,) {final _that = this;
switch (_that) {
case _OrdersPageResponseModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: parseToInt)  int totalRecords,  List<OrderInfoModel> items)?  $default,) {final _that = this;
switch (_that) {
case _OrdersPageResponseModel() when $default != null:
return $default(_that.totalRecords,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrdersPageResponseModel extends OrdersPageResponseModel {
  const _OrdersPageResponseModel({@JsonKey(fromJson: parseToInt) this.totalRecords = 0, final  List<OrderInfoModel> items = const <OrderInfoModel>[]}): _items = items,super._();
  factory _OrdersPageResponseModel.fromJson(Map<String, dynamic> json) => _$OrdersPageResponseModelFromJson(json);

@override@JsonKey(fromJson: parseToInt) final  int totalRecords;
 final  List<OrderInfoModel> _items;
@override@JsonKey() List<OrderInfoModel> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of OrdersPageResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrdersPageResponseModelCopyWith<_OrdersPageResponseModel> get copyWith => __$OrdersPageResponseModelCopyWithImpl<_OrdersPageResponseModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrdersPageResponseModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrdersPageResponseModel&&(identical(other.totalRecords, totalRecords) || other.totalRecords == totalRecords)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalRecords,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'OrdersPageResponseModel(totalRecords: $totalRecords, items: $items)';
}


}

/// @nodoc
abstract mixin class _$OrdersPageResponseModelCopyWith<$Res> implements $OrdersPageResponseModelCopyWith<$Res> {
  factory _$OrdersPageResponseModelCopyWith(_OrdersPageResponseModel value, $Res Function(_OrdersPageResponseModel) _then) = __$OrdersPageResponseModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: parseToInt) int totalRecords, List<OrderInfoModel> items
});




}
/// @nodoc
class __$OrdersPageResponseModelCopyWithImpl<$Res>
    implements _$OrdersPageResponseModelCopyWith<$Res> {
  __$OrdersPageResponseModelCopyWithImpl(this._self, this._then);

  final _OrdersPageResponseModel _self;
  final $Res Function(_OrdersPageResponseModel) _then;

/// Create a copy of OrdersPageResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalRecords = null,Object? items = null,}) {
  return _then(_OrdersPageResponseModel(
totalRecords: null == totalRecords ? _self.totalRecords : totalRecords // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<OrderInfoModel>,
  ));
}


}

// dart format on
