// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pdp_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PdpEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PdpEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PdpEvent()';
}


}

/// @nodoc
class $PdpEventCopyWith<$Res>  {
$PdpEventCopyWith(PdpEvent _, $Res Function(PdpEvent) __);
}


/// Adds pattern-matching-related methods to [PdpEvent].
extension PdpEventPatterns on PdpEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoadProductDetails value)?  loadProductDetails,TResult Function( SelectSku value)?  selectSku,TResult Function( AddToBag value)?  addToBag,TResult Function( BuyNow value)?  buyNow,TResult Function( VerifyPincode value)?  verifyPincode,TResult Function( SelectColorVariant value)?  selectColorVariant,TResult Function( ExpandDetailTab value)?  expandDetailTab,TResult Function( LoadRecommendations value)?  loadRecommendations,TResult Function( LoadMoreRecommendations value)?  loadMoreRecommendations,TResult Function( LoadSizeChart value)?  loadSizeChart,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoadProductDetails() when loadProductDetails != null:
return loadProductDetails(_that);case SelectSku() when selectSku != null:
return selectSku(_that);case AddToBag() when addToBag != null:
return addToBag(_that);case BuyNow() when buyNow != null:
return buyNow(_that);case VerifyPincode() when verifyPincode != null:
return verifyPincode(_that);case SelectColorVariant() when selectColorVariant != null:
return selectColorVariant(_that);case ExpandDetailTab() when expandDetailTab != null:
return expandDetailTab(_that);case LoadRecommendations() when loadRecommendations != null:
return loadRecommendations(_that);case LoadMoreRecommendations() when loadMoreRecommendations != null:
return loadMoreRecommendations(_that);case LoadSizeChart() when loadSizeChart != null:
return loadSizeChart(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoadProductDetails value)  loadProductDetails,required TResult Function( SelectSku value)  selectSku,required TResult Function( AddToBag value)  addToBag,required TResult Function( BuyNow value)  buyNow,required TResult Function( VerifyPincode value)  verifyPincode,required TResult Function( SelectColorVariant value)  selectColorVariant,required TResult Function( ExpandDetailTab value)  expandDetailTab,required TResult Function( LoadRecommendations value)  loadRecommendations,required TResult Function( LoadMoreRecommendations value)  loadMoreRecommendations,required TResult Function( LoadSizeChart value)  loadSizeChart,}){
final _that = this;
switch (_that) {
case LoadProductDetails():
return loadProductDetails(_that);case SelectSku():
return selectSku(_that);case AddToBag():
return addToBag(_that);case BuyNow():
return buyNow(_that);case VerifyPincode():
return verifyPincode(_that);case SelectColorVariant():
return selectColorVariant(_that);case ExpandDetailTab():
return expandDetailTab(_that);case LoadRecommendations():
return loadRecommendations(_that);case LoadMoreRecommendations():
return loadMoreRecommendations(_that);case LoadSizeChart():
return loadSizeChart(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoadProductDetails value)?  loadProductDetails,TResult? Function( SelectSku value)?  selectSku,TResult? Function( AddToBag value)?  addToBag,TResult? Function( BuyNow value)?  buyNow,TResult? Function( VerifyPincode value)?  verifyPincode,TResult? Function( SelectColorVariant value)?  selectColorVariant,TResult? Function( ExpandDetailTab value)?  expandDetailTab,TResult? Function( LoadRecommendations value)?  loadRecommendations,TResult? Function( LoadMoreRecommendations value)?  loadMoreRecommendations,TResult? Function( LoadSizeChart value)?  loadSizeChart,}){
final _that = this;
switch (_that) {
case LoadProductDetails() when loadProductDetails != null:
return loadProductDetails(_that);case SelectSku() when selectSku != null:
return selectSku(_that);case AddToBag() when addToBag != null:
return addToBag(_that);case BuyNow() when buyNow != null:
return buyNow(_that);case VerifyPincode() when verifyPincode != null:
return verifyPincode(_that);case SelectColorVariant() when selectColorVariant != null:
return selectColorVariant(_that);case ExpandDetailTab() when expandDetailTab != null:
return expandDetailTab(_that);case LoadRecommendations() when loadRecommendations != null:
return loadRecommendations(_that);case LoadMoreRecommendations() when loadMoreRecommendations != null:
return loadMoreRecommendations(_that);case LoadSizeChart() when loadSizeChart != null:
return loadSizeChart(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( int productId)?  loadProductDetails,TResult Function( String skuId)?  selectSku,TResult Function( String skuId)?  addToBag,TResult Function( String skuId)?  buyNow,TResult Function( String pincode)?  verifyPincode,TResult Function( int productId)?  selectColorVariant,TResult Function( int tabIndex)?  expandDetailTab,TResult Function( int productId)?  loadRecommendations,TResult Function()?  loadMoreRecommendations,TResult Function()?  loadSizeChart,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoadProductDetails() when loadProductDetails != null:
return loadProductDetails(_that.productId);case SelectSku() when selectSku != null:
return selectSku(_that.skuId);case AddToBag() when addToBag != null:
return addToBag(_that.skuId);case BuyNow() when buyNow != null:
return buyNow(_that.skuId);case VerifyPincode() when verifyPincode != null:
return verifyPincode(_that.pincode);case SelectColorVariant() when selectColorVariant != null:
return selectColorVariant(_that.productId);case ExpandDetailTab() when expandDetailTab != null:
return expandDetailTab(_that.tabIndex);case LoadRecommendations() when loadRecommendations != null:
return loadRecommendations(_that.productId);case LoadMoreRecommendations() when loadMoreRecommendations != null:
return loadMoreRecommendations();case LoadSizeChart() when loadSizeChart != null:
return loadSizeChart();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( int productId)  loadProductDetails,required TResult Function( String skuId)  selectSku,required TResult Function( String skuId)  addToBag,required TResult Function( String skuId)  buyNow,required TResult Function( String pincode)  verifyPincode,required TResult Function( int productId)  selectColorVariant,required TResult Function( int tabIndex)  expandDetailTab,required TResult Function( int productId)  loadRecommendations,required TResult Function()  loadMoreRecommendations,required TResult Function()  loadSizeChart,}) {final _that = this;
switch (_that) {
case LoadProductDetails():
return loadProductDetails(_that.productId);case SelectSku():
return selectSku(_that.skuId);case AddToBag():
return addToBag(_that.skuId);case BuyNow():
return buyNow(_that.skuId);case VerifyPincode():
return verifyPincode(_that.pincode);case SelectColorVariant():
return selectColorVariant(_that.productId);case ExpandDetailTab():
return expandDetailTab(_that.tabIndex);case LoadRecommendations():
return loadRecommendations(_that.productId);case LoadMoreRecommendations():
return loadMoreRecommendations();case LoadSizeChart():
return loadSizeChart();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( int productId)?  loadProductDetails,TResult? Function( String skuId)?  selectSku,TResult? Function( String skuId)?  addToBag,TResult? Function( String skuId)?  buyNow,TResult? Function( String pincode)?  verifyPincode,TResult? Function( int productId)?  selectColorVariant,TResult? Function( int tabIndex)?  expandDetailTab,TResult? Function( int productId)?  loadRecommendations,TResult? Function()?  loadMoreRecommendations,TResult? Function()?  loadSizeChart,}) {final _that = this;
switch (_that) {
case LoadProductDetails() when loadProductDetails != null:
return loadProductDetails(_that.productId);case SelectSku() when selectSku != null:
return selectSku(_that.skuId);case AddToBag() when addToBag != null:
return addToBag(_that.skuId);case BuyNow() when buyNow != null:
return buyNow(_that.skuId);case VerifyPincode() when verifyPincode != null:
return verifyPincode(_that.pincode);case SelectColorVariant() when selectColorVariant != null:
return selectColorVariant(_that.productId);case ExpandDetailTab() when expandDetailTab != null:
return expandDetailTab(_that.tabIndex);case LoadRecommendations() when loadRecommendations != null:
return loadRecommendations(_that.productId);case LoadMoreRecommendations() when loadMoreRecommendations != null:
return loadMoreRecommendations();case LoadSizeChart() when loadSizeChart != null:
return loadSizeChart();case _:
  return null;

}
}

}

