import 'package:flutter/material.dart';

import '../../../../components/atoms/cached_image_widget.dart';
import '../../domain/entities/visual_product_info_entity.dart';

class PdpVisualContent extends StatelessWidget {
  final VisualProductInfoEntity visualProductInfo;

  const PdpVisualContent({super.key, required this.visualProductInfo});

  @override
  Widget build(BuildContext context) {
    final imageItems = visualProductInfo.items
        .where((item) => item.url != null && item.type == 'image')
        .toList();

    if (imageItems.isEmpty) return const SizedBox.shrink();

    return Column(
      children: imageItems.map((item) {
        return CachedImageWidget(
          imageUrl: item.url!,
          width: double.infinity,
          fit: BoxFit.fitWidth,
        );
      }).toList(),
    );
  }
}
