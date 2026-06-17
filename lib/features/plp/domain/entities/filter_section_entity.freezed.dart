// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'filter_section_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FilterSectionEntity {

 String? get filterKey; String? get label; bool get isSelected; bool get hasSelected; bool get isMultiSelect; bool get showSearch; String? get searchBarLabel; int? get appliedCount; String? get uiType; List<FilterEntity> get filterList;/// Optional API-driven badge for the row in the filter sidebar (e.g.
/// "NEW" ribbon). Reuses the core VisualCueEntity; the same shape we
/// use for product visual cues so badge rendering can share a widget.
 VisualCueEntity? get visualCue;
/// Create a copy of FilterSectionEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FilterSectionEntityCopyWith<FilterSectionEntity> get copyWith => _$FilterSectionEntityCopyWithImpl<FilterSectionEntity>(this as FilterSectionEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FilterSectionEntity&&(identical(other.filterKey, filterKey) || other.filterKey == filterKey)&&(identical(other.label, label) || other.label == label)&&(identical(other.isSelected, isSelected) || other.isSelected == isSelected)&&(identical(other.hasSelected, hasSelected) || other.hasSelected == hasSelected)&&(identical(other.isMultiSelect, isMultiSelect) || other.isMultiSelect == isMultiSelect)&&(identical(other.showSearch, showSearch) || other.showSearch == showSearch)&&(identical(other.searchBarLabel, searchBarLabel) || other.searchBarLabel == searchBarLabel)&&(identical(other.appliedCount, appliedCount) || other.appliedCount == appliedCount)&&(identical(other.uiType, uiType) || other.uiType == uiType)&&const DeepCollectionEquality().equals(other.filterList, filterList)&&(identical(other.visualCue, visualCue) || other.visualCue == visualCue));
}


@override
int get hashCode => Object.hash(runtimeType,filterKey,label,isSelected,hasSelected,isMultiSelect,showSearch,searchBarLabel,appliedCount,uiType,const DeepCollectionEquality().hash(filterList),visualCue);

@override
String toString() {
  return 'FilterSectionEntity(filterKey: $filterKey, label: $label, isSelected: $isSelected, hasSelected: $hasSelected, isMultiSelect: $isMultiSelect, showSearch: $showSearch, searchBarLabel: $searchBarLabel, appliedCount: $appliedCount, uiType: $uiType, filterList: $filterList, visualCue: $visualCue)';
}


}

/// @nodoc
abstract mixin class $FilterSectionEntityCopyWith<$Res>  {
  factory $FilterSectionEntityCopyWith(FilterSectionEntity value, $Res Function(FilterSectionEntity) _then) = _$FilterSectionEntityCopyWithImpl;
@useResult
$Res call({
 String? filterKey, String? label, bool isSelected, bool hasSelected, bool isMultiSelect, bool showSearch, String? searchBarLabel, int? appliedCount, String? uiType, List<FilterEntity> filterList, VisualCueEntity? visualCue
});




}
/// @nodoc
class _$FilterSectionEntityCopyWithImpl<$Res>
    implements $FilterSectionEntityCopyWith<$Res> {
  _$FilterSectionEntityCopyWithImpl(this._self, this._then);

  final FilterSectionEntity _self;
  final $Res Function(FilterSectionEntity) _then;

/// Create a copy of FilterSectionEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? filterKey = freezed,Object? label = freezed,Object? isSelected = null,Object? hasSelected = null,Object? isMultiSelect = null,Object? showSearch = null,Object? searchBarLabel = freezed,Object? appliedCount = freezed,Object? uiType = freezed,Object? filterList = null,Object? visualCue = freezed,}) {
  return _then(_self.copyWith(
filterKey: freezed == filterKey ? _self.filterKey : filterKey // ignore: cast_nullable_to_non_nullable
as String?,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,isSelected: null == isSelected ? _self.isSelected : isSelected // ignore: cast_nullable_to_non_nullable
as bool,hasSelected: null == hasSelected ? _self.hasSelected : hasSelected // ignore: cast_nullable_to_non_nullable
as bool,isMultiSelect: null == isMultiSelect ? _self.isMultiSelect : isMultiSelect // ignore: cast_nullable_to_non_nullable
as bool,showSearch: null == showSearch ? _self.showSearch : showSearch // ignore: cast_nullable_to_non_nullable
as bool,searchBarLabel: freezed == searchBarLabel ? _self.searchBarLabel : searchBarLabel // ignore: cast_nullable_to_non_nullable
as String?,appliedCount: freezed == appliedCount ? _self.appliedCount : appliedCount // ignore: cast_nullable_to_non_nullable
as int?,uiType: freezed == uiType ? _self.uiType : uiType // ignore: cast_nullable_to_non_nullable
as String?,filterList: null == filterList ? _self.filterList : filterList // ignore: cast_nullable_to_non_nullable
as List<FilterEntity>,visualCue: freezed == visualCue ? _self.visualCue : visualCue // ignore: cast_nullable_to_non_nullable
as VisualCueEntity?,
  ));
}

}


