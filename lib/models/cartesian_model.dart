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

// List<CartesianModel> setWeekdayData(List<HomeModel> data) {
//   final List<CartesianModel> weekdayTotal = [];
//   final Map<String, int> countWeekday = {};

//   for (var item in data) {
//     countWeekday.update(
//       item.saleDate.weekday.toString(),
//       (value) => value + item.quantity,
//       ifAbsent: () => item.quantity,
//     );
//   }

//   countWeekday.forEach((key, value) {
//     weekdayTotal.add(CartesianModel(
//       value: key,
//       quantity: value,
//     ));
//   });

//   weekdayTotal.sort((a, b) => a.value.compareTo(b.value));

//   return weekdayTotal;
// }

List<CartesianModel> setStatusData(List<HomeModel> data) {
  final List<CartesianModel> statusTotal = [];
  final Map<String, int> countStatus = {};

  for (var item in data) {
    countStatus.update(
      item.status,
      (value) => value + item.quantity,
      ifAbsent: () => item.quantity,
    );
  }

  countStatus.forEach((key, value) {
    statusTotal.add(CartesianModel(
      value: key,
      quantity: value,
    ));
  });

  statusTotal.sort((a, b) => a.value.compareTo(b.value));

  return statusTotal;
}
