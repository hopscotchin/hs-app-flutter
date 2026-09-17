// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_info_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OrderInfoEntity {

 String? get barCode; String? get orderId; String? get iconStatus; int get productId; String? get hsBrandLabel; String get productName; String? get productImageUrl; String? get productSize; int get orderItemId; int get itemCounts; double get amount; DeliveryMessageInfoEntity? get deliveryMessage; ReturnInfoMessageEntity? get returnTagMessage; bool get isGift;
/// Create a copy of OrderInfoEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderInfoEntityCopyWith<OrderInfoEntity> get copyWith => _$OrderInfoEntityCopyWithImpl<OrderInfoEntity>(this as OrderInfoEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderInfoEntity&&(identical(other.barCode, barCode) || other.barCode == barCode)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.iconStatus, iconStatus) || other.iconStatus == iconStatus)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.hsBrandLabel, hsBrandLabel) || other.hsBrandLabel == hsBrandLabel)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.productImageUrl, productImageUrl) || other.productImageUrl == productImageUrl)&&(identical(other.productSize, productSize) || other.productSize == productSize)&&(identical(other.orderItemId, orderItemId) || other.orderItemId == orderItemId)&&(identical(other.itemCounts, itemCounts) || other.itemCounts == itemCounts)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.deliveryMessage, deliveryMessage) || other.deliveryMessage == deliveryMessage)&&(identical(other.returnTagMessage, returnTagMessage) || other.returnTagMessage == returnTagMessage)&&(identical(other.isGift, isGift) || other.isGift == isGift));
}


@override
int get hashCode => Object.hash(runtimeType,barCode,orderId,iconStatus,productId,hsBrandLabel,productName,productImageUrl,productSize,orderItemId,itemCounts,amount,deliveryMessage,returnTagMessage,isGift);

@override
String toString() {
  return 'OrderInfoEntity(barCode: $barCode, orderId: $orderId, iconStatus: $iconStatus, productId: $productId, hsBrandLabel: $hsBrandLabel, productName: $productName, productImageUrl: $productImageUrl, productSize: $productSize, orderItemId: $orderItemId, itemCounts: $itemCounts, amount: $amount, deliveryMessage: $deliveryMessage, returnTagMessage: $returnTagMessage, isGift: $isGift)';
}


}

