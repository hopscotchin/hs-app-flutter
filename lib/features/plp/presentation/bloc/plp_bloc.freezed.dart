// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plp_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlpEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlpEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PlpEvent()';
}


}

/// @nodoc
class $PlpEventCopyWith<$Res>  {
$PlpEventCopyWith(PlpEvent _, $Res Function(PlpEvent) __);
}


/// Adds pattern-matching-related methods to [PlpEvent].
extension PlpEventPatterns on PlpEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoadPlpData value)?  loadPlpData,TResult Function( LoadMorePlpData value)?  loadMore,TResult Function( ApplyFilter value)?  applyFilter,TResult Function( ApplyMultipleFilters value)?  applyMultipleFilters,TResult Function( RemoveFilter value)?  removeFilter,TResult Function( ClearAllFilters value)?  clearAllFilters,TResult Function( ApplySort value)?  applySort,TResult Function( ApplyFloatingFilter value)?  applyFloatingFilter,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoadPlpData() when loadPlpData != null:
return loadPlpData(_that);case LoadMorePlpData() when loadMore != null:
return loadMore(_that);case ApplyFilter() when applyFilter != null:
return applyFilter(_that);case ApplyMultipleFilters() when applyMultipleFilters != null:
return applyMultipleFilters(_that);case RemoveFilter() when removeFilter != null:
return removeFilter(_that);case ClearAllFilters() when clearAllFilters != null:
return clearAllFilters(_that);case ApplySort() when applySort != null:
return applySort(_that);case ApplyFloatingFilter() when applyFloatingFilter != null:
return applyFloatingFilter(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoadPlpData value)  loadPlpData,required TResult Function( LoadMorePlpData value)  loadMore,required TResult Function( ApplyFilter value)  applyFilter,required TResult Function( ApplyMultipleFilters value)  applyMultipleFilters,required TResult Function( RemoveFilter value)  removeFilter,required TResult Function( ClearAllFilters value)  clearAllFilters,required TResult Function( ApplySort value)  applySort,required TResult Function( ApplyFloatingFilter value)  applyFloatingFilter,}){
final _that = this;
switch (_that) {
case LoadPlpData():
return loadPlpData(_that);case LoadMorePlpData():
return loadMore(_that);case ApplyFilter():
return applyFilter(_that);case ApplyMultipleFilters():
return applyMultipleFilters(_that);case RemoveFilter():
return removeFilter(_that);case ClearAllFilters():
return clearAllFilters(_that);case ApplySort():
return applySort(_that);case ApplyFloatingFilter():
return applyFloatingFilter(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoadPlpData value)?  loadPlpData,TResult? Function( LoadMorePlpData value)?  loadMore,TResult? Function( ApplyFilter value)?  applyFilter,TResult? Function( ApplyMultipleFilters value)?  applyMultipleFilters,TResult? Function( RemoveFilter value)?  removeFilter,TResult? Function( ClearAllFilters value)?  clearAllFilters,TResult? Function( ApplySort value)?  applySort,TResult? Function( ApplyFloatingFilter value)?  applyFloatingFilter,}){
final _that = this;
switch (_that) {
case LoadPlpData() when loadPlpData != null:
return loadPlpData(_that);case LoadMorePlpData() when loadMore != null:
return loadMore(_that);case ApplyFilter() when applyFilter != null:
return applyFilter(_that);case ApplyMultipleFilters() when applyMultipleFilters != null:
return applyMultipleFilters(_that);case RemoveFilter() when removeFilter != null:
return removeFilter(_that);case ClearAllFilters() when clearAllFilters != null:
return clearAllFilters(_that);case ApplySort() when applySort != null:
return applySort(_that);case ApplyFloatingFilter() when applyFloatingFilter != null:
return applyFloatingFilter(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( PageType pageType,  int plpId,  String? searchQuery,  String? categoryName,  String? rawSearchParams,  Map<String, String>? initialFilters)?  loadPlpData,TResult Function()?  loadMore,TResult Function( String key,  String value)?  applyFilter,TResult Function( Map<String, String> filters)?  applyMultipleFilters,TResult Function( SelectedFilterEntity filterToRemove)?  removeFilter,TResult Function()?  clearAllFilters,TResult Function( int orderRule)?  applySort,TResult Function( String key,  String value)?  applyFloatingFilter,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoadPlpData() when loadPlpData != null:
return loadPlpData(_that.pageType,_that.plpId,_that.searchQuery,_that.categoryName,_that.rawSearchParams,_that.initialFilters);case LoadMorePlpData() when loadMore != null:
return loadMore();case ApplyFilter() when applyFilter != null:
return applyFilter(_that.key,_that.value);case ApplyMultipleFilters() when applyMultipleFilters != null:
return applyMultipleFilters(_that.filters);case RemoveFilter() when removeFilter != null:
return removeFilter(_that.filterToRemove);case ClearAllFilters() when clearAllFilters != null:
return clearAllFilters();case ApplySort() when applySort != null:
return applySort(_that.orderRule);case ApplyFloatingFilter() when applyFloatingFilter != null:
return applyFloatingFilter(_that.key,_that.value);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( PageType pageType,  int plpId,  String? searchQuery,  String? categoryName,  String? rawSearchParams,  Map<String, String>? initialFilters)  loadPlpData,required TResult Function()  loadMore,required TResult Function( String key,  String value)  applyFilter,required TResult Function( Map<String, String> filters)  applyMultipleFilters,required TResult Function( SelectedFilterEntity filterToRemove)  removeFilter,required TResult Function()  clearAllFilters,required TResult Function( int orderRule)  applySort,required TResult Function( String key,  String value)  applyFloatingFilter,}) {final _that = this;
switch (_that) {
case LoadPlpData():
return loadPlpData(_that.pageType,_that.plpId,_that.searchQuery,_that.categoryName,_that.rawSearchParams,_that.initialFilters);case LoadMorePlpData():
return loadMore();case ApplyFilter():
return applyFilter(_that.key,_that.value);case ApplyMultipleFilters():
return applyMultipleFilters(_that.filters);case RemoveFilter():
return removeFilter(_that.filterToRemove);case ClearAllFilters():
return clearAllFilters();case ApplySort():
return applySort(_that.orderRule);case ApplyFloatingFilter():
return applyFloatingFilter(_that.key,_that.value);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( PageType pageType,  int plpId,  String? searchQuery,  String? categoryName,  String? rawSearchParams,  Map<String, String>? initialFilters)?  loadPlpData,TResult? Function()?  loadMore,TResult? Function( String key,  String value)?  applyFilter,TResult? Function( Map<String, String> filters)?  applyMultipleFilters,TResult? Function( SelectedFilterEntity filterToRemove)?  removeFilter,TResult? Function()?  clearAllFilters,TResult? Function( int orderRule)?  applySort,TResult? Function( String key,  String value)?  applyFloatingFilter,}) {final _that = this;
switch (_that) {
case LoadPlpData() when loadPlpData != null:
return loadPlpData(_that.pageType,_that.plpId,_that.searchQuery,_that.categoryName,_that.rawSearchParams,_that.initialFilters);case LoadMorePlpData() when loadMore != null:
return loadMore();case ApplyFilter() when applyFilter != null:
return applyFilter(_that.key,_that.value);case ApplyMultipleFilters() when applyMultipleFilters != null:
return applyMultipleFilters(_that.filters);case RemoveFilter() when removeFilter != null:
return removeFilter(_that.filterToRemove);case ClearAllFilters() when clearAllFilters != null:
return clearAllFilters();case ApplySort() when applySort != null:
return applySort(_that.orderRule);case ApplyFloatingFilter() when applyFloatingFilter != null:
return applyFloatingFilter(_that.key,_that.value);case _:
  return null;

}
}

}

