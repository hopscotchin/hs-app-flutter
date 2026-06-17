// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'filter_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FilterEntity {

 String? get filterKey; String? get filterValue; int? get count; String? get label; bool get isSelected; bool get isMultiSelect; String? get type; List<FilterEntity> get filters; String? get colorHex; String? get ovalImgUrl; bool get isSection; String? get pincode; VisualCueEntity? get visualCue;
/// Create a copy of FilterEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FilterEntityCopyWith<FilterEntity> get copyWith => _$FilterEntityCopyWithImpl<FilterEntity>(this as FilterEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FilterEntity&&(identical(other.filterKey, filterKey) || other.filterKey == filterKey)&&(identical(other.filterValue, filterValue) || other.filterValue == filterValue)&&(identical(other.count, count) || other.count == count)&&(identical(other.label, label) || other.label == label)&&(identical(other.isSelected, isSelected) || other.isSelected == isSelected)&&(identical(other.isMultiSelect, isMultiSelect) || other.isMultiSelect == isMultiSelect)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.filters, filters)&&(identical(other.colorHex, colorHex) || other.colorHex == colorHex)&&(identical(other.ovalImgUrl, ovalImgUrl) || other.ovalImgUrl == ovalImgUrl)&&(identical(other.isSection, isSection) || other.isSection == isSection)&&(identical(other.pincode, pincode) || other.pincode == pincode)&&(identical(other.visualCue, visualCue) || other.visualCue == visualCue));
}


@override
int get hashCode => Object.hash(runtimeType,filterKey,filterValue,count,label,isSelected,isMultiSelect,type,const DeepCollectionEquality().hash(filters),colorHex,ovalImgUrl,isSection,pincode,visualCue);

@override
String toString() {
  return 'FilterEntity(filterKey: $filterKey, filterValue: $filterValue, count: $count, label: $label, isSelected: $isSelected, isMultiSelect: $isMultiSelect, type: $type, filters: $filters, colorHex: $colorHex, ovalImgUrl: $ovalImgUrl, isSection: $isSection, pincode: $pincode, visualCue: $visualCue)';
}


}

/// @nodoc
abstract mixin class $FilterEntityCopyWith<$Res>  {
  factory $FilterEntityCopyWith(FilterEntity value, $Res Function(FilterEntity) _then) = _$FilterEntityCopyWithImpl;
@useResult
$Res call({
 String? filterKey, String? filterValue, int? count, String? label, bool isSelected, bool isMultiSelect, String? type, List<FilterEntity> filters, String? colorHex, String? ovalImgUrl, bool isSection, String? pincode, VisualCueEntity? visualCue
});




}
/// @nodoc
class _$FilterEntityCopyWithImpl<$Res>
    implements $FilterEntityCopyWith<$Res> {
  _$FilterEntityCopyWithImpl(this._self, this._then);

  final FilterEntity _self;
  final $Res Function(FilterEntity) _then;

/// Create a copy of FilterEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? filterKey = freezed,Object? filterValue = freezed,Object? count = freezed,Object? label = freezed,Object? isSelected = null,Object? isMultiSelect = null,Object? type = freezed,Object? filters = null,Object? colorHex = freezed,Object? ovalImgUrl = freezed,Object? isSection = null,Object? pincode = freezed,Object? visualCue = freezed,}) {
  return _then(_self.copyWith(
filterKey: freezed == filterKey ? _self.filterKey : filterKey // ignore: cast_nullable_to_non_nullable
as String?,filterValue: freezed == filterValue ? _self.filterValue : filterValue // ignore: cast_nullable_to_non_nullable
as String?,count: freezed == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int?,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,isSelected: null == isSelected ? _self.isSelected : isSelected // ignore: cast_nullable_to_non_nullable
as bool,isMultiSelect: null == isMultiSelect ? _self.isMultiSelect : isMultiSelect // ignore: cast_nullable_to_non_nullable
as bool,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,filters: null == filters ? _self.filters : filters // ignore: cast_nullable_to_non_nullable
as List<FilterEntity>,colorHex: freezed == colorHex ? _self.colorHex : colorHex // ignore: cast_nullable_to_non_nullable
as String?,ovalImgUrl: freezed == ovalImgUrl ? _self.ovalImgUrl : ovalImgUrl // ignore: cast_nullable_to_non_nullable
as String?,isSection: null == isSection ? _self.isSection : isSection // ignore: cast_nullable_to_non_nullable
as bool,pincode: freezed == pincode ? _self.pincode : pincode // ignore: cast_nullable_to_non_nullable
as String?,visualCue: freezed == visualCue ? _self.visualCue : visualCue // ignore: cast_nullable_to_non_nullable
as VisualCueEntity?,
  ));
}

}


