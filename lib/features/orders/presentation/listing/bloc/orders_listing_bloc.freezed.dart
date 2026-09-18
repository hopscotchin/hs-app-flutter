// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'orders_listing_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OrdersListingEvent {

 OrdersTab get tab;
/// Create a copy of OrdersListingEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrdersListingEventCopyWith<OrdersListingEvent> get copyWith => _$OrdersListingEventCopyWithImpl<OrdersListingEvent>(this as OrdersListingEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrdersListingEvent&&(identical(other.tab, tab) || other.tab == tab));
}


@override
int get hashCode => Object.hash(runtimeType,tab);

@override
String toString() {
  return 'OrdersListingEvent(tab: $tab)';
}


}

/// @nodoc
abstract mixin class $OrdersListingEventCopyWith<$Res>  {
  factory $OrdersListingEventCopyWith(OrdersListingEvent value, $Res Function(OrdersListingEvent) _then) = _$OrdersListingEventCopyWithImpl;
@useResult
$Res call({
 OrdersTab tab
});




}
/// @nodoc
class _$OrdersListingEventCopyWithImpl<$Res>
    implements $OrdersListingEventCopyWith<$Res> {
  _$OrdersListingEventCopyWithImpl(this._self, this._then);

  final OrdersListingEvent _self;
  final $Res Function(OrdersListingEvent) _then;

/// Create a copy of OrdersListingEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tab = null,}) {
  return _then(_self.copyWith(
tab: null == tab ? _self.tab : tab // ignore: cast_nullable_to_non_nullable
as OrdersTab,
  ));
}

}


/// Adds pattern-matching-related methods to [OrdersListingEvent].
extension OrdersListingEventPatterns on OrdersListingEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoadListing value)?  load,TResult Function( RefreshListing value)?  refresh,TResult Function( LoadNextListingPage value)?  loadNextPage,TResult Function( SwitchListingTab value)?  switchTab,TResult Function( ClearListingPaginationError value)?  clearPaginationError,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoadListing() when load != null:
return load(_that);case RefreshListing() when refresh != null:
return refresh(_that);case LoadNextListingPage() when loadNextPage != null:
return loadNextPage(_that);case SwitchListingTab() when switchTab != null:
return switchTab(_that);case ClearListingPaginationError() when clearPaginationError != null:
return clearPaginationError(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoadListing value)  load,required TResult Function( RefreshListing value)  refresh,required TResult Function( LoadNextListingPage value)  loadNextPage,required TResult Function( SwitchListingTab value)  switchTab,required TResult Function( ClearListingPaginationError value)  clearPaginationError,}){
final _that = this;
switch (_that) {
case LoadListing():
return load(_that);case RefreshListing():
return refresh(_that);case LoadNextListingPage():
return loadNextPage(_that);case SwitchListingTab():
return switchTab(_that);case ClearListingPaginationError():
return clearPaginationError(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoadListing value)?  load,TResult? Function( RefreshListing value)?  refresh,TResult? Function( LoadNextListingPage value)?  loadNextPage,TResult? Function( SwitchListingTab value)?  switchTab,TResult? Function( ClearListingPaginationError value)?  clearPaginationError,}){
final _that = this;
switch (_that) {
case LoadListing() when load != null:
return load(_that);case RefreshListing() when refresh != null:
return refresh(_that);case LoadNextListingPage() when loadNextPage != null:
return loadNextPage(_that);case SwitchListingTab() when switchTab != null:
return switchTab(_that);case ClearListingPaginationError() when clearPaginationError != null:
return clearPaginationError(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( OrdersTab tab)?  load,TResult Function( OrdersTab tab)?  refresh,TResult Function( OrdersTab tab)?  loadNextPage,TResult Function( OrdersTab tab)?  switchTab,TResult Function( OrdersTab tab)?  clearPaginationError,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoadListing() when load != null:
return load(_that.tab);case RefreshListing() when refresh != null:
return refresh(_that.tab);case LoadNextListingPage() when loadNextPage != null:
return loadNextPage(_that.tab);case SwitchListingTab() when switchTab != null:
return switchTab(_that.tab);case ClearListingPaginationError() when clearPaginationError != null:
return clearPaginationError(_that.tab);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( OrdersTab tab)  load,required TResult Function( OrdersTab tab)  refresh,required TResult Function( OrdersTab tab)  loadNextPage,required TResult Function( OrdersTab tab)  switchTab,required TResult Function( OrdersTab tab)  clearPaginationError,}) {final _that = this;
switch (_that) {
case LoadListing():
return load(_that.tab);case RefreshListing():
return refresh(_that.tab);case LoadNextListingPage():
return loadNextPage(_that.tab);case SwitchListingTab():
return switchTab(_that.tab);case ClearListingPaginationError():
return clearPaginationError(_that.tab);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( OrdersTab tab)?  load,TResult? Function( OrdersTab tab)?  refresh,TResult? Function( OrdersTab tab)?  loadNextPage,TResult? Function( OrdersTab tab)?  switchTab,TResult? Function( OrdersTab tab)?  clearPaginationError,}) {final _that = this;
switch (_that) {
case LoadListing() when load != null:
return load(_that.tab);case RefreshListing() when refresh != null:
return refresh(_that.tab);case LoadNextListingPage() when loadNextPage != null:
return loadNextPage(_that.tab);case SwitchListingTab() when switchTab != null:
return switchTab(_that.tab);case ClearListingPaginationError() when clearPaginationError != null:
return clearPaginationError(_that.tab);case _:
  return null;

}
}

}

