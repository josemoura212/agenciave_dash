import 'package:agenciave_dash/modules/home/core/home_controller.dart';

class ProductModel {
  final Product product;
  final String description;
  final bool ads;

  ProductModel(
      {required this.product, required this.description, this.ads = false});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      product: Product.values.firstWhere((e) => e.toString() == json['name']),
      description: json['description'],
      ads: json['ads'],
    );
  }

  factory ProductModel.empyt() =>
      ProductModel(product: Product.vi, description: '');

  @override
  String toString() {
    return "ProductModel(product: $product, description: $description)";
  }
}
