import 'dart:convert';

class HomeModel {
  int nowNumber;
  String nomeProduto;
  String origem;
  DateTime dataVenda;
  DateTime horaVenda;
  int quantidade;
  double faturamento;
  String moeda;
  int numeroParcela;
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
      'Data de Venda': dataVenda.millisecondsSinceEpoch,
      'Hora de Venda': horaVenda.millisecondsSinceEpoch,
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
      dataVenda: DateTime.fromMillisecondsSinceEpoch(map['Data de Venda']),
      horaVenda: DateTime.fromMillisecondsSinceEpoch(map['Hora de Venda']),
      quantidade: map['Qtd.']?.toInt() ?? 0,
      faturamento: map['Faturamento']?.toDouble() ?? 0.0,
      moeda: map['Moeda'] ?? '',
      numeroParcela: map['Número da Parcela']?.toInt() ?? 0,
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
}
