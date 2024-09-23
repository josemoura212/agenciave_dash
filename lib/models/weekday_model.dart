import 'package:agenciave_dash/models/home_model.dart';

class WeekdayModel {
  final String _weekDay;
  final int quantity;

  WeekdayModel({required String weekDay, required this.quantity})
      : _weekDay = weekDay;

  String get weekday {
    const weekdays = [
      'Domingo',
      'Segunda-feira',
      'Terça-feira',
      'Quarta-feira',
      'Quinta-feira',
      'Sexta-feira',
      'Sábado'
    ];
    return weekdays[int.parse(_weekDay) % 7];
  }
}

List<WeekdayModel> setWeekdayData(List<HomeModel> data) {
  final List<WeekdayModel> weekdayTotal = [];
  final Map<String, int> countWeekday = {};

  for (var item in data) {
    countWeekday.update(
      item.saleDate.weekday.toString(),
      (value) => value + item.quantity,
      ifAbsent: () => item.quantity,
    );
  }

  countWeekday.forEach((key, value) {
    weekdayTotal.add(WeekdayModel(
      weekDay: key,
      quantity: value,
    ));
  });

  weekdayTotal.sort((a, b) => a._weekDay.compareTo(b._weekDay));

  return weekdayTotal;
}
