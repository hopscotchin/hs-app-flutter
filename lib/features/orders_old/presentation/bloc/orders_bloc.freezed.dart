// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'orders_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OrdersEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrdersEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OrdersEvent()';
}


}

/// @nodoc
class $OrdersEventCopyWith<$Res>  {
$OrdersEventCopyWith(OrdersEvent _, $Res Function(OrdersEvent) __);
}


/// Adds pattern-matching-related methods to [OrdersEvent].
extension OrdersEventPatterns on OrdersEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoadOrders value)?  load,TResult Function( RefreshOrders value)?  refresh,TResult Function( LoadNextOrdersPage value)?  loadNextPage,TResult Function( ClearPaginationError value)?  clearPaginationError,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoadOrders() when load != null:
return load(_that);case RefreshOrders() when refresh != null:
return refresh(_that);case LoadNextOrdersPage() when loadNextPage != null:
return loadNextPage(_that);case ClearPaginationError() when clearPaginationError != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoadOrders value)  load,required TResult Function( RefreshOrders value)  refresh,required TResult Function( LoadNextOrdersPage value)  loadNextPage,required TResult Function( ClearPaginationError value)  clearPaginationError,}){
final _that = this;
switch (_that) {
case LoadOrders():
return load(_that);case RefreshOrders():
return refresh(_that);case LoadNextOrdersPage():
return loadNextPage(_that);case ClearPaginationError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoadOrders value)?  load,TResult? Function( RefreshOrders value)?  refresh,TResult? Function( LoadNextOrdersPage value)?  loadNextPage,TResult? Function( ClearPaginationError value)?  clearPaginationError,}){
final _that = this;
switch (_that) {
case LoadOrders() when load != null:
return load(_that);case RefreshOrders() when refresh != null:
return refresh(_that);case LoadNextOrdersPage() when loadNextPage != null:
return loadNextPage(_that);case ClearPaginationError() when clearPaginationError != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  load,TResult Function()?  refresh,TResult Function()?  loadNextPage,TResult Function()?  clearPaginationError,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoadOrders() when load != null:
return load();case RefreshOrders() when refresh != null:
return refresh();case LoadNextOrdersPage() when loadNextPage != null:
return loadNextPage();case ClearPaginationError() when clearPaginationError != null:
return clearPaginationError();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  load,required TResult Function()  refresh,required TResult Function()  loadNextPage,required TResult Function()  clearPaginationError,}) {final _that = this;
switch (_that) {
case LoadOrders():
return load();case RefreshOrders():
return refresh();case LoadNextOrdersPage():
return loadNextPage();case ClearPaginationError():
return clearPaginationError();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  load,TResult? Function()?  refresh,TResult? Function()?  loadNextPage,TResult? Function()?  clearPaginationError,}) {final _that = this;
switch (_that) {
case LoadOrders() when load != null:
return load();case RefreshOrders() when refresh != null:
return refresh();case LoadNextOrdersPage() when loadNextPage != null:
return loadNextPage();case ClearPaginationError() when clearPaginationError != null:
return clearPaginationError();case _:
  return null;

}
}

}

/// @nodoc


class LoadOrders implements OrdersEvent {
  const LoadOrders();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadOrders);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OrdersEvent.load()';
}


}




/// @nodoc


class RefreshOrders implements OrdersEvent {
  const RefreshOrders();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RefreshOrders);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OrdersEvent.refresh()';
}


}




/// @nodoc


class LoadNextOrdersPage implements OrdersEvent {
  const LoadNextOrdersPage();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadNextOrdersPage);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OrdersEvent.loadNextPage()';
}


}




/// @nodoc


class ClearPaginationError implements OrdersEvent {
  const ClearPaginationError();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClearPaginationError);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OrdersEvent.clearPaginationError()';
}


}




/// @nodoc
mixin _$OrdersState {

 OrdersStatus get status; OrdersPageEntity? get page; int get currentPage; String? get errorMessage; bool get isLoadingMore;// One-shot effect field: non-null only while the listener hasn't cleared
// it yet. Used exclusively for pagination failures so the existing list
// stays visible. Full-page errors set [status] to error instead.
 String? get paginationError;
/// Create a copy of OrdersState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrdersStateCopyWith<OrdersState> get copyWith => _$OrdersStateCopyWithImpl<OrdersState>(this as OrdersState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrdersState&&(identical(other.status, status) || other.status == status)&&(identical(other.page, page) || other.page == page)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.paginationError, paginationError) || other.paginationError == paginationError));
}


@override
int get hashCode => Object.hash(runtimeType,status,page,currentPage,errorMessage,isLoadingMore,paginationError);

@override
String toString() {
  return 'OrdersState(status: $status, page: $page, currentPage: $currentPage, errorMessage: $errorMessage, isLoadingMore: $isLoadingMore, paginationError: $paginationError)';
}


}

