class ProductModel {
  final String name;
  final String description;

  ProductModel({required this.name, required this.description});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      name: json['name'],
      description: json['description'],
    );
  }

  factory ProductModel.empyt() => ProductModel(name: '', description: '');
}