/// @nodoc
abstract mixin class $OrderInfoEntityCopyWith<$Res>  {
  factory $OrderInfoEntityCopyWith(OrderInfoEntity value, $Res Function(OrderInfoEntity) _then) = _$OrderInfoEntityCopyWithImpl;
@useResult
$Res call({
 String? barCode, String? orderId, String? iconStatus, int productId, String? hsBrandLabel, String productName, String? productImageUrl, String? productSize, int orderItemId, int itemCounts, double amount, DeliveryMessageInfoEntity? deliveryMessage, ReturnInfoMessageEntity? returnTagMessage, bool isGift
});


$DeliveryMessageInfoEntityCopyWith<$Res>? get deliveryMessage;$ReturnInfoMessageEntityCopyWith<$Res>? get returnTagMessage;

}
/// @nodoc
class _$OrderInfoEntityCopyWithImpl<$Res>
    implements $OrderInfoEntityCopyWith<$Res> {
  _$OrderInfoEntityCopyWithImpl(this._self, this._then);

  final OrderInfoEntity _self;
  final $Res Function(OrderInfoEntity) _then;

/// Create a copy of OrderInfoEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? barCode = freezed,Object? orderId = freezed,Object? iconStatus = freezed,Object? productId = null,Object? hsBrandLabel = freezed,Object? productName = null,Object? productImageUrl = freezed,Object? productSize = freezed,Object? orderItemId = null,Object? itemCounts = null,Object? amount = null,Object? deliveryMessage = freezed,Object? returnTagMessage = freezed,Object? isGift = null,}) {
  return _then(_self.copyWith(
barCode: freezed == barCode ? _self.barCode : barCode // ignore: cast_nullable_to_non_nullable
as String?,orderId: freezed == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String?,iconStatus: freezed == iconStatus ? _self.iconStatus : iconStatus // ignore: cast_nullable_to_non_nullable
as String?,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,hsBrandLabel: freezed == hsBrandLabel ? _self.hsBrandLabel : hsBrandLabel // ignore: cast_nullable_to_non_nullable
as String?,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,productImageUrl: freezed == productImageUrl ? _self.productImageUrl : productImageUrl // ignore: cast_nullable_to_non_nullable
as String?,productSize: freezed == productSize ? _self.productSize : productSize // ignore: cast_nullable_to_non_nullable
as String?,orderItemId: null == orderItemId ? _self.orderItemId : orderItemId // ignore: cast_nullable_to_non_nullable
as int,itemCounts: null == itemCounts ? _self.itemCounts : itemCounts // ignore: cast_nullable_to_non_nullable
as int,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,deliveryMessage: freezed == deliveryMessage ? _self.deliveryMessage : deliveryMessage // ignore: cast_nullable_to_non_nullable
as DeliveryMessageInfoEntity?,returnTagMessage: freezed == returnTagMessage ? _self.returnTagMessage : returnTagMessage // ignore: cast_nullable_to_non_nullable
as ReturnInfoMessageEntity?,isGift: null == isGift ? _self.isGift : isGift // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of OrderInfoEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeliveryMessageInfoEntityCopyWith<$Res>? get deliveryMessage {
    if (_self.deliveryMessage == null) {
    return null;
  }

  return $DeliveryMessageInfoEntityCopyWith<$Res>(_self.deliveryMessage!, (value) {
    return _then(_self.copyWith(deliveryMessage: value));
  });
}/// Create a copy of OrderInfoEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReturnInfoMessageEntityCopyWith<$Res>? get returnTagMessage {
    if (_self.returnTagMessage == null) {
    return null;
  }

  return $ReturnInfoMessageEntityCopyWith<$Res>(_self.returnTagMessage!, (value) {
    return _then(_self.copyWith(returnTagMessage: value));
  });
}
}


/// Adds pattern-matching-related methods to [OrderInfoEntity].
extension OrderInfoEntityPatterns on OrderInfoEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderInfoEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderInfoEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderInfoEntity value)  $default,){
final _that = this;
switch (_that) {
case _OrderInfoEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderInfoEntity value)?  $default,){
final _that = this;
switch (_that) {
case _OrderInfoEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? barCode,  String? orderId,  String? iconStatus,  int productId,  String? hsBrandLabel,  String productName,  String? productImageUrl,  String? productSize,  int orderItemId,  int itemCounts,  double amount,  DeliveryMessageInfoEntity? deliveryMessage,  ReturnInfoMessageEntity? returnTagMessage,  bool isGift)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderInfoEntity() when $default != null:
return $default(_that.barCode,_that.orderId,_that.iconStatus,_that.productId,_that.hsBrandLabel,_that.productName,_that.productImageUrl,_that.productSize,_that.orderItemId,_that.itemCounts,_that.amount,_that.deliveryMessage,_that.returnTagMessage,_that.isGift);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? barCode,  String? orderId,  String? iconStatus,  int productId,  String? hsBrandLabel,  String productName,  String? productImageUrl,  String? productSize,  int orderItemId,  int itemCounts,  double amount,  DeliveryMessageInfoEntity? deliveryMessage,  ReturnInfoMessageEntity? returnTagMessage,  bool isGift)  $default,) {final _that = this;
switch (_that) {
case _OrderInfoEntity():
return $default(_that.barCode,_that.orderId,_that.iconStatus,_that.productId,_that.hsBrandLabel,_that.productName,_that.productImageUrl,_that.productSize,_that.orderItemId,_that.itemCounts,_that.amount,_that.deliveryMessage,_that.returnTagMessage,_that.isGift);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? barCode,  String? orderId,  String? iconStatus,  int productId,  String? hsBrandLabel,  String productName,  String? productImageUrl,  String? productSize,  int orderItemId,  int itemCounts,  double amount,  DeliveryMessageInfoEntity? deliveryMessage,  ReturnInfoMessageEntity? returnTagMessage,  bool isGift)?  $default,) {final _that = this;
switch (_that) {
case _OrderInfoEntity() when $default != null:
return $default(_that.barCode,_that.orderId,_that.iconStatus,_that.productId,_that.hsBrandLabel,_that.productName,_that.productImageUrl,_that.productSize,_that.orderItemId,_that.itemCounts,_that.amount,_that.deliveryMessage,_that.returnTagMessage,_that.isGift);case _:
  return null;

}
}

}

