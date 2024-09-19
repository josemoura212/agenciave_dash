import 'dart:convert';

class Origem {
  String name;
  double value;
  String? text;
  int total;
  Origem({
    required this.name,
    required this.value,
    this.text,
    required this.total,
  });
}

class HomeModel {
  int nowNumber;
  String nomeProduto;
  String origem;
  String dataVenda;
  String horaVenda;
  int quantidade;
  double faturamento;
  String moeda;
  String numeroParcela;
  String status;
  String pais;
  String estado;
  String tipoPagamento;
  String tipoPagamentoOferta;
  double valorComissaoGerada;

  HomeModel({
    required this.nowNumber,
    required this.nomeProduto,
    required this.origem,
    required this.dataVenda,
    required this.horaVenda,
    required this.quantidade,
    required this.faturamento,
    required this.moeda,
    required this.numeroParcela,
    required this.status,
    required this.pais,
    required this.estado,
    required this.tipoPagamento,
    required this.tipoPagamentoOferta,
    required this.valorComissaoGerada,
  });

  Map<String, dynamic> toMap() {
    return {
      'now_number': nowNumber,
      'Nome do Produto': nomeProduto,
      'Origem': origem,
      'Data de Venda': dataVenda,
      'Hora de Venda': horaVenda,
      'Qtd.': quantidade,
      'Faturamento': faturamento,
      'Moeda': moeda,
      'Número da Parcela': numeroParcela,
      'Status': status,
      'País': pais,
      'Estado': estado,
      'Tipo de Pagamento': tipoPagamento,
      'Tipo pagamento oferta': tipoPagamentoOferta,
      'Valor da Comissão Gerada': valorComissaoGerada,
    };
  }

  factory HomeModel.fromMap(Map<String, dynamic> map) {
    return HomeModel(
      nowNumber: map['row_number']?.toInt() ?? 0,
      nomeProduto: map['Nome do Produto'] ?? '',
      origem: map['Origem'] ?? '',
      dataVenda: map['Data de Venda'],
      horaVenda: map['Hora de Venda'],
      quantidade: map['Qtd.']?.toInt() ?? 0,
      faturamento: map['Faturamento']?.toDouble() ?? 0.0,
      moeda: map['Moeda'] ?? '',
      numeroParcela: map['Número da Parcela'],
      status: map['Status'] ?? '',
      pais: map['País'] ?? '',
      estado: map['Estado'] ?? '',
      tipoPagamento: map['Tipo de Pagamento'] ?? '',
      tipoPagamentoOferta: map['Tipo pagamento oferta'] ?? '',
      valorComissaoGerada: map['Valor da Comissão Gerada']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory HomeModel.fromJson(String source) =>
      HomeModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'HomeModel(nowNumber: $nowNumber, nomeProduto: $nomeProduto, origem: $origem, dataVenda: $dataVenda, horaVenda: $horaVenda, quantidade: $quantidade, faturamento: $faturamento, moeda: $moeda, numeroParcela: $numeroParcela, status: $status, pais: $pais, estado: $estado, tipoPagamento: $tipoPagamento, tipoPagamentoOferta: $tipoPagamentoOferta, valorComissaoGerada: $valorComissaoGerada)';
  }
}
