import 'package:agenciave_dash/models/home_model.dart';

class HourModel {
  final int hour;
  final int quantity;

  HourModel({
    required this.hour,
    required this.quantity,
  });
}

List<HourModel> setHourData(List<HomeModel> data) {
  final List<HourModel> hourTotal = [];
  final Map<int, int> countHour = {};

  for (var item in data) {
    countHour.update(
      item.saleDate.hour,
      (value) => value + item.quantity,
      ifAbsent: () => item.quantity,
    );
  }

  countHour.forEach((key, value) {
    hourTotal.add(HourModel(
      hour: key,
      quantity: value,
    ));
  });

  hourTotal.sort((a, b) => a.hour.compareTo(b.hour));

  return hourTotal;
}