/// @nodoc


class _OrderInfoEntity implements OrderInfoEntity {
  const _OrderInfoEntity({this.barCode, this.orderId, this.iconStatus, this.productId = 0, this.hsBrandLabel, this.productName = '', this.productImageUrl, this.productSize, this.orderItemId = 0, this.itemCounts = 0, this.amount = 0.0, this.deliveryMessage, this.returnTagMessage, this.isGift = false});
  

@override final  String? barCode;
@override final  String? orderId;
@override final  String? iconStatus;
@override@JsonKey() final  int productId;
@override final  String? hsBrandLabel;
@override@JsonKey() final  String productName;
@override final  String? productImageUrl;
@override final  String? productSize;
@override@JsonKey() final  int orderItemId;
@override@JsonKey() final  int itemCounts;
@override@JsonKey() final  double amount;
@override final  DeliveryMessageInfoEntity? deliveryMessage;
@override final  ReturnInfoMessageEntity? returnTagMessage;
@override@JsonKey() final  bool isGift;

/// Create a copy of OrderInfoEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderInfoEntityCopyWith<_OrderInfoEntity> get copyWith => __$OrderInfoEntityCopyWithImpl<_OrderInfoEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderInfoEntity&&(identical(other.barCode, barCode) || other.barCode == barCode)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.iconStatus, iconStatus) || other.iconStatus == iconStatus)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.hsBrandLabel, hsBrandLabel) || other.hsBrandLabel == hsBrandLabel)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.productImageUrl, productImageUrl) || other.productImageUrl == productImageUrl)&&(identical(other.productSize, productSize) || other.productSize == productSize)&&(identical(other.orderItemId, orderItemId) || other.orderItemId == orderItemId)&&(identical(other.itemCounts, itemCounts) || other.itemCounts == itemCounts)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.deliveryMessage, deliveryMessage) || other.deliveryMessage == deliveryMessage)&&(identical(other.returnTagMessage, returnTagMessage) || other.returnTagMessage == returnTagMessage)&&(identical(other.isGift, isGift) || other.isGift == isGift));
}


@override
int get hashCode => Object.hash(runtimeType,barCode,orderId,iconStatus,productId,hsBrandLabel,productName,productImageUrl,productSize,orderItemId,itemCounts,amount,deliveryMessage,returnTagMessage,isGift);

@override
String toString() {
  return 'OrderInfoEntity(barCode: $barCode, orderId: $orderId, iconStatus: $iconStatus, productId: $productId, hsBrandLabel: $hsBrandLabel, productName: $productName, productImageUrl: $productImageUrl, productSize: $productSize, orderItemId: $orderItemId, itemCounts: $itemCounts, amount: $amount, deliveryMessage: $deliveryMessage, returnTagMessage: $returnTagMessage, isGift: $isGift)';
}


}

