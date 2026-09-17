import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../components/atoms/error_retry_widget.dart';
import '../../../../components/atoms/loading_shimmer.dart';
import '../bloc/orders_bloc.dart';
import '../widgets/order_item_card.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    if (currentScroll >= maxScroll * 0.9) {
      context.read<OrdersBloc>().add(const LoadNextOrdersPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('My Orders'),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      body: BlocListener<OrdersBloc, OrdersState>(
        listenWhen: (prev, curr) =>
            curr.paginationError != null &&
            curr.paginationError != prev.paginationError,
        listener: (context, state) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.paginationError!)));
          context.read<OrdersBloc>().add(const ClearPaginationError());
        },
        child: BlocBuilder<OrdersBloc, OrdersState>(
          builder: (context, state) {
            if (state.status == OrdersStatus.loading) {
              return LoadingShimmer.listShimmer(itemCount: 8, itemHeight: 120);
            }

            if (state.status == OrdersStatus.error) {
              return ErrorRetryWidget(
                message: state.errorMessage!,
                onRetry: () =>
                    context.read<OrdersBloc>().add(const LoadOrders()),
              );
            }

            if (state.status == OrdersStatus.success) {
              if (state.orders.isEmpty) {
                return const Center(child: Text('No orders yet'));
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<OrdersBloc>().add(const RefreshOrders());
                },
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: state.orders.length,
                        itemBuilder: (context, index) {
                          return OrderItemCard(order: state.orders[index]);
                        },
                      ),
                    ),
                    if (state.isLoadingMore) const LinearProgressIndicator(),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
