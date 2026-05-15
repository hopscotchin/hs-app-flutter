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
mixin _$PlpState {

 PlpStatus get status; List<ListingProductEntity> get products; List<PlpListItem> get listItems; int? get totalRecords; int get currentPage; bool get hasMore; bool get isLoadingMore; PlpFilterEntity? get plpFilter; List<SortingOptionEntity> get sortingOptions; Map<String, String> get appliedFilters; ListingHeaderEntity? get salePlanDetail; TopBannerEntity? get topBanner; String? get screenName; int? get orderRule; String? get errorMessage;
/// Create a copy of PlpState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlpStateCopyWith<PlpState> get copyWith => _$PlpStateCopyWithImpl<PlpState>(this as PlpState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlpState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.products, products)&&const DeepCollectionEquality().equals(other.listItems, listItems)&&(identical(other.totalRecords, totalRecords) || other.totalRecords == totalRecords)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.plpFilter, plpFilter) || other.plpFilter == plpFilter)&&const DeepCollectionEquality().equals(other.sortingOptions, sortingOptions)&&const DeepCollectionEquality().equals(other.appliedFilters, appliedFilters)&&(identical(other.salePlanDetail, salePlanDetail) || other.salePlanDetail == salePlanDetail)&&(identical(other.topBanner, topBanner) || other.topBanner == topBanner)&&(identical(other.screenName, screenName) || other.screenName == screenName)&&(identical(other.orderRule, orderRule) || other.orderRule == orderRule)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(products),const DeepCollectionEquality().hash(listItems),totalRecords,currentPage,hasMore,isLoadingMore,plpFilter,const DeepCollectionEquality().hash(sortingOptions),const DeepCollectionEquality().hash(appliedFilters),salePlanDetail,topBanner,screenName,orderRule,errorMessage);

@override
String toString() {
  return 'PlpState(status: $status, products: $products, listItems: $listItems, totalRecords: $totalRecords, currentPage: $currentPage, hasMore: $hasMore, isLoadingMore: $isLoadingMore, plpFilter: $plpFilter, sortingOptions: $sortingOptions, appliedFilters: $appliedFilters, salePlanDetail: $salePlanDetail, topBanner: $topBanner, screenName: $screenName, orderRule: $orderRule, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $PlpStateCopyWith<$Res>  {
  factory $PlpStateCopyWith(PlpState value, $Res Function(PlpState) _then) = _$PlpStateCopyWithImpl;
@useResult
$Res call({
 PlpStatus status, List<ListingProductEntity> products, List<PlpListItem> listItems, int? totalRecords, int currentPage, bool hasMore, bool isLoadingMore, PlpFilterEntity? plpFilter, List<SortingOptionEntity> sortingOptions, Map<String, String> appliedFilters, ListingHeaderEntity? salePlanDetail, TopBannerEntity? topBanner, String? screenName, int? orderRule, String? errorMessage
});




}
/// @nodoc
class _$PlpStateCopyWithImpl<$Res>
    implements $PlpStateCopyWith<$Res> {
  _$PlpStateCopyWithImpl(this._self, this._then);

  final PlpState _self;
  final $Res Function(PlpState) _then;

/// Create a copy of PlpState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? products = null,Object? listItems = null,Object? totalRecords = freezed,Object? currentPage = null,Object? hasMore = null,Object? isLoadingMore = null,Object? plpFilter = freezed,Object? sortingOptions = null,Object? appliedFilters = null,Object? salePlanDetail = freezed,Object? topBanner = freezed,Object? screenName = freezed,Object? orderRule = freezed,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PlpStatus,products: null == products ? _self.products : products // ignore: cast_nullable_to_non_nullable
as List<ListingProductEntity>,listItems: null == listItems ? _self.listItems : listItems // ignore: cast_nullable_to_non_nullable
as List<PlpListItem>,totalRecords: freezed == totalRecords ? _self.totalRecords : totalRecords // ignore: cast_nullable_to_non_nullable
as int?,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,plpFilter: freezed == plpFilter ? _self.plpFilter : plpFilter // ignore: cast_nullable_to_non_nullable
as PlpFilterEntity?,sortingOptions: null == sortingOptions ? _self.sortingOptions : sortingOptions // ignore: cast_nullable_to_non_nullable
as List<SortingOptionEntity>,appliedFilters: null == appliedFilters ? _self.appliedFilters : appliedFilters // ignore: cast_nullable_to_non_nullable
as Map<String, String>,salePlanDetail: freezed == salePlanDetail ? _self.salePlanDetail : salePlanDetail // ignore: cast_nullable_to_non_nullable
as ListingHeaderEntity?,topBanner: freezed == topBanner ? _self.topBanner : topBanner // ignore: cast_nullable_to_non_nullable
as TopBannerEntity?,screenName: freezed == screenName ? _self.screenName : screenName // ignore: cast_nullable_to_non_nullable
as String?,orderRule: freezed == orderRule ? _self.orderRule : orderRule // ignore: cast_nullable_to_non_nullable
as int?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PlpStatus status,  List<ListingProductEntity> products,  List<PlpListItem> listItems,  int? totalRecords,  int currentPage,  bool hasMore,  bool isLoadingMore,  PlpFilterEntity? plpFilter,  List<SortingOptionEntity> sortingOptions,  Map<String, String> appliedFilters,  ListingHeaderEntity? salePlanDetail,  TopBannerEntity? topBanner,  String? screenName,  int? orderRule,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlpState() when $default != null:
return $default(_that.status,_that.products,_that.listItems,_that.totalRecords,_that.currentPage,_that.hasMore,_that.isLoadingMore,_that.plpFilter,_that.sortingOptions,_that.appliedFilters,_that.salePlanDetail,_that.topBanner,_that.screenName,_that.orderRule,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PlpStatus status,  List<ListingProductEntity> products,  List<PlpListItem> listItems,  int? totalRecords,  int currentPage,  bool hasMore,  bool isLoadingMore,  PlpFilterEntity? plpFilter,  List<SortingOptionEntity> sortingOptions,  Map<String, String> appliedFilters,  ListingHeaderEntity? salePlanDetail,  TopBannerEntity? topBanner,  String? screenName,  int? orderRule,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _PlpState():
return $default(_that.status,_that.products,_that.listItems,_that.totalRecords,_that.currentPage,_that.hasMore,_that.isLoadingMore,_that.plpFilter,_that.sortingOptions,_that.appliedFilters,_that.salePlanDetail,_that.topBanner,_that.screenName,_that.orderRule,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PlpStatus status,  List<ListingProductEntity> products,  List<PlpListItem> listItems,  int? totalRecords,  int currentPage,  bool hasMore,  bool isLoadingMore,  PlpFilterEntity? plpFilter,  List<SortingOptionEntity> sortingOptions,  Map<String, String> appliedFilters,  ListingHeaderEntity? salePlanDetail,  TopBannerEntity? topBanner,  String? screenName,  int? orderRule,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _PlpState() when $default != null:
return $default(_that.status,_that.products,_that.listItems,_that.totalRecords,_that.currentPage,_that.hasMore,_that.isLoadingMore,_that.plpFilter,_that.sortingOptions,_that.appliedFilters,_that.salePlanDetail,_that.topBanner,_that.screenName,_that.orderRule,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _PlpState implements PlpState {
  const _PlpState({this.status = PlpStatus.initial, final  List<ListingProductEntity> products = const [], final  List<PlpListItem> listItems = const [], this.totalRecords, this.currentPage = 0, this.hasMore = false, this.isLoadingMore = false, this.plpFilter, final  List<SortingOptionEntity> sortingOptions = const [], final  Map<String, String> appliedFilters = const {}, this.salePlanDetail, this.topBanner, this.screenName, this.orderRule, this.errorMessage}): _products = products,_listItems = listItems,_sortingOptions = sortingOptions,_appliedFilters = appliedFilters;
  

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
 final  List<SortingOptionEntity> _sortingOptions;
@override@JsonKey() List<SortingOptionEntity> get sortingOptions {
  if (_sortingOptions is EqualUnmodifiableListView) return _sortingOptions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sortingOptions);
}

 final  Map<String, String> _appliedFilters;
@override@JsonKey() Map<String, String> get appliedFilters {
  if (_appliedFilters is EqualUnmodifiableMapView) return _appliedFilters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_appliedFilters);
}

@override final  ListingHeaderEntity? salePlanDetail;
@override final  TopBannerEntity? topBanner;
@override final  String? screenName;
@override final  int? orderRule;
@override final  String? errorMessage;

/// Create a copy of PlpState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlpStateCopyWith<_PlpState> get copyWith => __$PlpStateCopyWithImpl<_PlpState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlpState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._products, _products)&&const DeepCollectionEquality().equals(other._listItems, _listItems)&&(identical(other.totalRecords, totalRecords) || other.totalRecords == totalRecords)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.plpFilter, plpFilter) || other.plpFilter == plpFilter)&&const DeepCollectionEquality().equals(other._sortingOptions, _sortingOptions)&&const DeepCollectionEquality().equals(other._appliedFilters, _appliedFilters)&&(identical(other.salePlanDetail, salePlanDetail) || other.salePlanDetail == salePlanDetail)&&(identical(other.topBanner, topBanner) || other.topBanner == topBanner)&&(identical(other.screenName, screenName) || other.screenName == screenName)&&(identical(other.orderRule, orderRule) || other.orderRule == orderRule)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_products),const DeepCollectionEquality().hash(_listItems),totalRecords,currentPage,hasMore,isLoadingMore,plpFilter,const DeepCollectionEquality().hash(_sortingOptions),const DeepCollectionEquality().hash(_appliedFilters),salePlanDetail,topBanner,screenName,orderRule,errorMessage);

@override
String toString() {
  return 'PlpState(status: $status, products: $products, listItems: $listItems, totalRecords: $totalRecords, currentPage: $currentPage, hasMore: $hasMore, isLoadingMore: $isLoadingMore, plpFilter: $plpFilter, sortingOptions: $sortingOptions, appliedFilters: $appliedFilters, salePlanDetail: $salePlanDetail, topBanner: $topBanner, screenName: $screenName, orderRule: $orderRule, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$PlpStateCopyWith<$Res> implements $PlpStateCopyWith<$Res> {
  factory _$PlpStateCopyWith(_PlpState value, $Res Function(_PlpState) _then) = __$PlpStateCopyWithImpl;
@override @useResult
$Res call({
 PlpStatus status, List<ListingProductEntity> products, List<PlpListItem> listItems, int? totalRecords, int currentPage, bool hasMore, bool isLoadingMore, PlpFilterEntity? plpFilter, List<SortingOptionEntity> sortingOptions, Map<String, String> appliedFilters, ListingHeaderEntity? salePlanDetail, TopBannerEntity? topBanner, String? screenName, int? orderRule, String? errorMessage
});




}
/// @nodoc
class __$PlpStateCopyWithImpl<$Res>
    implements _$PlpStateCopyWith<$Res> {
  __$PlpStateCopyWithImpl(this._self, this._then);

  final _PlpState _self;
  final $Res Function(_PlpState) _then;

/// Create a copy of PlpState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? products = null,Object? listItems = null,Object? totalRecords = freezed,Object? currentPage = null,Object? hasMore = null,Object? isLoadingMore = null,Object? plpFilter = freezed,Object? sortingOptions = null,Object? appliedFilters = null,Object? salePlanDetail = freezed,Object? topBanner = freezed,Object? screenName = freezed,Object? orderRule = freezed,Object? errorMessage = freezed,}) {
  return _then(_PlpState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PlpStatus,products: null == products ? _self._products : products // ignore: cast_nullable_to_non_nullable
as List<ListingProductEntity>,listItems: null == listItems ? _self._listItems : listItems // ignore: cast_nullable_to_non_nullable
as List<PlpListItem>,totalRecords: freezed == totalRecords ? _self.totalRecords : totalRecords // ignore: cast_nullable_to_non_nullable
as int?,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,plpFilter: freezed == plpFilter ? _self.plpFilter : plpFilter // ignore: cast_nullable_to_non_nullable
as PlpFilterEntity?,sortingOptions: null == sortingOptions ? _self._sortingOptions : sortingOptions // ignore: cast_nullable_to_non_nullable
as List<SortingOptionEntity>,appliedFilters: null == appliedFilters ? _self._appliedFilters : appliedFilters // ignore: cast_nullable_to_non_nullable
as Map<String, String>,salePlanDetail: freezed == salePlanDetail ? _self.salePlanDetail : salePlanDetail // ignore: cast_nullable_to_non_nullable
as ListingHeaderEntity?,topBanner: freezed == topBanner ? _self.topBanner : topBanner // ignore: cast_nullable_to_non_nullable
as TopBannerEntity?,screenName: freezed == screenName ? _self.screenName : screenName // ignore: cast_nullable_to_non_nullable
as String?,orderRule: freezed == orderRule ? _self.orderRule : orderRule // ignore: cast_nullable_to_non_nullable
as int?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
