import 'package:http/http.dart' as http;

class ApiHandler {
  Future<void> getallproducts() async {
    http.get( Uri.parse('https://api.escuelajs.co/api/v1/products'));
  }
}