/// @nodoc
abstract mixin class _$OrderInfoEntityCopyWith<$Res> implements $OrderInfoEntityCopyWith<$Res> {
  factory _$OrderInfoEntityCopyWith(_OrderInfoEntity value, $Res Function(_OrderInfoEntity) _then) = __$OrderInfoEntityCopyWithImpl;
@override @useResult
$Res call({
 String? barCode, String? orderId, String? iconStatus, int productId, String? hsBrandLabel, String productName, String? productImageUrl, String? productSize, int orderItemId, int itemCounts, double amount, DeliveryMessageInfoEntity? deliveryMessage, ReturnInfoMessageEntity? returnTagMessage, bool isGift
});


@override $DeliveryMessageInfoEntityCopyWith<$Res>? get deliveryMessage;@override $ReturnInfoMessageEntityCopyWith<$Res>? get returnTagMessage;

}
/// @nodoc
class __$OrderInfoEntityCopyWithImpl<$Res>
    implements _$OrderInfoEntityCopyWith<$Res> {
  __$OrderInfoEntityCopyWithImpl(this._self, this._then);

  final _OrderInfoEntity _self;
  final $Res Function(_OrderInfoEntity) _then;

/// Create a copy of OrderInfoEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? barCode = freezed,Object? orderId = freezed,Object? iconStatus = freezed,Object? productId = null,Object? hsBrandLabel = freezed,Object? productName = null,Object? productImageUrl = freezed,Object? productSize = freezed,Object? orderItemId = null,Object? itemCounts = null,Object? amount = null,Object? deliveryMessage = freezed,Object? returnTagMessage = freezed,Object? isGift = null,}) {
  return _then(_OrderInfoEntity(
barCode: freezed == barCode ? _self.barCode : barCode // ignore: cast_nullable_to_non_nullable
as String?,orderId: freezed == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String?,iconStatus: freezed == iconStatus ? _self.iconStatus : iconStatus // ignore: cast_nullable_to_non_nullable
as String?,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,hsBrandLabel: freezed == hsBrandLabel ? _self.hsBrandLabel : hsBrandLabel // ignore: cast_nullable_to_non_nullable
as String?,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,productImageUrl: freezed == productImageUrl ? _self.productImageUrl : productImageUrl // ignore: cast_nullable_to_non_nullable
as String?,productSize: freezed == productSize ? _self.productSize : productSize // ignore: cast_nullable_to_non_nullable
as String?,orderItemId: null == orderItemId ? _self.orderItemId : orderItemId // ignore: cast_nullable_to_non_nullable
as int,itemCounts: null == itemCounts ? _self.itemCounts : itemCounts // ignore: cast_nullable_to_non_nullable
as int,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,deliveryMessage: freezed == deliveryMessage ? _self.deliveryMessage : deliveryMessage // ignore: cast_nullable_to_non_nullable
as DeliveryMessageInfoEntity?,returnTagMessage: freezed == returnTagMessage ? _self.returnTagMessage : returnTagMessage // ignore: cast_nullable_to_non_nullable
as ReturnInfoMessageEntity?,isGift: null == isGift ? _self.isGift : isGift // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of OrderInfoEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeliveryMessageInfoEntityCopyWith<$Res>? get deliveryMessage {
    if (_self.deliveryMessage == null) {
    return null;
  }

  return $DeliveryMessageInfoEntityCopyWith<$Res>(_self.deliveryMessage!, (value) {
    return _then(_self.copyWith(deliveryMessage: value));
  });
}/// Create a copy of OrderInfoEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReturnInfoMessageEntityCopyWith<$Res>? get returnTagMessage {
    if (_self.returnTagMessage == null) {
    return null;
  }

  return $ReturnInfoMessageEntityCopyWith<$Res>(_self.returnTagMessage!, (value) {
    return _then(_self.copyWith(returnTagMessage: value));
  });
}
}