/// @nodoc


class LoadPlpData implements PlpEvent {
  const LoadPlpData({required this.pageType, required this.plpId, this.searchQuery, this.categoryName, this.rawSearchParams, final  Map<String, String>? initialFilters}): _initialFilters = initialFilters;
  

 final  PageType pageType;
 final  int plpId;
 final  String? searchQuery;
 final  String? categoryName;
 final  String? rawSearchParams;
 final  Map<String, String>? _initialFilters;
 Map<String, String>? get initialFilters {
  final value = _initialFilters;
  if (value == null) return null;
  if (_initialFilters is EqualUnmodifiableMapView) return _initialFilters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of PlpEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadPlpDataCopyWith<LoadPlpData> get copyWith => _$LoadPlpDataCopyWithImpl<LoadPlpData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadPlpData&&(identical(other.pageType, pageType) || other.pageType == pageType)&&(identical(other.plpId, plpId) || other.plpId == plpId)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.rawSearchParams, rawSearchParams) || other.rawSearchParams == rawSearchParams)&&const DeepCollectionEquality().equals(other._initialFilters, _initialFilters));
}


@override
int get hashCode => Object.hash(runtimeType,pageType,plpId,searchQuery,categoryName,rawSearchParams,const DeepCollectionEquality().hash(_initialFilters));

@override
String toString() {
  return 'PlpEvent.loadPlpData(pageType: $pageType, plpId: $plpId, searchQuery: $searchQuery, categoryName: $categoryName, rawSearchParams: $rawSearchParams, initialFilters: $initialFilters)';
}


}

