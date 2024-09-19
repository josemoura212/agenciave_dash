import 'package:agenciave_dash/models/home_model.dart';

class DateModel {
  final DateTime date;
  final int total;

  DateModel({
    required this.date,
    required this.total,
  });

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
    return weekdays[date.weekday % 7];
  }
}

setDateData(List<HomeModel> data) {
  final List<DateModel> dateTotal = [];

  final Map<DateTime, int> countDate = {};

  for (var item in data) {
    DateTime date;

    final split = item.dataVenda.split("/");
    date =
        DateTime(int.parse(split[2]), int.parse(split[1]), int.parse(split[0]));

    countDate.update(date, (value) => value + item.quantidade,
        ifAbsent: () => item.quantidade);
  }

  countDate.forEach((key, value) {
    dateTotal.add(DateModel(date: key, total: value));
  });

  dateTotal.sort((a, b) => a.date.compareTo(b.date));

  return dateTotal;
}
