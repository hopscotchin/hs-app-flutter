import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hs_app_flutter/core/constants/route_names.dart';

import '../domain/entities/media_entity.dart';
import 'pages/pdp_fullscreen_gallery_page.dart';

class PdpFullscreenGalleryRoute {
  static GoRoute getRoute(GlobalKey<NavigatorState> rootKey) => GoRoute(
    path: RouteNames.pdpImageGallery,
    name: 'pdpImageGallery',
    parentNavigatorKey: rootKey,
    builder: (context, state) {
      final extra = state.extra as Map<String, dynamic>? ?? {};
      return PdpFullscreenGalleryPage(
        media: (extra['media'] as List<MediaEntity>?) ?? const [],
        initialIndex: extra['initialIndex'] as int? ?? 0,
      );
    },
  );
}