/// @nodoc
mixin _$DeliveryMessageInfoEntity {

 String? get deliveryMessage; String? get orderItemActionMessage; String? get secondaryMessage; String? get delayedDeliveryMessage; String? get previousEstimatedDeliveryDate; String? get color;
/// Create a copy of DeliveryMessageInfoEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeliveryMessageInfoEntityCopyWith<DeliveryMessageInfoEntity> get copyWith => _$DeliveryMessageInfoEntityCopyWithImpl<DeliveryMessageInfoEntity>(this as DeliveryMessageInfoEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeliveryMessageInfoEntity&&(identical(other.deliveryMessage, deliveryMessage) || other.deliveryMessage == deliveryMessage)&&(identical(other.orderItemActionMessage, orderItemActionMessage) || other.orderItemActionMessage == orderItemActionMessage)&&(identical(other.secondaryMessage, secondaryMessage) || other.secondaryMessage == secondaryMessage)&&(identical(other.delayedDeliveryMessage, delayedDeliveryMessage) || other.delayedDeliveryMessage == delayedDeliveryMessage)&&(identical(other.previousEstimatedDeliveryDate, previousEstimatedDeliveryDate) || other.previousEstimatedDeliveryDate == previousEstimatedDeliveryDate)&&(identical(other.color, color) || other.color == color));
}


@override
int get hashCode => Object.hash(runtimeType,deliveryMessage,orderItemActionMessage,secondaryMessage,delayedDeliveryMessage,previousEstimatedDeliveryDate,color);

@override
String toString() {
  return 'DeliveryMessageInfoEntity(deliveryMessage: $deliveryMessage, orderItemActionMessage: $orderItemActionMessage, secondaryMessage: $secondaryMessage, delayedDeliveryMessage: $delayedDeliveryMessage, previousEstimatedDeliveryDate: $previousEstimatedDeliveryDate, color: $color)';
}


}

/// @nodoc
abstract mixin class $DeliveryMessageInfoEntityCopyWith<$Res>  {
  factory $DeliveryMessageInfoEntityCopyWith(DeliveryMessageInfoEntity value, $Res Function(DeliveryMessageInfoEntity) _then) = _$DeliveryMessageInfoEntityCopyWithImpl;
@useResult
$Res call({
 String? deliveryMessage, String? orderItemActionMessage, String? secondaryMessage, String? delayedDeliveryMessage, String? previousEstimatedDeliveryDate, String? color
});




}
/// @nodoc
class _$DeliveryMessageInfoEntityCopyWithImpl<$Res>
    implements $DeliveryMessageInfoEntityCopyWith<$Res> {
  _$DeliveryMessageInfoEntityCopyWithImpl(this._self, this._then);

  final DeliveryMessageInfoEntity _self;
  final $Res Function(DeliveryMessageInfoEntity) _then;

/// Create a copy of DeliveryMessageInfoEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? deliveryMessage = freezed,Object? orderItemActionMessage = freezed,Object? secondaryMessage = freezed,Object? delayedDeliveryMessage = freezed,Object? previousEstimatedDeliveryDate = freezed,Object? color = freezed,}) {
  return _then(_self.copyWith(
deliveryMessage: freezed == deliveryMessage ? _self.deliveryMessage : deliveryMessage // ignore: cast_nullable_to_non_nullable
as String?,orderItemActionMessage: freezed == orderItemActionMessage ? _self.orderItemActionMessage : orderItemActionMessage // ignore: cast_nullable_to_non_nullable
as String?,secondaryMessage: freezed == secondaryMessage ? _self.secondaryMessage : secondaryMessage // ignore: cast_nullable_to_non_nullable
as String?,delayedDeliveryMessage: freezed == delayedDeliveryMessage ? _self.delayedDeliveryMessage : delayedDeliveryMessage // ignore: cast_nullable_to_non_nullable
as String?,previousEstimatedDeliveryDate: freezed == previousEstimatedDeliveryDate ? _self.previousEstimatedDeliveryDate : previousEstimatedDeliveryDate // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DeliveryMessageInfoEntity].
extension DeliveryMessageInfoEntityPatterns on DeliveryMessageInfoEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeliveryMessageInfoEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeliveryMessageInfoEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeliveryMessageInfoEntity value)  $default,){
final _that = this;
switch (_that) {
case _DeliveryMessageInfoEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeliveryMessageInfoEntity value)?  $default,){
final _that = this;
switch (_that) {
case _DeliveryMessageInfoEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? deliveryMessage,  String? orderItemActionMessage,  String? secondaryMessage,  String? delayedDeliveryMessage,  String? previousEstimatedDeliveryDate,  String? color)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeliveryMessageInfoEntity() when $default != null:
return $default(_that.deliveryMessage,_that.orderItemActionMessage,_that.secondaryMessage,_that.delayedDeliveryMessage,_that.previousEstimatedDeliveryDate,_that.color);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? deliveryMessage,  String? orderItemActionMessage,  String? secondaryMessage,  String? delayedDeliveryMessage,  String? previousEstimatedDeliveryDate,  String? color)  $default,) {final _that = this;
switch (_that) {
case _DeliveryMessageInfoEntity():
return $default(_that.deliveryMessage,_that.orderItemActionMessage,_that.secondaryMessage,_that.delayedDeliveryMessage,_that.previousEstimatedDeliveryDate,_that.color);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? deliveryMessage,  String? orderItemActionMessage,  String? secondaryMessage,  String? delayedDeliveryMessage,  String? previousEstimatedDeliveryDate,  String? color)?  $default,) {final _that = this;
switch (_that) {
case _DeliveryMessageInfoEntity() when $default != null:
return $default(_that.deliveryMessage,_that.orderItemActionMessage,_that.secondaryMessage,_that.delayedDeliveryMessage,_that.previousEstimatedDeliveryDate,_that.color);case _:
  return null;

}
}

}

