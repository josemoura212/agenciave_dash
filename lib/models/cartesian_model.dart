import 'package:agenciave_dash/models/home_model.dart';

class CartesianModel {
  final String value;
  final int quantity;

  CartesianModel({
    required this.value,
    required this.quantity,
  });
}

List<CartesianModel> setHourData(List<HomeModel> data) {
  final List<CartesianModel> hourTotal = [];
  final Map<String, int> countHour = {};

  for (var item in data) {
    countHour.update(
      "${item.saleDate.hour}:00h",
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
