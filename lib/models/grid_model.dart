import 'package:agenciave_dash/models/home_model.dart';

class GridMediaModel {
  final List<MediaDiaria> mediaDiaria;
  final List<MediaMensal> mediaMensal;

  GridMediaModel({
    required this.mediaDiaria,
    required this.mediaMensal,
  });
}

class MediaDiaria {
  final int vendas;
  final double mediaFaturamento;
  final double mediaReceita;
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
  final double mediaFaturamento;
  final double mediaReceita;
  final DateTime? mes;

  MediaMensal({
    required this.vendas,
    required this.mediaFaturamento,
    required this.mediaReceita,
    this.mes,
  });
}

List<GridMediaModel> setGridMediaData(List<HomeModel> data) {
  final List<MediaDiaria> mediaDiaria = [];
  final List<MediaMensal> mediaMensal = [];

  final Map<DateTime, List<HomeModel>> countDate = {};

  for (var item in data) {
    DateTime date;

    final split = item.dataVenda.split("/");
    date =
        DateTime(int.parse(split[2]), int.parse(split[1]), int.parse(split[0]));

    countDate.update(date, (value) => [...value, item], ifAbsent: () => [item]);
  }

  countDate.forEach((key, value) {
    final totalVendas = value.fold<int>(
        0, (previousValue, element) => previousValue + element.quantidade);
    final totalFaturamento = value.fold<double>(
        0, (previousValue, element) => previousValue + element.faturamento);
    final totalReceita = value.fold<double>(
        0,
        (previousValue, element) =>
            previousValue + element.valorComissaoGerada);

    mediaDiaria.add(MediaDiaria(
      vendas: totalVendas,
      mediaFaturamento: totalFaturamento / value.length,
      mediaReceita: totalReceita / value.length,
      mes: key,
    ));
  });

  final Map<DateTime, List<MediaDiaria>> countMonth = {};

  for (var item in mediaDiaria) {
    DateTime date;

    date = DateTime(item.mes!.year, item.mes!.month);

    countMonth.update(date, (value) => [...value, item],
        ifAbsent: () => [item]);
  }

  countMonth.forEach((key, value) {
    final totalVendas = value.fold<int>(
        0, (previousValue, element) => previousValue + element.vendas);
    final totalFaturamento = value.fold<double>(0,
        (previousValue, element) => previousValue + element.mediaFaturamento);
    final totalReceita = value.fold<double>(
        0, (previousValue, element) => previousValue + element.mediaReceita);

    mediaMensal.add(MediaMensal(
      vendas: totalVendas,
      mediaFaturamento: totalFaturamento / value.length,
      mediaReceita: totalReceita / value.length,
      mes: key,
    ));
  });

  return [GridMediaModel(mediaDiaria: mediaDiaria, mediaMensal: mediaMensal)];
}
