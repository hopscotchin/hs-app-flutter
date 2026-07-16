import 'package:flutter/material.dart';

import '../../../../components/atoms/product_card.dart';
import '../../../../core/theme/colors.dart';
import '../../domain/entities/cart_item_entity.dart';

/// Dark accessory panel colors matching Android CartProductAdapter.
const _kPanelColor = Color(0xFF3C3C3E);
const _kFooterColor = Color(0xFF2E2E30);
const _kAccentColor = Color(0xFF00D9A6);

enum _PanelView { options, changeQuantity, removeConfirm }

class CartItemWidget extends StatefulWidget {
  final CartItemEntity item;
  final bool isLoading;
  final bool forceClose;
  final ValueChanged<int>? onQuantityChanged;
  final VoidCallback? onRemove;
  final VoidCallback? onMoveToWishlist;
  final VoidCallback? onPanelOpened;

  const CartItemWidget({
    super.key,
    required this.item,
    this.isLoading = false,
    this.forceClose = false,
    this.onQuantityChanged,
    this.onRemove,
    this.onMoveToWishlist,
    this.onPanelOpened,
  });

  @override
  State<CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _slideController;

  _PanelView _panelView = _PanelView.options;
  bool _isOpen = false;
  int _editingQuantity = 1;
  bool _wasLoading = false;
  bool _actionInProgress = false;

