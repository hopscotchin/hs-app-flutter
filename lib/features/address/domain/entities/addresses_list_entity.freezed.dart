// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'addresses_list_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AddressesListEntity {

 List<AddressEntity> get items; List<Map<String, dynamic>> get rawItems;
/// Create a copy of AddressesListEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddressesListEntityCopyWith<AddressesListEntity> get copyWith => _$AddressesListEntityCopyWithImpl<AddressesListEntity>(this as AddressesListEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddressesListEntity&&const DeepCollectionEquality().equals(other.items, items)&&const DeepCollectionEquality().equals(other.rawItems, rawItems));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),const DeepCollectionEquality().hash(rawItems));

@override
String toString() {
  return 'AddressesListEntity(items: $items, rawItems: $rawItems)';
}


}

/// @nodoc
abstract mixin class $AddressesListEntityCopyWith<$Res>  {
  factory $AddressesListEntityCopyWith(AddressesListEntity value, $Res Function(AddressesListEntity) _then) = _$AddressesListEntityCopyWithImpl;
@useResult
$Res call({
 List<AddressEntity> items, List<Map<String, dynamic>> rawItems
});




}
/// @nodoc
class _$AddressesListEntityCopyWithImpl<$Res>
    implements $AddressesListEntityCopyWith<$Res> {
  _$AddressesListEntityCopyWithImpl(this._self, this._then);

  final AddressesListEntity _self;
  final $Res Function(AddressesListEntity) _then;

/// Create a copy of AddressesListEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? rawItems = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<AddressEntity>,rawItems: null == rawItems ? _self.rawItems : rawItems // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,
  ));
}

}


/// Adds pattern-matching-related methods to [AddressesListEntity].
extension AddressesListEntityPatterns on AddressesListEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AddressesListEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AddressesListEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AddressesListEntity value)  $default,){
final _that = this;
switch (_that) {
case _AddressesListEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AddressesListEntity value)?  $default,){
final _that = this;
switch (_that) {
case _AddressesListEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<AddressEntity> items,  List<Map<String, dynamic>> rawItems)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AddressesListEntity() when $default != null:
return $default(_that.items,_that.rawItems);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<AddressEntity> items,  List<Map<String, dynamic>> rawItems)  $default,) {final _that = this;
switch (_that) {
case _AddressesListEntity():
return $default(_that.items,_that.rawItems);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<AddressEntity> items,  List<Map<String, dynamic>> rawItems)?  $default,) {final _that = this;
switch (_that) {
case _AddressesListEntity() when $default != null:
return $default(_that.items,_that.rawItems);case _:
  return null;

}
}

}

/// @nodoc


class _AddressesListEntity extends AddressesListEntity {
  const _AddressesListEntity({final  List<AddressEntity> items = const <AddressEntity>[], final  List<Map<String, dynamic>> rawItems = const <Map<String, dynamic>>[]}): _items = items,_rawItems = rawItems,super._();
  

 final  List<AddressEntity> _items;
@override@JsonKey() List<AddressEntity> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

 final  List<Map<String, dynamic>> _rawItems;
@override@JsonKey() List<Map<String, dynamic>> get rawItems {
  if (_rawItems is EqualUnmodifiableListView) return _rawItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rawItems);
}


/// Create a copy of AddressesListEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddressesListEntityCopyWith<_AddressesListEntity> get copyWith => __$AddressesListEntityCopyWithImpl<_AddressesListEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddressesListEntity&&const DeepCollectionEquality().equals(other._items, _items)&&const DeepCollectionEquality().equals(other._rawItems, _rawItems));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),const DeepCollectionEquality().hash(_rawItems));

@override
String toString() {
  return 'AddressesListEntity(items: $items, rawItems: $rawItems)';
}


}

/// @nodoc
abstract mixin class _$AddressesListEntityCopyWith<$Res> implements $AddressesListEntityCopyWith<$Res> {
  factory _$AddressesListEntityCopyWith(_AddressesListEntity value, $Res Function(_AddressesListEntity) _then) = __$AddressesListEntityCopyWithImpl;
@override @useResult
$Res call({
 List<AddressEntity> items, List<Map<String, dynamic>> rawItems
});




}
/// @nodoc
class __$AddressesListEntityCopyWithImpl<$Res>
    implements _$AddressesListEntityCopyWith<$Res> {
  __$AddressesListEntityCopyWithImpl(this._self, this._then);

  final _AddressesListEntity _self;
  final $Res Function(_AddressesListEntity) _then;

/// Create a copy of AddressesListEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? rawItems = null,}) {
  return _then(_AddressesListEntity(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<AddressEntity>,rawItems: null == rawItems ? _self._rawItems : rawItems // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,
  ));
}


}

// dart format on