/// @nodoc
abstract mixin class $LoadPlpDataCopyWith<$Res> implements $PlpEventCopyWith<$Res> {
  factory $LoadPlpDataCopyWith(LoadPlpData value, $Res Function(LoadPlpData) _then) = _$LoadPlpDataCopyWithImpl;
@useResult
$Res call({
 PageType pageType, int plpId, String? searchQuery, String? categoryName, String? rawSearchParams, Map<String, String>? initialFilters
});




}
/// @nodoc
class _$LoadPlpDataCopyWithImpl<$Res>
    implements $LoadPlpDataCopyWith<$Res> {
  _$LoadPlpDataCopyWithImpl(this._self, this._then);

  final LoadPlpData _self;
  final $Res Function(LoadPlpData) _then;

/// Create a copy of PlpEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? pageType = null,Object? plpId = null,Object? searchQuery = freezed,Object? categoryName = freezed,Object? rawSearchParams = freezed,Object? initialFilters = freezed,}) {
  return _then(LoadPlpData(
pageType: null == pageType ? _self.pageType : pageType // ignore: cast_nullable_to_non_nullable
as PageType,plpId: null == plpId ? _self.plpId : plpId // ignore: cast_nullable_to_non_nullable
as int,searchQuery: freezed == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String?,categoryName: freezed == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String?,rawSearchParams: freezed == rawSearchParams ? _self.rawSearchParams : rawSearchParams // ignore: cast_nullable_to_non_nullable
as String?,initialFilters: freezed == initialFilters ? _self._initialFilters : initialFilters // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,
  ));
}


}

/// @nodoc


class LoadMorePlpData implements PlpEvent {
  const LoadMorePlpData();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadMorePlpData);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PlpEvent.loadMore()';
}


}




/// @nodoc


class ApplyFilter implements PlpEvent {
  const ApplyFilter({required this.key, required this.value});
  

 final  String key;
 final  String value;

/// Create a copy of PlpEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApplyFilterCopyWith<ApplyFilter> get copyWith => _$ApplyFilterCopyWithImpl<ApplyFilter>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApplyFilter&&(identical(other.key, key) || other.key == key)&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,key,value);

@override
String toString() {
  return 'PlpEvent.applyFilter(key: $key, value: $value)';
}


}

/// @nodoc
abstract mixin class $ApplyFilterCopyWith<$Res> implements $PlpEventCopyWith<$Res> {
  factory $ApplyFilterCopyWith(ApplyFilter value, $Res Function(ApplyFilter) _then) = _$ApplyFilterCopyWithImpl;
@useResult
$Res call({
 String key, String value
});




}
/// @nodoc
class _$ApplyFilterCopyWithImpl<$Res>
    implements $ApplyFilterCopyWith<$Res> {
  _$ApplyFilterCopyWithImpl(this._self, this._then);

  final ApplyFilter _self;
  final $Res Function(ApplyFilter) _then;

/// Create a copy of PlpEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? key = null,Object? value = null,}) {
  return _then(ApplyFilter(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ApplyMultipleFilters implements PlpEvent {
  const ApplyMultipleFilters({required final  Map<String, String> filters}): _filters = filters;
  

 final  Map<String, String> _filters;
 Map<String, String> get filters {
  if (_filters is EqualUnmodifiableMapView) return _filters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_filters);
}


/// Create a copy of PlpEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApplyMultipleFiltersCopyWith<ApplyMultipleFilters> get copyWith => _$ApplyMultipleFiltersCopyWithImpl<ApplyMultipleFilters>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApplyMultipleFilters&&const DeepCollectionEquality().equals(other._filters, _filters));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_filters));

@override
String toString() {
  return 'PlpEvent.applyMultipleFilters(filters: $filters)';
}


}

/// @nodoc
abstract mixin class $ApplyMultipleFiltersCopyWith<$Res> implements $PlpEventCopyWith<$Res> {
  factory $ApplyMultipleFiltersCopyWith(ApplyMultipleFilters value, $Res Function(ApplyMultipleFilters) _then) = _$ApplyMultipleFiltersCopyWithImpl;
@useResult
$Res call({
 Map<String, String> filters
});




}
/// @nodoc
class _$ApplyMultipleFiltersCopyWithImpl<$Res>
    implements $ApplyMultipleFiltersCopyWith<$Res> {
  _$ApplyMultipleFiltersCopyWithImpl(this._self, this._then);

  final ApplyMultipleFilters _self;
  final $Res Function(ApplyMultipleFilters) _then;

/// Create a copy of PlpEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? filters = null,}) {
  return _then(ApplyMultipleFilters(
filters: null == filters ? _self._filters : filters // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}

/// @nodoc


class RemoveFilter implements PlpEvent {
  const RemoveFilter({required this.filterToRemove});
  

 final  SelectedFilterEntity filterToRemove;

/// Create a copy of PlpEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RemoveFilterCopyWith<RemoveFilter> get copyWith => _$RemoveFilterCopyWithImpl<RemoveFilter>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RemoveFilter&&(identical(other.filterToRemove, filterToRemove) || other.filterToRemove == filterToRemove));
}


@override
int get hashCode => Object.hash(runtimeType,filterToRemove);

@override
String toString() {
  return 'PlpEvent.removeFilter(filterToRemove: $filterToRemove)';
}


}

/// @nodoc
abstract mixin class $RemoveFilterCopyWith<$Res> implements $PlpEventCopyWith<$Res> {
  factory $RemoveFilterCopyWith(RemoveFilter value, $Res Function(RemoveFilter) _then) = _$RemoveFilterCopyWithImpl;
@useResult
$Res call({
 SelectedFilterEntity filterToRemove
});


$SelectedFilterEntityCopyWith<$Res> get filterToRemove;

}
/// @nodoc
class _$RemoveFilterCopyWithImpl<$Res>
    implements $RemoveFilterCopyWith<$Res> {
  _$RemoveFilterCopyWithImpl(this._self, this._then);

  final RemoveFilter _self;
  final $Res Function(RemoveFilter) _then;

/// Create a copy of PlpEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? filterToRemove = null,}) {
  return _then(RemoveFilter(
filterToRemove: null == filterToRemove ? _self.filterToRemove : filterToRemove // ignore: cast_nullable_to_non_nullable
as SelectedFilterEntity,
  ));
}

/// Create a copy of PlpEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SelectedFilterEntityCopyWith<$Res> get filterToRemove {
  
  return $SelectedFilterEntityCopyWith<$Res>(_self.filterToRemove, (value) {
    return _then(_self.copyWith(filterToRemove: value));
  });
}
}

/// @nodoc


class ClearAllFilters implements PlpEvent {
  const ClearAllFilters();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClearAllFilters);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PlpEvent.clearAllFilters()';
}


}