/// Adds pattern-matching-related methods to [FilterEntity].
extension FilterEntityPatterns on FilterEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FilterEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FilterEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FilterEntity value)  $default,){
final _that = this;
switch (_that) {
case _FilterEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FilterEntity value)?  $default,){
final _that = this;
switch (_that) {
case _FilterEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? filterKey,  String? filterValue,  int? count,  String? label,  bool isSelected,  bool isMultiSelect,  String? type,  List<FilterEntity> filters,  String? colorHex,  String? ovalImgUrl,  bool isSection,  String? pincode,  VisualCueEntity? visualCue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FilterEntity() when $default != null:
return $default(_that.filterKey,_that.filterValue,_that.count,_that.label,_that.isSelected,_that.isMultiSelect,_that.type,_that.filters,_that.colorHex,_that.ovalImgUrl,_that.isSection,_that.pincode,_that.visualCue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? filterKey,  String? filterValue,  int? count,  String? label,  bool isSelected,  bool isMultiSelect,  String? type,  List<FilterEntity> filters,  String? colorHex,  String? ovalImgUrl,  bool isSection,  String? pincode,  VisualCueEntity? visualCue)  $default,) {final _that = this;
switch (_that) {
case _FilterEntity():
return $default(_that.filterKey,_that.filterValue,_that.count,_that.label,_that.isSelected,_that.isMultiSelect,_that.type,_that.filters,_that.colorHex,_that.ovalImgUrl,_that.isSection,_that.pincode,_that.visualCue);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? filterKey,  String? filterValue,  int? count,  String? label,  bool isSelected,  bool isMultiSelect,  String? type,  List<FilterEntity> filters,  String? colorHex,  String? ovalImgUrl,  bool isSection,  String? pincode,  VisualCueEntity? visualCue)?  $default,) {final _that = this;
switch (_that) {
case _FilterEntity() when $default != null:
return $default(_that.filterKey,_that.filterValue,_that.count,_that.label,_that.isSelected,_that.isMultiSelect,_that.type,_that.filters,_that.colorHex,_that.ovalImgUrl,_that.isSection,_that.pincode,_that.visualCue);case _:
  return null;

}
}

}

/// @nodoc


class _FilterEntity implements FilterEntity {
  const _FilterEntity({this.filterKey, this.filterValue, this.count, this.label, this.isSelected = false, this.isMultiSelect = false, this.type, final  List<FilterEntity> filters = const [], this.colorHex, this.ovalImgUrl, this.isSection = false, this.pincode, this.visualCue}): _filters = filters;
  

@override final  String? filterKey;
@override final  String? filterValue;
@override final  int? count;
@override final  String? label;
@override@JsonKey() final  bool isSelected;
@override@JsonKey() final  bool isMultiSelect;
@override final  String? type;
 final  List<FilterEntity> _filters;
@override@JsonKey() List<FilterEntity> get filters {
  if (_filters is EqualUnmodifiableListView) return _filters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_filters);
}

@override final  String? colorHex;
@override final  String? ovalImgUrl;
@override@JsonKey() final  bool isSection;
@override final  String? pincode;
@override final  VisualCueEntity? visualCue;