  static const double _slideRatio = 0.78;
  static const Duration _slideDuration = Duration(milliseconds: 250);

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: _slideDuration,
    );
    _editingQuantity = widget.item.quantity ?? 1;
  }

  @override
  void didUpdateWidget(CartItemWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Force close from parent (another item opened)
    if (widget.forceClose && !oldWidget.forceClose && _isOpen) {
      _closePanel();
    }

    // Loading finished → close panel
    if (_wasLoading && !widget.isLoading && _isOpen) {
      _closePanel();
      _actionInProgress = false;
    }
    if (widget.isLoading) _actionInProgress = false;
    _wasLoading = widget.isLoading;

    // Sync editing qty when not in edit mode
    if (_panelView != _PanelView.changeQuantity) {
      _editingQuantity = widget.item.quantity ?? 1;
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  // ─── Panel control ───────────────────────────────────────────

  void _openPanel() {
    if (_isOpen) return;
    setState(() {
      _isOpen = true;
      _panelView = _PanelView.options;
    });
    _slideController.animateTo(1.0, curve: Curves.easeOut);
    widget.onPanelOpened?.call();
  }

  void _closePanel() {
    if (!_isOpen) return;
    _slideController.animateTo(0.0, curve: Curves.easeIn).then((_) {
      if (mounted) {
        setState(() {
          _isOpen = false;
          _panelView = _PanelView.options;
          _editingQuantity = widget.item.quantity ?? 1;
          _actionInProgress = false;
        });
      }
    });
  }

  void _togglePanel() => _isOpen ? _closePanel() : _openPanel();

  // ─── Drag handlers ──────────────────────────────────────────

  void _onDragUpdate(DragUpdateDetails details, double maxSlide) {
    if (_actionInProgress || widget.isLoading) return;
    final delta = (details.primaryDelta ?? 0) / maxSlide;
    _slideController.value = (_slideController.value - delta).clamp(0.0, 1.0);
  }

  void _onDragEnd(DragEndDetails details) {
    if (_actionInProgress || widget.isLoading) return;
    final velocity = details.primaryVelocity ?? 0;

    if (velocity < -300) {
      // Fast left swipe → open
      _slideController.animateTo(1.0, curve: Curves.easeOut);
      if (!_isOpen) {
        setState(() {
          _isOpen = true;
          _panelView = _PanelView.options;
        });
        widget.onPanelOpened?.call();
      }
    } else if (velocity > 300) {
      _closePanel();
    } else if (_slideController.value > 0.5) {
      _slideController.animateTo(1.0, curve: Curves.easeOut);
      if (!_isOpen) {
        setState(() {
          _isOpen = true;
          _panelView = _PanelView.options;
        });
        widget.onPanelOpened?.call();
      }
    } else {
      _closePanel();
    }
  }

  // ─── Action handlers ────────────────────────────────────────

  void _onMoveToWishlist() {
    setState(() => _actionInProgress = true);
    widget.onMoveToWishlist?.call();
  }

  void _onConfirmQuantity() {
    if (_editingQuantity == (widget.item.quantity ?? 1)) return;
    setState(() => _actionInProgress = true);
    widget.onQuantityChanged?.call(_editingQuantity);
  }

  void _onConfirmRemove() {
    setState(() => _actionInProgress = true);
    widget.onRemove?.call();
  }

  bool get _showPanelLoading =>
      _isOpen && (_actionInProgress || widget.isLoading);

  // ─── Build ──────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxSlide = constraints.maxWidth * _slideRatio;
        return AnimatedBuilder(
          animation: _slideController,
          builder: (context, _) {
            final slideValue = _slideController.value;
            return Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                // Background: arrow area + dark panel
                if (slideValue > 0)
                  Positioned.fill(
                    child: Row(
                      children: [
                        // Hidden area (behind content)
                        SizedBox(
                          width: constraints.maxWidth * (1 - _slideRatio) - 36,
                        ),
                        // Arrow button
                        GestureDetector(
                          onTap: _closePanel,
                          behavior: HitTestBehavior.opaque,
                          child: const SizedBox(
                            width: 36,
                            child: Center(
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 14,
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ),
                        ),
                        // Dark panel
                        Expanded(
                          child: _showPanelLoading
                              ? _buildLoadingOverlay()
                              : _buildPanelContent(),
                        ),
                      ],
                    ),
                  ),
                // Foreground: slideable content
                Transform.translate(
                  offset: Offset(-maxSlide * slideValue, 0),
                  child: GestureDetector(
                    onHorizontalDragUpdate: (d) => _onDragUpdate(d, maxSlide),
                    onHorizontalDragEnd: _onDragEnd,
                    child: _buildContent(),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ─── Content card ───────────────────────────────────────────

  Widget _buildContent() {
    return Container(
      color: AppColors.container,
      child: ProductCard(
        imageUrl: widget.item.imgSrc,
        productName: widget.item.productName,
        size: widget.item.size,
        isSingleSize: widget.item.isSingleSize ?? false,
        price: widget.item.price,
        regularPrice: widget.item.regularPrice,
        discount: widget.item.discount,
        isSoldOut: widget.item.isSoldOut ?? false,
        isSizeSoldOut: widget.item.isSizeSoldOut ?? false,
        deliveryText: widget.item.productTileText,
        lowInventoryText: widget.item.lowInventoryText,
        promoDiscountMessage: widget.item.promoDiscountMessage,
        visualCues: widget.item.visualCues,
        isLoading: widget.isLoading && !_isOpen,
        quantity: widget.item.quantity,
        trailing: IconButton(
          icon: const Icon(
            Icons.more_horiz,
            size: 20,
            color: AppColors.textSecondary,
          ),
          onPressed: _togglePanel,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          iconSize: 20,
        ),
      ),
    );
  }

  // ─── Panel content switcher ─────────────────────────────────

  Widget _buildPanelContent() {
    return switch (_panelView) {
      _PanelView.options => _buildOptionsPanel(),
      _PanelView.changeQuantity => _buildChangeQuantityPanel(),
      _PanelView.removeConfirm => _buildRemoveConfirmPanel(),
    };
  }

  // ─── Options panel ──────────────────────────────────────────

  Widget _buildOptionsPanel() {
    final isSoldOut = widget.item.isCompletelySoldOut;
    final maxQty = widget.item.selectMaxValue ?? 10;
    final qty = widget.item.quantity ?? 1;
    final oneLeft = maxQty < 2 && qty <= maxQty;

    return Container(
      color: _kPanelColor,
      child: Column(
        children: [
          if (oneLeft)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6),
              color: const Color(0xFFFFEB3B),
              child: const Text(
                'Only 1 item left',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
            ),
          Expanded(
            child: Row(
              children: [
                // Change Quantity
                Expanded(
                  child: _OptionButton(
                    icon: _buildQuantityIcon(qty, !isSoldOut && !oneLeft),
                    label: 'Change\nquantity',
                    enabled: !isSoldOut && !oneLeft,
                    onTap: () =>
                        setState(() => _panelView = _PanelView.changeQuantity),
                  ),
                ),
                Container(width: 1, color: Colors.white12),
                // Move to Wishlist
                Expanded(
                  child: _OptionButton(
                    icon: Icon(
                      Icons.favorite_border,
                      size: 28,
                      color: isSoldOut ? Colors.white30 : Colors.white,
                    ),
                    label: 'Move to\nWishlist',
                    enabled: !isSoldOut,
                    onTap: _onMoveToWishlist,
                  ),
                ),
                Container(width: 1, color: Colors.white12),
                // Remove from bag
                Expanded(
                  child: _OptionButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      size: 28,
                      color: Colors.white,
                    ),
                    label: 'Remove from\nbag',
                    enabled: true,
                    onTap: () =>
                        setState(() => _panelView = _PanelView.removeConfirm),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityIcon(int qty, bool enabled) {
    final color = enabled ? Colors.white : Colors.white30;
    return SizedBox(
      width: 32,
      height: 32,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: color, width: 1.5),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          Positioned(
            right: -2,
            top: -2,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: enabled ? Colors.white : Colors.white30,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                '$qty',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: enabled ? _kPanelColor : Colors.white54,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Change Quantity panel ──────────────────────────────────

  Widget _buildChangeQuantityPanel() {
    final unitPrice = widget.item.price ?? 0;
    final maxQty = widget.item.selectMaxValue ?? 10;
    final canDecrease = _editingQuantity > 1;
    final canIncrease = _editingQuantity < maxQty;
    final isChanged = _editingQuantity != (widget.item.quantity ?? 1);

    final priceText = _editingQuantity > 1
        ? '$_editingQuantity x \u20B9$unitPrice = \u20B9${_editingQuantity * unitPrice}'
        : '\u20B9$unitPrice';

    return Container(
      color: _kPanelColor,
      child: Column(
        children: [
          // Price per unit
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              priceText,
              style: const TextStyle(fontSize: 13, color: Colors.white60),
            ),
          ),
          // Quantity stepper
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _CircleButton(
                  icon: Icons.remove,
                  enabled: canDecrease,
                  onTap: () => setState(() => _editingQuantity--),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Text(
                    '$_editingQuantity',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                _CircleButton(
                  icon: Icons.add,
                  enabled: canIncrease,
                  onTap: () => setState(() => _editingQuantity++),
                ),
              ],
            ),
          ),
          // Footer
          _buildFooter(
            onCancel: () => setState(() {
              _panelView = _PanelView.options;
              _editingQuantity = widget.item.quantity ?? 1;
            }),
            onConfirm: isChanged ? _onConfirmQuantity : null,
            confirmColor: isChanged ? _kAccentColor : Colors.white30,
          ),
        ],
      ),
    );
  }

  // ─── Remove Confirmation panel ──────────────────────────────

  Widget _buildRemoveConfirmPanel() {
    return Container(
      color: _kPanelColor,
      child: Column(
        children: [
          const Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.delete_outline, size: 36, color: Colors.white),
                  SizedBox(height: 12),
                  Text(
                    'Are you sure you want to remove this item from bag?',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          _buildFooter(
            onCancel: () => setState(() => _panelView = _PanelView.options),
            onConfirm: _onConfirmRemove,
            confirmColor: _kAccentColor,
          ),
        ],
      ),
    );
  }

  // ─── Footer (Cancel | Confirm) ──────────────────────────────

  Widget _buildFooter({
    required VoidCallback onCancel,
    VoidCallback? onConfirm,
    Color confirmColor = Colors.white30,
  }) {
    return Container(
      decoration: const BoxDecoration(
        color: _kFooterColor,
        border: Border(top: BorderSide(color: Colors.white12)),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: onCancel,
                child: const Text(
                  'CANCEL',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const VerticalDivider(color: Colors.white12, width: 1),
            Expanded(
              child: TextButton(
                onPressed: onConfirm,
                child: Text(
                  'CONFIRM',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: confirmColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Loading overlay ────────────────────────────────────────

  Widget _buildLoadingOverlay() {
    return Container(
      color: _kPanelColor,
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Updating your bag',
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Extracted stateless helpers ────────────────────────────────

class _OptionButton extends StatelessWidget {
  final Widget icon;
  final String label;
  final bool enabled;
  final VoidCallback onTap;

  const _OptionButton({
    required this.icon,
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: enabled ? Colors.white : Colors.white30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _CircleButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: enabled ? Colors.white : Colors.white24,
            width: 1.5,
          ),
        ),
        child: Icon(
          icon,
          size: 22,
          color: enabled ? Colors.white : Colors.white24,
        ),
      ),
    );
  }
}