/// @nodoc


class ApplySort implements PlpEvent {
  const ApplySort({required this.orderRule});
  

 final  int orderRule;

/// Create a copy of PlpEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApplySortCopyWith<ApplySort> get copyWith => _$ApplySortCopyWithImpl<ApplySort>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApplySort&&(identical(other.orderRule, orderRule) || other.orderRule == orderRule));
}


@override
int get hashCode => Object.hash(runtimeType,orderRule);

@override
String toString() {
  return 'PlpEvent.applySort(orderRule: $orderRule)';
}


}

/// @nodoc
abstract mixin class $ApplySortCopyWith<$Res> implements $PlpEventCopyWith<$Res> {
  factory $ApplySortCopyWith(ApplySort value, $Res Function(ApplySort) _then) = _$ApplySortCopyWithImpl;
@useResult
$Res call({
 int orderRule
});




}
/// @nodoc
class _$ApplySortCopyWithImpl<$Res>
    implements $ApplySortCopyWith<$Res> {
  _$ApplySortCopyWithImpl(this._self, this._then);

  final ApplySort _self;
  final $Res Function(ApplySort) _then;

/// Create a copy of PlpEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? orderRule = null,}) {
  return _then(ApplySort(
orderRule: null == orderRule ? _self.orderRule : orderRule // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class ApplyFloatingFilter implements PlpEvent {
  const ApplyFloatingFilter({required this.key, required this.value});
  

 final  String key;
 final  String value;

/// Create a copy of PlpEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApplyFloatingFilterCopyWith<ApplyFloatingFilter> get copyWith => _$ApplyFloatingFilterCopyWithImpl<ApplyFloatingFilter>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApplyFloatingFilter&&(identical(other.key, key) || other.key == key)&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,key,value);

@override
String toString() {
  return 'PlpEvent.applyFloatingFilter(key: $key, value: $value)';
}


}

/// @nodoc
abstract mixin class $ApplyFloatingFilterCopyWith<$Res> implements $PlpEventCopyWith<$Res> {
  factory $ApplyFloatingFilterCopyWith(ApplyFloatingFilter value, $Res Function(ApplyFloatingFilter) _then) = _$ApplyFloatingFilterCopyWithImpl;
@useResult
$Res call({
 String key, String value
});




}
/// @nodoc
class _$ApplyFloatingFilterCopyWithImpl<$Res>
    implements $ApplyFloatingFilterCopyWith<$Res> {
  _$ApplyFloatingFilterCopyWithImpl(this._self, this._then);

  final ApplyFloatingFilter _self;
  final $Res Function(ApplyFloatingFilter) _then;

/// Create a copy of PlpEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? key = null,Object? value = null,}) {
  return _then(ApplyFloatingFilter(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$PlpState {

 PlpStatus get status; List<ListingProductEntity> get products; List<PlpListItem> get listItems; int? get totalRecords; int get currentPage; bool get hasMore; bool get isLoadingMore; PlpFilterEntity? get plpFilter; List<BannerEntity> get banners; Map<String, String> get appliedFilters; String? get screenName; String? get screenSubtitle; String? get errorMessage; QueryCorrectionEntity? get queryCorrection; int? get currentOrderRule; List<MessageBarEntity> get messageBars;/// Which kind of listing this is. Retained from [LoadPlpData] because
/// analytics needs it: `from_page` on every PDP event is `"boutique"` for a
/// boutique and `"plp"` for a category listing, and Android distinguishes
/// them (`PLPProductViewModel.java:171` vs
/// `ProductListPageActivity.java:794`). Nothing else reads it — the query
/// builder keeps its own copy for endpoint selection.
 PageType get pageType;
/// Create a copy of PlpState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlpStateCopyWith<PlpState> get copyWith => _$PlpStateCopyWithImpl<PlpState>(this as PlpState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlpState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.products, products)&&const DeepCollectionEquality().equals(other.listItems, listItems)&&(identical(other.totalRecords, totalRecords) || other.totalRecords == totalRecords)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.plpFilter, plpFilter) || other.plpFilter == plpFilter)&&const DeepCollectionEquality().equals(other.banners, banners)&&const DeepCollectionEquality().equals(other.appliedFilters, appliedFilters)&&(identical(other.screenName, screenName) || other.screenName == screenName)&&(identical(other.screenSubtitle, screenSubtitle) || other.screenSubtitle == screenSubtitle)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.queryCorrection, queryCorrection) || other.queryCorrection == queryCorrection)&&(identical(other.currentOrderRule, currentOrderRule) || other.currentOrderRule == currentOrderRule)&&const DeepCollectionEquality().equals(other.messageBars, messageBars)&&(identical(other.pageType, pageType) || other.pageType == pageType));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(products),const DeepCollectionEquality().hash(listItems),totalRecords,currentPage,hasMore,isLoadingMore,plpFilter,const DeepCollectionEquality().hash(banners),const DeepCollectionEquality().hash(appliedFilters),screenName,screenSubtitle,errorMessage,queryCorrection,currentOrderRule,const DeepCollectionEquality().hash(messageBars),pageType);

@override
String toString() {
  return 'PlpState(status: $status, products: $products, listItems: $listItems, totalRecords: $totalRecords, currentPage: $currentPage, hasMore: $hasMore, isLoadingMore: $isLoadingMore, plpFilter: $plpFilter, banners: $banners, appliedFilters: $appliedFilters, screenName: $screenName, screenSubtitle: $screenSubtitle, errorMessage: $errorMessage, queryCorrection: $queryCorrection, currentOrderRule: $currentOrderRule, messageBars: $messageBars, pageType: $pageType)';
}


}

/// @nodoc
abstract mixin class $PlpStateCopyWith<$Res>  {
  factory $PlpStateCopyWith(PlpState value, $Res Function(PlpState) _then) = _$PlpStateCopyWithImpl;
@useResult
$Res call({
 PlpStatus status, List<ListingProductEntity> products, List<PlpListItem> listItems, int? totalRecords, int currentPage, bool hasMore, bool isLoadingMore, PlpFilterEntity? plpFilter, List<BannerEntity> banners, Map<String, String> appliedFilters, String? screenName, String? screenSubtitle, String? errorMessage, QueryCorrectionEntity? queryCorrection, int? currentOrderRule, List<MessageBarEntity> messageBars, PageType pageType
});


$PlpFilterEntityCopyWith<$Res>? get plpFilter;$QueryCorrectionEntityCopyWith<$Res>? get queryCorrection;

}
/// @nodoc
class _$PlpStateCopyWithImpl<$Res>
    implements $PlpStateCopyWith<$Res> {
  _$PlpStateCopyWithImpl(this._self, this._then);

  final PlpState _self;
  final $Res Function(PlpState) _then;

/// Create a copy of PlpState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? products = null,Object? listItems = null,Object? totalRecords = freezed,Object? currentPage = null,Object? hasMore = null,Object? isLoadingMore = null,Object? plpFilter = freezed,Object? banners = null,Object? appliedFilters = null,Object? screenName = freezed,Object? screenSubtitle = freezed,Object? errorMessage = freezed,Object? queryCorrection = freezed,Object? currentOrderRule = freezed,Object? messageBars = null,Object? pageType = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PlpStatus,products: null == products ? _self.products : products // ignore: cast_nullable_to_non_nullable
as List<ListingProductEntity>,listItems: null == listItems ? _self.listItems : listItems // ignore: cast_nullable_to_non_nullable
as List<PlpListItem>,totalRecords: freezed == totalRecords ? _self.totalRecords : totalRecords // ignore: cast_nullable_to_non_nullable
as int?,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,plpFilter: freezed == plpFilter ? _self.plpFilter : plpFilter // ignore: cast_nullable_to_non_nullable
as PlpFilterEntity?,banners: null == banners ? _self.banners : banners // ignore: cast_nullable_to_non_nullable
as List<BannerEntity>,appliedFilters: null == appliedFilters ? _self.appliedFilters : appliedFilters // ignore: cast_nullable_to_non_nullable
as Map<String, String>,screenName: freezed == screenName ? _self.screenName : screenName // ignore: cast_nullable_to_non_nullable
as String?,screenSubtitle: freezed == screenSubtitle ? _self.screenSubtitle : screenSubtitle // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,queryCorrection: freezed == queryCorrection ? _self.queryCorrection : queryCorrection // ignore: cast_nullable_to_non_nullable
as QueryCorrectionEntity?,currentOrderRule: freezed == currentOrderRule ? _self.currentOrderRule : currentOrderRule // ignore: cast_nullable_to_non_nullable
as int?,messageBars: null == messageBars ? _self.messageBars : messageBars // ignore: cast_nullable_to_non_nullable
as List<MessageBarEntity>,pageType: null == pageType ? _self.pageType : pageType // ignore: cast_nullable_to_non_nullable
as PageType,
  ));
}
/// Create a copy of PlpState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlpFilterEntityCopyWith<$Res>? get plpFilter {
    if (_self.plpFilter == null) {
    return null;
  }

  return $PlpFilterEntityCopyWith<$Res>(_self.plpFilter!, (value) {
    return _then(_self.copyWith(plpFilter: value));
  });
}/// Create a copy of PlpState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QueryCorrectionEntityCopyWith<$Res>? get queryCorrection {
    if (_self.queryCorrection == null) {
    return null;
  }

  return $QueryCorrectionEntityCopyWith<$Res>(_self.queryCorrection!, (value) {
    return _then(_self.copyWith(queryCorrection: value));
  });
}
}


