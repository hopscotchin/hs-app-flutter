import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hs_app_flutter/core/router/app_navigator.dart';

import '../../../../components/atoms/price_summary_widget.dart';
import '../../../../components/atoms/product_card.dart';
import '../../../../core/cubits/cart_count_cubit.dart';
import '../../../../core/entities/order_summary_entity.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/typography.dart';
import '../../domain/entities/order_confirmation_entity.dart';
import '../../domain/entities/order_confirmation_item_entity.dart';

class OrderConfirmationPage extends StatefulWidget {
  final OrderConfirmationEntity orderConfirmationEntity;

  /// Attribution stamped on any analytics fired from this screen (e.g. the
  /// terminal `order_placed` event mirrors Android's `logOrderPlaced`).
  final String? fromScreen;

  const OrderConfirmationPage({
    super.key,
    required this.orderConfirmationEntity,
    this.fromScreen,
  });

  @override
  State<OrderConfirmationPage> createState() => _OrderConfirmationPageState();
}

class _OrderConfirmationPageState extends State<OrderConfirmationPage> {
  @override
  void initState() {
    super.initState();
    context.read<CartCountCubit>().set(0);
  }

  OrderConfirmationEntity get data => widget.orderConfirmationEntity;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) AppNavigator.goToHome(context);
      },
      child: Scaffold(
        backgroundColor: AppColors.container,
        appBar: AppBar(
          title: Text(data.header?.title ?? 'All done'),
          backgroundColor: AppColors.container,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          titleTextStyle: AppTypography.headlineSmall.copyWith(
            fontWeight: AppTypography.semiBold,
            color: AppColors.textPrimary,
          ),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => AppNavigator.goToHome(context),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildOrderInfo(),
                    if (data.orderDetails != null && data.orderDetails!.items.isNotEmpty)
                      _buildProductItems(),
                    if (data.orderSummary != null) _buildPriceSummary(),
                    if (data.address != null) _buildAddress(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            _buildContinueShoppingButton(),
          ],
        ),
      ),
    );
  }

  // ─── Order Info ──────────────────────────────────────────────────────────────

  Widget _buildOrderInfo() {
    final details = data.orderDetails;
    final title = details?.title ?? (details?.orderId != null ? 'Order ${details!.orderId}' : null);
    final subtitle = details?.subtitle ?? data.header?.subtitle ?? 'Your order has been confirmed';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Text(
              title,
              style: AppTypography.titleMedium.copyWith(fontWeight: AppTypography.semiBold),
            ),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ],
      ),
    );
  }

  // ─── Product Items ─────────────────────────────────────────────────────────

  Widget _buildProductItems() {
    final items = data.orderDetails!.items;
    return Column(
      children: [
        for (int i = 0; i < items.length; i++) ...[
          _buildProductCard(items[i]),
          if (i < items.length - 1)
            const Divider(height: 1, indent: 16, endIndent: 16, color: AppColors.dividerLight),
        ],
      ],
    );
  }

  Widget _buildProductCard(OrderConfirmationItemEntity item) {
    return ProductCard(
      imageUrl: item.imgSrc,
      brandLabel: item.hsBrandLabel ?? item.brandName,
      productName: item.productName,
      size: item.size,
      isSingleSize: item.isSingleSize ?? false,
      price: item.price ?? item.orderPrice,
      regularPrice: item.regularPrice,
      discount: item.discount ?? _computeDiscount(item),
      quantity: item.quantity,
      deliveryText: item.productTileText,
      visualCues: item.visualCues,
      promoDiscountMessage: item.promoDiscountMessage,
      isSoldOut: item.isSoldOut ?? false,
      isSizeSoldOut: item.isSizeSoldOut ?? false,
    );
  }

  String? _computeDiscount(OrderConfirmationItemEntity item) {
    if (item.discountPercentage != null && item.discountPercentage! > 0) {
      return '${item.discountPercentage}% off';
    }
    return null;
  }

  // ─── Price Summary ─────────────────────────────────────────────────────────

  Widget _buildPriceSummary() {
    final allRows = data.orderSummary?.pricingData ?? [];

    // The API includes "Total" in both pricingData and totalOrderAmount.
    // Extract it from pricingData (it has the ₹ symbol) and use as the
    // dedicated total row to avoid duplication.
    final totalRow = allRows.where((r) => r.label?.toLowerCase() == 'total').firstOrNull;
    final filteredRows = allRows.where((r) => r.label?.toLowerCase() != 'total').toList();

    final summary = OrderSummaryEntity(
      sectionTitle: data.orderSummary?.sectionTitle,
      subText: data.orderSummary?.subText,
      pricingData: filteredRows,
      totalOrderAmount: totalRow ?? data.orderSummary?.totalOrderAmount,
    );

    return PriceSummaryWidget(
      summary: summary,
      postTotalRows: data.paymentDetails?.payByRows ?? [],
    );
  }

  // ─── Address ───────────────────────────────────────────────────────────────

  Widget _buildAddress() {
    final address = data.address!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.container,
        border: Border(top: BorderSide(color: AppColors.dividerLight)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(address.sectionTitle ?? 'Shipping Address', style: AppTypography.titleSmall),
          const SizedBox(height: 12),
          if (address.name != null && address.name!.isNotEmpty)
            Text(
              address.name!,
              style: AppTypography.bodyMedium.copyWith(fontWeight: AppTypography.semiBold),
            ),
          if (address.formattedPhone.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              address.formattedPhone,
              style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
            ),
          ],
          if (address.formattedAddress.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              address.formattedAddress,
              style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ],
      ),
    );
  }

  // ─── Continue Shopping Button ─────────────────────────────────────────────

  Widget _buildContinueShoppingButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.container,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () => AppNavigator.goToHome(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
            child: Text(
              'CONTINUE SHOPPING',
              style: AppTypography.buttonMedium.copyWith(color: AppColors.onPrimary),
            ),
          ),
        ),
      ),
    );
  }
}
