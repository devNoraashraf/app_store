import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_store/providers/cart_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _promoCtrl = TextEditingController();
  double _discount = 0.0;
  double _delivery = 0.0;

  @override
  void dispose() {
    _promoCtrl.dispose();
    super.dispose();
  }

  void _applyPromo(double subtotal) {
    final code = _promoCtrl.text.trim().toUpperCase();
    if (code == 'CODE10' && subtotal > 0) {
      setState(() => _discount = subtotal * 0.10);
      _snack('Promo applied: 10% off');
    } else if (code == 'FREESHIP' && subtotal > 0) {
      setState(() => _delivery = 0.0);
      _snack('Free delivery applied');
    } else {
      setState(() => _discount = 0.0);
      _snack('Invalid promo code');
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final items = cart.items;
    final subtotal = cart.subtotal;

    // لو السلة فاضية، صفّر الخصم والشحن (مرة واحدة)
    if (items.isEmpty && (_discount != 0 || _delivery != 0)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() { _discount = 0; _delivery = 0; });
      });
    }

    // حط رسوم توصيل افتراضية بسيطة لو في عناصر
    if (items.isNotEmpty && _delivery == 0) {
      _delivery = 3.99;
    }

    final total = (subtotal - _discount + _delivery).clamp(0, double.infinity).toDouble();


    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('My Cart'), centerTitle: true),
      bottomNavigationBar: items.isEmpty
          ? null
          : _CheckoutBar(total: total, onCheckout: () => _snack('Proceeding to checkout…')),
      body: items.isEmpty
          ? const _EmptyCart()
          : CustomScrollView(
              slivers: [
                // Promo
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: _PromoField(
                      controller: _promoCtrl,
                      onApply: () => _applyPromo(subtotal),
                    ),
                  ),
                ),
                // List
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = items[index];
                      return Dismissible(
                        key: ValueKey('cart-${item.product.id ?? index}'),
                        background: _dismissBg(alignEnd: false, cs: cs),
                        secondaryBackground: _dismissBg(alignEnd: true, cs: cs),
                        onDismissed: (_) => cart.removeAt(index),
                        child: _CartTile(
                          item: item,
                          onInc: () => cart.updateQty(index, 1),
                          onDec: () => cart.updateQty(index, -1),
                          onRemove: () => cart.removeAt(index),
                        ),
                      );
                    },
                    childCount: items.length,
                  ),
                ),
                // Summary
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    child: _SummaryCard(
                      subtotal: subtotal,
                      discount: _discount,
                      delivery: _delivery,
                      total: total,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: MediaQuery.of(context).padding.bottom + 80),
                ),
              ],
            ),
    );
  }

  Widget _dismissBg({required bool alignEnd, required ColorScheme cs}) {
    return Container(
      alignment: alignEnd ? Alignment.centerRight : Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: cs.errorContainer,
      child: Icon(Icons.delete_outline, color: cs.onErrorContainer, size: 28),
    );
  }
}

// ------------------ UI Widgets ------------------

class _PromoField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onApply;

  const _PromoField({required this.controller, required this.onApply});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_offer_outlined),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Promo code',
                border: InputBorder.none,
              ),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => onApply(),
            ),
          ),
          const SizedBox(width: 6),
          FilledButton.tonal(
            onPressed: onApply,
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}

class _CartTile extends StatelessWidget {
  final CartItem item;
  final VoidCallback onInc;
  final VoidCallback onDec;
  final VoidCallback onRemove;

  const _CartTile({
    required this.item,
    required this.onInc,
    required this.onDec,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final p = item.product;
    final imageUrl = (p.images?.isNotEmpty ?? false) ? p.images!.first : null;
    final title = p.title ?? 'Product';
    final unit = item.unitPrice;
    final total = item.total;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
        boxShadow: [
          BoxShadow(color: cs.shadow.withOpacity(.05), blurRadius: 12, offset: const Offset(0, 6)),
        ],
      ),
      child: Row(
        children: [
          // صورة
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 78,
              height: 78,
              child: imageUrl != null
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.broken_image_outlined, size: 28),
                    )
                  : const Icon(Icons.image_not_supported, size: 28),
            ),
          ),
          const SizedBox(width: 12),
          // نصوص
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text('\$${unit.toStringAsFixed(2)} • each',
                    style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _QtyPill(qty: item.qty, onInc: onInc, onDec: onDec),
                    const Spacer(),
                    Text('\$${total.toStringAsFixed(2)}',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            tooltip: 'Remove',
            onPressed: onRemove,
            icon: const Icon(Icons.close_rounded),
          ),
        ],
      ),
    );
  }
}

class _QtyPill extends StatelessWidget {
  final int qty;
  final VoidCallback onInc;
  final VoidCallback onDec;

  const _QtyPill({required this.qty, required this.onInc, required this.onDec});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: [
          _SquareBtn(icon: Icons.remove_rounded, onTap: onDec),
          SizedBox(width: 40, child: Center(child: Text('$qty', style: const TextStyle(fontWeight: FontWeight.w700)))),
          _SquareBtn(icon: Icons.add_rounded, onTap: onInc),
        ],
      ),
    );
  }
}

class _SquareBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SquareBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(9),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Icon(icon, size: 20),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final double subtotal;
  final double discount;
  final double delivery;
  final double total;

  const _SummaryCard({
    required this.subtotal,
    required this.discount,
    required this.delivery,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    Widget row(String label, String value, {bool bold = false}) {
      return Row(
        children: [
          Expanded(
            child: Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
          ),
          Text(
            value,
            style: (bold
                    ? theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)
                    : theme.textTheme.bodyMedium)
                ?.copyWith(letterSpacing: .2),
          ),
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        children: [
          row('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
          row('Discount', '- \$${discount.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
          row('Delivery', '\$${delivery.toStringAsFixed(2)}'),
          const Divider(height: 24),
          row('Total', '\$${total.toStringAsFixed(2)}', bold: true),
        ],
      ),
    );
  }
}

class _CheckoutBar extends StatelessWidget {
  final double total;
  final VoidCallback onCheckout;

  const _CheckoutBar({required this.total, required this.onCheckout});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        decoration: BoxDecoration(
          color: cs.surface,
          border: Border(top: BorderSide(color: cs.outlineVariant)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Total: \$${total.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
            ),
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: onCheckout,
                icon: const Icon(Icons.lock_outline),
                label: const Text('Checkout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: cs.primary,
                  foregroundColor: cs.onPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.shopping_bag_outlined, size: 88, color: cs.onSurfaceVariant),
            const SizedBox(height: 16),
            Text('Your cart is empty', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('Browse products and add your favorites.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
            const SizedBox(height: 20),
            FilledButton.tonal(
              onPressed: () => Navigator.of(context).maybePop(),
              child: const Text('Continue shopping'),
            ),
          ],
        ),
      ),
    );
  }
}
