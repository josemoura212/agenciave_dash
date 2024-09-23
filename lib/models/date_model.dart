import 'package:agenciave_dash/models/home_model.dart';

class DateModel {
  final DateTime date;
  final int total;
  final double invoicing;
  final double revenue;

  DateModel({
    required this.date,
    required this.total,
    required this.invoicing,
    required this.revenue,
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
  final Map<DateTime, VendaModel> countDate = {};

  for (var item in data) {
    countDate.update(
      item.saleDate,
      (value) => VendaModel(
        total: value.total + item.quantity,
        faturamento: value.faturamento + item.invoicing,
        receita: value.receita + item.commissionValueGenerated,
      ),
      ifAbsent: () => VendaModel(
        total: item.quantity,
        faturamento: item.invoicing,
        receita: item.commissionValueGenerated,
      ),
    );
  }

  countDate.forEach((key, value) {
    dateTotal.add(DateModel(
        date: key,
        total: value.total,
        invoicing: value.faturamento,
        revenue: value.receita));
  });

  dateTotal.sort((a, b) => a.date.compareTo(b.date));

  return dateTotal;
}

class VendaModel {
  final int total;
  final double faturamento;
  final double receita;

  VendaModel(
      {required this.total, required this.faturamento, required this.receita});
}
