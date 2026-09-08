// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CartState {

 CartStatus get status; CartEntity? get cart; String? get errorMessage;/// The item call in flight, if any. Read it through [CartStateX]'s
/// `isItemBusy` / `isRemoving` / `isMovingToWishlist` rather than
/// destructuring it at call sites.
 ({String sku, CartItemAction action})? get pendingItemAction; bool get isCheckoutLoading; bool get isPromoLoading; bool get isMerging;/// Full-screen overlay flag — set by the quantity change, move-to-wishlist,
/// promo apply/remove and the post-login merge. Remove is the exception:
/// it runs behind its confirmation sheet's own button loader.
///
/// It spans the follow-up cart refresh for every mutation except the
/// quantity change, which drops it as soon as its own call answers and
/// refreshes silently — see [CartBloc._onUpdateCartItem].
 bool get isCartUpdating; List<MessageBarEntity> get staticMessageBars; String? get toastMessage;/// Whether [toastMessage] is a failure, so the snack can be styled the way
/// PLP/PDP style theirs (`WishlistState.feedbackIsError` is the same idea).
 bool get toastIsError;/// Bumped every time a [RefreshCart] handler completes (success or
/// failure) — lets the pull-to-refresh indicator await exactly one
/// round-trip via `bloc.stream.firstWhere((s) => s.refreshTick != tick)`
/// without needing a dedicated loading flag (RefreshCart is otherwise a
/// silent background refresh).
 int get refreshTick;/// Non-null when an apply/remove returned a backend-authored sheet — UI
/// shows it instead of [toastMessage].
 BackendActionContentEntity? get promoActionSheet;
/// Create a copy of CartState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CartStateCopyWith<CartState> get copyWith => _$CartStateCopyWithImpl<CartState>(this as CartState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CartState&&(identical(other.status, status) || other.status == status)&&(identical(other.cart, cart) || other.cart == cart)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.pendingItemAction, pendingItemAction) || other.pendingItemAction == pendingItemAction)&&(identical(other.isCheckoutLoading, isCheckoutLoading) || other.isCheckoutLoading == isCheckoutLoading)&&(identical(other.isPromoLoading, isPromoLoading) || other.isPromoLoading == isPromoLoading)&&(identical(other.isMerging, isMerging) || other.isMerging == isMerging)&&(identical(other.isCartUpdating, isCartUpdating) || other.isCartUpdating == isCartUpdating)&&const DeepCollectionEquality().equals(other.staticMessageBars, staticMessageBars)&&(identical(other.toastMessage, toastMessage) || other.toastMessage == toastMessage)&&(identical(other.toastIsError, toastIsError) || other.toastIsError == toastIsError)&&(identical(other.refreshTick, refreshTick) || other.refreshTick == refreshTick)&&(identical(other.promoActionSheet, promoActionSheet) || other.promoActionSheet == promoActionSheet));
}


@override
int get hashCode => Object.hash(runtimeType,status,cart,errorMessage,pendingItemAction,isCheckoutLoading,isPromoLoading,isMerging,isCartUpdating,const DeepCollectionEquality().hash(staticMessageBars),toastMessage,toastIsError,refreshTick,promoActionSheet);

@override
String toString() {
  return 'CartState(status: $status, cart: $cart, errorMessage: $errorMessage, pendingItemAction: $pendingItemAction, isCheckoutLoading: $isCheckoutLoading, isPromoLoading: $isPromoLoading, isMerging: $isMerging, isCartUpdating: $isCartUpdating, staticMessageBars: $staticMessageBars, toastMessage: $toastMessage, toastIsError: $toastIsError, refreshTick: $refreshTick, promoActionSheet: $promoActionSheet)';
}


}

