import 'package:agenciave_dash/models/processed_sale_model.dart';
import 'package:agenciave_dash/models/raw_sale_model.dart';

class ChartModel {
  final String name;
  final double value;
  final String? text;
  final int total;

  ChartModel({
    required this.name,
    required this.value,
    required this.text,
    required this.total,
  });
}

List<ChartModel> setChartData(List<RawSaleModel> data, TypeData type) {
  final List<ChartModel> resultData = [];
  final Map<String, int> dataMap = {};

  String format(String value) {
    return value.toLowerCase().replaceAll('-', ' ');
  }

  for (var item in data) {
    final data = switch (type) {
      TypeData.origem => format(item.origin),
      TypeData.state => format(item.state).toUpperCase(),
      TypeData.paymentType => format(item.paymentType),
      TypeData.paymentTypeOffer => format(item.paymenteTypeOffer),
      TypeData.country => format(item.country),
      TypeData.status => throw UnimplementedError(),
      TypeData.buyer => throw UnimplementedError(),
      TypeData.media => throw UnimplementedError(),
      TypeData.weekday => throw UnimplementedError(),
      TypeData.hour => throw UnimplementedError(),
    };
    dataMap[data] = (dataMap[data] ?? 0) + item.quantity;
  }

  dataMap.forEach((key, value) {
    if (value == 0) return;
    resultData.add(ChartModel(
        name: key,
        value: value.toDouble(),
        total: value,
        text: "$key: ${(value * 100 / data.length).toStringAsFixed(2)}%"));
  });

  return resultData;
}
