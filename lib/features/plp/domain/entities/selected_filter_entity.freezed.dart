// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'selected_filter_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SelectedFilterEntity {

 String? get filterKey; String? get filterValue; String? get selectedFilterName; bool get showOnUi;
/// Create a copy of SelectedFilterEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SelectedFilterEntityCopyWith<SelectedFilterEntity> get copyWith => _$SelectedFilterEntityCopyWithImpl<SelectedFilterEntity>(this as SelectedFilterEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SelectedFilterEntity&&(identical(other.filterKey, filterKey) || other.filterKey == filterKey)&&(identical(other.filterValue, filterValue) || other.filterValue == filterValue)&&(identical(other.selectedFilterName, selectedFilterName) || other.selectedFilterName == selectedFilterName)&&(identical(other.showOnUi, showOnUi) || other.showOnUi == showOnUi));
}


@override
int get hashCode => Object.hash(runtimeType,filterKey,filterValue,selectedFilterName,showOnUi);

@override
String toString() {
  return 'SelectedFilterEntity(filterKey: $filterKey, filterValue: $filterValue, selectedFilterName: $selectedFilterName, showOnUi: $showOnUi)';
}


}

/// @nodoc
abstract mixin class $SelectedFilterEntityCopyWith<$Res>  {
  factory $SelectedFilterEntityCopyWith(SelectedFilterEntity value, $Res Function(SelectedFilterEntity) _then) = _$SelectedFilterEntityCopyWithImpl;
@useResult
$Res call({
 String? filterKey, String? filterValue, String? selectedFilterName, bool showOnUi
});




}
/// @nodoc
class _$SelectedFilterEntityCopyWithImpl<$Res>
    implements $SelectedFilterEntityCopyWith<$Res> {
  _$SelectedFilterEntityCopyWithImpl(this._self, this._then);

  final SelectedFilterEntity _self;
  final $Res Function(SelectedFilterEntity) _then;

/// Create a copy of SelectedFilterEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? filterKey = freezed,Object? filterValue = freezed,Object? selectedFilterName = freezed,Object? showOnUi = null,}) {
  return _then(_self.copyWith(
filterKey: freezed == filterKey ? _self.filterKey : filterKey // ignore: cast_nullable_to_non_nullable
as String?,filterValue: freezed == filterValue ? _self.filterValue : filterValue // ignore: cast_nullable_to_non_nullable
as String?,selectedFilterName: freezed == selectedFilterName ? _self.selectedFilterName : selectedFilterName // ignore: cast_nullable_to_non_nullable
as String?,showOnUi: null == showOnUi ? _self.showOnUi : showOnUi // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SelectedFilterEntity].
extension SelectedFilterEntityPatterns on SelectedFilterEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SelectedFilterEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SelectedFilterEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SelectedFilterEntity value)  $default,){
final _that = this;
switch (_that) {
case _SelectedFilterEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SelectedFilterEntity value)?  $default,){
final _that = this;
switch (_that) {
case _SelectedFilterEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? filterKey,  String? filterValue,  String? selectedFilterName,  bool showOnUi)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SelectedFilterEntity() when $default != null:
return $default(_that.filterKey,_that.filterValue,_that.selectedFilterName,_that.showOnUi);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? filterKey,  String? filterValue,  String? selectedFilterName,  bool showOnUi)  $default,) {final _that = this;
switch (_that) {
case _SelectedFilterEntity():
return $default(_that.filterKey,_that.filterValue,_that.selectedFilterName,_that.showOnUi);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? filterKey,  String? filterValue,  String? selectedFilterName,  bool showOnUi)?  $default,) {final _that = this;
switch (_that) {
case _SelectedFilterEntity() when $default != null:
return $default(_that.filterKey,_that.filterValue,_that.selectedFilterName,_that.showOnUi);case _:
  return null;

}
}

}

/// @nodoc


class _SelectedFilterEntity implements SelectedFilterEntity {
  const _SelectedFilterEntity({this.filterKey, this.filterValue, this.selectedFilterName, this.showOnUi = true});
  

@override final  String? filterKey;
@override final  String? filterValue;
@override final  String? selectedFilterName;
@override@JsonKey() final  bool showOnUi;

/// Create a copy of SelectedFilterEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SelectedFilterEntityCopyWith<_SelectedFilterEntity> get copyWith => __$SelectedFilterEntityCopyWithImpl<_SelectedFilterEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SelectedFilterEntity&&(identical(other.filterKey, filterKey) || other.filterKey == filterKey)&&(identical(other.filterValue, filterValue) || other.filterValue == filterValue)&&(identical(other.selectedFilterName, selectedFilterName) || other.selectedFilterName == selectedFilterName)&&(identical(other.showOnUi, showOnUi) || other.showOnUi == showOnUi));
}


@override
int get hashCode => Object.hash(runtimeType,filterKey,filterValue,selectedFilterName,showOnUi);

@override
String toString() {
  return 'SelectedFilterEntity(filterKey: $filterKey, filterValue: $filterValue, selectedFilterName: $selectedFilterName, showOnUi: $showOnUi)';
}


}

/// @nodoc
abstract mixin class _$SelectedFilterEntityCopyWith<$Res> implements $SelectedFilterEntityCopyWith<$Res> {
  factory _$SelectedFilterEntityCopyWith(_SelectedFilterEntity value, $Res Function(_SelectedFilterEntity) _then) = __$SelectedFilterEntityCopyWithImpl;
@override @useResult
$Res call({
 String? filterKey, String? filterValue, String? selectedFilterName, bool showOnUi
});




}
/// @nodoc
class __$SelectedFilterEntityCopyWithImpl<$Res>
    implements _$SelectedFilterEntityCopyWith<$Res> {
  __$SelectedFilterEntityCopyWithImpl(this._self, this._then);

  final _SelectedFilterEntity _self;
  final $Res Function(_SelectedFilterEntity) _then;

/// Create a copy of SelectedFilterEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? filterKey = freezed,Object? filterValue = freezed,Object? selectedFilterName = freezed,Object? showOnUi = null,}) {
  return _then(_SelectedFilterEntity(
filterKey: freezed == filterKey ? _self.filterKey : filterKey // ignore: cast_nullable_to_non_nullable
as String?,filterValue: freezed == filterValue ? _self.filterValue : filterValue // ignore: cast_nullable_to_non_nullable
as String?,selectedFilterName: freezed == selectedFilterName ? _self.selectedFilterName : selectedFilterName // ignore: cast_nullable_to_non_nullable
as String?,showOnUi: null == showOnUi ? _self.showOnUi : showOnUi // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
