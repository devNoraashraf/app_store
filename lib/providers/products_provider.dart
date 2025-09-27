import 'package:flutter/foundation.dart';
import 'package:app_store/models/products_model.dart';
import 'package:app_store/services/api_handler.dart';

class ProductsProvider extends ChangeNotifier {
  final ApiHandler _api = ApiHandler();

  List<products> _items = [];
  List<products> get items => _items;

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  ProductsProvider() {
    fetchAll();
  }

  Future<void> fetchAll() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _items = await _api.getAllProducts();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
  
