// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'promos_offers_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PromosOffersEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PromosOffersEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PromosOffersEvent()';
}


}

/// @nodoc
class $PromosOffersEventCopyWith<$Res>  {
$PromosOffersEventCopyWith(PromosOffersEvent _, $Res Function(PromosOffersEvent) __);
}


/// Adds pattern-matching-related methods to [PromosOffersEvent].
extension PromosOffersEventPatterns on PromosOffersEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoadPromosOffers value)?  load,TResult Function( RefreshPromosOffers value)?  refresh,TResult Function( ApplyPromo value)?  apply,TResult Function( RemovePromo value)?  remove,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoadPromosOffers() when load != null:
return load(_that);case RefreshPromosOffers() when refresh != null:
return refresh(_that);case ApplyPromo() when apply != null:
return apply(_that);case RemovePromo() when remove != null:
return remove(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoadPromosOffers value)  load,required TResult Function( RefreshPromosOffers value)  refresh,required TResult Function( ApplyPromo value)  apply,required TResult Function( RemovePromo value)  remove,}){
final _that = this;
switch (_that) {
case LoadPromosOffers():
return load(_that);case RefreshPromosOffers():
return refresh(_that);case ApplyPromo():
return apply(_that);case RemovePromo():
return remove(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoadPromosOffers value)?  load,TResult? Function( RefreshPromosOffers value)?  refresh,TResult? Function( ApplyPromo value)?  apply,TResult? Function( RemovePromo value)?  remove,}){
final _that = this;
switch (_that) {
case LoadPromosOffers() when load != null:
return load(_that);case RefreshPromosOffers() when refresh != null:
return refresh(_that);case ApplyPromo() when apply != null:
return apply(_that);case RemovePromo() when remove != null:
return remove(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  load,TResult Function()?  refresh,TResult Function( String promoCode)?  apply,TResult Function( String promoCode)?  remove,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoadPromosOffers() when load != null:
return load();case RefreshPromosOffers() when refresh != null:
return refresh();case ApplyPromo() when apply != null:
return apply(_that.promoCode);case RemovePromo() when remove != null:
return remove(_that.promoCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  load,required TResult Function()  refresh,required TResult Function( String promoCode)  apply,required TResult Function( String promoCode)  remove,}) {final _that = this;
switch (_that) {
case LoadPromosOffers():
return load();case RefreshPromosOffers():
return refresh();case ApplyPromo():
return apply(_that.promoCode);case RemovePromo():
return remove(_that.promoCode);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  load,TResult? Function()?  refresh,TResult? Function( String promoCode)?  apply,TResult? Function( String promoCode)?  remove,}) {final _that = this;
switch (_that) {
case LoadPromosOffers() when load != null:
return load();case RefreshPromosOffers() when refresh != null:
return refresh();case ApplyPromo() when apply != null:
return apply(_that.promoCode);case RemovePromo() when remove != null:
return remove(_that.promoCode);case _:
  return null;

}
}

}

/// @nodoc


class LoadPromosOffers implements PromosOffersEvent {
  const LoadPromosOffers();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadPromosOffers);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PromosOffersEvent.load()';
}


}




/// @nodoc


class RefreshPromosOffers implements PromosOffersEvent {
  const RefreshPromosOffers();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RefreshPromosOffers);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PromosOffersEvent.refresh()';
}


}




/// @nodoc


class ApplyPromo implements PromosOffersEvent {
  const ApplyPromo(this.promoCode);
  

 final  String promoCode;

/// Create a copy of PromosOffersEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApplyPromoCopyWith<ApplyPromo> get copyWith => _$ApplyPromoCopyWithImpl<ApplyPromo>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApplyPromo&&(identical(other.promoCode, promoCode) || other.promoCode == promoCode));
}


@override
int get hashCode => Object.hash(runtimeType,promoCode);

@override
String toString() {
  return 'PromosOffersEvent.apply(promoCode: $promoCode)';
}


}

