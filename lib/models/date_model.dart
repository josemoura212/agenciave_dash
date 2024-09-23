import 'package:agenciave_dash/models/home_model.dart';

class DateModel {
  final DateTime date;
  final int total;
  final double faturamento;
  final double receita;

  DateModel({
    required this.date,
    required this.total,
    required this.faturamento,
    required this.receita,
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
      item.dataVenda,
      (value) => VendaModel(
        total: value.total + item.quantidade,
        faturamento: value.faturamento + item.faturamento,
        receita: value.receita + item.valorComissaoGerada,
      ),
      ifAbsent: () => VendaModel(
        total: item.quantidade,
        faturamento: item.faturamento,
        receita: item.valorComissaoGerada,
      ),
    );
  }

  countDate.forEach((key, value) {
    dateTotal.add(DateModel(
        date: key,
        total: value.total,
        faturamento: value.faturamento,
        receita: value.receita));
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