/// @nodoc


class _DeliveryMessageInfoEntity implements DeliveryMessageInfoEntity {
  const _DeliveryMessageInfoEntity({this.deliveryMessage, this.orderItemActionMessage, this.secondaryMessage, this.delayedDeliveryMessage, this.previousEstimatedDeliveryDate, this.color});
  

@override final  String? deliveryMessage;
@override final  String? orderItemActionMessage;
@override final  String? secondaryMessage;
@override final  String? delayedDeliveryMessage;
@override final  String? previousEstimatedDeliveryDate;
@override final  String? color;

/// Create a copy of DeliveryMessageInfoEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeliveryMessageInfoEntityCopyWith<_DeliveryMessageInfoEntity> get copyWith => __$DeliveryMessageInfoEntityCopyWithImpl<_DeliveryMessageInfoEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeliveryMessageInfoEntity&&(identical(other.deliveryMessage, deliveryMessage) || other.deliveryMessage == deliveryMessage)&&(identical(other.orderItemActionMessage, orderItemActionMessage) || other.orderItemActionMessage == orderItemActionMessage)&&(identical(other.secondaryMessage, secondaryMessage) || other.secondaryMessage == secondaryMessage)&&(identical(other.delayedDeliveryMessage, delayedDeliveryMessage) || other.delayedDeliveryMessage == delayedDeliveryMessage)&&(identical(other.previousEstimatedDeliveryDate, previousEstimatedDeliveryDate) || other.previousEstimatedDeliveryDate == previousEstimatedDeliveryDate)&&(identical(other.color, color) || other.color == color));
}


@override
int get hashCode => Object.hash(runtimeType,deliveryMessage,orderItemActionMessage,secondaryMessage,delayedDeliveryMessage,previousEstimatedDeliveryDate,color);

@override
String toString() {
  return 'DeliveryMessageInfoEntity(deliveryMessage: $deliveryMessage, orderItemActionMessage: $orderItemActionMessage, secondaryMessage: $secondaryMessage, delayedDeliveryMessage: $delayedDeliveryMessage, previousEstimatedDeliveryDate: $previousEstimatedDeliveryDate, color: $color)';
}


}

