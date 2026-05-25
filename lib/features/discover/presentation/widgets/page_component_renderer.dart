import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../components/page_components/custom_tiles_widget.dart';
import '../../../../components/page_components/hero_carousel_widget.dart';
import '../../../../components/page_components/page_carousel_widget.dart';
import '../../data/models/component_models.dart';
import '../../domain/entities/home_page_entity.dart';

class PageComponentRenderer extends StatelessWidget {
  final PageComponent component;

  const PageComponentRenderer({super.key, required this.component});

  @override
  Widget build(BuildContext context) {
    final parsed = component.parsedData;
    final margins = component.margins;

    // Each widget handles horizontal + inner margins internally.
    // Renderer only applies top/bottom outer spacing.
    final child = switch (component.type) {
      PageComponentType.hero => _buildHero(parsed, margins),
      PageComponentType.customTiles => _buildCustomTiles(parsed, margins),
      PageComponentType.pageCarousel => _buildPageCarousel(parsed, margins),
      _ => const SizedBox.shrink(),
    };

    if (margins == null) return child;

    return Padding(
      padding: EdgeInsets.only(top: margins.top, bottom: margins.bottom),
      child: child,
    );
  }

  Widget _buildHero(Object? parsed, ComponentMargins? margins) {
    final data = parsed is HeroCarouselData
        ? parsed
        : component.data != null
        ? ComponentDataParser.parseHero(component.data!)
        : null;
    if (data == null) return const SizedBox.shrink();
    return HeroCarouselWidget(heroData: data, margins: margins);
  }

  Widget _buildCustomTiles(Object? parsed, ComponentMargins? margins) {
    final data = parsed is CustomTilesData
        ? parsed
        : component.data != null
        ? ComponentDataParser.parseCustomTiles(component.data!)
        : null;
    if (data == null) return const SizedBox.shrink();
    return CustomTilesWidget(tilesData: data, margins: margins);
  }

  Widget _buildPageCarousel(Object? parsed, ComponentMargins? margins) {
    final data = parsed is PageCarouselData
        ? parsed
        : component.data != null
        ? ComponentDataParser.parsePageCarousel(component.data!)
        : null;
    if (data == null) return const SizedBox.shrink();
    return PageCarouselWidget(carouselData: data, margins: margins);
  }
}