/// @nodoc
abstract mixin class $ApplyPromoCopyWith<$Res> implements $PromosOffersEventCopyWith<$Res> {
  factory $ApplyPromoCopyWith(ApplyPromo value, $Res Function(ApplyPromo) _then) = _$ApplyPromoCopyWithImpl;
@useResult
$Res call({
 String promoCode
});




}
/// @nodoc
class _$ApplyPromoCopyWithImpl<$Res>
    implements $ApplyPromoCopyWith<$Res> {
  _$ApplyPromoCopyWithImpl(this._self, this._then);

  final ApplyPromo _self;
  final $Res Function(ApplyPromo) _then;

/// Create a copy of PromosOffersEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? promoCode = null,}) {
  return _then(ApplyPromo(
null == promoCode ? _self.promoCode : promoCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class RemovePromo implements PromosOffersEvent {
  const RemovePromo(this.promoCode);
  

 final  String promoCode;

/// Create a copy of PromosOffersEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RemovePromoCopyWith<RemovePromo> get copyWith => _$RemovePromoCopyWithImpl<RemovePromo>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RemovePromo&&(identical(other.promoCode, promoCode) || other.promoCode == promoCode));
}


@override
int get hashCode => Object.hash(runtimeType,promoCode);

@override
String toString() {
  return 'PromosOffersEvent.remove(promoCode: $promoCode)';
}


}

/// @nodoc
abstract mixin class $RemovePromoCopyWith<$Res> implements $PromosOffersEventCopyWith<$Res> {
  factory $RemovePromoCopyWith(RemovePromo value, $Res Function(RemovePromo) _then) = _$RemovePromoCopyWithImpl;
@useResult
$Res call({
 String promoCode
});




}
/// @nodoc
class _$RemovePromoCopyWithImpl<$Res>
    implements $RemovePromoCopyWith<$Res> {
  _$RemovePromoCopyWithImpl(this._self, this._then);

  final RemovePromo _self;
  final $Res Function(RemovePromo) _then;

/// Create a copy of PromosOffersEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? promoCode = null,}) {
  return _then(RemovePromo(
null == promoCode ? _self.promoCode : promoCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$PromosOffersState {

 PromosOffersStatus get status; PromoOffersEntity? get offers; String? get errorMessage;/// Promo code whose apply/remove is in flight; empty when idle.
 String get pendingActionCode;/// Bumped once per completed apply/remove so a [BlocListener] fires
/// exactly once even when two actions produce the same message.
 int get actionNonce; String? get actionMessage; String? get actionError;/// Backend-authored bars for the latest action. Rendered **in preference
/// to** [actionError] — they carry their own copy, colour and icon, so
/// showing both would duplicate the message.
 List<MessageBarEntity> get actionMessageBars;/// Backend-authored sheet for the latest action; takes the place of the
/// toast when present.
 BackendActionContentEntity? get actionBottomSheet;/// Mutation behind the latest [actionNonce]; null until one completes.
 PromoActionKind? get lastAction;/// Whether that mutation actually succeeded server-side.
///
/// Needed as its own flag rather than inferring from [actionError]: a
/// rejection is an HTTP 200 with `success: false`, and the sheet must stay
/// open for it. Inferring would let a rejection read as success and pop the
/// sheet out from under the user.
 bool get actionSucceeded;/// Sticky once any apply/remove succeeds server-side, so the sheet's caller
/// knows the cart needs a re-read even when the sheet is dismissed later.
 bool get cartChanged;
/// Create a copy of PromosOffersState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PromosOffersStateCopyWith<PromosOffersState> get copyWith => _$PromosOffersStateCopyWithImpl<PromosOffersState>(this as PromosOffersState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PromosOffersState&&(identical(other.status, status) || other.status == status)&&(identical(other.offers, offers) || other.offers == offers)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.pendingActionCode, pendingActionCode) || other.pendingActionCode == pendingActionCode)&&(identical(other.actionNonce, actionNonce) || other.actionNonce == actionNonce)&&(identical(other.actionMessage, actionMessage) || other.actionMessage == actionMessage)&&(identical(other.actionError, actionError) || other.actionError == actionError)&&const DeepCollectionEquality().equals(other.actionMessageBars, actionMessageBars)&&(identical(other.actionBottomSheet, actionBottomSheet) || other.actionBottomSheet == actionBottomSheet)&&(identical(other.lastAction, lastAction) || other.lastAction == lastAction)&&(identical(other.actionSucceeded, actionSucceeded) || other.actionSucceeded == actionSucceeded)&&(identical(other.cartChanged, cartChanged) || other.cartChanged == cartChanged));
}


@override
int get hashCode => Object.hash(runtimeType,status,offers,errorMessage,pendingActionCode,actionNonce,actionMessage,actionError,const DeepCollectionEquality().hash(actionMessageBars),actionBottomSheet,lastAction,actionSucceeded,cartChanged);

@override
String toString() {
  return 'PromosOffersState(status: $status, offers: $offers, errorMessage: $errorMessage, pendingActionCode: $pendingActionCode, actionNonce: $actionNonce, actionMessage: $actionMessage, actionError: $actionError, actionMessageBars: $actionMessageBars, actionBottomSheet: $actionBottomSheet, lastAction: $lastAction, actionSucceeded: $actionSucceeded, cartChanged: $cartChanged)';
}


}

/// @nodoc
abstract mixin class $PromosOffersStateCopyWith<$Res>  {
  factory $PromosOffersStateCopyWith(PromosOffersState value, $Res Function(PromosOffersState) _then) = _$PromosOffersStateCopyWithImpl;
@useResult
$Res call({
 PromosOffersStatus status, PromoOffersEntity? offers, String? errorMessage, String pendingActionCode, int actionNonce, String? actionMessage, String? actionError, List<MessageBarEntity> actionMessageBars, BackendActionContentEntity? actionBottomSheet, PromoActionKind? lastAction, bool actionSucceeded, bool cartChanged
});


$PromoOffersEntityCopyWith<$Res>? get offers;

}
/// @nodoc
class _$PromosOffersStateCopyWithImpl<$Res>
    implements $PromosOffersStateCopyWith<$Res> {
  _$PromosOffersStateCopyWithImpl(this._self, this._then);

  final PromosOffersState _self;
  final $Res Function(PromosOffersState) _then;

/// Create a copy of PromosOffersState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? offers = freezed,Object? errorMessage = freezed,Object? pendingActionCode = null,Object? actionNonce = null,Object? actionMessage = freezed,Object? actionError = freezed,Object? actionMessageBars = null,Object? actionBottomSheet = freezed,Object? lastAction = freezed,Object? actionSucceeded = null,Object? cartChanged = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PromosOffersStatus,offers: freezed == offers ? _self.offers : offers // ignore: cast_nullable_to_non_nullable
as PromoOffersEntity?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,pendingActionCode: null == pendingActionCode ? _self.pendingActionCode : pendingActionCode // ignore: cast_nullable_to_non_nullable
as String,actionNonce: null == actionNonce ? _self.actionNonce : actionNonce // ignore: cast_nullable_to_non_nullable
as int,actionMessage: freezed == actionMessage ? _self.actionMessage : actionMessage // ignore: cast_nullable_to_non_nullable
as String?,actionError: freezed == actionError ? _self.actionError : actionError // ignore: cast_nullable_to_non_nullable
as String?,actionMessageBars: null == actionMessageBars ? _self.actionMessageBars : actionMessageBars // ignore: cast_nullable_to_non_nullable
as List<MessageBarEntity>,actionBottomSheet: freezed == actionBottomSheet ? _self.actionBottomSheet : actionBottomSheet // ignore: cast_nullable_to_non_nullable
as BackendActionContentEntity?,lastAction: freezed == lastAction ? _self.lastAction : lastAction // ignore: cast_nullable_to_non_nullable
as PromoActionKind?,actionSucceeded: null == actionSucceeded ? _self.actionSucceeded : actionSucceeded // ignore: cast_nullable_to_non_nullable
as bool,cartChanged: null == cartChanged ? _self.cartChanged : cartChanged // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of PromosOffersState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PromoOffersEntityCopyWith<$Res>? get offers {
    if (_self.offers == null) {
    return null;
  }

  return $PromoOffersEntityCopyWith<$Res>(_self.offers!, (value) {
    return _then(_self.copyWith(offers: value));
  });
}
}


/// Adds pattern-matching-related methods to [PromosOffersState].
extension PromosOffersStatePatterns on PromosOffersState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PromosOffersState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PromosOffersState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PromosOffersState value)  $default,){
final _that = this;
switch (_that) {
case _PromosOffersState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PromosOffersState value)?  $default,){
final _that = this;
switch (_that) {
case _PromosOffersState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PromosOffersStatus status,  PromoOffersEntity? offers,  String? errorMessage,  String pendingActionCode,  int actionNonce,  String? actionMessage,  String? actionError,  List<MessageBarEntity> actionMessageBars,  BackendActionContentEntity? actionBottomSheet,  PromoActionKind? lastAction,  bool actionSucceeded,  bool cartChanged)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PromosOffersState() when $default != null:
return $default(_that.status,_that.offers,_that.errorMessage,_that.pendingActionCode,_that.actionNonce,_that.actionMessage,_that.actionError,_that.actionMessageBars,_that.actionBottomSheet,_that.lastAction,_that.actionSucceeded,_that.cartChanged);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PromosOffersStatus status,  PromoOffersEntity? offers,  String? errorMessage,  String pendingActionCode,  int actionNonce,  String? actionMessage,  String? actionError,  List<MessageBarEntity> actionMessageBars,  BackendActionContentEntity? actionBottomSheet,  PromoActionKind? lastAction,  bool actionSucceeded,  bool cartChanged)  $default,) {final _that = this;
switch (_that) {
case _PromosOffersState():
return $default(_that.status,_that.offers,_that.errorMessage,_that.pendingActionCode,_that.actionNonce,_that.actionMessage,_that.actionError,_that.actionMessageBars,_that.actionBottomSheet,_that.lastAction,_that.actionSucceeded,_that.cartChanged);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PromosOffersStatus status,  PromoOffersEntity? offers,  String? errorMessage,  String pendingActionCode,  int actionNonce,  String? actionMessage,  String? actionError,  List<MessageBarEntity> actionMessageBars,  BackendActionContentEntity? actionBottomSheet,  PromoActionKind? lastAction,  bool actionSucceeded,  bool cartChanged)?  $default,) {final _that = this;
switch (_that) {
case _PromosOffersState() when $default != null:
return $default(_that.status,_that.offers,_that.errorMessage,_that.pendingActionCode,_that.actionNonce,_that.actionMessage,_that.actionError,_that.actionMessageBars,_that.actionBottomSheet,_that.lastAction,_that.actionSucceeded,_that.cartChanged);case _:
  return null;

}
}

}

