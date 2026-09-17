// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wishlist_listing_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WishlistListingEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WishlistListingEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'WishlistListingEvent()';
}


}

/// @nodoc
class $WishlistListingEventCopyWith<$Res>  {
$WishlistListingEventCopyWith(WishlistListingEvent _, $Res Function(WishlistListingEvent) __);
}


/// Adds pattern-matching-related methods to [WishlistListingEvent].
extension WishlistListingEventPatterns on WishlistListingEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoadWishlist value)?  load,TResult Function( RefreshWishlist value)?  refresh,TResult Function( LoadNextWishlistPage value)?  loadNextPage,TResult Function( RemoveWishlistItem value)?  removeItem,TResult Function( MoveWishlistItemToBag value)?  moveToBag,TResult Function( ClearWishlistMessage value)?  clearMessage,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoadWishlist() when load != null:
return load(_that);case RefreshWishlist() when refresh != null:
return refresh(_that);case LoadNextWishlistPage() when loadNextPage != null:
return loadNextPage(_that);case RemoveWishlistItem() when removeItem != null:
return removeItem(_that);case MoveWishlistItemToBag() when moveToBag != null:
return moveToBag(_that);case ClearWishlistMessage() when clearMessage != null:
return clearMessage(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoadWishlist value)  load,required TResult Function( RefreshWishlist value)  refresh,required TResult Function( LoadNextWishlistPage value)  loadNextPage,required TResult Function( RemoveWishlistItem value)  removeItem,required TResult Function( MoveWishlistItemToBag value)  moveToBag,required TResult Function( ClearWishlistMessage value)  clearMessage,}){
final _that = this;
switch (_that) {
case LoadWishlist():
return load(_that);case RefreshWishlist():
return refresh(_that);case LoadNextWishlistPage():
return loadNextPage(_that);case RemoveWishlistItem():
return removeItem(_that);case MoveWishlistItemToBag():
return moveToBag(_that);case ClearWishlistMessage():
return clearMessage(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoadWishlist value)?  load,TResult? Function( RefreshWishlist value)?  refresh,TResult? Function( LoadNextWishlistPage value)?  loadNextPage,TResult? Function( RemoveWishlistItem value)?  removeItem,TResult? Function( MoveWishlistItemToBag value)?  moveToBag,TResult? Function( ClearWishlistMessage value)?  clearMessage,}){
final _that = this;
switch (_that) {
case LoadWishlist() when load != null:
return load(_that);case RefreshWishlist() when refresh != null:
return refresh(_that);case LoadNextWishlistPage() when loadNextPage != null:
return loadNextPage(_that);case RemoveWishlistItem() when removeItem != null:
return removeItem(_that);case MoveWishlistItemToBag() when moveToBag != null:
return moveToBag(_that);case ClearWishlistMessage() when clearMessage != null:
return clearMessage(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String? fromScreen)?  load,TResult Function()?  refresh,TResult Function()?  loadNextPage,TResult Function( WishlistProductEntity item)?  removeItem,TResult Function( WishlistProductEntity item,  String? skuId)?  moveToBag,TResult Function()?  clearMessage,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoadWishlist() when load != null:
return load(_that.fromScreen);case RefreshWishlist() when refresh != null:
return refresh();case LoadNextWishlistPage() when loadNextPage != null:
return loadNextPage();case RemoveWishlistItem() when removeItem != null:
return removeItem(_that.item);case MoveWishlistItemToBag() when moveToBag != null:
return moveToBag(_that.item,_that.skuId);case ClearWishlistMessage() when clearMessage != null:
return clearMessage();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String? fromScreen)  load,required TResult Function()  refresh,required TResult Function()  loadNextPage,required TResult Function( WishlistProductEntity item)  removeItem,required TResult Function( WishlistProductEntity item,  String? skuId)  moveToBag,required TResult Function()  clearMessage,}) {final _that = this;
switch (_that) {
case LoadWishlist():
return load(_that.fromScreen);case RefreshWishlist():
return refresh();case LoadNextWishlistPage():
return loadNextPage();case RemoveWishlistItem():
return removeItem(_that.item);case MoveWishlistItemToBag():
return moveToBag(_that.item,_that.skuId);case ClearWishlistMessage():
return clearMessage();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String? fromScreen)?  load,TResult? Function()?  refresh,TResult? Function()?  loadNextPage,TResult? Function( WishlistProductEntity item)?  removeItem,TResult? Function( WishlistProductEntity item,  String? skuId)?  moveToBag,TResult? Function()?  clearMessage,}) {final _that = this;
switch (_that) {
case LoadWishlist() when load != null:
return load(_that.fromScreen);case RefreshWishlist() when refresh != null:
return refresh();case LoadNextWishlistPage() when loadNextPage != null:
return loadNextPage();case RemoveWishlistItem() when removeItem != null:
return removeItem(_that.item);case MoveWishlistItemToBag() when moveToBag != null:
return moveToBag(_that.item,_that.skuId);case ClearWishlistMessage() when clearMessage != null:
return clearMessage();case _:
  return null;

}
}

}