/// @nodoc


class LoadListing implements OrdersListingEvent {
  const LoadListing(this.tab);
  

@override final  OrdersTab tab;

/// Create a copy of OrdersListingEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadListingCopyWith<LoadListing> get copyWith => _$LoadListingCopyWithImpl<LoadListing>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadListing&&(identical(other.tab, tab) || other.tab == tab));
}


@override
int get hashCode => Object.hash(runtimeType,tab);

@override
String toString() {
  return 'OrdersListingEvent.load(tab: $tab)';
}


}

/// @nodoc
abstract mixin class $LoadListingCopyWith<$Res> implements $OrdersListingEventCopyWith<$Res> {
  factory $LoadListingCopyWith(LoadListing value, $Res Function(LoadListing) _then) = _$LoadListingCopyWithImpl;
@override @useResult
$Res call({
 OrdersTab tab
});




}
/// @nodoc
class _$LoadListingCopyWithImpl<$Res>
    implements $LoadListingCopyWith<$Res> {
  _$LoadListingCopyWithImpl(this._self, this._then);

  final LoadListing _self;
  final $Res Function(LoadListing) _then;

/// Create a copy of OrdersListingEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tab = null,}) {
  return _then(LoadListing(
null == tab ? _self.tab : tab // ignore: cast_nullable_to_non_nullable
as OrdersTab,
  ));
}


}

/// @nodoc


class RefreshListing implements OrdersListingEvent {
  const RefreshListing(this.tab);
  

@override final  OrdersTab tab;

/// Create a copy of OrdersListingEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RefreshListingCopyWith<RefreshListing> get copyWith => _$RefreshListingCopyWithImpl<RefreshListing>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RefreshListing&&(identical(other.tab, tab) || other.tab == tab));
}


@override
int get hashCode => Object.hash(runtimeType,tab);

@override
String toString() {
  return 'OrdersListingEvent.refresh(tab: $tab)';
}


}

