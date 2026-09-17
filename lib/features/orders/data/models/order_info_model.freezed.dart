// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_info_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OrderInfoModel {

 String? get barCode; String? get orderId; String? get iconStatus;@JsonKey(name: 'productId', fromJson: parseToInt) int get productId; String? get hsBrandLabel; String get productName; String? get productImageUrl; String? get productSize; int get orderItemId; int get itemCounts; double get amount; DeliveryMessageInfoModel? get deliveryMessage; ReturnInfoMessageModel? get returnTagMessage; bool get isGift;
/// Create a copy of OrderInfoModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderInfoModelCopyWith<OrderInfoModel> get copyWith => _$OrderInfoModelCopyWithImpl<OrderInfoModel>(this as OrderInfoModel, _$identity);

  /// Serializes this OrderInfoModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderInfoModel&&(identical(other.barCode, barCode) || other.barCode == barCode)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.iconStatus, iconStatus) || other.iconStatus == iconStatus)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.hsBrandLabel, hsBrandLabel) || other.hsBrandLabel == hsBrandLabel)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.productImageUrl, productImageUrl) || other.productImageUrl == productImageUrl)&&(identical(other.productSize, productSize) || other.productSize == productSize)&&(identical(other.orderItemId, orderItemId) || other.orderItemId == orderItemId)&&(identical(other.itemCounts, itemCounts) || other.itemCounts == itemCounts)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.deliveryMessage, deliveryMessage) || other.deliveryMessage == deliveryMessage)&&(identical(other.returnTagMessage, returnTagMessage) || other.returnTagMessage == returnTagMessage)&&(identical(other.isGift, isGift) || other.isGift == isGift));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,barCode,orderId,iconStatus,productId,hsBrandLabel,productName,productImageUrl,productSize,orderItemId,itemCounts,amount,deliveryMessage,returnTagMessage,isGift);

@override
String toString() {
  return 'OrderInfoModel(barCode: $barCode, orderId: $orderId, iconStatus: $iconStatus, productId: $productId, hsBrandLabel: $hsBrandLabel, productName: $productName, productImageUrl: $productImageUrl, productSize: $productSize, orderItemId: $orderItemId, itemCounts: $itemCounts, amount: $amount, deliveryMessage: $deliveryMessage, returnTagMessage: $returnTagMessage, isGift: $isGift)';
}


}

/// @nodoc
abstract mixin class $OrderInfoModelCopyWith<$Res>  {
  factory $OrderInfoModelCopyWith(OrderInfoModel value, $Res Function(OrderInfoModel) _then) = _$OrderInfoModelCopyWithImpl;
@useResult
$Res call({
 String? barCode, String? orderId, String? iconStatus,@JsonKey(name: 'productId', fromJson: parseToInt) int productId, String? hsBrandLabel, String productName, String? productImageUrl, String? productSize, int orderItemId, int itemCounts, double amount, DeliveryMessageInfoModel? deliveryMessage, ReturnInfoMessageModel? returnTagMessage, bool isGift
});


$DeliveryMessageInfoModelCopyWith<$Res>? get deliveryMessage;$ReturnInfoMessageModelCopyWith<$Res>? get returnTagMessage;

}
/// @nodoc
class _$OrderInfoModelCopyWithImpl<$Res>
    implements $OrderInfoModelCopyWith<$Res> {
  _$OrderInfoModelCopyWithImpl(this._self, this._then);

  final OrderInfoModel _self;
  final $Res Function(OrderInfoModel) _then;

/// Create a copy of OrderInfoModel
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
as DeliveryMessageInfoModel?,returnTagMessage: freezed == returnTagMessage ? _self.returnTagMessage : returnTagMessage // ignore: cast_nullable_to_non_nullable
as ReturnInfoMessageModel?,isGift: null == isGift ? _self.isGift : isGift // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of OrderInfoModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeliveryMessageInfoModelCopyWith<$Res>? get deliveryMessage {
    if (_self.deliveryMessage == null) {
    return null;
  }

  return $DeliveryMessageInfoModelCopyWith<$Res>(_self.deliveryMessage!, (value) {
    return _then(_self.copyWith(deliveryMessage: value));
  });
}/// Create a copy of OrderInfoModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReturnInfoMessageModelCopyWith<$Res>? get returnTagMessage {
    if (_self.returnTagMessage == null) {
    return null;
  }

  return $ReturnInfoMessageModelCopyWith<$Res>(_self.returnTagMessage!, (value) {
    return _then(_self.copyWith(returnTagMessage: value));
  });
}
}