/// Adds pattern-matching-related methods to [PlpState].
extension PlpStatePatterns on PlpState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlpState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlpState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlpState value)  $default,){
final _that = this;
switch (_that) {
case _PlpState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlpState value)?  $default,){
final _that = this;
switch (_that) {
case _PlpState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PlpStatus status,  List<ListingProductEntity> products,  List<PlpListItem> listItems,  int? totalRecords,  int currentPage,  bool hasMore,  bool isLoadingMore,  PlpFilterEntity? plpFilter,  List<BannerEntity> banners,  Map<String, String> appliedFilters,  String? screenName,  String? screenSubtitle,  String? errorMessage,  QueryCorrectionEntity? queryCorrection,  int? currentOrderRule,  List<MessageBarEntity> messageBars,  PageType pageType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlpState() when $default != null:
return $default(_that.status,_that.products,_that.listItems,_that.totalRecords,_that.currentPage,_that.hasMore,_that.isLoadingMore,_that.plpFilter,_that.banners,_that.appliedFilters,_that.screenName,_that.screenSubtitle,_that.errorMessage,_that.queryCorrection,_that.currentOrderRule,_that.messageBars,_that.pageType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PlpStatus status,  List<ListingProductEntity> products,  List<PlpListItem> listItems,  int? totalRecords,  int currentPage,  bool hasMore,  bool isLoadingMore,  PlpFilterEntity? plpFilter,  List<BannerEntity> banners,  Map<String, String> appliedFilters,  String? screenName,  String? screenSubtitle,  String? errorMessage,  QueryCorrectionEntity? queryCorrection,  int? currentOrderRule,  List<MessageBarEntity> messageBars,  PageType pageType)  $default,) {final _that = this;
switch (_that) {
case _PlpState():
return $default(_that.status,_that.products,_that.listItems,_that.totalRecords,_that.currentPage,_that.hasMore,_that.isLoadingMore,_that.plpFilter,_that.banners,_that.appliedFilters,_that.screenName,_that.screenSubtitle,_that.errorMessage,_that.queryCorrection,_that.currentOrderRule,_that.messageBars,_that.pageType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PlpStatus status,  List<ListingProductEntity> products,  List<PlpListItem> listItems,  int? totalRecords,  int currentPage,  bool hasMore,  bool isLoadingMore,  PlpFilterEntity? plpFilter,  List<BannerEntity> banners,  Map<String, String> appliedFilters,  String? screenName,  String? screenSubtitle,  String? errorMessage,  QueryCorrectionEntity? queryCorrection,  int? currentOrderRule,  List<MessageBarEntity> messageBars,  PageType pageType)?  $default,) {final _that = this;
switch (_that) {
case _PlpState() when $default != null:
return $default(_that.status,_that.products,_that.listItems,_that.totalRecords,_that.currentPage,_that.hasMore,_that.isLoadingMore,_that.plpFilter,_that.banners,_that.appliedFilters,_that.screenName,_that.screenSubtitle,_that.errorMessage,_that.queryCorrection,_that.currentOrderRule,_that.messageBars,_that.pageType);case _:
  return null;

}
}

}

/// @nodoc


class _PlpState implements PlpState {
  const _PlpState({this.status = PlpStatus.initial, final  List<ListingProductEntity> products = const [], final  List<PlpListItem> listItems = const [], this.totalRecords, this.currentPage = 0, this.hasMore = false, this.isLoadingMore = false, this.plpFilter, final  List<BannerEntity> banners = const [], final  Map<String, String> appliedFilters = const {}, this.screenName, this.screenSubtitle, this.errorMessage, this.queryCorrection, this.currentOrderRule, final  List<MessageBarEntity> messageBars = const <MessageBarEntity>[], this.pageType = PageType.plp}): _products = products,_listItems = listItems,_banners = banners,_appliedFilters = appliedFilters,_messageBars = messageBars;
  

@override@JsonKey() final  PlpStatus status;
 final  List<ListingProductEntity> _products;
@override@JsonKey() List<ListingProductEntity> get products {
  if (_products is EqualUnmodifiableListView) return _products;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_products);
}

 final  List<PlpListItem> _listItems;
@override@JsonKey() List<PlpListItem> get listItems {
  if (_listItems is EqualUnmodifiableListView) return _listItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_listItems);
}

