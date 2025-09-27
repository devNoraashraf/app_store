import 'package:flutter/foundation.dart';
import 'package:app_store/models/products_model.dart' show products;

class CartItem {
  final products product;
  int qty;
  CartItem({required this.product, this.qty = 1});

  double get unitPrice => (product.price ?? 0).toDouble();
  double get total => unitPrice * qty;
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  List<CartItem> get items => List.unmodifiable(_items);

  void add(products p, {int qty = 1}) {
    final idx = _items.indexWhere((e) => e.product.id == p.id);
    if (idx >= 0) {
      _items[idx].qty = (_items[idx].qty + qty).clamp(1, 99);
    } else {
      _items.add(CartItem(product: p, qty: qty.clamp(1, 99)));
    }
    notifyListeners();
  }

  void removeAt(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void updateQty(int index, int delta) {
    final newQty = (_items[index].qty + delta).clamp(1, 99);
    _items[index].qty = newQty;
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  double get subtotal => _items.fold(0.0, (s, it) => s + it.total);
}