/// Create a copy of FilterEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FilterEntityCopyWith<_FilterEntity> get copyWith => __$FilterEntityCopyWithImpl<_FilterEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FilterEntity&&(identical(other.filterKey, filterKey) || other.filterKey == filterKey)&&(identical(other.filterValue, filterValue) || other.filterValue == filterValue)&&(identical(other.count, count) || other.count == count)&&(identical(other.label, label) || other.label == label)&&(identical(other.isSelected, isSelected) || other.isSelected == isSelected)&&(identical(other.isMultiSelect, isMultiSelect) || other.isMultiSelect == isMultiSelect)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other._filters, _filters)&&(identical(other.colorHex, colorHex) || other.colorHex == colorHex)&&(identical(other.ovalImgUrl, ovalImgUrl) || other.ovalImgUrl == ovalImgUrl)&&(identical(other.isSection, isSection) || other.isSection == isSection)&&(identical(other.pincode, pincode) || other.pincode == pincode)&&(identical(other.visualCue, visualCue) || other.visualCue == visualCue));
}


@override
int get hashCode => Object.hash(runtimeType,filterKey,filterValue,count,label,isSelected,isMultiSelect,type,const DeepCollectionEquality().hash(_filters),colorHex,ovalImgUrl,isSection,pincode,visualCue);

@override
String toString() {
  return 'FilterEntity(filterKey: $filterKey, filterValue: $filterValue, count: $count, label: $label, isSelected: $isSelected, isMultiSelect: $isMultiSelect, type: $type, filters: $filters, colorHex: $colorHex, ovalImgUrl: $ovalImgUrl, isSection: $isSection, pincode: $pincode, visualCue: $visualCue)';
}


}

/// @nodoc
abstract mixin class _$FilterEntityCopyWith<$Res> implements $FilterEntityCopyWith<$Res> {
  factory _$FilterEntityCopyWith(_FilterEntity value, $Res Function(_FilterEntity) _then) = __$FilterEntityCopyWithImpl;
@override @useResult
$Res call({
 String? filterKey, String? filterValue, int? count, String? label, bool isSelected, bool isMultiSelect, String? type, List<FilterEntity> filters, String? colorHex, String? ovalImgUrl, bool isSection, String? pincode, VisualCueEntity? visualCue
});




}
/// @nodoc
class __$FilterEntityCopyWithImpl<$Res>
    implements _$FilterEntityCopyWith<$Res> {
  __$FilterEntityCopyWithImpl(this._self, this._then);

  final _FilterEntity _self;
  final $Res Function(_FilterEntity) _then;

/// Create a copy of FilterEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? filterKey = freezed,Object? filterValue = freezed,Object? count = freezed,Object? label = freezed,Object? isSelected = null,Object? isMultiSelect = null,Object? type = freezed,Object? filters = null,Object? colorHex = freezed,Object? ovalImgUrl = freezed,Object? isSection = null,Object? pincode = freezed,Object? visualCue = freezed,}) {
  return _then(_FilterEntity(
filterKey: freezed == filterKey ? _self.filterKey : filterKey // ignore: cast_nullable_to_non_nullable
as String?,filterValue: freezed == filterValue ? _self.filterValue : filterValue // ignore: cast_nullable_to_non_nullable
as String?,count: freezed == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int?,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,isSelected: null == isSelected ? _self.isSelected : isSelected // ignore: cast_nullable_to_non_nullable
as bool,isMultiSelect: null == isMultiSelect ? _self.isMultiSelect : isMultiSelect // ignore: cast_nullable_to_non_nullable
as bool,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,filters: null == filters ? _self._filters : filters // ignore: cast_nullable_to_non_nullable
as List<FilterEntity>,colorHex: freezed == colorHex ? _self.colorHex : colorHex // ignore: cast_nullable_to_non_nullable
as String?,ovalImgUrl: freezed == ovalImgUrl ? _self.ovalImgUrl : ovalImgUrl // ignore: cast_nullable_to_non_nullable
as String?,isSection: null == isSection ? _self.isSection : isSection // ignore: cast_nullable_to_non_nullable
as bool,pincode: freezed == pincode ? _self.pincode : pincode // ignore: cast_nullable_to_non_nullable
as String?,visualCue: freezed == visualCue ? _self.visualCue : visualCue // ignore: cast_nullable_to_non_nullable
as VisualCueEntity?,
  ));
}


}

// dart format on