@override final  int? totalRecords;
@override@JsonKey() final  int currentPage;
@override@JsonKey() final  bool hasMore;
@override@JsonKey() final  bool isLoadingMore;
@override final  PlpFilterEntity? plpFilter;
 final  List<BannerEntity> _banners;
@override@JsonKey() List<BannerEntity> get banners {
  if (_banners is EqualUnmodifiableListView) return _banners;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_banners);
}

 final  Map<String, String> _appliedFilters;
@override@JsonKey() Map<String, String> get appliedFilters {
  if (_appliedFilters is EqualUnmodifiableMapView) return _appliedFilters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_appliedFilters);
}

@override final  String? screenName;
@override final  String? screenSubtitle;
@override final  String? errorMessage;
@override final  QueryCorrectionEntity? queryCorrection;
@override final  int? currentOrderRule;
 final  List<MessageBarEntity> _messageBars;
@override@JsonKey() List<MessageBarEntity> get messageBars {
  if (_messageBars is EqualUnmodifiableListView) return _messageBars;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messageBars);
}

/// Which kind of listing this is. Retained from [LoadPlpData] because
/// analytics needs it: `from_page` on every PDP event is `"boutique"` for a
/// boutique and `"plp"` for a category listing, and Android distinguishes
/// them (`PLPProductViewModel.java:171` vs
/// `ProductListPageActivity.java:794`). Nothing else reads it — the query
/// builder keeps its own copy for endpoint selection.
@override@JsonKey() final  PageType pageType;