/// @nodoc
abstract mixin class $RefreshListingCopyWith<$Res> implements $OrdersListingEventCopyWith<$Res> {
  factory $RefreshListingCopyWith(RefreshListing value, $Res Function(RefreshListing) _then) = _$RefreshListingCopyWithImpl;
@override @useResult
$Res call({
 OrdersTab tab
});




}
/// @nodoc
class _$RefreshListingCopyWithImpl<$Res>
    implements $RefreshListingCopyWith<$Res> {
  _$RefreshListingCopyWithImpl(this._self, this._then);

  final RefreshListing _self;
  final $Res Function(RefreshListing) _then;

/// Create a copy of OrdersListingEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tab = null,}) {
  return _then(RefreshListing(
null == tab ? _self.tab : tab // ignore: cast_nullable_to_non_nullable
as OrdersTab,
  ));
}


}

/// @nodoc


class LoadNextListingPage implements OrdersListingEvent {
  const LoadNextListingPage(this.tab);
  

@override final  OrdersTab tab;

/// Create a copy of OrdersListingEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadNextListingPageCopyWith<LoadNextListingPage> get copyWith => _$LoadNextListingPageCopyWithImpl<LoadNextListingPage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadNextListingPage&&(identical(other.tab, tab) || other.tab == tab));
}


@override
int get hashCode => Object.hash(runtimeType,tab);

@override
String toString() {
  return 'OrdersListingEvent.loadNextPage(tab: $tab)';
}


}

/// @nodoc
abstract mixin class $LoadNextListingPageCopyWith<$Res> implements $OrdersListingEventCopyWith<$Res> {
  factory $LoadNextListingPageCopyWith(LoadNextListingPage value, $Res Function(LoadNextListingPage) _then) = _$LoadNextListingPageCopyWithImpl;
@override @useResult
$Res call({
 OrdersTab tab
});




}
/// @nodoc
class _$LoadNextListingPageCopyWithImpl<$Res>
    implements $LoadNextListingPageCopyWith<$Res> {
  _$LoadNextListingPageCopyWithImpl(this._self, this._then);

  final LoadNextListingPage _self;
  final $Res Function(LoadNextListingPage) _then;

/// Create a copy of OrdersListingEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tab = null,}) {
  return _then(LoadNextListingPage(
null == tab ? _self.tab : tab // ignore: cast_nullable_to_non_nullable
as OrdersTab,
  ));
}


}

/// @nodoc


class SwitchListingTab implements OrdersListingEvent {
  const SwitchListingTab(this.tab);
  

@override final  OrdersTab tab;

/// Create a copy of OrdersListingEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SwitchListingTabCopyWith<SwitchListingTab> get copyWith => _$SwitchListingTabCopyWithImpl<SwitchListingTab>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SwitchListingTab&&(identical(other.tab, tab) || other.tab == tab));
}


@override
int get hashCode => Object.hash(runtimeType,tab);

@override
String toString() {
  return 'OrdersListingEvent.switchTab(tab: $tab)';
}


}

/// @nodoc
abstract mixin class $SwitchListingTabCopyWith<$Res> implements $OrdersListingEventCopyWith<$Res> {
  factory $SwitchListingTabCopyWith(SwitchListingTab value, $Res Function(SwitchListingTab) _then) = _$SwitchListingTabCopyWithImpl;
@override @useResult
$Res call({
 OrdersTab tab
});




}
/// @nodoc
class _$SwitchListingTabCopyWithImpl<$Res>
    implements $SwitchListingTabCopyWith<$Res> {
  _$SwitchListingTabCopyWithImpl(this._self, this._then);

  final SwitchListingTab _self;
  final $Res Function(SwitchListingTab) _then;

/// Create a copy of OrdersListingEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tab = null,}) {
  return _then(SwitchListingTab(
null == tab ? _self.tab : tab // ignore: cast_nullable_to_non_nullable
as OrdersTab,
  ));
}


}

/// @nodoc


class ClearListingPaginationError implements OrdersListingEvent {
  const ClearListingPaginationError(this.tab);
  

@override final  OrdersTab tab;

/// Create a copy of OrdersListingEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClearListingPaginationErrorCopyWith<ClearListingPaginationError> get copyWith => _$ClearListingPaginationErrorCopyWithImpl<ClearListingPaginationError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClearListingPaginationError&&(identical(other.tab, tab) || other.tab == tab));
}