/// @nodoc


class LoadProductDetails implements PdpEvent {
  const LoadProductDetails({required this.productId});
  

 final  int productId;

/// Create a copy of PdpEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadProductDetailsCopyWith<LoadProductDetails> get copyWith => _$LoadProductDetailsCopyWithImpl<LoadProductDetails>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadProductDetails&&(identical(other.productId, productId) || other.productId == productId));
}


@override
int get hashCode => Object.hash(runtimeType,productId);

@override
String toString() {
  return 'PdpEvent.loadProductDetails(productId: $productId)';
}


}

/// @nodoc
abstract mixin class $LoadProductDetailsCopyWith<$Res> implements $PdpEventCopyWith<$Res> {
  factory $LoadProductDetailsCopyWith(LoadProductDetails value, $Res Function(LoadProductDetails) _then) = _$LoadProductDetailsCopyWithImpl;
@useResult
$Res call({
 int productId
});




}
/// @nodoc
class _$LoadProductDetailsCopyWithImpl<$Res>
    implements $LoadProductDetailsCopyWith<$Res> {
  _$LoadProductDetailsCopyWithImpl(this._self, this._then);

  final LoadProductDetails _self;
  final $Res Function(LoadProductDetails) _then;

/// Create a copy of PdpEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? productId = null,}) {
  return _then(LoadProductDetails(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class SelectSku implements PdpEvent {
  const SelectSku({required this.skuId});
  

 final  String skuId;

/// Create a copy of PdpEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SelectSkuCopyWith<SelectSku> get copyWith => _$SelectSkuCopyWithImpl<SelectSku>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SelectSku&&(identical(other.skuId, skuId) || other.skuId == skuId));
}


@override
int get hashCode => Object.hash(runtimeType,skuId);

@override
String toString() {
  return 'PdpEvent.selectSku(skuId: $skuId)';
}


}

/// @nodoc
abstract mixin class $SelectSkuCopyWith<$Res> implements $PdpEventCopyWith<$Res> {
  factory $SelectSkuCopyWith(SelectSku value, $Res Function(SelectSku) _then) = _$SelectSkuCopyWithImpl;
@useResult
$Res call({
 String skuId
});




}
/// @nodoc
class _$SelectSkuCopyWithImpl<$Res>
    implements $SelectSkuCopyWith<$Res> {
  _$SelectSkuCopyWithImpl(this._self, this._then);

  final SelectSku _self;
  final $Res Function(SelectSku) _then;

/// Create a copy of PdpEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? skuId = null,}) {
  return _then(SelectSku(
skuId: null == skuId ? _self.skuId : skuId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class AddToBag implements PdpEvent {
  const AddToBag({required this.skuId});
  

 final  String skuId;

/// Create a copy of PdpEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddToBagCopyWith<AddToBag> get copyWith => _$AddToBagCopyWithImpl<AddToBag>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddToBag&&(identical(other.skuId, skuId) || other.skuId == skuId));
}


@override
int get hashCode => Object.hash(runtimeType,skuId);

@override
String toString() {
  return 'PdpEvent.addToBag(skuId: $skuId)';
}


}

/// @nodoc
abstract mixin class $AddToBagCopyWith<$Res> implements $PdpEventCopyWith<$Res> {
  factory $AddToBagCopyWith(AddToBag value, $Res Function(AddToBag) _then) = _$AddToBagCopyWithImpl;
@useResult
$Res call({
 String skuId
});




}
/// @nodoc
class _$AddToBagCopyWithImpl<$Res>
    implements $AddToBagCopyWith<$Res> {
  _$AddToBagCopyWithImpl(this._self, this._then);

  final AddToBag _self;
  final $Res Function(AddToBag) _then;

/// Create a copy of PdpEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? skuId = null,}) {
  return _then(AddToBag(
skuId: null == skuId ? _self.skuId : skuId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class BuyNow implements PdpEvent {
  const BuyNow({required this.skuId});
  

 final  String skuId;

/// Create a copy of PdpEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BuyNowCopyWith<BuyNow> get copyWith => _$BuyNowCopyWithImpl<BuyNow>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BuyNow&&(identical(other.skuId, skuId) || other.skuId == skuId));
}


@override
int get hashCode => Object.hash(runtimeType,skuId);

@override
String toString() {
  return 'PdpEvent.buyNow(skuId: $skuId)';
}


}

/// @nodoc
abstract mixin class $BuyNowCopyWith<$Res> implements $PdpEventCopyWith<$Res> {
  factory $BuyNowCopyWith(BuyNow value, $Res Function(BuyNow) _then) = _$BuyNowCopyWithImpl;
@useResult
$Res call({
 String skuId
});




}
/// @nodoc
class _$BuyNowCopyWithImpl<$Res>
    implements $BuyNowCopyWith<$Res> {
  _$BuyNowCopyWithImpl(this._self, this._then);

  final BuyNow _self;
  final $Res Function(BuyNow) _then;

/// Create a copy of PdpEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? skuId = null,}) {
  return _then(BuyNow(
skuId: null == skuId ? _self.skuId : skuId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class VerifyPincode implements PdpEvent {
  const VerifyPincode({required this.pincode});
  

 final  String pincode;

/// Create a copy of PdpEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VerifyPincodeCopyWith<VerifyPincode> get copyWith => _$VerifyPincodeCopyWithImpl<VerifyPincode>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VerifyPincode&&(identical(other.pincode, pincode) || other.pincode == pincode));
}


@override
int get hashCode => Object.hash(runtimeType,pincode);

@override
String toString() {
  return 'PdpEvent.verifyPincode(pincode: $pincode)';
}


}

/// @nodoc
abstract mixin class $VerifyPincodeCopyWith<$Res> implements $PdpEventCopyWith<$Res> {
  factory $VerifyPincodeCopyWith(VerifyPincode value, $Res Function(VerifyPincode) _then) = _$VerifyPincodeCopyWithImpl;
@useResult
$Res call({
 String pincode
});




}
/// @nodoc
class _$VerifyPincodeCopyWithImpl<$Res>
    implements $VerifyPincodeCopyWith<$Res> {
  _$VerifyPincodeCopyWithImpl(this._self, this._then);

  final VerifyPincode _self;
  final $Res Function(VerifyPincode) _then;

/// Create a copy of PdpEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? pincode = null,}) {
  return _then(VerifyPincode(
pincode: null == pincode ? _self.pincode : pincode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SelectColorVariant implements PdpEvent {
  const SelectColorVariant({required this.productId});
  

 final  int productId;

/// Create a copy of PdpEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SelectColorVariantCopyWith<SelectColorVariant> get copyWith => _$SelectColorVariantCopyWithImpl<SelectColorVariant>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SelectColorVariant&&(identical(other.productId, productId) || other.productId == productId));
}


@override
int get hashCode => Object.hash(runtimeType,productId);

@override
String toString() {
  return 'PdpEvent.selectColorVariant(productId: $productId)';
}


}

/// @nodoc
abstract mixin class $SelectColorVariantCopyWith<$Res> implements $PdpEventCopyWith<$Res> {
  factory $SelectColorVariantCopyWith(SelectColorVariant value, $Res Function(SelectColorVariant) _then) = _$SelectColorVariantCopyWithImpl;
@useResult
$Res call({
 int productId
});




}
/// @nodoc
class _$SelectColorVariantCopyWithImpl<$Res>
    implements $SelectColorVariantCopyWith<$Res> {
  _$SelectColorVariantCopyWithImpl(this._self, this._then);

  final SelectColorVariant _self;
  final $Res Function(SelectColorVariant) _then;

/// Create a copy of PdpEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? productId = null,}) {
  return _then(SelectColorVariant(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class ExpandDetailTab implements PdpEvent {
  const ExpandDetailTab({required this.tabIndex});
  

 final  int tabIndex;

/// Create a copy of PdpEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpandDetailTabCopyWith<ExpandDetailTab> get copyWith => _$ExpandDetailTabCopyWithImpl<ExpandDetailTab>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpandDetailTab&&(identical(other.tabIndex, tabIndex) || other.tabIndex == tabIndex));
}


@override
int get hashCode => Object.hash(runtimeType,tabIndex);

@override
String toString() {
  return 'PdpEvent.expandDetailTab(tabIndex: $tabIndex)';
}


}

/// @nodoc
abstract mixin class $ExpandDetailTabCopyWith<$Res> implements $PdpEventCopyWith<$Res> {
  factory $ExpandDetailTabCopyWith(ExpandDetailTab value, $Res Function(ExpandDetailTab) _then) = _$ExpandDetailTabCopyWithImpl;
@useResult
$Res call({
 int tabIndex
});




}
/// @nodoc
class _$ExpandDetailTabCopyWithImpl<$Res>
    implements $ExpandDetailTabCopyWith<$Res> {
  _$ExpandDetailTabCopyWithImpl(this._self, this._then);

  final ExpandDetailTab _self;
  final $Res Function(ExpandDetailTab) _then;

/// Create a copy of PdpEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? tabIndex = null,}) {
  return _then(ExpandDetailTab(
tabIndex: null == tabIndex ? _self.tabIndex : tabIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class LoadRecommendations implements PdpEvent {
  const LoadRecommendations({required this.productId});
  

 final  int productId;

/// Create a copy of PdpEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadRecommendationsCopyWith<LoadRecommendations> get copyWith => _$LoadRecommendationsCopyWithImpl<LoadRecommendations>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadRecommendations&&(identical(other.productId, productId) || other.productId == productId));
}


@override
int get hashCode => Object.hash(runtimeType,productId);

@override
String toString() {
  return 'PdpEvent.loadRecommendations(productId: $productId)';
}


}

/// @nodoc
abstract mixin class $LoadRecommendationsCopyWith<$Res> implements $PdpEventCopyWith<$Res> {
  factory $LoadRecommendationsCopyWith(LoadRecommendations value, $Res Function(LoadRecommendations) _then) = _$LoadRecommendationsCopyWithImpl;
@useResult
$Res call({
 int productId
});




}
/// @nodoc
class _$LoadRecommendationsCopyWithImpl<$Res>
    implements $LoadRecommendationsCopyWith<$Res> {
  _$LoadRecommendationsCopyWithImpl(this._self, this._then);

  final LoadRecommendations _self;
  final $Res Function(LoadRecommendations) _then;

/// Create a copy of PdpEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? productId = null,}) {
  return _then(LoadRecommendations(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class LoadMoreRecommendations implements PdpEvent {
  const LoadMoreRecommendations();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadMoreRecommendations);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PdpEvent.loadMoreRecommendations()';
}


}




/// @nodoc


class LoadSizeChart implements PdpEvent {
  const LoadSizeChart();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadSizeChart);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PdpEvent.loadSizeChart()';
}


}




/// @nodoc
mixin _$PdpState {

 PdpStatus get status; ProductDetailEntity? get productDetail; SkuEntity? get selectedSku; int get expandedDetailTab; bool get isAddingToBag; bool get isBuyingNow;// Shared one-shot snackbar channel (add-to-bag, buy-now). The tick is bumped
// on every message so the UI re-fires even when the same message repeats —
// mirrors WishlistState's feedbackTick pattern. (Pincode-verify failures use
// the pincodeVerify* channel below so the sheet can show them inline.)
 int get snackBarTick; String? get snackBarMessage; bool get snackBarIsError; String? get errorMessage; RecommendationsEntity? get recommendations; int get recommendationsPage; bool get isLoadingMoreRecommendations; bool get isLoadingSizeChart; SizeChartEntity? get sizeChart; String? get sizeChartError; String? get verifiedPincode;// PDP pincode-verify outcome, consumed by the pincode sheet so it can stay
// open and surface the failure inline. The tick bumps on every completion so
// the awaiting caller resolves even when the same result repeats; the error
// string is null on success and a plain message on failure.
 int get pincodeVerifyTick; String? get pincodeVerifyError;
/// Create a copy of PdpState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PdpStateCopyWith<PdpState> get copyWith => _$PdpStateCopyWithImpl<PdpState>(this as PdpState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PdpState&&(identical(other.status, status) || other.status == status)&&(identical(other.productDetail, productDetail) || other.productDetail == productDetail)&&(identical(other.selectedSku, selectedSku) || other.selectedSku == selectedSku)&&(identical(other.expandedDetailTab, expandedDetailTab) || other.expandedDetailTab == expandedDetailTab)&&(identical(other.isAddingToBag, isAddingToBag) || other.isAddingToBag == isAddingToBag)&&(identical(other.isBuyingNow, isBuyingNow) || other.isBuyingNow == isBuyingNow)&&(identical(other.snackBarTick, snackBarTick) || other.snackBarTick == snackBarTick)&&(identical(other.snackBarMessage, snackBarMessage) || other.snackBarMessage == snackBarMessage)&&(identical(other.snackBarIsError, snackBarIsError) || other.snackBarIsError == snackBarIsError)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.recommendations, recommendations) || other.recommendations == recommendations)&&(identical(other.recommendationsPage, recommendationsPage) || other.recommendationsPage == recommendationsPage)&&(identical(other.isLoadingMoreRecommendations, isLoadingMoreRecommendations) || other.isLoadingMoreRecommendations == isLoadingMoreRecommendations)&&(identical(other.isLoadingSizeChart, isLoadingSizeChart) || other.isLoadingSizeChart == isLoadingSizeChart)&&(identical(other.sizeChart, sizeChart) || other.sizeChart == sizeChart)&&(identical(other.sizeChartError, sizeChartError) || other.sizeChartError == sizeChartError)&&(identical(other.verifiedPincode, verifiedPincode) || other.verifiedPincode == verifiedPincode)&&(identical(other.pincodeVerifyTick, pincodeVerifyTick) || other.pincodeVerifyTick == pincodeVerifyTick)&&(identical(other.pincodeVerifyError, pincodeVerifyError) || other.pincodeVerifyError == pincodeVerifyError));
}


@override
int get hashCode => Object.hashAll([runtimeType,status,productDetail,selectedSku,expandedDetailTab,isAddingToBag,isBuyingNow,snackBarTick,snackBarMessage,snackBarIsError,errorMessage,recommendations,recommendationsPage,isLoadingMoreRecommendations,isLoadingSizeChart,sizeChart,sizeChartError,verifiedPincode,pincodeVerifyTick,pincodeVerifyError]);

@override
String toString() {
  return 'PdpState(status: $status, productDetail: $productDetail, selectedSku: $selectedSku, expandedDetailTab: $expandedDetailTab, isAddingToBag: $isAddingToBag, isBuyingNow: $isBuyingNow, snackBarTick: $snackBarTick, snackBarMessage: $snackBarMessage, snackBarIsError: $snackBarIsError, errorMessage: $errorMessage, recommendations: $recommendations, recommendationsPage: $recommendationsPage, isLoadingMoreRecommendations: $isLoadingMoreRecommendations, isLoadingSizeChart: $isLoadingSizeChart, sizeChart: $sizeChart, sizeChartError: $sizeChartError, verifiedPincode: $verifiedPincode, pincodeVerifyTick: $pincodeVerifyTick, pincodeVerifyError: $pincodeVerifyError)';
}


}

/// @nodoc
abstract mixin class $PdpStateCopyWith<$Res>  {
  factory $PdpStateCopyWith(PdpState value, $Res Function(PdpState) _then) = _$PdpStateCopyWithImpl;
@useResult
$Res call({
 PdpStatus status, ProductDetailEntity? productDetail, SkuEntity? selectedSku, int expandedDetailTab, bool isAddingToBag, bool isBuyingNow, int snackBarTick, String? snackBarMessage, bool snackBarIsError, String? errorMessage, RecommendationsEntity? recommendations, int recommendationsPage, bool isLoadingMoreRecommendations, bool isLoadingSizeChart, SizeChartEntity? sizeChart, String? sizeChartError, String? verifiedPincode, int pincodeVerifyTick, String? pincodeVerifyError
});


$ProductDetailEntityCopyWith<$Res>? get productDetail;$SkuEntityCopyWith<$Res>? get selectedSku;$RecommendationsEntityCopyWith<$Res>? get recommendations;$SizeChartEntityCopyWith<$Res>? get sizeChart;

}
/// @nodoc
class _$PdpStateCopyWithImpl<$Res>
    implements $PdpStateCopyWith<$Res> {
  _$PdpStateCopyWithImpl(this._self, this._then);

  final PdpState _self;
  final $Res Function(PdpState) _then;

/// Create a copy of PdpState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? productDetail = freezed,Object? selectedSku = freezed,Object? expandedDetailTab = null,Object? isAddingToBag = null,Object? isBuyingNow = null,Object? snackBarTick = null,Object? snackBarMessage = freezed,Object? snackBarIsError = null,Object? errorMessage = freezed,Object? recommendations = freezed,Object? recommendationsPage = null,Object? isLoadingMoreRecommendations = null,Object? isLoadingSizeChart = null,Object? sizeChart = freezed,Object? sizeChartError = freezed,Object? verifiedPincode = freezed,Object? pincodeVerifyTick = null,Object? pincodeVerifyError = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PdpStatus,productDetail: freezed == productDetail ? _self.productDetail : productDetail // ignore: cast_nullable_to_non_nullable
as ProductDetailEntity?,selectedSku: freezed == selectedSku ? _self.selectedSku : selectedSku // ignore: cast_nullable_to_non_nullable
as SkuEntity?,expandedDetailTab: null == expandedDetailTab ? _self.expandedDetailTab : expandedDetailTab // ignore: cast_nullable_to_non_nullable
as int,isAddingToBag: null == isAddingToBag ? _self.isAddingToBag : isAddingToBag // ignore: cast_nullable_to_non_nullable
as bool,isBuyingNow: null == isBuyingNow ? _self.isBuyingNow : isBuyingNow // ignore: cast_nullable_to_non_nullable
as bool,snackBarTick: null == snackBarTick ? _self.snackBarTick : snackBarTick // ignore: cast_nullable_to_non_nullable
as int,snackBarMessage: freezed == snackBarMessage ? _self.snackBarMessage : snackBarMessage // ignore: cast_nullable_to_non_nullable
as String?,snackBarIsError: null == snackBarIsError ? _self.snackBarIsError : snackBarIsError // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,recommendations: freezed == recommendations ? _self.recommendations : recommendations // ignore: cast_nullable_to_non_nullable
as RecommendationsEntity?,recommendationsPage: null == recommendationsPage ? _self.recommendationsPage : recommendationsPage // ignore: cast_nullable_to_non_nullable
as int,isLoadingMoreRecommendations: null == isLoadingMoreRecommendations ? _self.isLoadingMoreRecommendations : isLoadingMoreRecommendations // ignore: cast_nullable_to_non_nullable
as bool,isLoadingSizeChart: null == isLoadingSizeChart ? _self.isLoadingSizeChart : isLoadingSizeChart // ignore: cast_nullable_to_non_nullable
as bool,sizeChart: freezed == sizeChart ? _self.sizeChart : sizeChart // ignore: cast_nullable_to_non_nullable
as SizeChartEntity?,sizeChartError: freezed == sizeChartError ? _self.sizeChartError : sizeChartError // ignore: cast_nullable_to_non_nullable
as String?,verifiedPincode: freezed == verifiedPincode ? _self.verifiedPincode : verifiedPincode // ignore: cast_nullable_to_non_nullable
as String?,pincodeVerifyTick: null == pincodeVerifyTick ? _self.pincodeVerifyTick : pincodeVerifyTick // ignore: cast_nullable_to_non_nullable
as int,pincodeVerifyError: freezed == pincodeVerifyError ? _self.pincodeVerifyError : pincodeVerifyError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of PdpState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductDetailEntityCopyWith<$Res>? get productDetail {
    if (_self.productDetail == null) {
    return null;
  }

  return $ProductDetailEntityCopyWith<$Res>(_self.productDetail!, (value) {
    return _then(_self.copyWith(productDetail: value));
  });
}/// Create a copy of PdpState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SkuEntityCopyWith<$Res>? get selectedSku {
    if (_self.selectedSku == null) {
    return null;
  }

  return $SkuEntityCopyWith<$Res>(_self.selectedSku!, (value) {
    return _then(_self.copyWith(selectedSku: value));
  });
}/// Create a copy of PdpState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecommendationsEntityCopyWith<$Res>? get recommendations {
    if (_self.recommendations == null) {
    return null;
  }

  return $RecommendationsEntityCopyWith<$Res>(_self.recommendations!, (value) {
    return _then(_self.copyWith(recommendations: value));
  });
}/// Create a copy of PdpState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SizeChartEntityCopyWith<$Res>? get sizeChart {
    if (_self.sizeChart == null) {
    return null;
  }

  return $SizeChartEntityCopyWith<$Res>(_self.sizeChart!, (value) {
    return _then(_self.copyWith(sizeChart: value));
  });
}
}


/// Adds pattern-matching-related methods to [PdpState].
extension PdpStatePatterns on PdpState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PdpState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PdpState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PdpState value)  $default,){
final _that = this;
switch (_that) {
case _PdpState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PdpState value)?  $default,){
final _that = this;
switch (_that) {
case _PdpState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PdpStatus status,  ProductDetailEntity? productDetail,  SkuEntity? selectedSku,  int expandedDetailTab,  bool isAddingToBag,  bool isBuyingNow,  int snackBarTick,  String? snackBarMessage,  bool snackBarIsError,  String? errorMessage,  RecommendationsEntity? recommendations,  int recommendationsPage,  bool isLoadingMoreRecommendations,  bool isLoadingSizeChart,  SizeChartEntity? sizeChart,  String? sizeChartError,  String? verifiedPincode,  int pincodeVerifyTick,  String? pincodeVerifyError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PdpState() when $default != null:
return $default(_that.status,_that.productDetail,_that.selectedSku,_that.expandedDetailTab,_that.isAddingToBag,_that.isBuyingNow,_that.snackBarTick,_that.snackBarMessage,_that.snackBarIsError,_that.errorMessage,_that.recommendations,_that.recommendationsPage,_that.isLoadingMoreRecommendations,_that.isLoadingSizeChart,_that.sizeChart,_that.sizeChartError,_that.verifiedPincode,_that.pincodeVerifyTick,_that.pincodeVerifyError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PdpStatus status,  ProductDetailEntity? productDetail,  SkuEntity? selectedSku,  int expandedDetailTab,  bool isAddingToBag,  bool isBuyingNow,  int snackBarTick,  String? snackBarMessage,  bool snackBarIsError,  String? errorMessage,  RecommendationsEntity? recommendations,  int recommendationsPage,  bool isLoadingMoreRecommendations,  bool isLoadingSizeChart,  SizeChartEntity? sizeChart,  String? sizeChartError,  String? verifiedPincode,  int pincodeVerifyTick,  String? pincodeVerifyError)  $default,) {final _that = this;
switch (_that) {
case _PdpState():
return $default(_that.status,_that.productDetail,_that.selectedSku,_that.expandedDetailTab,_that.isAddingToBag,_that.isBuyingNow,_that.snackBarTick,_that.snackBarMessage,_that.snackBarIsError,_that.errorMessage,_that.recommendations,_that.recommendationsPage,_that.isLoadingMoreRecommendations,_that.isLoadingSizeChart,_that.sizeChart,_that.sizeChartError,_that.verifiedPincode,_that.pincodeVerifyTick,_that.pincodeVerifyError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PdpStatus status,  ProductDetailEntity? productDetail,  SkuEntity? selectedSku,  int expandedDetailTab,  bool isAddingToBag,  bool isBuyingNow,  int snackBarTick,  String? snackBarMessage,  bool snackBarIsError,  String? errorMessage,  RecommendationsEntity? recommendations,  int recommendationsPage,  bool isLoadingMoreRecommendations,  bool isLoadingSizeChart,  SizeChartEntity? sizeChart,  String? sizeChartError,  String? verifiedPincode,  int pincodeVerifyTick,  String? pincodeVerifyError)?  $default,) {final _that = this;
switch (_that) {
case _PdpState() when $default != null:
return $default(_that.status,_that.productDetail,_that.selectedSku,_that.expandedDetailTab,_that.isAddingToBag,_that.isBuyingNow,_that.snackBarTick,_that.snackBarMessage,_that.snackBarIsError,_that.errorMessage,_that.recommendations,_that.recommendationsPage,_that.isLoadingMoreRecommendations,_that.isLoadingSizeChart,_that.sizeChart,_that.sizeChartError,_that.verifiedPincode,_that.pincodeVerifyTick,_that.pincodeVerifyError);case _:
  return null;

}
}

}

/// @nodoc


class _PdpState implements PdpState {
  const _PdpState({this.status = PdpStatus.initial, this.productDetail, this.selectedSku, this.expandedDetailTab = 0, this.isAddingToBag = false, this.isBuyingNow = false, this.snackBarTick = 0, this.snackBarMessage, this.snackBarIsError = false, this.errorMessage, this.recommendations, this.recommendationsPage = 1, this.isLoadingMoreRecommendations = false, this.isLoadingSizeChart = false, this.sizeChart, this.sizeChartError, this.verifiedPincode, this.pincodeVerifyTick = 0, this.pincodeVerifyError});
  

@override@JsonKey() final  PdpStatus status;
@override final  ProductDetailEntity? productDetail;
@override final  SkuEntity? selectedSku;
@override@JsonKey() final  int expandedDetailTab;
@override@JsonKey() final  bool isAddingToBag;
@override@JsonKey() final  bool isBuyingNow;
// Shared one-shot snackbar channel (add-to-bag, buy-now). The tick is bumped
// on every message so the UI re-fires even when the same message repeats —
// mirrors WishlistState's feedbackTick pattern. (Pincode-verify failures use
// the pincodeVerify* channel below so the sheet can show them inline.)
@override@JsonKey() final  int snackBarTick;
@override final  String? snackBarMessage;
@override@JsonKey() final  bool snackBarIsError;
@override final  String? errorMessage;
@override final  RecommendationsEntity? recommendations;
@override@JsonKey() final  int recommendationsPage;
@override@JsonKey() final  bool isLoadingMoreRecommendations;
@override@JsonKey() final  bool isLoadingSizeChart;
@override final  SizeChartEntity? sizeChart;
@override final  String? sizeChartError;
@override final  String? verifiedPincode;
// PDP pincode-verify outcome, consumed by the pincode sheet so it can stay
// open and surface the failure inline. The tick bumps on every completion so
// the awaiting caller resolves even when the same result repeats; the error
// string is null on success and a plain message on failure.
@override@JsonKey() final  int pincodeVerifyTick;
@override final  String? pincodeVerifyError;

/// Create a copy of PdpState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PdpStateCopyWith<_PdpState> get copyWith => __$PdpStateCopyWithImpl<_PdpState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PdpState&&(identical(other.status, status) || other.status == status)&&(identical(other.productDetail, productDetail) || other.productDetail == productDetail)&&(identical(other.selectedSku, selectedSku) || other.selectedSku == selectedSku)&&(identical(other.expandedDetailTab, expandedDetailTab) || other.expandedDetailTab == expandedDetailTab)&&(identical(other.isAddingToBag, isAddingToBag) || other.isAddingToBag == isAddingToBag)&&(identical(other.isBuyingNow, isBuyingNow) || other.isBuyingNow == isBuyingNow)&&(identical(other.snackBarTick, snackBarTick) || other.snackBarTick == snackBarTick)&&(identical(other.snackBarMessage, snackBarMessage) || other.snackBarMessage == snackBarMessage)&&(identical(other.snackBarIsError, snackBarIsError) || other.snackBarIsError == snackBarIsError)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.recommendations, recommendations) || other.recommendations == recommendations)&&(identical(other.recommendationsPage, recommendationsPage) || other.recommendationsPage == recommendationsPage)&&(identical(other.isLoadingMoreRecommendations, isLoadingMoreRecommendations) || other.isLoadingMoreRecommendations == isLoadingMoreRecommendations)&&(identical(other.isLoadingSizeChart, isLoadingSizeChart) || other.isLoadingSizeChart == isLoadingSizeChart)&&(identical(other.sizeChart, sizeChart) || other.sizeChart == sizeChart)&&(identical(other.sizeChartError, sizeChartError) || other.sizeChartError == sizeChartError)&&(identical(other.verifiedPincode, verifiedPincode) || other.verifiedPincode == verifiedPincode)&&(identical(other.pincodeVerifyTick, pincodeVerifyTick) || other.pincodeVerifyTick == pincodeVerifyTick)&&(identical(other.pincodeVerifyError, pincodeVerifyError) || other.pincodeVerifyError == pincodeVerifyError));
}


@override
int get hashCode => Object.hashAll([runtimeType,status,productDetail,selectedSku,expandedDetailTab,isAddingToBag,isBuyingNow,snackBarTick,snackBarMessage,snackBarIsError,errorMessage,recommendations,recommendationsPage,isLoadingMoreRecommendations,isLoadingSizeChart,sizeChart,sizeChartError,verifiedPincode,pincodeVerifyTick,pincodeVerifyError]);

@override
String toString() {
  return 'PdpState(status: $status, productDetail: $productDetail, selectedSku: $selectedSku, expandedDetailTab: $expandedDetailTab, isAddingToBag: $isAddingToBag, isBuyingNow: $isBuyingNow, snackBarTick: $snackBarTick, snackBarMessage: $snackBarMessage, snackBarIsError: $snackBarIsError, errorMessage: $errorMessage, recommendations: $recommendations, recommendationsPage: $recommendationsPage, isLoadingMoreRecommendations: $isLoadingMoreRecommendations, isLoadingSizeChart: $isLoadingSizeChart, sizeChart: $sizeChart, sizeChartError: $sizeChartError, verifiedPincode: $verifiedPincode, pincodeVerifyTick: $pincodeVerifyTick, pincodeVerifyError: $pincodeVerifyError)';
}


}

/// @nodoc
abstract mixin class _$PdpStateCopyWith<$Res> implements $PdpStateCopyWith<$Res> {
  factory _$PdpStateCopyWith(_PdpState value, $Res Function(_PdpState) _then) = __$PdpStateCopyWithImpl;
@override @useResult
$Res call({
 PdpStatus status, ProductDetailEntity? productDetail, SkuEntity? selectedSku, int expandedDetailTab, bool isAddingToBag, bool isBuyingNow, int snackBarTick, String? snackBarMessage, bool snackBarIsError, String? errorMessage, RecommendationsEntity? recommendations, int recommendationsPage, bool isLoadingMoreRecommendations, bool isLoadingSizeChart, SizeChartEntity? sizeChart, String? sizeChartError, String? verifiedPincode, int pincodeVerifyTick, String? pincodeVerifyError
});


@override $ProductDetailEntityCopyWith<$Res>? get productDetail;@override $SkuEntityCopyWith<$Res>? get selectedSku;@override $RecommendationsEntityCopyWith<$Res>? get recommendations;@override $SizeChartEntityCopyWith<$Res>? get sizeChart;

}
/// @nodoc
class __$PdpStateCopyWithImpl<$Res>
    implements _$PdpStateCopyWith<$Res> {
  __$PdpStateCopyWithImpl(this._self, this._then);

  final _PdpState _self;
  final $Res Function(_PdpState) _then;

/// Create a copy of PdpState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? productDetail = freezed,Object? selectedSku = freezed,Object? expandedDetailTab = null,Object? isAddingToBag = null,Object? isBuyingNow = null,Object? snackBarTick = null,Object? snackBarMessage = freezed,Object? snackBarIsError = null,Object? errorMessage = freezed,Object? recommendations = freezed,Object? recommendationsPage = null,Object? isLoadingMoreRecommendations = null,Object? isLoadingSizeChart = null,Object? sizeChart = freezed,Object? sizeChartError = freezed,Object? verifiedPincode = freezed,Object? pincodeVerifyTick = null,Object? pincodeVerifyError = freezed,}) {
  return _then(_PdpState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PdpStatus,productDetail: freezed == productDetail ? _self.productDetail : productDetail // ignore: cast_nullable_to_non_nullable
as ProductDetailEntity?,selectedSku: freezed == selectedSku ? _self.selectedSku : selectedSku // ignore: cast_nullable_to_non_nullable
as SkuEntity?,expandedDetailTab: null == expandedDetailTab ? _self.expandedDetailTab : expandedDetailTab // ignore: cast_nullable_to_non_nullable
as int,isAddingToBag: null == isAddingToBag ? _self.isAddingToBag : isAddingToBag // ignore: cast_nullable_to_non_nullable
as bool,isBuyingNow: null == isBuyingNow ? _self.isBuyingNow : isBuyingNow // ignore: cast_nullable_to_non_nullable
as bool,snackBarTick: null == snackBarTick ? _self.snackBarTick : snackBarTick // ignore: cast_nullable_to_non_nullable
as int,snackBarMessage: freezed == snackBarMessage ? _self.snackBarMessage : snackBarMessage // ignore: cast_nullable_to_non_nullable
as String?,snackBarIsError: null == snackBarIsError ? _self.snackBarIsError : snackBarIsError // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,recommendations: freezed == recommendations ? _self.recommendations : recommendations // ignore: cast_nullable_to_non_nullable
as RecommendationsEntity?,recommendationsPage: null == recommendationsPage ? _self.recommendationsPage : recommendationsPage // ignore: cast_nullable_to_non_nullable
as int,isLoadingMoreRecommendations: null == isLoadingMoreRecommendations ? _self.isLoadingMoreRecommendations : isLoadingMoreRecommendations // ignore: cast_nullable_to_non_nullable
as bool,isLoadingSizeChart: null == isLoadingSizeChart ? _self.isLoadingSizeChart : isLoadingSizeChart // ignore: cast_nullable_to_non_nullable
as bool,sizeChart: freezed == sizeChart ? _self.sizeChart : sizeChart // ignore: cast_nullable_to_non_nullable
as SizeChartEntity?,sizeChartError: freezed == sizeChartError ? _self.sizeChartError : sizeChartError // ignore: cast_nullable_to_non_nullable
as String?,verifiedPincode: freezed == verifiedPincode ? _self.verifiedPincode : verifiedPincode // ignore: cast_nullable_to_non_nullable
as String?,pincodeVerifyTick: null == pincodeVerifyTick ? _self.pincodeVerifyTick : pincodeVerifyTick // ignore: cast_nullable_to_non_nullable
as int,pincodeVerifyError: freezed == pincodeVerifyError ? _self.pincodeVerifyError : pincodeVerifyError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of PdpState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductDetailEntityCopyWith<$Res>? get productDetail {
    if (_self.productDetail == null) {
    return null;
  }

  return $ProductDetailEntityCopyWith<$Res>(_self.productDetail!, (value) {
    return _then(_self.copyWith(productDetail: value));
  });
}/// Create a copy of PdpState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SkuEntityCopyWith<$Res>? get selectedSku {
    if (_self.selectedSku == null) {
    return null;
  }

  return $SkuEntityCopyWith<$Res>(_self.selectedSku!, (value) {
    return _then(_self.copyWith(selectedSku: value));
  });
}/// Create a copy of PdpState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecommendationsEntityCopyWith<$Res>? get recommendations {
    if (_self.recommendations == null) {
    return null;
  }

  return $RecommendationsEntityCopyWith<$Res>(_self.recommendations!, (value) {
    return _then(_self.copyWith(recommendations: value));
  });
}/// Create a copy of PdpState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SizeChartEntityCopyWith<$Res>? get sizeChart {
    if (_self.sizeChart == null) {
    return null;
  }

  return $SizeChartEntityCopyWith<$Res>(_self.sizeChart!, (value) {
    return _then(_self.copyWith(sizeChart: value));
  });
}
}

// dart format on
