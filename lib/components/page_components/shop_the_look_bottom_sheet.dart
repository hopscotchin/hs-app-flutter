import 'package:flutter/material.dart';

import '../../core/constants/strings/discover_strings.dart';
import '../../core/navigation/action_url_handler.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/typography.dart';
import '../../features/discover/domain/entities/home_page_entity.dart';
import '../atoms/cached_image_widget.dart';

class ShopTheLookBottomSheet extends StatefulWidget {
  final ShopTheLookItem item;
  final void Function(List<ShopTheLookSelection>)? onAddToCart;

  const ShopTheLookBottomSheet({
    super.key,
    required this.item,
    this.onAddToCart,
  });

  @override
  State<ShopTheLookBottomSheet> createState() => _ShopTheLookBottomSheetState();
}

class _ShopTheLookBottomSheetState extends State<ShopTheLookBottomSheet> {
  // productId → selected SKU
  final Map<int, ShopTheLookSku> _selectedSkus = {};
  // IDs of products included in the add-to-cart set
  final Set<int> _selectedProducts = {};

  @override
  void initState() {
    super.initState();
    _initializeSelections();
  }

  // Auto-selects the first available size for each product, matching Android loadData().
  void _initializeSelections() {
    for (final product in widget.item.productTiles) {
      if (product.id == null) continue;
      final firstAvailable = product.skus
          .where((s) => s.isAvailable)
          .cast<ShopTheLookSku?>()
          .firstOrNull;
      if (firstAvailable != null) {
        _selectedSkus[product.id!] = firstAvailable;
        _selectedProducts.add(product.id!);
      }
    }
  }

  ({int totalPrice, int totalMrp}) _computePricing() {
    var totalPrice = 0;
    var totalMrp = 0;
    for (final id in _selectedProducts) {
      final sku = _selectedSkus[id];
      totalPrice += sku?.price?.absoluteValue ?? 0;
      totalMrp += sku?.price?.absoluteMrp ?? 0;
    }
    return (totalPrice: totalPrice, totalMrp: totalMrp);
  }

  void _onSizeSelected(int productId, ShopTheLookSku sku) {
    setState(() {
      _selectedSkus[productId] = sku;
      _selectedProducts.add(productId);
    });
  }

  void _toggleProduct(int productId) {
    if (_selectedProducts.contains(productId)) {
      if (_selectedProducts.length <= 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(DiscoverStrings.atLeastOneItemMustBeSelected),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }
      setState(() => _selectedProducts.remove(productId));
    } else {
      final selectedSku = _selectedSkus[productId];
      if (selectedSku != null) {
        setState(() => _selectedProducts.add(productId));
      } else {
        final firstAvailable = widget.item.productTiles
            .firstWhere(
              (p) => p.id == productId,
              orElse: () => const ShopTheLookProduct(),
            )
            .skus
            .where((s) => s.isAvailable)
            .cast<ShopTheLookSku?>()
            .firstOrNull;
        if (firstAvailable != null) {
          setState(() {
            _selectedSkus[productId] = firstAvailable;
            _selectedProducts.add(productId);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(DiscoverStrings.itemSoldOut),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    }
  }

  void _onAddToCart() {
    final List<ShopTheLookSelection> selections = _selectedProducts.map((id) {
      return ShopTheLookSelection(
        productId: id,
        skuId: _selectedSkus[id]?.skuId,
      );
    }).toList();
    Navigator.pop(context);
    widget.onAddToCart?.call(selections);
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final pricing = _computePricing();
    final int totalPrice = pricing.totalPrice;
    final int totalMrp = pricing.totalMrp;
    final int discountAmount = totalMrp - totalPrice;
    final int discountPercent = totalMrp > 0
        ? (discountAmount / totalMrp * 100).round()
        : 0;
    final int itemCount = _selectedProducts.length;

    return Container(
      height: screenHeight * 0.58,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          _buildHeader(context),
          const Divider(height: 1, thickness: 1, color: AppColors.divider),
          Expanded(
            child: ListView.builder(
              itemCount: widget.item.productTiles.length,
              itemBuilder: (_, int i) {
                final product = widget.item.productTiles[i];
                final bool isLast = i == widget.item.productTiles.length - 1;
                return _buildProductRow(product, isLast);
              },
            ),
          ),
          _buildBottomBar(totalPrice, totalMrp, discountPercent, itemCount),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, size: 24),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 8),
          const Text(DiscoverStrings.selectSize, style: AppTypography.titleMedium),
        ],
      ),
    );
  }