@override
int get hashCode => Object.hash(runtimeType,tab);

@override
String toString() {
  return 'OrdersListingEvent.clearPaginationError(tab: $tab)';
}


}

/// @nodoc
abstract mixin class $ClearListingPaginationErrorCopyWith<$Res> implements $OrdersListingEventCopyWith<$Res> {
  factory $ClearListingPaginationErrorCopyWith(ClearListingPaginationError value, $Res Function(ClearListingPaginationError) _then) = _$ClearListingPaginationErrorCopyWithImpl;
@override @useResult
$Res call({
 OrdersTab tab
});




}
/// @nodoc
class _$ClearListingPaginationErrorCopyWithImpl<$Res>
    implements $ClearListingPaginationErrorCopyWith<$Res> {
  _$ClearListingPaginationErrorCopyWithImpl(this._self, this._then);

  final ClearListingPaginationError _self;
  final $Res Function(ClearListingPaginationError) _then;

/// Create a copy of OrdersListingEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tab = null,}) {
  return _then(ClearListingPaginationError(
null == tab ? _self.tab : tab // ignore: cast_nullable_to_non_nullable
as OrdersTab,
  ));
}


}

/// @nodoc
mixin _$TabListingState {

 ListingStatus get status; OrdersListingEntity? get page; int get currentPage; bool get isLoadingMore;/// Bumped on every refresh outcome, success or failure.
///
/// A silent refresh changes no other field on failure, so there would
/// otherwise be nothing for `RefreshIndicator` to await and the spinner
/// would vanish on the same frame it appeared.
 int get refreshTick;/// Full-page failure — shown only when there is no data to fall back on.
 String? get errorMessage;/// One-shot: a pagination failure surfaced as a snackbar while the loaded
/// list stays visible. Cleared by [ClearListingPaginationError] once the
/// listener has shown it.
 String? get paginationError;
/// Create a copy of TabListingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TabListingStateCopyWith<TabListingState> get copyWith => _$TabListingStateCopyWithImpl<TabListingState>(this as TabListingState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TabListingState&&(identical(other.status, status) || other.status == status)&&(identical(other.page, page) || other.page == page)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.refreshTick, refreshTick) || other.refreshTick == refreshTick)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.paginationError, paginationError) || other.paginationError == paginationError));
}


@override
int get hashCode => Object.hash(runtimeType,status,page,currentPage,isLoadingMore,refreshTick,errorMessage,paginationError);

@override
String toString() {
  return 'TabListingState(status: $status, page: $page, currentPage: $currentPage, isLoadingMore: $isLoadingMore, refreshTick: $refreshTick, errorMessage: $errorMessage, paginationError: $paginationError)';
}


}

/// @nodoc
abstract mixin class $TabListingStateCopyWith<$Res>  {
  factory $TabListingStateCopyWith(TabListingState value, $Res Function(TabListingState) _then) = _$TabListingStateCopyWithImpl;
@useResult
$Res call({
 ListingStatus status, OrdersListingEntity? page, int currentPage, bool isLoadingMore, int refreshTick, String? errorMessage, String? paginationError
});


$OrdersListingEntityCopyWith<$Res>? get page;

}
/// @nodoc
class _$TabListingStateCopyWithImpl<$Res>
    implements $TabListingStateCopyWith<$Res> {
  _$TabListingStateCopyWithImpl(this._self, this._then);

  final TabListingState _self;
  final $Res Function(TabListingState) _then;

/// Create a copy of TabListingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? page = freezed,Object? currentPage = null,Object? isLoadingMore = null,Object? refreshTick = null,Object? errorMessage = freezed,Object? paginationError = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ListingStatus,page: freezed == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as OrdersListingEntity?,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,refreshTick: null == refreshTick ? _self.refreshTick : refreshTick // ignore: cast_nullable_to_non_nullable
as int,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,paginationError: freezed == paginationError ? _self.paginationError : paginationError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of TabListingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrdersListingEntityCopyWith<$Res>? get page {
    if (_self.page == null) {
    return null;
  }

  return $OrdersListingEntityCopyWith<$Res>(_self.page!, (value) {
    return _then(_self.copyWith(page: value));
  });
}
}