/// @nodoc
abstract mixin class $CartStateCopyWith<$Res>  {
  factory $CartStateCopyWith(CartState value, $Res Function(CartState) _then) = _$CartStateCopyWithImpl;
@useResult
$Res call({
 CartStatus status, CartEntity? cart, String? errorMessage, ({String sku, CartItemAction action})? pendingItemAction, bool isCheckoutLoading, bool isPromoLoading, bool isMerging, bool isCartUpdating, List<MessageBarEntity> staticMessageBars, String? toastMessage, bool toastIsError, int refreshTick, BackendActionContentEntity? promoActionSheet
});




}
/// @nodoc
class _$CartStateCopyWithImpl<$Res>
    implements $CartStateCopyWith<$Res> {
  _$CartStateCopyWithImpl(this._self, this._then);

  final CartState _self;
  final $Res Function(CartState) _then;

/// Create a copy of CartState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? cart = freezed,Object? errorMessage = freezed,Object? pendingItemAction = freezed,Object? isCheckoutLoading = null,Object? isPromoLoading = null,Object? isMerging = null,Object? isCartUpdating = null,Object? staticMessageBars = null,Object? toastMessage = freezed,Object? toastIsError = null,Object? refreshTick = null,Object? promoActionSheet = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CartStatus,cart: freezed == cart ? _self.cart : cart // ignore: cast_nullable_to_non_nullable
as CartEntity?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,pendingItemAction: freezed == pendingItemAction ? _self.pendingItemAction : pendingItemAction // ignore: cast_nullable_to_non_nullable
as ({String sku, CartItemAction action})?,isCheckoutLoading: null == isCheckoutLoading ? _self.isCheckoutLoading : isCheckoutLoading // ignore: cast_nullable_to_non_nullable
as bool,isPromoLoading: null == isPromoLoading ? _self.isPromoLoading : isPromoLoading // ignore: cast_nullable_to_non_nullable
as bool,isMerging: null == isMerging ? _self.isMerging : isMerging // ignore: cast_nullable_to_non_nullable
as bool,isCartUpdating: null == isCartUpdating ? _self.isCartUpdating : isCartUpdating // ignore: cast_nullable_to_non_nullable
as bool,staticMessageBars: null == staticMessageBars ? _self.staticMessageBars : staticMessageBars // ignore: cast_nullable_to_non_nullable
as List<MessageBarEntity>,toastMessage: freezed == toastMessage ? _self.toastMessage : toastMessage // ignore: cast_nullable_to_non_nullable
as String?,toastIsError: null == toastIsError ? _self.toastIsError : toastIsError // ignore: cast_nullable_to_non_nullable
as bool,refreshTick: null == refreshTick ? _self.refreshTick : refreshTick // ignore: cast_nullable_to_non_nullable
as int,promoActionSheet: freezed == promoActionSheet ? _self.promoActionSheet : promoActionSheet // ignore: cast_nullable_to_non_nullable
as BackendActionContentEntity?,
  ));
}

}


/// Adds pattern-matching-related methods to [CartState].
extension CartStatePatterns on CartState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CartState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CartState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CartState value)  $default,){
final _that = this;
switch (_that) {
case _CartState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CartState value)?  $default,){
final _that = this;
switch (_that) {
case _CartState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CartStatus status,  CartEntity? cart,  String? errorMessage,  ({String sku, CartItemAction action})? pendingItemAction,  bool isCheckoutLoading,  bool isPromoLoading,  bool isMerging,  bool isCartUpdating,  List<MessageBarEntity> staticMessageBars,  String? toastMessage,  bool toastIsError,  int refreshTick,  BackendActionContentEntity? promoActionSheet)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CartState() when $default != null:
return $default(_that.status,_that.cart,_that.errorMessage,_that.pendingItemAction,_that.isCheckoutLoading,_that.isPromoLoading,_that.isMerging,_that.isCartUpdating,_that.staticMessageBars,_that.toastMessage,_that.toastIsError,_that.refreshTick,_that.promoActionSheet);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CartStatus status,  CartEntity? cart,  String? errorMessage,  ({String sku, CartItemAction action})? pendingItemAction,  bool isCheckoutLoading,  bool isPromoLoading,  bool isMerging,  bool isCartUpdating,  List<MessageBarEntity> staticMessageBars,  String? toastMessage,  bool toastIsError,  int refreshTick,  BackendActionContentEntity? promoActionSheet)  $default,) {final _that = this;
switch (_that) {
case _CartState():
return $default(_that.status,_that.cart,_that.errorMessage,_that.pendingItemAction,_that.isCheckoutLoading,_that.isPromoLoading,_that.isMerging,_that.isCartUpdating,_that.staticMessageBars,_that.toastMessage,_that.toastIsError,_that.refreshTick,_that.promoActionSheet);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CartStatus status,  CartEntity? cart,  String? errorMessage,  ({String sku, CartItemAction action})? pendingItemAction,  bool isCheckoutLoading,  bool isPromoLoading,  bool isMerging,  bool isCartUpdating,  List<MessageBarEntity> staticMessageBars,  String? toastMessage,  bool toastIsError,  int refreshTick,  BackendActionContentEntity? promoActionSheet)?  $default,) {final _that = this;
switch (_that) {
case _CartState() when $default != null:
return $default(_that.status,_that.cart,_that.errorMessage,_that.pendingItemAction,_that.isCheckoutLoading,_that.isPromoLoading,_that.isMerging,_that.isCartUpdating,_that.staticMessageBars,_that.toastMessage,_that.toastIsError,_that.refreshTick,_that.promoActionSheet);case _:
  return null;

}
}

}

