// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plp_filter_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlpFilterEntity {

 List<QuickFilterEntity> get quickFilters; PlpSortingOptionsEntity? get sortingOptions; List<FilterSectionEntity> get filterSections; List<SelectedFilterEntity> get selectedFilters;
/// Create a copy of PlpFilterEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlpFilterEntityCopyWith<PlpFilterEntity> get copyWith => _$PlpFilterEntityCopyWithImpl<PlpFilterEntity>(this as PlpFilterEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlpFilterEntity&&const DeepCollectionEquality().equals(other.quickFilters, quickFilters)&&(identical(other.sortingOptions, sortingOptions) || other.sortingOptions == sortingOptions)&&const DeepCollectionEquality().equals(other.filterSections, filterSections)&&const DeepCollectionEquality().equals(other.selectedFilters, selectedFilters));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(quickFilters),sortingOptions,const DeepCollectionEquality().hash(filterSections),const DeepCollectionEquality().hash(selectedFilters));

@override
String toString() {
  return 'PlpFilterEntity(quickFilters: $quickFilters, sortingOptions: $sortingOptions, filterSections: $filterSections, selectedFilters: $selectedFilters)';
}


}

/// @nodoc
abstract mixin class $PlpFilterEntityCopyWith<$Res>  {
  factory $PlpFilterEntityCopyWith(PlpFilterEntity value, $Res Function(PlpFilterEntity) _then) = _$PlpFilterEntityCopyWithImpl;
@useResult
$Res call({
 List<QuickFilterEntity> quickFilters, PlpSortingOptionsEntity? sortingOptions, List<FilterSectionEntity> filterSections, List<SelectedFilterEntity> selectedFilters
});


$PlpSortingOptionsEntityCopyWith<$Res>? get sortingOptions;

}
/// @nodoc
class _$PlpFilterEntityCopyWithImpl<$Res>
    implements $PlpFilterEntityCopyWith<$Res> {
  _$PlpFilterEntityCopyWithImpl(this._self, this._then);

  final PlpFilterEntity _self;
  final $Res Function(PlpFilterEntity) _then;

/// Create a copy of PlpFilterEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? quickFilters = null,Object? sortingOptions = freezed,Object? filterSections = null,Object? selectedFilters = null,}) {
  return _then(_self.copyWith(
quickFilters: null == quickFilters ? _self.quickFilters : quickFilters // ignore: cast_nullable_to_non_nullable
as List<QuickFilterEntity>,sortingOptions: freezed == sortingOptions ? _self.sortingOptions : sortingOptions // ignore: cast_nullable_to_non_nullable
as PlpSortingOptionsEntity?,filterSections: null == filterSections ? _self.filterSections : filterSections // ignore: cast_nullable_to_non_nullable
as List<FilterSectionEntity>,selectedFilters: null == selectedFilters ? _self.selectedFilters : selectedFilters // ignore: cast_nullable_to_non_nullable
as List<SelectedFilterEntity>,
  ));
}
/// Create a copy of PlpFilterEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlpSortingOptionsEntityCopyWith<$Res>? get sortingOptions {
    if (_self.sortingOptions == null) {
    return null;
  }

  return $PlpSortingOptionsEntityCopyWith<$Res>(_self.sortingOptions!, (value) {
    return _then(_self.copyWith(sortingOptions: value));
  });
}
}


/// Adds pattern-matching-related methods to [PlpFilterEntity].
extension PlpFilterEntityPatterns on PlpFilterEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlpFilterEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlpFilterEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlpFilterEntity value)  $default,){
final _that = this;
switch (_that) {
case _PlpFilterEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlpFilterEntity value)?  $default,){
final _that = this;
switch (_that) {
case _PlpFilterEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<QuickFilterEntity> quickFilters,  PlpSortingOptionsEntity? sortingOptions,  List<FilterSectionEntity> filterSections,  List<SelectedFilterEntity> selectedFilters)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlpFilterEntity() when $default != null:
return $default(_that.quickFilters,_that.sortingOptions,_that.filterSections,_that.selectedFilters);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<QuickFilterEntity> quickFilters,  PlpSortingOptionsEntity? sortingOptions,  List<FilterSectionEntity> filterSections,  List<SelectedFilterEntity> selectedFilters)  $default,) {final _that = this;
switch (_that) {
case _PlpFilterEntity():
return $default(_that.quickFilters,_that.sortingOptions,_that.filterSections,_that.selectedFilters);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<QuickFilterEntity> quickFilters,  PlpSortingOptionsEntity? sortingOptions,  List<FilterSectionEntity> filterSections,  List<SelectedFilterEntity> selectedFilters)?  $default,) {final _that = this;
switch (_that) {
case _PlpFilterEntity() when $default != null:
return $default(_that.quickFilters,_that.sortingOptions,_that.filterSections,_that.selectedFilters);case _:
  return null;

}
}

}