/// Adds pattern-matching-related methods to [TabListingState].
extension TabListingStatePatterns on TabListingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TabListingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TabListingState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TabListingState value)  $default,){
final _that = this;
switch (_that) {
case _TabListingState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TabListingState value)?  $default,){
final _that = this;
switch (_that) {
case _TabListingState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ListingStatus status,  OrdersListingEntity? page,  int currentPage,  bool isLoadingMore,  int refreshTick,  String? errorMessage,  String? paginationError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TabListingState() when $default != null:
return $default(_that.status,_that.page,_that.currentPage,_that.isLoadingMore,_that.refreshTick,_that.errorMessage,_that.paginationError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ListingStatus status,  OrdersListingEntity? page,  int currentPage,  bool isLoadingMore,  int refreshTick,  String? errorMessage,  String? paginationError)  $default,) {final _that = this;
switch (_that) {
case _TabListingState():
return $default(_that.status,_that.page,_that.currentPage,_that.isLoadingMore,_that.refreshTick,_that.errorMessage,_that.paginationError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ListingStatus status,  OrdersListingEntity? page,  int currentPage,  bool isLoadingMore,  int refreshTick,  String? errorMessage,  String? paginationError)?  $default,) {final _that = this;
switch (_that) {
case _TabListingState() when $default != null:
return $default(_that.status,_that.page,_that.currentPage,_that.isLoadingMore,_that.refreshTick,_that.errorMessage,_that.paginationError);case _:
  return null;

}
}

}

/// @nodoc


class _TabListingState implements TabListingState {
  const _TabListingState({this.status = ListingStatus.initial, this.page, this.currentPage = 1, this.isLoadingMore = false, this.refreshTick = 0, this.errorMessage, this.paginationError});
  

@override@JsonKey() final  ListingStatus status;
@override final  OrdersListingEntity? page;
@override@JsonKey() final  int currentPage;
@override@JsonKey() final  bool isLoadingMore;
/// Bumped on every refresh outcome, success or failure.
///
/// A silent refresh changes no other field on failure, so there would
/// otherwise be nothing for `RefreshIndicator` to await and the spinner
/// would vanish on the same frame it appeared.
@override@JsonKey() final  int refreshTick;
/// Full-page failure — shown only when there is no data to fall back on.
@override final  String? errorMessage;
/// One-shot: a pagination failure surfaced as a snackbar while the loaded
/// list stays visible. Cleared by [ClearListingPaginationError] once the
/// listener has shown it.
@override final  String? paginationError;

/// Create a copy of TabListingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TabListingStateCopyWith<_TabListingState> get copyWith => __$TabListingStateCopyWithImpl<_TabListingState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TabListingState&&(identical(other.status, status) || other.status == status)&&(identical(other.page, page) || other.page == page)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.refreshTick, refreshTick) || other.refreshTick == refreshTick)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.paginationError, paginationError) || other.paginationError == paginationError));
}


@override
int get hashCode => Object.hash(runtimeType,status,page,currentPage,isLoadingMore,refreshTick,errorMessage,paginationError);

@override
String toString() {
  return 'TabListingState(status: $status, page: $page, currentPage: $currentPage, isLoadingMore: $isLoadingMore, refreshTick: $refreshTick, errorMessage: $errorMessage, paginationError: $paginationError)';
}


}

