// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banners_wrapper_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BannersWrapperModel _$BannersWrapperModelFromJson(Map<String, dynamic> json) =>
    BannersWrapperModel(
      promoBanner: json['promoBanner'] == null
          ? null
          : BannerModel.fromJson(json['promoBanner'] as Map<String, dynamic>),
      pageBanner: json['pageBanner'] == null
          ? null
          : BannerModel.fromJson(json['pageBanner'] as Map<String, dynamic>),
    );