/// Adds pattern-matching-related methods to [FilterSectionEntity].
extension FilterSectionEntityPatterns on FilterSectionEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FilterSectionEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FilterSectionEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FilterSectionEntity value)  $default,){
final _that = this;
switch (_that) {
case _FilterSectionEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FilterSectionEntity value)?  $default,){
final _that = this;
switch (_that) {
case _FilterSectionEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? filterKey,  String? label,  bool isSelected,  bool hasSelected,  bool isMultiSelect,  bool showSearch,  String? searchBarLabel,  int? appliedCount,  String? uiType,  List<FilterEntity> filterList,  VisualCueEntity? visualCue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FilterSectionEntity() when $default != null:
return $default(_that.filterKey,_that.label,_that.isSelected,_that.hasSelected,_that.isMultiSelect,_that.showSearch,_that.searchBarLabel,_that.appliedCount,_that.uiType,_that.filterList,_that.visualCue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? filterKey,  String? label,  bool isSelected,  bool hasSelected,  bool isMultiSelect,  bool showSearch,  String? searchBarLabel,  int? appliedCount,  String? uiType,  List<FilterEntity> filterList,  VisualCueEntity? visualCue)  $default,) {final _that = this;
switch (_that) {
case _FilterSectionEntity():
return $default(_that.filterKey,_that.label,_that.isSelected,_that.hasSelected,_that.isMultiSelect,_that.showSearch,_that.searchBarLabel,_that.appliedCount,_that.uiType,_that.filterList,_that.visualCue);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? filterKey,  String? label,  bool isSelected,  bool hasSelected,  bool isMultiSelect,  bool showSearch,  String? searchBarLabel,  int? appliedCount,  String? uiType,  List<FilterEntity> filterList,  VisualCueEntity? visualCue)?  $default,) {final _that = this;
switch (_that) {
case _FilterSectionEntity() when $default != null:
return $default(_that.filterKey,_that.label,_that.isSelected,_that.hasSelected,_that.isMultiSelect,_that.showSearch,_that.searchBarLabel,_that.appliedCount,_that.uiType,_that.filterList,_that.visualCue);case _:
  return null;

}
}

}

/// @nodoc


class _FilterSectionEntity implements FilterSectionEntity {
  const _FilterSectionEntity({this.filterKey, this.label, this.isSelected = false, this.hasSelected = false, this.isMultiSelect = false, this.showSearch = false, this.searchBarLabel, this.appliedCount, this.uiType, final  List<FilterEntity> filterList = const [], this.visualCue}): _filterList = filterList;
  

@override final  String? filterKey;
@override final  String? label;
@override@JsonKey() final  bool isSelected;
@override@JsonKey() final  bool hasSelected;
@override@JsonKey() final  bool isMultiSelect;
@override@JsonKey() final  bool showSearch;
@override final  String? searchBarLabel;
@override final  int? appliedCount;
@override final  String? uiType;
 final  List<FilterEntity> _filterList;
@override@JsonKey() List<FilterEntity> get filterList {
  if (_filterList is EqualUnmodifiableListView) return _filterList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_filterList);
}

/// Optional API-driven badge for the row in the filter sidebar (e.g.
/// "NEW" ribbon). Reuses the core VisualCueEntity; the same shape we
/// use for product visual cues so badge rendering can share a widget.
@override final  VisualCueEntity? visualCue;

