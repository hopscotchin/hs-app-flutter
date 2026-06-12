import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomImage extends StatelessWidget {
  final String path;

  // Common properties
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;
  final Alignment alignment;

  // Network specific
  final Widget? placeholder;
  final Widget? errorWidget;

  const CustomImage({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.color,
    this.alignment = Alignment.center,
    this.placeholder,
    this.errorWidget,
  });

  bool get _isNetwork => path.startsWith('http');
  bool get _isSvg => path.toLowerCase().endsWith('.svg');

  @override
  Widget build(BuildContext context) {
    if (_isSvg) {
      return _isNetwork ? _networkSvg() : _assetSvg();
    } else {
      return _isNetwork ? _networkImage() : _assetImage();
    }
  }

  /// SVG - Asset
  Widget _assetSvg() {
    return SvgPicture.asset(
      path,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
    );
  }

  /// SVG - Network
  Widget _networkSvg() {
    return SvgPicture.network(
      path,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      placeholderBuilder: (context) => placeholder ?? const SizedBox.shrink(),
    );
  }

  /// PNG/JPG - Asset
  Widget _assetImage() {
    return Image.asset(
      path,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      color: color,
    );
  }

  /// PNG/JPG - Network (CACHED ✅)
  Widget _networkImage() {
    return CachedNetworkImage(
      imageUrl: path,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      // Loading placeholder
      placeholder: (context, url) => placeholder ?? const SizedBox.shrink(),
      // Error widget
      errorWidget: (context, url, error) => errorWidget ?? const Icon(Icons.error),
      // Needed to apply color
      imageBuilder: (context, imageProvider) {
        return Image(
          image: imageProvider,
          width: width,
          height: height,
          fit: fit,
          alignment: alignment,
          color: color,
        );
      },

      fadeInDuration: const Duration(milliseconds: 200),
    );
  }
}