/// @nodoc


class LoadWishlist implements WishlistListingEvent {
  const LoadWishlist({this.fromScreen});
  

 final  String? fromScreen;

/// Create a copy of WishlistListingEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadWishlistCopyWith<LoadWishlist> get copyWith => _$LoadWishlistCopyWithImpl<LoadWishlist>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadWishlist&&(identical(other.fromScreen, fromScreen) || other.fromScreen == fromScreen));
}


@override
int get hashCode => Object.hash(runtimeType,fromScreen);

@override
String toString() {
  return 'WishlistListingEvent.load(fromScreen: $fromScreen)';
}


}

/// @nodoc
abstract mixin class $LoadWishlistCopyWith<$Res> implements $WishlistListingEventCopyWith<$Res> {
  factory $LoadWishlistCopyWith(LoadWishlist value, $Res Function(LoadWishlist) _then) = _$LoadWishlistCopyWithImpl;
@useResult
$Res call({
 String? fromScreen
});




}
/// @nodoc
class _$LoadWishlistCopyWithImpl<$Res>
    implements $LoadWishlistCopyWith<$Res> {
  _$LoadWishlistCopyWithImpl(this._self, this._then);

  final LoadWishlist _self;
  final $Res Function(LoadWishlist) _then;

/// Create a copy of WishlistListingEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? fromScreen = freezed,}) {
  return _then(LoadWishlist(
fromScreen: freezed == fromScreen ? _self.fromScreen : fromScreen // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class RefreshWishlist implements WishlistListingEvent {
  const RefreshWishlist();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RefreshWishlist);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'WishlistListingEvent.refresh()';
}


}




/// @nodoc


class LoadNextWishlistPage implements WishlistListingEvent {
  const LoadNextWishlistPage();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadNextWishlistPage);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'WishlistListingEvent.loadNextPage()';
}


}




/// @nodoc


class RemoveWishlistItem implements WishlistListingEvent {
  const RemoveWishlistItem(this.item);
  

 final  WishlistProductEntity item;

/// Create a copy of WishlistListingEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RemoveWishlistItemCopyWith<RemoveWishlistItem> get copyWith => _$RemoveWishlistItemCopyWithImpl<RemoveWishlistItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RemoveWishlistItem&&(identical(other.item, item) || other.item == item));
}


@override
int get hashCode => Object.hash(runtimeType,item);

@override
String toString() {
  return 'WishlistListingEvent.removeItem(item: $item)';
}


}

/// @nodoc
abstract mixin class $RemoveWishlistItemCopyWith<$Res> implements $WishlistListingEventCopyWith<$Res> {
  factory $RemoveWishlistItemCopyWith(RemoveWishlistItem value, $Res Function(RemoveWishlistItem) _then) = _$RemoveWishlistItemCopyWithImpl;
@useResult
$Res call({
 WishlistProductEntity item
});


$WishlistProductEntityCopyWith<$Res> get item;

}
/// @nodoc
class _$RemoveWishlistItemCopyWithImpl<$Res>
    implements $RemoveWishlistItemCopyWith<$Res> {
  _$RemoveWishlistItemCopyWithImpl(this._self, this._then);

  final RemoveWishlistItem _self;
  final $Res Function(RemoveWishlistItem) _then;

/// Create a copy of WishlistListingEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? item = null,}) {
  return _then(RemoveWishlistItem(
null == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as WishlistProductEntity,
  ));
}

/// Create a copy of WishlistListingEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WishlistProductEntityCopyWith<$Res> get item {
  
  return $WishlistProductEntityCopyWith<$Res>(_self.item, (value) {
    return _then(_self.copyWith(item: value));
  });
}
}

/// @nodoc


class MoveWishlistItemToBag implements WishlistListingEvent {
  const MoveWishlistItemToBag(this.item, {this.skuId});
  

 final  WishlistProductEntity item;
 final  String? skuId;

/// Create a copy of WishlistListingEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MoveWishlistItemToBagCopyWith<MoveWishlistItemToBag> get copyWith => _$MoveWishlistItemToBagCopyWithImpl<MoveWishlistItemToBag>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MoveWishlistItemToBag&&(identical(other.item, item) || other.item == item)&&(identical(other.skuId, skuId) || other.skuId == skuId));
}