/// @nodoc


class _CartState implements CartState {
  const _CartState({this.status = CartStatus.initial, this.cart, this.errorMessage, this.pendingItemAction, this.isCheckoutLoading = false, this.isPromoLoading = false, this.isMerging = false, this.isCartUpdating = false, final  List<MessageBarEntity> staticMessageBars = const <MessageBarEntity>[], this.toastMessage, this.toastIsError = false, this.refreshTick = 0, this.promoActionSheet}): _staticMessageBars = staticMessageBars;
  

@override@JsonKey() final  CartStatus status;
@override final  CartEntity? cart;
@override final  String? errorMessage;
/// The item call in flight, if any. Read it through [CartStateX]'s
/// `isItemBusy` / `isRemoving` / `isMovingToWishlist` rather than
/// destructuring it at call sites.
@override final  ({String sku, CartItemAction action})? pendingItemAction;
@override@JsonKey() final  bool isCheckoutLoading;
@override@JsonKey() final  bool isPromoLoading;
@override@JsonKey() final  bool isMerging;
/// Full-screen overlay flag — set by the quantity change, move-to-wishlist,
/// promo apply/remove and the post-login merge. Remove is the exception:
/// it runs behind its confirmation sheet's own button loader.
///
/// It spans the follow-up cart refresh for every mutation except the
/// quantity change, which drops it as soon as its own call answers and
/// refreshes silently — see [CartBloc._onUpdateCartItem].
@override@JsonKey() final  bool isCartUpdating;
 final  List<MessageBarEntity> _staticMessageBars;
@override@JsonKey() List<MessageBarEntity> get staticMessageBars {
  if (_staticMessageBars is EqualUnmodifiableListView) return _staticMessageBars;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_staticMessageBars);
}

@override final  String? toastMessage;
/// Whether [toastMessage] is a failure, so the snack can be styled the way
/// PLP/PDP style theirs (`WishlistState.feedbackIsError` is the same idea).
@override@JsonKey() final  bool toastIsError;
/// Bumped every time a [RefreshCart] handler completes (success or
/// failure) — lets the pull-to-refresh indicator await exactly one
/// round-trip via `bloc.stream.firstWhere((s) => s.refreshTick != tick)`
/// without needing a dedicated loading flag (RefreshCart is otherwise a
/// silent background refresh).
@override@JsonKey() final  int refreshTick;
/// Non-null when an apply/remove returned a backend-authored sheet — UI
/// shows it instead of [toastMessage].
@override final  BackendActionContentEntity? promoActionSheet;

/// Create a copy of CartState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CartStateCopyWith<_CartState> get copyWith => __$CartStateCopyWithImpl<_CartState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CartState&&(identical(other.status, status) || other.status == status)&&(identical(other.cart, cart) || other.cart == cart)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.pendingItemAction, pendingItemAction) || other.pendingItemAction == pendingItemAction)&&(identical(other.isCheckoutLoading, isCheckoutLoading) || other.isCheckoutLoading == isCheckoutLoading)&&(identical(other.isPromoLoading, isPromoLoading) || other.isPromoLoading == isPromoLoading)&&(identical(other.isMerging, isMerging) || other.isMerging == isMerging)&&(identical(other.isCartUpdating, isCartUpdating) || other.isCartUpdating == isCartUpdating)&&const DeepCollectionEquality().equals(other._staticMessageBars, _staticMessageBars)&&(identical(other.toastMessage, toastMessage) || other.toastMessage == toastMessage)&&(identical(other.toastIsError, toastIsError) || other.toastIsError == toastIsError)&&(identical(other.refreshTick, refreshTick) || other.refreshTick == refreshTick)&&(identical(other.promoActionSheet, promoActionSheet) || other.promoActionSheet == promoActionSheet));
}