/// @nodoc


class _PlpFilterEntity implements PlpFilterEntity {
  const _PlpFilterEntity({final  List<QuickFilterEntity> quickFilters = const [], this.sortingOptions, final  List<FilterSectionEntity> filterSections = const [], final  List<SelectedFilterEntity> selectedFilters = const []}): _quickFilters = quickFilters,_filterSections = filterSections,_selectedFilters = selectedFilters;
  

 final  List<QuickFilterEntity> _quickFilters;
@override@JsonKey() List<QuickFilterEntity> get quickFilters {
  if (_quickFilters is EqualUnmodifiableListView) return _quickFilters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_quickFilters);
}

@override final  PlpSortingOptionsEntity? sortingOptions;
 final  List<FilterSectionEntity> _filterSections;
@override@JsonKey() List<FilterSectionEntity> get filterSections {
  if (_filterSections is EqualUnmodifiableListView) return _filterSections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_filterSections);
}

 final  List<SelectedFilterEntity> _selectedFilters;
@override@JsonKey() List<SelectedFilterEntity> get selectedFilters {
  if (_selectedFilters is EqualUnmodifiableListView) return _selectedFilters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedFilters);
}


/// Create a copy of PlpFilterEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlpFilterEntityCopyWith<_PlpFilterEntity> get copyWith => __$PlpFilterEntityCopyWithImpl<_PlpFilterEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlpFilterEntity&&const DeepCollectionEquality().equals(other._quickFilters, _quickFilters)&&(identical(other.sortingOptions, sortingOptions) || other.sortingOptions == sortingOptions)&&const DeepCollectionEquality().equals(other._filterSections, _filterSections)&&const DeepCollectionEquality().equals(other._selectedFilters, _selectedFilters));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_quickFilters),sortingOptions,const DeepCollectionEquality().hash(_filterSections),const DeepCollectionEquality().hash(_selectedFilters));

@override
String toString() {
  return 'PlpFilterEntity(quickFilters: $quickFilters, sortingOptions: $sortingOptions, filterSections: $filterSections, selectedFilters: $selectedFilters)';
}


}

/// @nodoc
abstract mixin class _$PlpFilterEntityCopyWith<$Res> implements $PlpFilterEntityCopyWith<$Res> {
  factory _$PlpFilterEntityCopyWith(_PlpFilterEntity value, $Res Function(_PlpFilterEntity) _then) = __$PlpFilterEntityCopyWithImpl;
@override @useResult
$Res call({
 List<QuickFilterEntity> quickFilters, PlpSortingOptionsEntity? sortingOptions, List<FilterSectionEntity> filterSections, List<SelectedFilterEntity> selectedFilters
});


@override $PlpSortingOptionsEntityCopyWith<$Res>? get sortingOptions;

}
/// @nodoc
class __$PlpFilterEntityCopyWithImpl<$Res>
    implements _$PlpFilterEntityCopyWith<$Res> {
  __$PlpFilterEntityCopyWithImpl(this._self, this._then);

  final _PlpFilterEntity _self;
  final $Res Function(_PlpFilterEntity) _then;

/// Create a copy of PlpFilterEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? quickFilters = null,Object? sortingOptions = freezed,Object? filterSections = null,Object? selectedFilters = null,}) {
  return _then(_PlpFilterEntity(
quickFilters: null == quickFilters ? _self._quickFilters : quickFilters // ignore: cast_nullable_to_non_nullable
as List<QuickFilterEntity>,sortingOptions: freezed == sortingOptions ? _self.sortingOptions : sortingOptions // ignore: cast_nullable_to_non_nullable
as PlpSortingOptionsEntity?,filterSections: null == filterSections ? _self._filterSections : filterSections // ignore: cast_nullable_to_non_nullable
as List<FilterSectionEntity>,selectedFilters: null == selectedFilters ? _self._selectedFilters : selectedFilters // ignore: cast_nullable_to_non_nullable
as List<SelectedFilterEntity>,
  ));
}

/// Create a copy of PlpFilterEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlpSortingOptionsEntityCopyWith<$Res>? get sortingOptions {
    if (_self.sortingOptions == null) {
    return null;
  }

  return $PlpSortingOptionsEntityCopyWith<$Res>(_self.sortingOptions!, (value) {
    return _then(_self.copyWith(sortingOptions: value));
  });
}
}

// dart format on