@override
int get hashCode => Object.hash(runtimeType,item,skuId);

@override
String toString() {
  return 'WishlistListingEvent.moveToBag(item: $item, skuId: $skuId)';
}


}

/// @nodoc
abstract mixin class $MoveWishlistItemToBagCopyWith<$Res> implements $WishlistListingEventCopyWith<$Res> {
  factory $MoveWishlistItemToBagCopyWith(MoveWishlistItemToBag value, $Res Function(MoveWishlistItemToBag) _then) = _$MoveWishlistItemToBagCopyWithImpl;
@useResult
$Res call({
 WishlistProductEntity item, String? skuId
});


$WishlistProductEntityCopyWith<$Res> get item;

}
/// @nodoc
class _$MoveWishlistItemToBagCopyWithImpl<$Res>
    implements $MoveWishlistItemToBagCopyWith<$Res> {
  _$MoveWishlistItemToBagCopyWithImpl(this._self, this._then);

  final MoveWishlistItemToBag _self;
  final $Res Function(MoveWishlistItemToBag) _then;

/// Create a copy of WishlistListingEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? item = null,Object? skuId = freezed,}) {
  return _then(MoveWishlistItemToBag(
null == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as WishlistProductEntity,skuId: freezed == skuId ? _self.skuId : skuId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of WishlistListingEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WishlistProductEntityCopyWith<$Res> get item {
  
  return $WishlistProductEntityCopyWith<$Res>(_self.item, (value) {
    return _then(_self.copyWith(item: value));
  });
}
}

/// @nodoc


class ClearWishlistMessage implements WishlistListingEvent {
  const ClearWishlistMessage();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClearWishlistMessage);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'WishlistListingEvent.clearMessage()';
}


}




/// @nodoc
mixin _$WishlistListingState {

 WishlistStatus get status; WishlistPageEntity? get page; int get currentPage; String? get errorMessage; bool get isLoadingMore;// One-shot effect field for per-item action results and pagination
// errors, surfaced as a snackbar and cleared by the listener.
 String? get message;// Product ids with an in-flight remove / move-to-bag action.
 Set<int> get processingIds;
/// Create a copy of WishlistListingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WishlistListingStateCopyWith<WishlistListingState> get copyWith => _$WishlistListingStateCopyWithImpl<WishlistListingState>(this as WishlistListingState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WishlistListingState&&(identical(other.status, status) || other.status == status)&&(identical(other.page, page) || other.page == page)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.processingIds, processingIds));
}


@override
int get hashCode => Object.hash(runtimeType,status,page,currentPage,errorMessage,isLoadingMore,message,const DeepCollectionEquality().hash(processingIds));

@override
String toString() {
  return 'WishlistListingState(status: $status, page: $page, currentPage: $currentPage, errorMessage: $errorMessage, isLoadingMore: $isLoadingMore, message: $message, processingIds: $processingIds)';
}


}

/// @nodoc
abstract mixin class $WishlistListingStateCopyWith<$Res>  {
  factory $WishlistListingStateCopyWith(WishlistListingState value, $Res Function(WishlistListingState) _then) = _$WishlistListingStateCopyWithImpl;
@useResult
$Res call({
 WishlistStatus status, WishlistPageEntity? page, int currentPage, String? errorMessage, bool isLoadingMore, String? message, Set<int> processingIds
});


$WishlistPageEntityCopyWith<$Res>? get page;

}
/// @nodoc
class _$WishlistListingStateCopyWithImpl<$Res>
    implements $WishlistListingStateCopyWith<$Res> {
  _$WishlistListingStateCopyWithImpl(this._self, this._then);

  final WishlistListingState _self;
  final $Res Function(WishlistListingState) _then;

/// Create a copy of WishlistListingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? page = freezed,Object? currentPage = null,Object? errorMessage = freezed,Object? isLoadingMore = null,Object? message = freezed,Object? processingIds = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as WishlistStatus,page: freezed == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as WishlistPageEntity?,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,processingIds: null == processingIds ? _self.processingIds : processingIds // ignore: cast_nullable_to_non_nullable
as Set<int>,
  ));
}
/// Create a copy of WishlistListingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WishlistPageEntityCopyWith<$Res>? get page {
    if (_self.page == null) {
    return null;
  }

  return $WishlistPageEntityCopyWith<$Res>(_self.page!, (value) {
    return _then(_self.copyWith(page: value));
  });
}
}