/// @nodoc


class _PromosOffersState implements PromosOffersState {
  const _PromosOffersState({this.status = PromosOffersStatus.initial, this.offers, this.errorMessage, this.pendingActionCode = '', this.actionNonce = 0, this.actionMessage, this.actionError, final  List<MessageBarEntity> actionMessageBars = const <MessageBarEntity>[], this.actionBottomSheet, this.lastAction, this.actionSucceeded = false, this.cartChanged = false}): _actionMessageBars = actionMessageBars;
  

@override@JsonKey() final  PromosOffersStatus status;
@override final  PromoOffersEntity? offers;
@override final  String? errorMessage;
/// Promo code whose apply/remove is in flight; empty when idle.
@override@JsonKey() final  String pendingActionCode;
/// Bumped once per completed apply/remove so a [BlocListener] fires
/// exactly once even when two actions produce the same message.
@override@JsonKey() final  int actionNonce;
@override final  String? actionMessage;
@override final  String? actionError;
/// Backend-authored bars for the latest action. Rendered **in preference
/// to** [actionError] — they carry their own copy, colour and icon, so
/// showing both would duplicate the message.
 final  List<MessageBarEntity> _actionMessageBars;
/// Backend-authored bars for the latest action. Rendered **in preference
/// to** [actionError] — they carry their own copy, colour and icon, so
/// showing both would duplicate the message.
@override@JsonKey() List<MessageBarEntity> get actionMessageBars {
  if (_actionMessageBars is EqualUnmodifiableListView) return _actionMessageBars;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_actionMessageBars);
}

