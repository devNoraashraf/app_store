import 'dart:convert';
import 'package:app_store/models/products_model.dart';
import 'package:http/http.dart' as http;
import 'package:app_store/models/category_model.dart';

class ApiHandler {
  Future<List<products>> getAllProducts() async {
    var response = await http.get(
      Uri.parse('https://api.escuelajs.co/api/v1/products'),
    );

    var data = jsonDecode(response.body);

    List tempList = [];
    for (var item in data) {
      tempList.add(item);
    }
    return tempList.map((item) => products.fromJson(item)).toList();
  }
  ///////////////////////////////////////////////////////////////////////////
  Future<List<Category>> getAllCategories() async {
    final response = await http.get(
      Uri.parse('https://api.escuelajs.co/api/v1/categories'),
    );
    final data = jsonDecode(response.body) as List;
    return data.map((item) => Category.fromJson(item)).toList();
  }

}
