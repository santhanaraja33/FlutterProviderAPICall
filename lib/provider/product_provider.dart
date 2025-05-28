import 'package:flutter/material.dart';
import 'package:provider_app/model/product.dart';
import 'package:provider_app/services/product_services.dart';

class ProductProvider extends ChangeNotifier {
  final _ProductServices = ProductServices();

  bool isLoading = false;
  List<Product> _products = [];

  List<Product> get products => _products;

  Future<void> getAllProducts() async {
    isLoading = true;

    notifyListeners();

    final response = await _ProductServices.getAllProducts();

    print(response.toString());

    _products = response;

    isLoading = false;
    notifyListeners();
  }
}
