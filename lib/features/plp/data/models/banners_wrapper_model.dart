import 'package:json_annotation/json_annotation.dart';

import 'banner_model.dart';

part 'banners_wrapper_model.g.dart';

/// Wraps the new `banners` object on the PLP response:
///
/// ```json
/// "banners": {
///   "promoBanner": { ... },
///   "pageBanner":  { ..., "title": "Ho Ho Holiday Styles!" }
/// }
/// ```
///
/// Both slots are optional. For now PLP consumes only `pageBanner` (the
/// big sliver-header banner with the fade-in/out title). `promoBanner`
/// is parsed and held so when the design lands we just wire it through
/// without touching the data layer.
@JsonSerializable(createToJson: false)
class BannersWrapperModel {
  const BannersWrapperModel({this.promoBanner, this.pageBanner});

  final BannerModel? promoBanner;
  final BannerModel? pageBanner;

  factory BannersWrapperModel.fromJson(Map<String, dynamic> json) =>
      _$BannersWrapperModelFromJson(json);
}
