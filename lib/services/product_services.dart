import 'dart:convert';

import 'package:provider_app/model/product.dart';
import 'package:http/http.dart' as http;

class ProductServices {
  Future<List<Product>> getAllProducts() async {
    const url = 'https://dummyjson.com/products';
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List<dynamic> productsJson = json['products'];

      final List<Product> products = productsJson.map((e) {
        return Product(
          id: e['id'],
          title: e['title'],
          description: e['description'],
          category: e['category'],
          price: (e['price'] as num).toDouble(),
          discountPercentage: (e['discountPercentage'] as num).toDouble(),
          rating: (e['rating'] as num).toDouble(),
          stock: e['stock'],
          tags: e['tags'].cast<String>(),
          brand: e['brand'],
          sku: e['sku'],
          weight: e['weight'],
          dimensions: e['dimensions'] != null
              ? Dimensions.fromJson(e['dimensions'])
              : null,
          warrantyInformation: e['warrantyInformation'],
          shippingInformation: e['shippingInformation'],
          availabilityStatus: e['availabilityStatus'],
          reviews: e['reviews'] != null
              ? (e['reviews'] as List).map((v) => Reviews.fromJson(v)).toList()
              : null,
          returnPolicy: e['returnPolicy'],
          minimumOrderQuantity: e['minimumOrderQuantity'],
          meta: e['meta'] != null ? Meta.fromJson(e['meta']) : null,
          images: e['images'].cast<String>(),
          thumbnail: e['thumbnail'],
        );
      }).toList();

      return products;
    }

    return [];
  }
}