/// Adds pattern-matching-related methods to [WishlistListingState].
extension WishlistListingStatePatterns on WishlistListingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WishlistListingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WishlistListingState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WishlistListingState value)  $default,){
final _that = this;
switch (_that) {
case _WishlistListingState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WishlistListingState value)?  $default,){
final _that = this;
switch (_that) {
case _WishlistListingState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( WishlistStatus status,  WishlistPageEntity? page,  int currentPage,  String? errorMessage,  bool isLoadingMore,  String? message,  Set<int> processingIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WishlistListingState() when $default != null:
return $default(_that.status,_that.page,_that.currentPage,_that.errorMessage,_that.isLoadingMore,_that.message,_that.processingIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( WishlistStatus status,  WishlistPageEntity? page,  int currentPage,  String? errorMessage,  bool isLoadingMore,  String? message,  Set<int> processingIds)  $default,) {final _that = this;
switch (_that) {
case _WishlistListingState():
return $default(_that.status,_that.page,_that.currentPage,_that.errorMessage,_that.isLoadingMore,_that.message,_that.processingIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( WishlistStatus status,  WishlistPageEntity? page,  int currentPage,  String? errorMessage,  bool isLoadingMore,  String? message,  Set<int> processingIds)?  $default,) {final _that = this;
switch (_that) {
case _WishlistListingState() when $default != null:
return $default(_that.status,_that.page,_that.currentPage,_that.errorMessage,_that.isLoadingMore,_that.message,_that.processingIds);case _:
  return null;

}
}

}

/// @nodoc


class _WishlistListingState implements WishlistListingState {
  const _WishlistListingState({this.status = WishlistStatus.initial, this.page, this.currentPage = 1, this.errorMessage, this.isLoadingMore = false, this.message, final  Set<int> processingIds = const <int>{}}): _processingIds = processingIds;
  

@override@JsonKey() final  WishlistStatus status;
@override final  WishlistPageEntity? page;
@override@JsonKey() final  int currentPage;
@override final  String? errorMessage;
@override@JsonKey() final  bool isLoadingMore;
// One-shot effect field for per-item action results and pagination
// errors, surfaced as a snackbar and cleared by the listener.
@override final  String? message;
// Product ids with an in-flight remove / move-to-bag action.
 final  Set<int> _processingIds;
// Product ids with an in-flight remove / move-to-bag action.
@override@JsonKey() Set<int> get processingIds {
  if (_processingIds is EqualUnmodifiableSetView) return _processingIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_processingIds);
}


/// Create a copy of WishlistListingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WishlistListingStateCopyWith<_WishlistListingState> get copyWith => __$WishlistListingStateCopyWithImpl<_WishlistListingState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WishlistListingState&&(identical(other.status, status) || other.status == status)&&(identical(other.page, page) || other.page == page)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other._processingIds, _processingIds));
}


@override
int get hashCode => Object.hash(runtimeType,status,page,currentPage,errorMessage,isLoadingMore,message,const DeepCollectionEquality().hash(_processingIds));

@override
String toString() {
  return 'WishlistListingState(status: $status, page: $page, currentPage: $currentPage, errorMessage: $errorMessage, isLoadingMore: $isLoadingMore, message: $message, processingIds: $processingIds)';
}


}

/// @nodoc
abstract mixin class _$WishlistListingStateCopyWith<$Res> implements $WishlistListingStateCopyWith<$Res> {
  factory _$WishlistListingStateCopyWith(_WishlistListingState value, $Res Function(_WishlistListingState) _then) = __$WishlistListingStateCopyWithImpl;
@override @useResult
$Res call({
 WishlistStatus status, WishlistPageEntity? page, int currentPage, String? errorMessage, bool isLoadingMore, String? message, Set<int> processingIds
});


@override $WishlistPageEntityCopyWith<$Res>? get page;

}
/// @nodoc
class __$WishlistListingStateCopyWithImpl<$Res>
    implements _$WishlistListingStateCopyWith<$Res> {
  __$WishlistListingStateCopyWithImpl(this._self, this._then);

  final _WishlistListingState _self;
  final $Res Function(_WishlistListingState) _then;

/// Create a copy of WishlistListingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? page = freezed,Object? currentPage = null,Object? errorMessage = freezed,Object? isLoadingMore = null,Object? message = freezed,Object? processingIds = null,}) {
  return _then(_WishlistListingState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as WishlistStatus,page: freezed == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as WishlistPageEntity?,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,processingIds: null == processingIds ? _self._processingIds : processingIds // ignore: cast_nullable_to_non_nullable
as Set<int>,
  ));
}

/// Create a copy of WishlistListingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WishlistPageEntityCopyWith<$Res>? get page {
    if (_self.page == null) {
    return null;
  }

  return $WishlistPageEntityCopyWith<$Res>(_self.page!, (value) {
    return _then(_self.copyWith(page: value));
  });
}
}

// dart format on