/// @nodoc
abstract mixin class _$DeliveryMessageInfoEntityCopyWith<$Res> implements $DeliveryMessageInfoEntityCopyWith<$Res> {
  factory _$DeliveryMessageInfoEntityCopyWith(_DeliveryMessageInfoEntity value, $Res Function(_DeliveryMessageInfoEntity) _then) = __$DeliveryMessageInfoEntityCopyWithImpl;
@override @useResult
$Res call({
 String? deliveryMessage, String? orderItemActionMessage, String? secondaryMessage, String? delayedDeliveryMessage, String? previousEstimatedDeliveryDate, String? color
});




}
/// @nodoc
class __$DeliveryMessageInfoEntityCopyWithImpl<$Res>
    implements _$DeliveryMessageInfoEntityCopyWith<$Res> {
  __$DeliveryMessageInfoEntityCopyWithImpl(this._self, this._then);

  final _DeliveryMessageInfoEntity _self;
  final $Res Function(_DeliveryMessageInfoEntity) _then;

/// Create a copy of DeliveryMessageInfoEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? deliveryMessage = freezed,Object? orderItemActionMessage = freezed,Object? secondaryMessage = freezed,Object? delayedDeliveryMessage = freezed,Object? previousEstimatedDeliveryDate = freezed,Object? color = freezed,}) {
  return _then(_DeliveryMessageInfoEntity(
deliveryMessage: freezed == deliveryMessage ? _self.deliveryMessage : deliveryMessage // ignore: cast_nullable_to_non_nullable
as String?,orderItemActionMessage: freezed == orderItemActionMessage ? _self.orderItemActionMessage : orderItemActionMessage // ignore: cast_nullable_to_non_nullable
as String?,secondaryMessage: freezed == secondaryMessage ? _self.secondaryMessage : secondaryMessage // ignore: cast_nullable_to_non_nullable
as String?,delayedDeliveryMessage: freezed == delayedDeliveryMessage ? _self.delayedDeliveryMessage : delayedDeliveryMessage // ignore: cast_nullable_to_non_nullable
as String?,previousEstimatedDeliveryDate: freezed == previousEstimatedDeliveryDate ? _self.previousEstimatedDeliveryDate : previousEstimatedDeliveryDate // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$ReturnInfoMessageEntity {

 bool get qcAndWrTagSuccess; String? get mobileNumber; String? get message;
/// Create a copy of ReturnInfoMessageEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReturnInfoMessageEntityCopyWith<ReturnInfoMessageEntity> get copyWith => _$ReturnInfoMessageEntityCopyWithImpl<ReturnInfoMessageEntity>(this as ReturnInfoMessageEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReturnInfoMessageEntity&&(identical(other.qcAndWrTagSuccess, qcAndWrTagSuccess) || other.qcAndWrTagSuccess == qcAndWrTagSuccess)&&(identical(other.mobileNumber, mobileNumber) || other.mobileNumber == mobileNumber)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,qcAndWrTagSuccess,mobileNumber,message);

@override
String toString() {
  return 'ReturnInfoMessageEntity(qcAndWrTagSuccess: $qcAndWrTagSuccess, mobileNumber: $mobileNumber, message: $message)';
}


}

/// @nodoc
abstract mixin class $ReturnInfoMessageEntityCopyWith<$Res>  {
  factory $ReturnInfoMessageEntityCopyWith(ReturnInfoMessageEntity value, $Res Function(ReturnInfoMessageEntity) _then) = _$ReturnInfoMessageEntityCopyWithImpl;
@useResult
$Res call({
 bool qcAndWrTagSuccess, String? mobileNumber, String? message
});




}
/// @nodoc
class _$ReturnInfoMessageEntityCopyWithImpl<$Res>
    implements $ReturnInfoMessageEntityCopyWith<$Res> {
  _$ReturnInfoMessageEntityCopyWithImpl(this._self, this._then);

  final ReturnInfoMessageEntity _self;
  final $Res Function(ReturnInfoMessageEntity) _then;

/// Create a copy of ReturnInfoMessageEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? qcAndWrTagSuccess = null,Object? mobileNumber = freezed,Object? message = freezed,}) {
  return _then(_self.copyWith(
qcAndWrTagSuccess: null == qcAndWrTagSuccess ? _self.qcAndWrTagSuccess : qcAndWrTagSuccess // ignore: cast_nullable_to_non_nullable
as bool,mobileNumber: freezed == mobileNumber ? _self.mobileNumber : mobileNumber // ignore: cast_nullable_to_non_nullable
as String?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReturnInfoMessageEntity].
extension ReturnInfoMessageEntityPatterns on ReturnInfoMessageEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReturnInfoMessageEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReturnInfoMessageEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReturnInfoMessageEntity value)  $default,){
final _that = this;
switch (_that) {
case _ReturnInfoMessageEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReturnInfoMessageEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ReturnInfoMessageEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool qcAndWrTagSuccess,  String? mobileNumber,  String? message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReturnInfoMessageEntity() when $default != null:
return $default(_that.qcAndWrTagSuccess,_that.mobileNumber,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool qcAndWrTagSuccess,  String? mobileNumber,  String? message)  $default,) {final _that = this;
switch (_that) {
case _ReturnInfoMessageEntity():
return $default(_that.qcAndWrTagSuccess,_that.mobileNumber,_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool qcAndWrTagSuccess,  String? mobileNumber,  String? message)?  $default,) {final _that = this;
switch (_that) {
case _ReturnInfoMessageEntity() when $default != null:
return $default(_that.qcAndWrTagSuccess,_that.mobileNumber,_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _ReturnInfoMessageEntity implements ReturnInfoMessageEntity {
  const _ReturnInfoMessageEntity({this.qcAndWrTagSuccess = false, this.mobileNumber, this.message});
  

@override@JsonKey() final  bool qcAndWrTagSuccess;
@override final  String? mobileNumber;
@override final  String? message;

/// Create a copy of ReturnInfoMessageEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReturnInfoMessageEntityCopyWith<_ReturnInfoMessageEntity> get copyWith => __$ReturnInfoMessageEntityCopyWithImpl<_ReturnInfoMessageEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReturnInfoMessageEntity&&(identical(other.qcAndWrTagSuccess, qcAndWrTagSuccess) || other.qcAndWrTagSuccess == qcAndWrTagSuccess)&&(identical(other.mobileNumber, mobileNumber) || other.mobileNumber == mobileNumber)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,qcAndWrTagSuccess,mobileNumber,message);

@override
String toString() {
  return 'ReturnInfoMessageEntity(qcAndWrTagSuccess: $qcAndWrTagSuccess, mobileNumber: $mobileNumber, message: $message)';
}


}

/// @nodoc
abstract mixin class _$ReturnInfoMessageEntityCopyWith<$Res> implements $ReturnInfoMessageEntityCopyWith<$Res> {
  factory _$ReturnInfoMessageEntityCopyWith(_ReturnInfoMessageEntity value, $Res Function(_ReturnInfoMessageEntity) _then) = __$ReturnInfoMessageEntityCopyWithImpl;
@override @useResult
$Res call({
 bool qcAndWrTagSuccess, String? mobileNumber, String? message
});




}
/// @nodoc
class __$ReturnInfoMessageEntityCopyWithImpl<$Res>
    implements _$ReturnInfoMessageEntityCopyWith<$Res> {
  __$ReturnInfoMessageEntityCopyWithImpl(this._self, this._then);

  final _ReturnInfoMessageEntity _self;
  final $Res Function(_ReturnInfoMessageEntity) _then;

/// Create a copy of ReturnInfoMessageEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? qcAndWrTagSuccess = null,Object? mobileNumber = freezed,Object? message = freezed,}) {
  return _then(_ReturnInfoMessageEntity(
qcAndWrTagSuccess: null == qcAndWrTagSuccess ? _self.qcAndWrTagSuccess : qcAndWrTagSuccess // ignore: cast_nullable_to_non_nullable
as bool,mobileNumber: freezed == mobileNumber ? _self.mobileNumber : mobileNumber // ignore: cast_nullable_to_non_nullable
as String?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