/// Create a copy of PlpState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlpStateCopyWith<_PlpState> get copyWith => __$PlpStateCopyWithImpl<_PlpState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlpState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._products, _products)&&const DeepCollectionEquality().equals(other._listItems, _listItems)&&(identical(other.totalRecords, totalRecords) || other.totalRecords == totalRecords)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.plpFilter, plpFilter) || other.plpFilter == plpFilter)&&const DeepCollectionEquality().equals(other._banners, _banners)&&const DeepCollectionEquality().equals(other._appliedFilters, _appliedFilters)&&(identical(other.screenName, screenName) || other.screenName == screenName)&&(identical(other.screenSubtitle, screenSubtitle) || other.screenSubtitle == screenSubtitle)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.queryCorrection, queryCorrection) || other.queryCorrection == queryCorrection)&&(identical(other.currentOrderRule, currentOrderRule) || other.currentOrderRule == currentOrderRule)&&const DeepCollectionEquality().equals(other._messageBars, _messageBars)&&(identical(other.pageType, pageType) || other.pageType == pageType));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_products),const DeepCollectionEquality().hash(_listItems),totalRecords,currentPage,hasMore,isLoadingMore,plpFilter,const DeepCollectionEquality().hash(_banners),const DeepCollectionEquality().hash(_appliedFilters),screenName,screenSubtitle,errorMessage,queryCorrection,currentOrderRule,const DeepCollectionEquality().hash(_messageBars),pageType);

