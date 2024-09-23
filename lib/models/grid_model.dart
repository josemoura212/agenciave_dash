import 'package:agenciave_dash/models/date_model.dart';
import 'package:intl/intl.dart';

class GridMediaModel {
  final MediaDiaria mediaDiaria;
  final MediaMensal mediaMensal;

  GridMediaModel({
    required this.mediaDiaria,
    required this.mediaMensal,
  });
}

class MediaDiaria {
  final int vendas;
  final String mediaFaturamento;
  final String mediaReceita;
  final DateTime? mes;

  MediaDiaria({
    required this.vendas,
    required this.mediaFaturamento,
    required this.mediaReceita,
    this.mes,
  });
}

class MediaMensal {
  final int vendas;
  final String mediaFaturamento;
  final String mediaReceita;
  final DateTime? mes;

  MediaMensal({
    required this.vendas,
    required this.mediaFaturamento,
    required this.mediaReceita,
    this.mes,
  });
}

GridMediaModel setGridMediaData(List<DateModel> data) {
  var vendas = 0;
  var currentMonth = data[0].date.month;
  var totalMonth = 1;
  var totalDays = 0;
  var totalFaturamento = 0.0;
  var totalReceita = 0.0;

  for (var item in data) {
    if (item.date.month == currentMonth) {
      vendas += item.total;
      totalDays++;
      totalFaturamento += item.faturamento;
      totalReceita += item.receita;
    } else {
      vendas += item.total;
      totalDays++;
      totalFaturamento += item.faturamento;
      totalReceita += item.receita;
      totalMonth++;
    }
  }

  final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  final mediaDiaria = MediaDiaria(
    vendas: vendas ~/ totalDays,
    mediaFaturamento: formatter.format(totalFaturamento / totalDays),
    mediaReceita: formatter.format(totalReceita / totalDays),
  );

  final mediaMensal = MediaMensal(
    vendas: vendas ~/ totalMonth,
    mediaFaturamento: formatter.format(totalFaturamento / totalMonth),
    mediaReceita: formatter.format(totalReceita / totalMonth),
  );

  return GridMediaModel(
    mediaDiaria: mediaDiaria,
    mediaMensal: mediaMensal,
  );
}