/// Backend-authored sheet for the latest action; takes the place of the
/// toast when present.
@override final  BackendActionContentEntity? actionBottomSheet;
/// Mutation behind the latest [actionNonce]; null until one completes.
@override final  PromoActionKind? lastAction;
/// Whether that mutation actually succeeded server-side.
///
/// Needed as its own flag rather than inferring from [actionError]: a
/// rejection is an HTTP 200 with `success: false`, and the sheet must stay
/// open for it. Inferring would let a rejection read as success and pop the
/// sheet out from under the user.
@override@JsonKey() final  bool actionSucceeded;
/// Sticky once any apply/remove succeeds server-side, so the sheet's caller
/// knows the cart needs a re-read even when the sheet is dismissed later.
@override@JsonKey() final  bool cartChanged;

/// Create a copy of PromosOffersState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PromosOffersStateCopyWith<_PromosOffersState> get copyWith => __$PromosOffersStateCopyWithImpl<_PromosOffersState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PromosOffersState&&(identical(other.status, status) || other.status == status)&&(identical(other.offers, offers) || other.offers == offers)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.pendingActionCode, pendingActionCode) || other.pendingActionCode == pendingActionCode)&&(identical(other.actionNonce, actionNonce) || other.actionNonce == actionNonce)&&(identical(other.actionMessage, actionMessage) || other.actionMessage == actionMessage)&&(identical(other.actionError, actionError) || other.actionError == actionError)&&const DeepCollectionEquality().equals(other._actionMessageBars, _actionMessageBars)&&(identical(other.actionBottomSheet, actionBottomSheet) || other.actionBottomSheet == actionBottomSheet)&&(identical(other.lastAction, lastAction) || other.lastAction == lastAction)&&(identical(other.actionSucceeded, actionSucceeded) || other.actionSucceeded == actionSucceeded)&&(identical(other.cartChanged, cartChanged) || other.cartChanged == cartChanged));
}


