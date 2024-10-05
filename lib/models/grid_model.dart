import 'package:agenciave_dash/models/date_model.dart';
import 'package:agenciave_dash/models/raw_sale_model.dart';
import 'package:intl/intl.dart';

class GridMediaModel {
  final MediaDiaria mediaDiaria;
  final MediaMensal mediaMensal;

  GridMediaModel({
    required this.mediaDiaria,
    required this.mediaMensal,
  });

  GridMediaModel.empty()
      : mediaDiaria = MediaDiaria(
          vendas: 0,
          mediaFaturamento: '',
          mediaReceita: '',
        ),
        mediaMensal = MediaMensal(
          vendas: 0,
          mediaFaturamento: '',
          mediaReceita: '',
        );
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
    if (item.date.month != currentMonth) {
      currentMonth = item.date.month;
      totalMonth++;
    }
    vendas += item.total;
    totalDays++;
    totalFaturamento += item.invoicing;
    totalReceita += item.revenue;
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

class RecoveryModel {
  final String refundRate;
  final String automaticRecovery;
  final String commercialRecovery;

  RecoveryModel({
    required this.refundRate,
    required this.automaticRecovery,
    required this.commercialRecovery,
  });

  RecoveryModel.empty()
      : refundRate = '',
        automaticRecovery = '',
        commercialRecovery = '';
}

RecoveryModel setRecoveryData(List<RawSaleModel> data) {
  var refundRate = 0.0;
  var automaticRecovery = 0.0;
  var comemrcialRecovery = 0.0;
  var total = 0;
  var expiredOrCanceled = 0;

  for (var item in data) {
    total += 1;
    if (item.status == Status.disputed || item.status == Status.chargeback) {
      refundRate += 1;
    }
    if (item.status == Status.canceled || item.status == Status.expired) {
      expiredOrCanceled += 1;
    }

    if (item.origin.toLowerCase() == "listboos" ||
        item.origin.toLowerCase() == "chatbot") {
      automaticRecovery += item.invoicing;
    } else if (item.origin.toLowerCase() == 'poliana') {
      comemrcialRecovery += item.invoicing;
    }
  }

  return RecoveryModel(
    refundRate: refundRate == 0
        ? "0.0%"
        : "${(refundRate / total * 100).toStringAsFixed(2)}%",
    automaticRecovery: automaticRecovery == 0
        ? "0.0%"
        : "${(automaticRecovery / expiredOrCanceled * 100).toStringAsFixed(2)}%",
    commercialRecovery: comemrcialRecovery == 0
        ? "0.0%"
        : "${(comemrcialRecovery / expiredOrCanceled * 100).toStringAsFixed(2)}%",
  );
}
