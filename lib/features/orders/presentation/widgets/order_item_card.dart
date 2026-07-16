import 'package:flutter/material.dart';

import '../../domain/entities/order_info_entity.dart';

class OrderItemCard extends StatelessWidget {
  final OrderInfoEntity order;
  final VoidCallback? onTap;

  const OrderItemCard({super.key, required this.order, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProductImage(),
              const SizedBox(width: 12),
              Expanded(child: _buildProductDetails(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 88,
        color: const Color(0xFFF5F5F5),
        child: order.productImageUrl != null
            ? Image.network(
                order.productImageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const _PlaceholderIcon(),
              )
            : const _PlaceholderIcon(),
      ),
    );
  }

  Widget _buildProductDetails(BuildContext context) {
    final theme = Theme.of(context);
    final deliveryText =
        order.deliveryMessage?.deliveryMessage ?? 'In progress';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (order.hsBrandLabel != null && order.hsBrandLabel!.isNotEmpty)
          Text(
            order.hsBrandLabel!,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        const SizedBox(height: 2),
        Text(
          order.productName,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSize(theme),
            Text(
              '₹${order.amount.toStringAsFixed(0)}',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        if (order.itemCounts > 0)
          Text(
            'Qty: ${order.itemCounts}',
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
          ),
        const SizedBox(height: 8),
        Text(
          deliveryText,
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Text(
          order.deliveryMessage?.secondaryMessage ?? '',
          style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildSize(ThemeData theme) {
    if (order.productSize == null || order.productSize!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Text(
      'Size: ${order.productSize}',
      style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
    );
  }
}

class _PlaceholderIcon extends StatelessWidget {
  const _PlaceholderIcon();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(Icons.image_outlined, size: 32, color: Colors.grey),
    );
  }
}
