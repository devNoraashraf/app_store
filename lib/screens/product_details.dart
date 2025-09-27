import 'package:app_store/consts/colors_manger.dart';
import 'package:app_store/models/products_model.dart';
import 'package:app_store/providers/cart_provider.dart' show CartProvider;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatefulWidget {
  final products product;

  const ProductDetails({super.key, required this.product});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int _qty = 1;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final imageUrl = (p.images?.isNotEmpty ?? false) ? p.images!.first : null;
    final title =
        p.title?.trim().isNotEmpty == true ? p.title! : "Product Details";
    final description =
        p.description?.trim().isNotEmpty == true
            ? p.description!
            : "No description provided for this product.";
    final price = (p.price ?? 0).toDouble();

    // محاولة جلب اسم التصنيف إن وُجد
    final categoryName = () {
      try {
        final c = p.category;
        if (c == null) return null;
        final dynamic maybeName = (c as dynamic).name ?? (c as dynamic).title;
        if (maybeName is String && maybeName.trim().isNotEmpty)
          return maybeName as String;
        return null;
      } catch (_) {
        return null;
      }
    }();

    return Scaffold(
      bottomNavigationBar: _BottomBar(
        price: price,
        qty: _qty,
        onDecrement: () => setState(() => _qty = (_qty > 1) ? _qty - 1 : 1),
        onIncrement: () => setState(() => _qty += 1),
        onAddToCart: () {
          context.read<CartProvider>().add(p, qty: _qty);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Added to cart')));
        },
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: false,
            snap: false,
            stretch: true,
            elevation: 0,
            backgroundColor: cs.surface,
            foregroundColor: cs.onSurface,
            expandedHeight: 320,
            title: Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
            actions: [
              IconButton(
                tooltip: 'Share',
                icon: const Icon(Icons.ios_share_rounded),
                onPressed: () {
                  // TODO: Share logic
                },
              ),
              IconButton(
                tooltip: 'Cart',
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () => Navigator.pushNamed(context, '/cart'),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.fadeTitle,
              ],
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (imageUrl != null)
                    Hero(
                      tag: 'product-image-${p.id ?? title}',
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (_, __, ___) => const Center(
                              child: Icon(
                                Icons.broken_image_outlined,
                                size: 120,
                              ),
                            ),
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                    )
                  else
                    const Center(
                      child: Icon(Icons.image_not_supported, size: 120),
                    ),
                  const _BottomGradient(),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // سطر السعر + شارة التصنيف + زر Favorite
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _PriceTag(price: price),
                      const SizedBox(width: 12),
                      if (categoryName != null)
                        Chip(
                          label: Text(categoryName),
                          avatar: const Icon(Icons.category_outlined, size: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(color: cs.outlineVariant),
                        ),
                      const Spacer(),
                      _FavButton(),
                    ],
                  ),

                  const SizedBox(height: 16),

                  _SectionCard(
                    title: 'Description',
                    child: Text(
                      description,
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                    ),
                  ),

                  const SizedBox(height: 12),

                  _SectionCard(
                    title: 'Details',
                    child: Column(
                      children: [
                        _DetailRow(label: 'Slug', value: p.slug ?? '—'),
                        const Divider(height: 20),
                        _DetailRow(
                          label: 'Created at',
                          value: p.creationAt ?? '—',
                        ),
                        const Divider(height: 20),
                        _DetailRow(
                          label: 'Updated at',
                          value: p.updatedAt ?? '—',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 64),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomGradient extends StatelessWidget {
  const _BottomGradient();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: IgnorePointer(
        child: Container(
          height: 140,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.black54, Colors.transparent],
            ),
          ),
        ),
      ),
    );
  }
}

class _PriceTag extends StatelessWidget {
  final double price;
  const _PriceTag({required this.price});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: ShapeDecoration(
        color: cs.primaryContainer,
        shape: StadiumBorder(
          side: BorderSide(color: cs.primary.withOpacity(.25)),
        ),
        shadows: [
          BoxShadow(
            color: cs.primary.withOpacity(.15),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Text(
        '\$${price.toStringAsFixed(2)}',
        style: theme.textTheme.titleMedium?.copyWith(
          color: cs.onPrimaryContainer,
          fontWeight: FontWeight.w700,
          letterSpacing: .2,
        ),
      ),
    );
  }
}

class _FavButton extends StatefulWidget {
  @override
  State<_FavButton> createState() => _FavButtonState();
}

class _FavButtonState extends State<_FavButton> {
  bool _fav = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => setState(() => _fav = !_fav),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: _fav ? cs.errorContainer : cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Icon(
          _fav ? Icons.favorite : Icons.favorite_border,
          color: _fav ? cs.onErrorContainer : cs.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withOpacity(.06),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          flex: 6,
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: theme.textTheme.bodyMedium,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _BottomBar extends StatelessWidget {
  final double price;
  final int qty;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final VoidCallback onAddToCart;

  const _BottomBar({
    required this.price,
    required this.qty,
    required this.onDecrement,
    required this.onIncrement,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        decoration: BoxDecoration(
          color: cs.surface,
          border: Border(top: BorderSide(color: cs.outlineVariant)),
        ),
        child: Row(
          children: [
            _QtyControl(qty: qty, onDec: onDecrement, onInc: onIncrement),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  onPressed:
                      onAddToCart, // ← نستخدم الكولباك القادم من الشاشة الأم
                  icon: const Icon(Icons.add_shopping_cart_rounded),
                  label: Text(
                    'Add to Cart • \$${(price * qty).toStringAsFixed(2)}',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsManager.purple,
                    foregroundColor: cs.onPrimary,
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QtyControl extends StatelessWidget {
  final int qty;
  final VoidCallback onDec;
  final VoidCallback onInc;

  const _QtyControl({
    required this.qty,
    required this.onDec,
    required this.onInc,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SafeArea(
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Row(
          children: [
            _IconSquare(icon: Icons.remove_rounded, onTap: onDec),
            SizedBox(
              width: 44,
              child: Center(
                child: Text(
                  '$qty',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            _IconSquare(icon: Icons.add_rounded, onTap: onInc),
          ],
        ),
      ),
    );
  }
}

class _IconSquare extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconSquare({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Icon(icon, size: 22),
      ),
    );
  }
}