@override
int get hashCode => Object.hash(runtimeType,status,cart,errorMessage,pendingItemAction,isCheckoutLoading,isPromoLoading,isMerging,isCartUpdating,const DeepCollectionEquality().hash(_staticMessageBars),toastMessage,toastIsError,refreshTick,promoActionSheet);

@override
String toString() {
  return 'CartState(status: $status, cart: $cart, errorMessage: $errorMessage, pendingItemAction: $pendingItemAction, isCheckoutLoading: $isCheckoutLoading, isPromoLoading: $isPromoLoading, isMerging: $isMerging, isCartUpdating: $isCartUpdating, staticMessageBars: $staticMessageBars, toastMessage: $toastMessage, toastIsError: $toastIsError, refreshTick: $refreshTick, promoActionSheet: $promoActionSheet)';
}


}

/// @nodoc
abstract mixin class _$CartStateCopyWith<$Res> implements $CartStateCopyWith<$Res> {
  factory _$CartStateCopyWith(_CartState value, $Res Function(_CartState) _then) = __$CartStateCopyWithImpl;
@override @useResult
$Res call({
 CartStatus status, CartEntity? cart, String? errorMessage, ({String sku, CartItemAction action})? pendingItemAction, bool isCheckoutLoading, bool isPromoLoading, bool isMerging, bool isCartUpdating, List<MessageBarEntity> staticMessageBars, String? toastMessage, bool toastIsError, int refreshTick, BackendActionContentEntity? promoActionSheet
});




}
/// @nodoc
class __$CartStateCopyWithImpl<$Res>
    implements _$CartStateCopyWith<$Res> {
  __$CartStateCopyWithImpl(this._self, this._then);

  final _CartState _self;
  final $Res Function(_CartState) _then;

/// Create a copy of CartState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? cart = freezed,Object? errorMessage = freezed,Object? pendingItemAction = freezed,Object? isCheckoutLoading = null,Object? isPromoLoading = null,Object? isMerging = null,Object? isCartUpdating = null,Object? staticMessageBars = null,Object? toastMessage = freezed,Object? toastIsError = null,Object? refreshTick = null,Object? promoActionSheet = freezed,}) {
  return _then(_CartState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CartStatus,cart: freezed == cart ? _self.cart : cart // ignore: cast_nullable_to_non_nullable
as CartEntity?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,pendingItemAction: freezed == pendingItemAction ? _self.pendingItemAction : pendingItemAction // ignore: cast_nullable_to_non_nullable
as ({String sku, CartItemAction action})?,isCheckoutLoading: null == isCheckoutLoading ? _self.isCheckoutLoading : isCheckoutLoading // ignore: cast_nullable_to_non_nullable
as bool,isPromoLoading: null == isPromoLoading ? _self.isPromoLoading : isPromoLoading // ignore: cast_nullable_to_non_nullable
as bool,isMerging: null == isMerging ? _self.isMerging : isMerging // ignore: cast_nullable_to_non_nullable
as bool,isCartUpdating: null == isCartUpdating ? _self.isCartUpdating : isCartUpdating // ignore: cast_nullable_to_non_nullable
as bool,staticMessageBars: null == staticMessageBars ? _self._staticMessageBars : staticMessageBars // ignore: cast_nullable_to_non_nullable
as List<MessageBarEntity>,toastMessage: freezed == toastMessage ? _self.toastMessage : toastMessage // ignore: cast_nullable_to_non_nullable
as String?,toastIsError: null == toastIsError ? _self.toastIsError : toastIsError // ignore: cast_nullable_to_non_nullable
as bool,refreshTick: null == refreshTick ? _self.refreshTick : refreshTick // ignore: cast_nullable_to_non_nullable
as int,promoActionSheet: freezed == promoActionSheet ? _self.promoActionSheet : promoActionSheet // ignore: cast_nullable_to_non_nullable
as BackendActionContentEntity?,
  ));
}


}

// dart format on
