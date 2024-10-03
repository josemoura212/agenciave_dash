import 'package:agenciave_dash/models/processed_sale_model.dart';
import 'package:agenciave_dash/models/raw_sale_model.dart';

class CartesianModel {
  final String value;
  final int quantity;

  CartesianModel({
    required this.value,
    required this.quantity,
  });
}

List<CartesianModel> setCartesianData(List<RawSaleModel> data, TypeData type) {
  final List<CartesianModel> hourTotal = [];
  final Map<String, int> countHour = {};

  for (var item in data) {
    countHour.update(
      switch (type) {
        TypeData.hour => "${item.saleDate.hour}:00h",
        TypeData.weekday => throw UnimplementedError(),
        TypeData.status => item.status,
        TypeData.origem => throw UnimplementedError(),
        TypeData.state => throw UnimplementedError(),
        TypeData.paymentType => throw UnimplementedError(),
        TypeData.paymentTypeOffer => throw UnimplementedError(),
        TypeData.country => throw UnimplementedError(),
        TypeData.media => throw UnimplementedError(),
        TypeData.buyer => throw UnimplementedError(),
      },
      (value) => value + item.quantity,
      ifAbsent: () => item.quantity,
    );
  }

  countHour.forEach((key, value) {
    hourTotal.add(CartesianModel(
      value: key,
      quantity: value,
    ));
  });

  hourTotal.sort((a, b) => a.value.compareTo(b.value));

  return hourTotal;
}