/// @nodoc
abstract mixin class _$TabListingStateCopyWith<$Res> implements $TabListingStateCopyWith<$Res> {
  factory _$TabListingStateCopyWith(_TabListingState value, $Res Function(_TabListingState) _then) = __$TabListingStateCopyWithImpl;
@override @useResult
$Res call({
 ListingStatus status, OrdersListingEntity? page, int currentPage, bool isLoadingMore, int refreshTick, String? errorMessage, String? paginationError
});


@override $OrdersListingEntityCopyWith<$Res>? get page;

}
/// @nodoc
class __$TabListingStateCopyWithImpl<$Res>
    implements _$TabListingStateCopyWith<$Res> {
  __$TabListingStateCopyWithImpl(this._self, this._then);

  final _TabListingState _self;
  final $Res Function(_TabListingState) _then;

/// Create a copy of TabListingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? page = freezed,Object? currentPage = null,Object? isLoadingMore = null,Object? refreshTick = null,Object? errorMessage = freezed,Object? paginationError = freezed,}) {
  return _then(_TabListingState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ListingStatus,page: freezed == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as OrdersListingEntity?,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,refreshTick: null == refreshTick ? _self.refreshTick : refreshTick // ignore: cast_nullable_to_non_nullable
as int,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,paginationError: freezed == paginationError ? _self.paginationError : paginationError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of TabListingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrdersListingEntityCopyWith<$Res>? get page {
    if (_self.page == null) {
    return null;
  }

  return $OrdersListingEntityCopyWith<$Res>(_self.page!, (value) {
    return _then(_self.copyWith(page: value));
  });
}
}

/// @nodoc
mixin _$OrdersListingState {

 OrdersTab get activeTab; TabListingState get orders; TabListingState get giftCards;
/// Create a copy of OrdersListingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrdersListingStateCopyWith<OrdersListingState> get copyWith => _$OrdersListingStateCopyWithImpl<OrdersListingState>(this as OrdersListingState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrdersListingState&&(identical(other.activeTab, activeTab) || other.activeTab == activeTab)&&(identical(other.orders, orders) || other.orders == orders)&&(identical(other.giftCards, giftCards) || other.giftCards == giftCards));
}


@override
int get hashCode => Object.hash(runtimeType,activeTab,orders,giftCards);

@override
String toString() {
  return 'OrdersListingState(activeTab: $activeTab, orders: $orders, giftCards: $giftCards)';
}


}

/// @nodoc
abstract mixin class $OrdersListingStateCopyWith<$Res>  {
  factory $OrdersListingStateCopyWith(OrdersListingState value, $Res Function(OrdersListingState) _then) = _$OrdersListingStateCopyWithImpl;
@useResult
$Res call({
 OrdersTab activeTab, TabListingState orders, TabListingState giftCards
});


$TabListingStateCopyWith<$Res> get orders;$TabListingStateCopyWith<$Res> get giftCards;

}
/// @nodoc
class _$OrdersListingStateCopyWithImpl<$Res>
    implements $OrdersListingStateCopyWith<$Res> {
  _$OrdersListingStateCopyWithImpl(this._self, this._then);

  final OrdersListingState _self;
  final $Res Function(OrdersListingState) _then;

/// Create a copy of OrdersListingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? activeTab = null,Object? orders = null,Object? giftCards = null,}) {
  return _then(_self.copyWith(
activeTab: null == activeTab ? _self.activeTab : activeTab // ignore: cast_nullable_to_non_nullable
as OrdersTab,orders: null == orders ? _self.orders : orders // ignore: cast_nullable_to_non_nullable
as TabListingState,giftCards: null == giftCards ? _self.giftCards : giftCards // ignore: cast_nullable_to_non_nullable
as TabListingState,
  ));
}
/// Create a copy of OrdersListingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TabListingStateCopyWith<$Res> get orders {
  
  return $TabListingStateCopyWith<$Res>(_self.orders, (value) {
    return _then(_self.copyWith(orders: value));
  });
}/// Create a copy of OrdersListingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TabListingStateCopyWith<$Res> get giftCards {
  
  return $TabListingStateCopyWith<$Res>(_self.giftCards, (value) {
    return _then(_self.copyWith(giftCards: value));
  });
}
}