/// @nodoc
abstract mixin class $OrdersStateCopyWith<$Res>  {
  factory $OrdersStateCopyWith(OrdersState value, $Res Function(OrdersState) _then) = _$OrdersStateCopyWithImpl;
@useResult
$Res call({
 OrdersStatus status, OrdersPageEntity? page, int currentPage, String? errorMessage, bool isLoadingMore, String? paginationError
});


$OrdersPageEntityCopyWith<$Res>? get page;

}
/// @nodoc
class _$OrdersStateCopyWithImpl<$Res>
    implements $OrdersStateCopyWith<$Res> {
  _$OrdersStateCopyWithImpl(this._self, this._then);

  final OrdersState _self;
  final $Res Function(OrdersState) _then;

/// Create a copy of OrdersState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? page = freezed,Object? currentPage = null,Object? errorMessage = freezed,Object? isLoadingMore = null,Object? paginationError = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrdersStatus,page: freezed == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as OrdersPageEntity?,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,paginationError: freezed == paginationError ? _self.paginationError : paginationError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of OrdersState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrdersPageEntityCopyWith<$Res>? get page {
    if (_self.page == null) {
    return null;
  }

  return $OrdersPageEntityCopyWith<$Res>(_self.page!, (value) {
    return _then(_self.copyWith(page: value));
  });
}
}


/// Adds pattern-matching-related methods to [OrdersState].
extension OrdersStatePatterns on OrdersState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrdersState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrdersState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrdersState value)  $default,){
final _that = this;
switch (_that) {
case _OrdersState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrdersState value)?  $default,){
final _that = this;
switch (_that) {
case _OrdersState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( OrdersStatus status,  OrdersPageEntity? page,  int currentPage,  String? errorMessage,  bool isLoadingMore,  String? paginationError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrdersState() when $default != null:
return $default(_that.status,_that.page,_that.currentPage,_that.errorMessage,_that.isLoadingMore,_that.paginationError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( OrdersStatus status,  OrdersPageEntity? page,  int currentPage,  String? errorMessage,  bool isLoadingMore,  String? paginationError)  $default,) {final _that = this;
switch (_that) {
case _OrdersState():
return $default(_that.status,_that.page,_that.currentPage,_that.errorMessage,_that.isLoadingMore,_that.paginationError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( OrdersStatus status,  OrdersPageEntity? page,  int currentPage,  String? errorMessage,  bool isLoadingMore,  String? paginationError)?  $default,) {final _that = this;
switch (_that) {
case _OrdersState() when $default != null:
return $default(_that.status,_that.page,_that.currentPage,_that.errorMessage,_that.isLoadingMore,_that.paginationError);case _:
  return null;

}
}

}

/// @nodoc


class _OrdersState implements OrdersState {
  const _OrdersState({this.status = OrdersStatus.initial, this.page, this.currentPage = 1, this.errorMessage, this.isLoadingMore = false, this.paginationError});
  

@override@JsonKey() final  OrdersStatus status;
@override final  OrdersPageEntity? page;
@override@JsonKey() final  int currentPage;
@override final  String? errorMessage;
@override@JsonKey() final  bool isLoadingMore;
// One-shot effect field: non-null only while the listener hasn't cleared
// it yet. Used exclusively for pagination failures so the existing list
// stays visible. Full-page errors set [status] to error instead.
@override final  String? paginationError;

/// Create a copy of OrdersState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrdersStateCopyWith<_OrdersState> get copyWith => __$OrdersStateCopyWithImpl<_OrdersState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrdersState&&(identical(other.status, status) || other.status == status)&&(identical(other.page, page) || other.page == page)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.paginationError, paginationError) || other.paginationError == paginationError));
}


@override
int get hashCode => Object.hash(runtimeType,status,page,currentPage,errorMessage,isLoadingMore,paginationError);

@override
String toString() {
  return 'OrdersState(status: $status, page: $page, currentPage: $currentPage, errorMessage: $errorMessage, isLoadingMore: $isLoadingMore, paginationError: $paginationError)';
}


}

/// @nodoc
abstract mixin class _$OrdersStateCopyWith<$Res> implements $OrdersStateCopyWith<$Res> {
  factory _$OrdersStateCopyWith(_OrdersState value, $Res Function(_OrdersState) _then) = __$OrdersStateCopyWithImpl;
@override @useResult
$Res call({
 OrdersStatus status, OrdersPageEntity? page, int currentPage, String? errorMessage, bool isLoadingMore, String? paginationError
});


@override $OrdersPageEntityCopyWith<$Res>? get page;

}
/// @nodoc
class __$OrdersStateCopyWithImpl<$Res>
    implements _$OrdersStateCopyWith<$Res> {
  __$OrdersStateCopyWithImpl(this._self, this._then);

  final _OrdersState _self;
  final $Res Function(_OrdersState) _then;

/// Create a copy of OrdersState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? page = freezed,Object? currentPage = null,Object? errorMessage = freezed,Object? isLoadingMore = null,Object? paginationError = freezed,}) {
  return _then(_OrdersState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrdersStatus,page: freezed == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as OrdersPageEntity?,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,paginationError: freezed == paginationError ? _self.paginationError : paginationError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of OrdersState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrdersPageEntityCopyWith<$Res>? get page {
    if (_self.page == null) {
    return null;
  }

  return $OrdersPageEntityCopyWith<$Res>(_self.page!, (value) {
    return _then(_self.copyWith(page: value));
  });
}
}

// dart format on