  Widget _buildProductRow(ShopTheLookProduct product, bool isLast) {
    if (product.id == null) return const SizedBox.shrink();

    final int productId = product.id!;
    final bool isSelected = _selectedProducts.contains(productId);
    final bool isOos = product.hasInv == false;
    final ShopTheLookSku? selectedSku = _selectedSkus[productId];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product image with checkbox overlay
              GestureDetector(
                onTap: () => _toggleProduct(productId),
                child: SizedBox(
                  width: 85,
                  height: 122,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Opacity(
                          opacity: isOos ? 0.4 : 1.0,
                          child: CachedImageWidget(
                            imageUrl: product.imageUrl ?? '',
                            width: 85,
                            height: 122,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => _toggleProduct(productId),
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.white,
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.border,
                                width: 1.5,
                              ),
                            ),
                            child: isSelected
                                ? const Icon(
                                    Icons.check,
                                    size: 14,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Product info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (product.productName != null)
                      Text(
                        product.productName!,
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (isOos) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Text(
                          DiscoverStrings.outOfStock,
                          style: AppTypography.labelSmall.copyWith(
                            color: Colors.white,
                            fontSize: 9,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    _buildSizeSelector(product, selectedSku),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => ActionUrlHandler.navigate(
                            context,
                            product.actionUri,
                          ),
                          child: Text(
                            DiscoverStrings.viewDetails,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        if (product.hasSizeChart == true) ...[
                          const SizedBox(width: 16),
                          GestureDetector(
                            onTap: () => ActionUrlHandler.navigate(
                              context,
                              product.actionUri,
                            ),
                            child: Text(
                              DiscoverStrings.sizeChart,
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          const Divider(height: 1, thickness: 1, color: AppColors.divider),
      ],
    );
  }

  Widget _buildSizeSelector(
    ShopTheLookProduct product,
    ShopTheLookSku? selectedSku,
  ) {
    if (product.skus.isEmpty) return const SizedBox.shrink();
    if (product.skus.length == 1) {
      return _buildSizeChip(
        product.skus.first,
        isSelected: true,
        isSingleSize: true,
        onTap: null,
      );
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: product.skus.map((sku) {
          final bool isSelected = sku.skuId == selectedSku?.skuId;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _buildSizeChip(
              sku,
              isSelected: isSelected,
              isSingleSize: false,
              onTap: sku.isAvailable
                  ? () {
                      if (product.id != null) _onSizeSelected(product.id!, sku);
                    }
                  : null,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSizeChip(
    ShopTheLookSku sku, {
    required bool isSelected,
    required bool isSingleSize,
    required VoidCallback? onTap,
  }) {
    final bool isOos = !sku.isAvailable;
    Color bgColor;
    Color textColor;
    Color borderColor;

    if (isSingleSize) {
      bgColor = AppColors.primary;
      textColor = Colors.white;
      borderColor = AppColors.primary;
    } else if (isOos) {
      bgColor = Colors.grey.shade100;
      textColor = Colors.grey.shade400;
      borderColor = Colors.grey.shade300;
    } else if (isSelected) {
      bgColor = AppColors.primaryLight;
      textColor = AppColors.neutralBlack;
      borderColor = AppColors.primary;
    } else {
      bgColor = Colors.white;
      textColor = AppColors.neutralBlack;
      borderColor = AppColors.border;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: borderColor),
        ),
        child: Text(
          sku.size ?? '',
          style: AppTypography.labelSmall.copyWith(
            color: textColor,
            decoration: isOos ? TextDecoration.lineThrough : null,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar(
    int totalPrice,
    int totalMrp,
    int discountPercent,
    int itemCount,
  ) {
    final bool hasSelection = _selectedProducts.isNotEmpty;

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.divider)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    DiscoverStrings.totalPriceForItems(itemCount),
                    style: AppTypography.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  AppSpacing.verticalGapXxs,
                  Row(
                    children: [
                      if (totalPrice > 0)
                        Text(
                          '₹$totalPrice',
                          style: AppTypography.labelMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      if (totalMrp > 0 && totalMrp != totalPrice) ...[
                        const SizedBox(width: 8),
                        Text(
                          '₹$totalMrp',
                          style: AppTypography.bodySmall.copyWith(
                            decoration: TextDecoration.lineThrough,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                      if (discountPercent > 0) ...[
                        const SizedBox(width: 8),
                        Text(
                          '($discountPercent% off)',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            FilledButton(
              onPressed: hasSelection ? _onAddToCart : null,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: AppColors.border,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                textStyle: AppTypography.labelMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text(DiscoverStrings.addToBag),
            ),
          ],
        ),
      ),
    );
  }
}