/// Adds pattern-matching-related methods to [OrderInfoModel].
extension OrderInfoModelPatterns on OrderInfoModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderInfoModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderInfoModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderInfoModel value)  $default,){
final _that = this;
switch (_that) {
case _OrderInfoModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderInfoModel value)?  $default,){
final _that = this;
switch (_that) {
case _OrderInfoModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? barCode,  String? orderId,  String? iconStatus, @JsonKey(name: 'productId', fromJson: parseToInt)  int productId,  String? hsBrandLabel,  String productName,  String? productImageUrl,  String? productSize,  int orderItemId,  int itemCounts,  double amount,  DeliveryMessageInfoModel? deliveryMessage,  ReturnInfoMessageModel? returnTagMessage,  bool isGift)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderInfoModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? barCode,  String? orderId,  String? iconStatus, @JsonKey(name: 'productId', fromJson: parseToInt)  int productId,  String? hsBrandLabel,  String productName,  String? productImageUrl,  String? productSize,  int orderItemId,  int itemCounts,  double amount,  DeliveryMessageInfoModel? deliveryMessage,  ReturnInfoMessageModel? returnTagMessage,  bool isGift)  $default,) {final _that = this;
switch (_that) {
case _OrderInfoModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? barCode,  String? orderId,  String? iconStatus, @JsonKey(name: 'productId', fromJson: parseToInt)  int productId,  String? hsBrandLabel,  String productName,  String? productImageUrl,  String? productSize,  int orderItemId,  int itemCounts,  double amount,  DeliveryMessageInfoModel? deliveryMessage,  ReturnInfoMessageModel? returnTagMessage,  bool isGift)?  $default,) {final _that = this;
switch (_that) {
case _OrderInfoModel() when $default != null:
return $default(_that.barCode,_that.orderId,_that.iconStatus,_that.productId,_that.hsBrandLabel,_that.productName,_that.productImageUrl,_that.productSize,_that.orderItemId,_that.itemCounts,_that.amount,_that.deliveryMessage,_that.returnTagMessage,_that.isGift);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderInfoModel extends OrderInfoModel {
  const _OrderInfoModel({this.barCode, this.orderId, this.iconStatus, @JsonKey(name: 'productId', fromJson: parseToInt) this.productId = 0, this.hsBrandLabel, this.productName = '', this.productImageUrl, this.productSize, this.orderItemId = 0, this.itemCounts = 0, this.amount = 0.0, this.deliveryMessage, this.returnTagMessage, this.isGift = false}): super._();
  factory _OrderInfoModel.fromJson(Map<String, dynamic> json) => _$OrderInfoModelFromJson(json);

@override final  String? barCode;
@override final  String? orderId;
@override final  String? iconStatus;
@override@JsonKey(name: 'productId', fromJson: parseToInt) final  int productId;
@override final  String? hsBrandLabel;
@override@JsonKey() final  String productName;
@override final  String? productImageUrl;
@override final  String? productSize;
@override@JsonKey() final  int orderItemId;
@override@JsonKey() final  int itemCounts;
@override@JsonKey() final  double amount;
@override final  DeliveryMessageInfoModel? deliveryMessage;
@override final  ReturnInfoMessageModel? returnTagMessage;
@override@JsonKey() final  bool isGift;

/// Create a copy of OrderInfoModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderInfoModelCopyWith<_OrderInfoModel> get copyWith => __$OrderInfoModelCopyWithImpl<_OrderInfoModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderInfoModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderInfoModel&&(identical(other.barCode, barCode) || other.barCode == barCode)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.iconStatus, iconStatus) || other.iconStatus == iconStatus)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.hsBrandLabel, hsBrandLabel) || other.hsBrandLabel == hsBrandLabel)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.productImageUrl, productImageUrl) || other.productImageUrl == productImageUrl)&&(identical(other.productSize, productSize) || other.productSize == productSize)&&(identical(other.orderItemId, orderItemId) || other.orderItemId == orderItemId)&&(identical(other.itemCounts, itemCounts) || other.itemCounts == itemCounts)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.deliveryMessage, deliveryMessage) || other.deliveryMessage == deliveryMessage)&&(identical(other.returnTagMessage, returnTagMessage) || other.returnTagMessage == returnTagMessage)&&(identical(other.isGift, isGift) || other.isGift == isGift));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,barCode,orderId,iconStatus,productId,hsBrandLabel,productName,productImageUrl,productSize,orderItemId,itemCounts,amount,deliveryMessage,returnTagMessage,isGift);

@override
String toString() {
  return 'OrderInfoModel(barCode: $barCode, orderId: $orderId, iconStatus: $iconStatus, productId: $productId, hsBrandLabel: $hsBrandLabel, productName: $productName, productImageUrl: $productImageUrl, productSize: $productSize, orderItemId: $orderItemId, itemCounts: $itemCounts, amount: $amount, deliveryMessage: $deliveryMessage, returnTagMessage: $returnTagMessage, isGift: $isGift)';
}


}

/// @nodoc
abstract mixin class _$OrderInfoModelCopyWith<$Res> implements $OrderInfoModelCopyWith<$Res> {
  factory _$OrderInfoModelCopyWith(_OrderInfoModel value, $Res Function(_OrderInfoModel) _then) = __$OrderInfoModelCopyWithImpl;
@override @useResult
$Res call({
 String? barCode, String? orderId, String? iconStatus,@JsonKey(name: 'productId', fromJson: parseToInt) int productId, String? hsBrandLabel, String productName, String? productImageUrl, String? productSize, int orderItemId, int itemCounts, double amount, DeliveryMessageInfoModel? deliveryMessage, ReturnInfoMessageModel? returnTagMessage, bool isGift
});


@override $DeliveryMessageInfoModelCopyWith<$Res>? get deliveryMessage;@override $ReturnInfoMessageModelCopyWith<$Res>? get returnTagMessage;

}
/// @nodoc
class __$OrderInfoModelCopyWithImpl<$Res>
    implements _$OrderInfoModelCopyWith<$Res> {
  __$OrderInfoModelCopyWithImpl(this._self, this._then);

  final _OrderInfoModel _self;
  final $Res Function(_OrderInfoModel) _then;

/// Create a copy of OrderInfoModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? barCode = freezed,Object? orderId = freezed,Object? iconStatus = freezed,Object? productId = null,Object? hsBrandLabel = freezed,Object? productName = null,Object? productImageUrl = freezed,Object? productSize = freezed,Object? orderItemId = null,Object? itemCounts = null,Object? amount = null,Object? deliveryMessage = freezed,Object? returnTagMessage = freezed,Object? isGift = null,}) {
  return _then(_OrderInfoModel(
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
as DeliveryMessageInfoModel?,returnTagMessage: freezed == returnTagMessage ? _self.returnTagMessage : returnTagMessage // ignore: cast_nullable_to_non_nullable
as ReturnInfoMessageModel?,isGift: null == isGift ? _self.isGift : isGift // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of OrderInfoModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeliveryMessageInfoModelCopyWith<$Res>? get deliveryMessage {
    if (_self.deliveryMessage == null) {
    return null;
  }

  return $DeliveryMessageInfoModelCopyWith<$Res>(_self.deliveryMessage!, (value) {
    return _then(_self.copyWith(deliveryMessage: value));
  });
}/// Create a copy of OrderInfoModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReturnInfoMessageModelCopyWith<$Res>? get returnTagMessage {
    if (_self.returnTagMessage == null) {
    return null;
  }

  return $ReturnInfoMessageModelCopyWith<$Res>(_self.returnTagMessage!, (value) {
    return _then(_self.copyWith(returnTagMessage: value));
  });
}
}


/// @nodoc
mixin _$DeliveryMessageInfoModel {

 String? get deliveryMessage; String? get orderItemActionMessage; String? get secondaryMessage; String? get delayedDeliveryMessage; String? get previousEstimatedDeliveryDate; String? get color;
/// Create a copy of DeliveryMessageInfoModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeliveryMessageInfoModelCopyWith<DeliveryMessageInfoModel> get copyWith => _$DeliveryMessageInfoModelCopyWithImpl<DeliveryMessageInfoModel>(this as DeliveryMessageInfoModel, _$identity);

  /// Serializes this DeliveryMessageInfoModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeliveryMessageInfoModel&&(identical(other.deliveryMessage, deliveryMessage) || other.deliveryMessage == deliveryMessage)&&(identical(other.orderItemActionMessage, orderItemActionMessage) || other.orderItemActionMessage == orderItemActionMessage)&&(identical(other.secondaryMessage, secondaryMessage) || other.secondaryMessage == secondaryMessage)&&(identical(other.delayedDeliveryMessage, delayedDeliveryMessage) || other.delayedDeliveryMessage == delayedDeliveryMessage)&&(identical(other.previousEstimatedDeliveryDate, previousEstimatedDeliveryDate) || other.previousEstimatedDeliveryDate == previousEstimatedDeliveryDate)&&(identical(other.color, color) || other.color == color));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,deliveryMessage,orderItemActionMessage,secondaryMessage,delayedDeliveryMessage,previousEstimatedDeliveryDate,color);

@override
String toString() {
  return 'DeliveryMessageInfoModel(deliveryMessage: $deliveryMessage, orderItemActionMessage: $orderItemActionMessage, secondaryMessage: $secondaryMessage, delayedDeliveryMessage: $delayedDeliveryMessage, previousEstimatedDeliveryDate: $previousEstimatedDeliveryDate, color: $color)';
}


}

/// @nodoc
abstract mixin class $DeliveryMessageInfoModelCopyWith<$Res>  {
  factory $DeliveryMessageInfoModelCopyWith(DeliveryMessageInfoModel value, $Res Function(DeliveryMessageInfoModel) _then) = _$DeliveryMessageInfoModelCopyWithImpl;
@useResult
$Res call({
 String? deliveryMessage, String? orderItemActionMessage, String? secondaryMessage, String? delayedDeliveryMessage, String? previousEstimatedDeliveryDate, String? color
});




}
/// @nodoc
class _$DeliveryMessageInfoModelCopyWithImpl<$Res>
    implements $DeliveryMessageInfoModelCopyWith<$Res> {
  _$DeliveryMessageInfoModelCopyWithImpl(this._self, this._then);

  final DeliveryMessageInfoModel _self;
  final $Res Function(DeliveryMessageInfoModel) _then;

/// Create a copy of DeliveryMessageInfoModel
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


/// Adds pattern-matching-related methods to [DeliveryMessageInfoModel].
extension DeliveryMessageInfoModelPatterns on DeliveryMessageInfoModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeliveryMessageInfoModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeliveryMessageInfoModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeliveryMessageInfoModel value)  $default,){
final _that = this;
switch (_that) {
case _DeliveryMessageInfoModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeliveryMessageInfoModel value)?  $default,){
final _that = this;
switch (_that) {
case _DeliveryMessageInfoModel() when $default != null:
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
case _DeliveryMessageInfoModel() when $default != null:
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
case _DeliveryMessageInfoModel():
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
case _DeliveryMessageInfoModel() when $default != null:
return $default(_that.deliveryMessage,_that.orderItemActionMessage,_that.secondaryMessage,_that.delayedDeliveryMessage,_that.previousEstimatedDeliveryDate,_that.color);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeliveryMessageInfoModel extends DeliveryMessageInfoModel {
  const _DeliveryMessageInfoModel({this.deliveryMessage, this.orderItemActionMessage, this.secondaryMessage, this.delayedDeliveryMessage, this.previousEstimatedDeliveryDate, this.color}): super._();
  factory _DeliveryMessageInfoModel.fromJson(Map<String, dynamic> json) => _$DeliveryMessageInfoModelFromJson(json);

@override final  String? deliveryMessage;
@override final  String? orderItemActionMessage;
@override final  String? secondaryMessage;
@override final  String? delayedDeliveryMessage;
@override final  String? previousEstimatedDeliveryDate;
@override final  String? color;

/// Create a copy of DeliveryMessageInfoModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeliveryMessageInfoModelCopyWith<_DeliveryMessageInfoModel> get copyWith => __$DeliveryMessageInfoModelCopyWithImpl<_DeliveryMessageInfoModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeliveryMessageInfoModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeliveryMessageInfoModel&&(identical(other.deliveryMessage, deliveryMessage) || other.deliveryMessage == deliveryMessage)&&(identical(other.orderItemActionMessage, orderItemActionMessage) || other.orderItemActionMessage == orderItemActionMessage)&&(identical(other.secondaryMessage, secondaryMessage) || other.secondaryMessage == secondaryMessage)&&(identical(other.delayedDeliveryMessage, delayedDeliveryMessage) || other.delayedDeliveryMessage == delayedDeliveryMessage)&&(identical(other.previousEstimatedDeliveryDate, previousEstimatedDeliveryDate) || other.previousEstimatedDeliveryDate == previousEstimatedDeliveryDate)&&(identical(other.color, color) || other.color == color));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,deliveryMessage,orderItemActionMessage,secondaryMessage,delayedDeliveryMessage,previousEstimatedDeliveryDate,color);

@override
String toString() {
  return 'DeliveryMessageInfoModel(deliveryMessage: $deliveryMessage, orderItemActionMessage: $orderItemActionMessage, secondaryMessage: $secondaryMessage, delayedDeliveryMessage: $delayedDeliveryMessage, previousEstimatedDeliveryDate: $previousEstimatedDeliveryDate, color: $color)';
}


}

/// @nodoc
abstract mixin class _$DeliveryMessageInfoModelCopyWith<$Res> implements $DeliveryMessageInfoModelCopyWith<$Res> {
  factory _$DeliveryMessageInfoModelCopyWith(_DeliveryMessageInfoModel value, $Res Function(_DeliveryMessageInfoModel) _then) = __$DeliveryMessageInfoModelCopyWithImpl;
@override @useResult
$Res call({
 String? deliveryMessage, String? orderItemActionMessage, String? secondaryMessage, String? delayedDeliveryMessage, String? previousEstimatedDeliveryDate, String? color
});




}
/// @nodoc
class __$DeliveryMessageInfoModelCopyWithImpl<$Res>
    implements _$DeliveryMessageInfoModelCopyWith<$Res> {
  __$DeliveryMessageInfoModelCopyWithImpl(this._self, this._then);

  final _DeliveryMessageInfoModel _self;
  final $Res Function(_DeliveryMessageInfoModel) _then;

/// Create a copy of DeliveryMessageInfoModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? deliveryMessage = freezed,Object? orderItemActionMessage = freezed,Object? secondaryMessage = freezed,Object? delayedDeliveryMessage = freezed,Object? previousEstimatedDeliveryDate = freezed,Object? color = freezed,}) {
  return _then(_DeliveryMessageInfoModel(
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
mixin _$ReturnInfoMessageModel {

 bool get qcAndWrTagSuccess; String? get mobileNumber; String? get message;
/// Create a copy of ReturnInfoMessageModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReturnInfoMessageModelCopyWith<ReturnInfoMessageModel> get copyWith => _$ReturnInfoMessageModelCopyWithImpl<ReturnInfoMessageModel>(this as ReturnInfoMessageModel, _$identity);

  /// Serializes this ReturnInfoMessageModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReturnInfoMessageModel&&(identical(other.qcAndWrTagSuccess, qcAndWrTagSuccess) || other.qcAndWrTagSuccess == qcAndWrTagSuccess)&&(identical(other.mobileNumber, mobileNumber) || other.mobileNumber == mobileNumber)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,qcAndWrTagSuccess,mobileNumber,message);

@override
String toString() {
  return 'ReturnInfoMessageModel(qcAndWrTagSuccess: $qcAndWrTagSuccess, mobileNumber: $mobileNumber, message: $message)';
}


}

/// @nodoc
abstract mixin class $ReturnInfoMessageModelCopyWith<$Res>  {
  factory $ReturnInfoMessageModelCopyWith(ReturnInfoMessageModel value, $Res Function(ReturnInfoMessageModel) _then) = _$ReturnInfoMessageModelCopyWithImpl;
@useResult
$Res call({
 bool qcAndWrTagSuccess, String? mobileNumber, String? message
});




}
/// @nodoc
class _$ReturnInfoMessageModelCopyWithImpl<$Res>
    implements $ReturnInfoMessageModelCopyWith<$Res> {
  _$ReturnInfoMessageModelCopyWithImpl(this._self, this._then);

  final ReturnInfoMessageModel _self;
  final $Res Function(ReturnInfoMessageModel) _then;

/// Create a copy of ReturnInfoMessageModel
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


/// Adds pattern-matching-related methods to [ReturnInfoMessageModel].
extension ReturnInfoMessageModelPatterns on ReturnInfoMessageModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReturnInfoMessageModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReturnInfoMessageModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReturnInfoMessageModel value)  $default,){
final _that = this;
switch (_that) {
case _ReturnInfoMessageModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReturnInfoMessageModel value)?  $default,){
final _that = this;
switch (_that) {
case _ReturnInfoMessageModel() when $default != null:
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
case _ReturnInfoMessageModel() when $default != null:
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
case _ReturnInfoMessageModel():
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
case _ReturnInfoMessageModel() when $default != null:
return $default(_that.qcAndWrTagSuccess,_that.mobileNumber,_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReturnInfoMessageModel extends ReturnInfoMessageModel {
  const _ReturnInfoMessageModel({this.qcAndWrTagSuccess = false, this.mobileNumber, this.message}): super._();
  factory _ReturnInfoMessageModel.fromJson(Map<String, dynamic> json) => _$ReturnInfoMessageModelFromJson(json);

@override@JsonKey() final  bool qcAndWrTagSuccess;
@override final  String? mobileNumber;
@override final  String? message;

/// Create a copy of ReturnInfoMessageModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReturnInfoMessageModelCopyWith<_ReturnInfoMessageModel> get copyWith => __$ReturnInfoMessageModelCopyWithImpl<_ReturnInfoMessageModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReturnInfoMessageModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReturnInfoMessageModel&&(identical(other.qcAndWrTagSuccess, qcAndWrTagSuccess) || other.qcAndWrTagSuccess == qcAndWrTagSuccess)&&(identical(other.mobileNumber, mobileNumber) || other.mobileNumber == mobileNumber)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,qcAndWrTagSuccess,mobileNumber,message);

@override
String toString() {
  return 'ReturnInfoMessageModel(qcAndWrTagSuccess: $qcAndWrTagSuccess, mobileNumber: $mobileNumber, message: $message)';
}


}

/// @nodoc
abstract mixin class _$ReturnInfoMessageModelCopyWith<$Res> implements $ReturnInfoMessageModelCopyWith<$Res> {
  factory _$ReturnInfoMessageModelCopyWith(_ReturnInfoMessageModel value, $Res Function(_ReturnInfoMessageModel) _then) = __$ReturnInfoMessageModelCopyWithImpl;
@override @useResult
$Res call({
 bool qcAndWrTagSuccess, String? mobileNumber, String? message
});




}
/// @nodoc
class __$ReturnInfoMessageModelCopyWithImpl<$Res>
    implements _$ReturnInfoMessageModelCopyWith<$Res> {
  __$ReturnInfoMessageModelCopyWithImpl(this._self, this._then);

  final _ReturnInfoMessageModel _self;
  final $Res Function(_ReturnInfoMessageModel) _then;

/// Create a copy of ReturnInfoMessageModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? qcAndWrTagSuccess = null,Object? mobileNumber = freezed,Object? message = freezed,}) {
  return _then(_ReturnInfoMessageModel(
qcAndWrTagSuccess: null == qcAndWrTagSuccess ? _self.qcAndWrTagSuccess : qcAndWrTagSuccess // ignore: cast_nullable_to_non_nullable
as bool,mobileNumber: freezed == mobileNumber ? _self.mobileNumber : mobileNumber // ignore: cast_nullable_to_non_nullable
as String?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