/// Create a copy of FilterSectionEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FilterSectionEntityCopyWith<_FilterSectionEntity> get copyWith => __$FilterSectionEntityCopyWithImpl<_FilterSectionEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FilterSectionEntity&&(identical(other.filterKey, filterKey) || other.filterKey == filterKey)&&(identical(other.label, label) || other.label == label)&&(identical(other.isSelected, isSelected) || other.isSelected == isSelected)&&(identical(other.hasSelected, hasSelected) || other.hasSelected == hasSelected)&&(identical(other.isMultiSelect, isMultiSelect) || other.isMultiSelect == isMultiSelect)&&(identical(other.showSearch, showSearch) || other.showSearch == showSearch)&&(identical(other.searchBarLabel, searchBarLabel) || other.searchBarLabel == searchBarLabel)&&(identical(other.appliedCount, appliedCount) || other.appliedCount == appliedCount)&&(identical(other.uiType, uiType) || other.uiType == uiType)&&const DeepCollectionEquality().equals(other._filterList, _filterList)&&(identical(other.visualCue, visualCue) || other.visualCue == visualCue));
}


@override
int get hashCode => Object.hash(runtimeType,filterKey,label,isSelected,hasSelected,isMultiSelect,showSearch,searchBarLabel,appliedCount,uiType,const DeepCollectionEquality().hash(_filterList),visualCue);

@override
String toString() {
  return 'FilterSectionEntity(filterKey: $filterKey, label: $label, isSelected: $isSelected, hasSelected: $hasSelected, isMultiSelect: $isMultiSelect, showSearch: $showSearch, searchBarLabel: $searchBarLabel, appliedCount: $appliedCount, uiType: $uiType, filterList: $filterList, visualCue: $visualCue)';
}


}

/// @nodoc
abstract mixin class _$FilterSectionEntityCopyWith<$Res> implements $FilterSectionEntityCopyWith<$Res> {
  factory _$FilterSectionEntityCopyWith(_FilterSectionEntity value, $Res Function(_FilterSectionEntity) _then) = __$FilterSectionEntityCopyWithImpl;
@override @useResult
$Res call({
 String? filterKey, String? label, bool isSelected, bool hasSelected, bool isMultiSelect, bool showSearch, String? searchBarLabel, int? appliedCount, String? uiType, List<FilterEntity> filterList, VisualCueEntity? visualCue
});




}
/// @nodoc
class __$FilterSectionEntityCopyWithImpl<$Res>
    implements _$FilterSectionEntityCopyWith<$Res> {
  __$FilterSectionEntityCopyWithImpl(this._self, this._then);

  final _FilterSectionEntity _self;
  final $Res Function(_FilterSectionEntity) _then;

/// Create a copy of FilterSectionEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? filterKey = freezed,Object? label = freezed,Object? isSelected = null,Object? hasSelected = null,Object? isMultiSelect = null,Object? showSearch = null,Object? searchBarLabel = freezed,Object? appliedCount = freezed,Object? uiType = freezed,Object? filterList = null,Object? visualCue = freezed,}) {
  return _then(_FilterSectionEntity(
filterKey: freezed == filterKey ? _self.filterKey : filterKey // ignore: cast_nullable_to_non_nullable
as String?,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,isSelected: null == isSelected ? _self.isSelected : isSelected // ignore: cast_nullable_to_non_nullable
as bool,hasSelected: null == hasSelected ? _self.hasSelected : hasSelected // ignore: cast_nullable_to_non_nullable
as bool,isMultiSelect: null == isMultiSelect ? _self.isMultiSelect : isMultiSelect // ignore: cast_nullable_to_non_nullable
as bool,showSearch: null == showSearch ? _self.showSearch : showSearch // ignore: cast_nullable_to_non_nullable
as bool,searchBarLabel: freezed == searchBarLabel ? _self.searchBarLabel : searchBarLabel // ignore: cast_nullable_to_non_nullable
as String?,appliedCount: freezed == appliedCount ? _self.appliedCount : appliedCount // ignore: cast_nullable_to_non_nullable
as int?,uiType: freezed == uiType ? _self.uiType : uiType // ignore: cast_nullable_to_non_nullable
as String?,filterList: null == filterList ? _self._filterList : filterList // ignore: cast_nullable_to_non_nullable
as List<FilterEntity>,visualCue: freezed == visualCue ? _self.visualCue : visualCue // ignore: cast_nullable_to_non_nullable
as VisualCueEntity?,
  ));
}


}

// dart format on
