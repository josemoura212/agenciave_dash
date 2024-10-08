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
  final List<CartesianModel> resultData = [];
  final Map<String, int> dataMap = {};

  for (var item in data) {
    if (item.status == Status.aproved || item.status == Status.completed) {
      dataMap.update(
        switch (type) {
          TypeData.hour =>
            "${item.saleDate.hour.toString().padLeft(2, "0")}:00h",
          TypeData.weekday => throw UnimplementedError(),
          TypeData.status => item.status.name,
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
    } else if (type == TypeData.status) {
      dataMap.update(
        item.status.name,
        (value) => value + item.quantity,
        ifAbsent: () => item.quantity,
      );
    }
  }

  dataMap.forEach((key, value) {
    resultData.add(CartesianModel(
      value: key,
      quantity: value,
    ));
  });

  resultData.sort((a, b) => a.value.compareTo(b.value));

  return resultData;
}
