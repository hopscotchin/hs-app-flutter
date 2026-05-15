import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImageWidget extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const CachedImageWidget({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.devicePixelRatioOf(context);
    // Decode images at display size instead of full resolution.
    // Uses explicit width when available, otherwise screen width as upper bound.
    final effectiveWidth = (width != null && width != double.infinity)
        ? width!
        : MediaQuery.sizeOf(context).width;
    final cacheWidth = (effectiveWidth * dpr).round();

    final cacheHeight = (height != null && height != double.infinity)
        ? (height! * dpr).round()
        : null;

    final image = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      memCacheWidth: cacheWidth,
      memCacheHeight: cacheHeight,
      fadeInDuration: Duration.zero,
      fadeOutDuration: Duration.zero,
      useOldImageOnUrlChange: true,
      placeholder: (_, _) => _placeholder(),
      errorWidget: (_, _, _) => Container(
        width: width,
        height: height,
        color: Colors.grey[200],
        child: const Icon(Icons.broken_image_outlined, color: Colors.grey),
      ),
    );

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: image);
    }
    return image;
  }

  Widget _placeholder() =>
      Container(width: width, height: height, color: Colors.grey[200]);
}
