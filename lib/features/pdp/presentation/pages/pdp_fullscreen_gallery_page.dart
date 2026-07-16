import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../components/atoms/cached_image_widget.dart';
import '../../../../core/constants/strings/pdp_strings.dart';
import '../../domain/entities/media_entity.dart';
import '../widgets/pdp_vertical_dot_indicator.dart';

/// Fullscreen, vertically-paged product image gallery.
///
/// Mirrors the Android PDP behaviour: tapping any image in the PDP vertical
/// carousel opens this page starting at the tapped image. Layout matches
/// Android — a top toolbar with a circular back button over a white background,
/// and the images shown in an aspect-ratio band (not a black lightbox). Each
/// image supports pinch- and double-tap-to-zoom, and a right-side page
/// indicator mirrors the PDP carousel.
class PdpFullscreenGalleryPage extends StatefulWidget {
  const PdpFullscreenGalleryPage({
    super.key,
    required this.media,
    this.initialIndex = 0,
  });

  final List<MediaEntity> media;
  final int initialIndex;

  @override
  State<PdpFullscreenGalleryPage> createState() => _PdpFullscreenGalleryPageState();
}

class _PdpFullscreenGalleryPageState extends State<PdpFullscreenGalleryPage> {
  late final PageController _pageController;
  late int _currentPage;

  // True while the current image is zoomed in — page swiping is disabled so a
  // vertical pan moves the zoomed image instead of flipping to the next image.
  bool _isZoomed = false;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialIndex.clamp(0, _lastIndex);
    _pageController = PageController(initialPage: _currentPage);
  }

  int get _lastIndex => widget.media.isEmpty ? 0 : widget.media.length - 1;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onZoomChanged(bool zoomed) {
    if (zoomed != _isZoomed) setState(() => _isZoomed = zoomed);
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
      _isZoomed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _Toolbar(onBack: () => context.pop()),
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: AspectRatio(
                  aspectRatio: PdpStrings.imageAspectRatio,
                  child: Stack(
                    children: [
                      PageView.builder(
                        controller: _pageController,
                        scrollDirection: Axis.vertical,
                        physics: _isZoomed
                            ? const NeverScrollableScrollPhysics()
                            : const PageScrollPhysics(),
                        itemCount: widget.media.length,
                        onPageChanged: _onPageChanged,
                        itemBuilder: (context, index) {
                          final url = widget.media[index].url;
                          if (url == null) return const SizedBox.expand();
                          return _ZoomableImage(
                            key: ValueKey(index),
                            imageUrl: url,
                            onZoomChanged: _onZoomChanged,
                          );
                        },
                      ),
                      if (widget.media.length > 1)
                        Positioned(
                          right: 14,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: PdpVerticalDotIndicator(
                              count: widget.media.length,
                              currentIndex: _currentPage,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Top toolbar with an elevated circular back button, mirroring Android's
/// 54dp toolbar CardView with a 38dp circular back button pinned to the start.
class _Toolbar extends StatelessWidget {
  const _Toolbar({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 0,
      child: SizedBox(
        height: 54,
        width: double.infinity,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: _CircularBackButton(onTap: onBack),
          ),
        ),
      ),
    );
  }
}

class _CircularBackButton extends StatelessWidget {
  const _CircularBackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 0,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: const SizedBox(
          width: 38,
          height: 38,
          child: Icon(Icons.arrow_back, color: Colors.black, size: 20),
        ),
      ),
    );
  }
}

/// A single gallery image with pinch- and double-tap-to-zoom.
///
/// [onZoomChanged] fires whenever the zoom state crosses 1× so the parent can
/// lock page swiping while zoomed (matching Android's
/// `requestDisallowInterceptTouchEvent`). Double-tap toggles between fit and a
/// [_doubleTapScale]× zoom centred on the tapped point, animated over 200ms.
class _ZoomableImage extends StatefulWidget {
  const _ZoomableImage({
    super.key,
    required this.imageUrl,
    required this.onZoomChanged,
  });

  final String imageUrl;
  final ValueChanged<bool> onZoomChanged;

  @override
  State<_ZoomableImage> createState() => _ZoomableImageState();
}

class _ZoomableImageState extends State<_ZoomableImage>
    with SingleTickerProviderStateMixin {
  static const _maxScale = 3.0;
  static const _doubleTapScale = 2.5;

  late final TransformationController _controller;
  late final AnimationController _animController;
  Animation<Matrix4>? _animation;
  TapDownDetails? _doubleTapDetails;

  @override
  void initState() {
    super.initState();
    _controller = TransformationController()..addListener(_onTransformChanged);
    _animController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 200))
          ..addListener(() {
            final value = _animation?.value;
            if (value != null) _controller.value = value;
          });
  }

  void _onTransformChanged() {
    widget.onZoomChanged(_controller.value.getMaxScaleOnAxis() > 1.01);
  }

  void _handleDoubleTap() {
    final currentScale = _controller.value.getMaxScaleOnAxis();
    final Matrix4 target;
    if (currentScale > 1.01) {
      target = Matrix4.identity();
    } else {
      final pos = _doubleTapDetails?.localPosition ?? Offset.zero;
      // Scale about the tapped point so it stays put under the finger.
      target = Matrix4.identity()
        ..translateByDouble(
          -pos.dx * (_doubleTapScale - 1),
          -pos.dy * (_doubleTapScale - 1),
          0,
          1,
        )
        ..scaleByDouble(_doubleTapScale, _doubleTapScale, _doubleTapScale, 1);
    }
    _animation = Matrix4Tween(begin: _controller.value, end: target)
        .animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTransformChanged);
    _controller.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTapDown: (details) => _doubleTapDetails = details,
      onDoubleTap: _handleDoubleTap,
      child: InteractiveViewer(
        transformationController: _controller,
        minScale: 1.0,
        maxScale: _maxScale,
        // Fill the page so the viewport equals the image — swiping then reads
        // as simply changing images rather than scrolling an oversized area.
        child: SizedBox.expand(
          child: CachedImageWidget(imageUrl: widget.imageUrl, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
