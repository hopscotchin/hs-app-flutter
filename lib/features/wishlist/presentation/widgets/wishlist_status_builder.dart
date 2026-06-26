import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../plp/domain/entities/listing_product_entity.dart';
import '../../../plp/domain/entities/wishlist_info_entity.dart';
import '../cubit/wishlist_cubit.dart';

/// Seeds the global [WishlistCubit] with a product's server status and rebuilds
/// its child whenever that product's membership changes anywhere in the app.
///
/// Drop this around any product tile (grids, carousels) to get cross-screen
/// wishlist sync without the host having to seed at the page level.
class WishlistStatusBuilder extends StatefulWidget {
  const WishlistStatusBuilder({super.key, required this.product, required this.builder});

  final ListingProductEntity product;
  final Widget Function(BuildContext context, bool isWishlisted) builder;

  @override
  State<WishlistStatusBuilder> createState() => _WishlistStatusBuilderState();
}

class _WishlistStatusBuilderState extends State<WishlistStatusBuilder> {
  @override
  void initState() {
    super.initState();
    _seed();
  }

  @override
  void didUpdateWidget(WishlistStatusBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    // On refresh, Flutter may recycle this element with a different product
    // (the tiles carry no keys). Re-seed so the recycled slot reflects the new
    // product's server status. seed() still respects user toggles.
    if (oldWidget.product.id != widget.product.id) _seed();
  }

  void _seed() {
    final p = widget.product;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<WishlistCubit>().seed([
        WishlistSeed(
          productId: p.id.toString(),
          wished: p.wishlistInfo.isWishlisted,
          wishlistItemId: p.wishlistInfo.wishlistId,
        ),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final id = widget.product.id.toString();
    return BlocSelector<WishlistCubit, WishlistState, bool>(
      selector: (s) => s.isWishlisted(id),
      builder: (context, wished) => widget.builder(context, wished),
    );
  }
}