@override
int get hashCode => Object.hash(runtimeType,status,offers,errorMessage,pendingActionCode,actionNonce,actionMessage,actionError,const DeepCollectionEquality().hash(_actionMessageBars),actionBottomSheet,lastAction,actionSucceeded,cartChanged);

@override
String toString() {
  return 'PromosOffersState(status: $status, offers: $offers, errorMessage: $errorMessage, pendingActionCode: $pendingActionCode, actionNonce: $actionNonce, actionMessage: $actionMessage, actionError: $actionError, actionMessageBars: $actionMessageBars, actionBottomSheet: $actionBottomSheet, lastAction: $lastAction, actionSucceeded: $actionSucceeded, cartChanged: $cartChanged)';
}


}

/// @nodoc
abstract mixin class _$PromosOffersStateCopyWith<$Res> implements $PromosOffersStateCopyWith<$Res> {
  factory _$PromosOffersStateCopyWith(_PromosOffersState value, $Res Function(_PromosOffersState) _then) = __$PromosOffersStateCopyWithImpl;
@override @useResult
$Res call({
 PromosOffersStatus status, PromoOffersEntity? offers, String? errorMessage, String pendingActionCode, int actionNonce, String? actionMessage, String? actionError, List<MessageBarEntity> actionMessageBars, BackendActionContentEntity? actionBottomSheet, PromoActionKind? lastAction, bool actionSucceeded, bool cartChanged
});


@override $PromoOffersEntityCopyWith<$Res>? get offers;

}
/// @nodoc
class __$PromosOffersStateCopyWithImpl<$Res>
    implements _$PromosOffersStateCopyWith<$Res> {
  __$PromosOffersStateCopyWithImpl(this._self, this._then);

  final _PromosOffersState _self;
  final $Res Function(_PromosOffersState) _then;

/// Create a copy of PromosOffersState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? offers = freezed,Object? errorMessage = freezed,Object? pendingActionCode = null,Object? actionNonce = null,Object? actionMessage = freezed,Object? actionError = freezed,Object? actionMessageBars = null,Object? actionBottomSheet = freezed,Object? lastAction = freezed,Object? actionSucceeded = null,Object? cartChanged = null,}) {
  return _then(_PromosOffersState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PromosOffersStatus,offers: freezed == offers ? _self.offers : offers // ignore: cast_nullable_to_non_nullable
as PromoOffersEntity?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,pendingActionCode: null == pendingActionCode ? _self.pendingActionCode : pendingActionCode // ignore: cast_nullable_to_non_nullable
as String,actionNonce: null == actionNonce ? _self.actionNonce : actionNonce // ignore: cast_nullable_to_non_nullable
as int,actionMessage: freezed == actionMessage ? _self.actionMessage : actionMessage // ignore: cast_nullable_to_non_nullable
as String?,actionError: freezed == actionError ? _self.actionError : actionError // ignore: cast_nullable_to_non_nullable
as String?,actionMessageBars: null == actionMessageBars ? _self._actionMessageBars : actionMessageBars // ignore: cast_nullable_to_non_nullable
as List<MessageBarEntity>,actionBottomSheet: freezed == actionBottomSheet ? _self.actionBottomSheet : actionBottomSheet // ignore: cast_nullable_to_non_nullable
as BackendActionContentEntity?,lastAction: freezed == lastAction ? _self.lastAction : lastAction // ignore: cast_nullable_to_non_nullable
as PromoActionKind?,actionSucceeded: null == actionSucceeded ? _self.actionSucceeded : actionSucceeded // ignore: cast_nullable_to_non_nullable
as bool,cartChanged: null == cartChanged ? _self.cartChanged : cartChanged // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of PromosOffersState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PromoOffersEntityCopyWith<$Res>? get offers {
    if (_self.offers == null) {
    return null;
  }

  return $PromoOffersEntityCopyWith<$Res>(_self.offers!, (value) {
    return _then(_self.copyWith(offers: value));
  });
}
}

// dart format on