/// Adds pattern-matching-related methods to [OrdersListingState].
extension OrdersListingStatePatterns on OrdersListingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrdersListingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrdersListingState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrdersListingState value)  $default,){
final _that = this;
switch (_that) {
case _OrdersListingState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrdersListingState value)?  $default,){
final _that = this;
switch (_that) {
case _OrdersListingState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( OrdersTab activeTab,  TabListingState orders,  TabListingState giftCards)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrdersListingState() when $default != null:
return $default(_that.activeTab,_that.orders,_that.giftCards);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( OrdersTab activeTab,  TabListingState orders,  TabListingState giftCards)  $default,) {final _that = this;
switch (_that) {
case _OrdersListingState():
return $default(_that.activeTab,_that.orders,_that.giftCards);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( OrdersTab activeTab,  TabListingState orders,  TabListingState giftCards)?  $default,) {final _that = this;
switch (_that) {
case _OrdersListingState() when $default != null:
return $default(_that.activeTab,_that.orders,_that.giftCards);case _:
  return null;

}
}

}

/// @nodoc


class _OrdersListingState implements OrdersListingState {
  const _OrdersListingState({this.activeTab = OrdersTab.orders, this.orders = const TabListingState(), this.giftCards = const TabListingState()});
  

@override@JsonKey() final  OrdersTab activeTab;
@override@JsonKey() final  TabListingState orders;
@override@JsonKey() final  TabListingState giftCards;

/// Create a copy of OrdersListingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrdersListingStateCopyWith<_OrdersListingState> get copyWith => __$OrdersListingStateCopyWithImpl<_OrdersListingState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrdersListingState&&(identical(other.activeTab, activeTab) || other.activeTab == activeTab)&&(identical(other.orders, orders) || other.orders == orders)&&(identical(other.giftCards, giftCards) || other.giftCards == giftCards));
}


@override
int get hashCode => Object.hash(runtimeType,activeTab,orders,giftCards);

@override
String toString() {
  return 'OrdersListingState(activeTab: $activeTab, orders: $orders, giftCards: $giftCards)';
}


}

/// @nodoc
abstract mixin class _$OrdersListingStateCopyWith<$Res> implements $OrdersListingStateCopyWith<$Res> {
  factory _$OrdersListingStateCopyWith(_OrdersListingState value, $Res Function(_OrdersListingState) _then) = __$OrdersListingStateCopyWithImpl;
@override @useResult
$Res call({
 OrdersTab activeTab, TabListingState orders, TabListingState giftCards
});


@override $TabListingStateCopyWith<$Res> get orders;@override $TabListingStateCopyWith<$Res> get giftCards;

}
/// @nodoc
class __$OrdersListingStateCopyWithImpl<$Res>
    implements _$OrdersListingStateCopyWith<$Res> {
  __$OrdersListingStateCopyWithImpl(this._self, this._then);

  final _OrdersListingState _self;
  final $Res Function(_OrdersListingState) _then;

/// Create a copy of OrdersListingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? activeTab = null,Object? orders = null,Object? giftCards = null,}) {
  return _then(_OrdersListingState(
activeTab: null == activeTab ? _self.activeTab : activeTab // ignore: cast_nullable_to_non_nullable
as OrdersTab,orders: null == orders ? _self.orders : orders // ignore: cast_nullable_to_non_nullable
as TabListingState,giftCards: null == giftCards ? _self.giftCards : giftCards // ignore: cast_nullable_to_non_nullable
as TabListingState,
  ));
}

/// Create a copy of OrdersListingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TabListingStateCopyWith<$Res> get orders {
  
  return $TabListingStateCopyWith<$Res>(_self.orders, (value) {
    return _then(_self.copyWith(orders: value));
  });
}/// Create a copy of OrdersListingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TabListingStateCopyWith<$Res> get giftCards {
  
  return $TabListingStateCopyWith<$Res>(_self.giftCards, (value) {
    return _then(_self.copyWith(giftCards: value));
  });
}
}

// dart format on