@override
String toString() {
  return 'PlpState(status: $status, products: $products, listItems: $listItems, totalRecords: $totalRecords, currentPage: $currentPage, hasMore: $hasMore, isLoadingMore: $isLoadingMore, plpFilter: $plpFilter, banners: $banners, appliedFilters: $appliedFilters, screenName: $screenName, screenSubtitle: $screenSubtitle, errorMessage: $errorMessage, queryCorrection: $queryCorrection, currentOrderRule: $currentOrderRule, messageBars: $messageBars, pageType: $pageType)';
}


}

/// @nodoc
abstract mixin class _$PlpStateCopyWith<$Res> implements $PlpStateCopyWith<$Res> {
  factory _$PlpStateCopyWith(_PlpState value, $Res Function(_PlpState) _then) = __$PlpStateCopyWithImpl;
@override @useResult
$Res call({
 PlpStatus status, List<ListingProductEntity> products, List<PlpListItem> listItems, int? totalRecords, int currentPage, bool hasMore, bool isLoadingMore, PlpFilterEntity? plpFilter, List<BannerEntity> banners, Map<String, String> appliedFilters, String? screenName, String? screenSubtitle, String? errorMessage, QueryCorrectionEntity? queryCorrection, int? currentOrderRule, List<MessageBarEntity> messageBars, PageType pageType
});


@override $PlpFilterEntityCopyWith<$Res>? get plpFilter;@override $QueryCorrectionEntityCopyWith<$Res>? get queryCorrection;

}
/// @nodoc
class __$PlpStateCopyWithImpl<$Res>
    implements _$PlpStateCopyWith<$Res> {
  __$PlpStateCopyWithImpl(this._self, this._then);

  final _PlpState _self;
  final $Res Function(_PlpState) _then;

/// Create a copy of PlpState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? products = null,Object? listItems = null,Object? totalRecords = freezed,Object? currentPage = null,Object? hasMore = null,Object? isLoadingMore = null,Object? plpFilter = freezed,Object? banners = null,Object? appliedFilters = null,Object? screenName = freezed,Object? screenSubtitle = freezed,Object? errorMessage = freezed,Object? queryCorrection = freezed,Object? currentOrderRule = freezed,Object? messageBars = null,Object? pageType = null,}) {
  return _then(_PlpState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PlpStatus,products: null == products ? _self._products : products // ignore: cast_nullable_to_non_nullable
as List<ListingProductEntity>,listItems: null == listItems ? _self._listItems : listItems // ignore: cast_nullable_to_non_nullable
as List<PlpListItem>,totalRecords: freezed == totalRecords ? _self.totalRecords : totalRecords // ignore: cast_nullable_to_non_nullable
as int?,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,plpFilter: freezed == plpFilter ? _self.plpFilter : plpFilter // ignore: cast_nullable_to_non_nullable
as PlpFilterEntity?,banners: null == banners ? _self._banners : banners // ignore: cast_nullable_to_non_nullable
as List<BannerEntity>,appliedFilters: null == appliedFilters ? _self._appliedFilters : appliedFilters // ignore: cast_nullable_to_non_nullable
as Map<String, String>,screenName: freezed == screenName ? _self.screenName : screenName // ignore: cast_nullable_to_non_nullable
as String?,screenSubtitle: freezed == screenSubtitle ? _self.screenSubtitle : screenSubtitle // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,queryCorrection: freezed == queryCorrection ? _self.queryCorrection : queryCorrection // ignore: cast_nullable_to_non_nullable
as QueryCorrectionEntity?,currentOrderRule: freezed == currentOrderRule ? _self.currentOrderRule : currentOrderRule // ignore: cast_nullable_to_non_nullable
as int?,messageBars: null == messageBars ? _self._messageBars : messageBars // ignore: cast_nullable_to_non_nullable
as List<MessageBarEntity>,pageType: null == pageType ? _self.pageType : pageType // ignore: cast_nullable_to_non_nullable
as PageType,
  ));
}

/// Create a copy of PlpState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlpFilterEntityCopyWith<$Res>? get plpFilter {
    if (_self.plpFilter == null) {
    return null;
  }

  return $PlpFilterEntityCopyWith<$Res>(_self.plpFilter!, (value) {
    return _then(_self.copyWith(plpFilter: value));
  });
}/// Create a copy of PlpState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QueryCorrectionEntityCopyWith<$Res>? get queryCorrection {
    if (_self.queryCorrection == null) {
    return null;
  }

  return $QueryCorrectionEntityCopyWith<$Res>(_self.queryCorrection!, (value) {
    return _then(_self.copyWith(queryCorrection: value));
  });
}
}

// dart format on
