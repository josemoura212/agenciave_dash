import 'package:agenciave_dash/models/processed_sale_model.dart';
import 'package:agenciave_dash/models/raw_sale_model.dart';

class ChartModel {
  final String name;
  final double value;
  final String? text;
  final int total;

  ChartModel({
    required this.name,
    required this.value,
    required this.text,
    required this.total,
  });
}

List<ChartModel> setChartData(List<RawSaleModel> data, TypeData type) {
  final List<ChartModel> resultData = [];
  final Map<String, int> dataMap = {};

  for (var item in data) {
    if (item.status == Status.aproved || item.status == Status.completed) {
      final data = switch (type) {
        TypeData.origem => _originFormat(item.origin),
        TypeData.state => _stateFormat(item.state),
        TypeData.paymentType => _paymentTypeFomart(item.paymentType),
        TypeData.paymentTypeOffer =>
          _paymentTypeOfferFormat(item.paymenteTypeOffer),
        TypeData.country => item.country,
        TypeData.status => throw UnimplementedError(),
        TypeData.buyer => throw UnimplementedError(),
        TypeData.media => throw UnimplementedError(),
        TypeData.weekday => throw UnimplementedError(),
        TypeData.hour => throw UnimplementedError(),
      };
      dataMap[data] = (dataMap[data] ?? 0) + item.quantity;
    }
  }

  dataMap.forEach((key, value) {
    if (value == 0) return;
    resultData.add(ChartModel(
        name: key,
        value: value.toDouble(),
        total: value,
        text: "$key: ${(value * 100 / data.length).toStringAsFixed(2)}%"));
  });

  return resultData;
}

String _paymentTypeOfferFormat(String value) {
  return switch (value.toLowerCase()) {
    "parcelamento padrão (até 12×)" => "Parcelamento Padrão",
    "apenas à vista" => "À Vista",
    _ => "Outros",
  };
}

String _paymentTypeFomart(String value) {
  return switch (value.toLowerCase()) {
    "boleto bancário" || "billet" => "Boleto",
    "cartão de crédito" || "credit_card" => "Cartão",
    "pix" => "Pix",
    "paypal" => "PayPal",
    "google pay" => "Google Pay",
    "apple pay" => "Apple Pay",
    "transferência" => "Transferência",
    "conta hotmart (saldo hotmart)" => "Hotmart Saldo",
    "conta hotmart" => "Conta Hotmart",
    "pagamento híbrido" => "Híbrido",
    "conta hotmart (cartão)" => "Hotmart Cartão ",
    "conta hotmart (cartão + saldo)" => "Hotmart Cartão + Saldo",
    _ => "Outros",
  };
}

String _originFormat(String value) {
  return switch (value.toLowerCase()) {
    "zoom" => "Zoom",
    "whatsapp" => "Whatsapp",
    "manychat" => "Manychat",
    "chatbot" => "Chatbot",
    "bio" => "Bio",
    "listboos" => "ListBoss",
    "poliana" => "Poliana",
    "fbads-frio" => "fbads Frio",
    "fbads-quente" => "fbads Quente",
    "redirect-cap" => "Redirect Cap",
    "email" => "Email",
    "aluno" => "Aluno",
    _ => "Outros",
  };
}

String _stateFormat(String value) {
  return switch (value.toUpperCase()) {
    "AC" => "AC",
    "AL" => "AL",
    "AP" => "AP",
    "AM" => "AM",
    "BA" => "BA",
    "CE" => "CE",
    "DF" => "DF",
    "ES" => "ES",
    "GO" => "GO",
    "MA" => "MA",
    "MT" => "MT",
    "MS" => "MS",
    "MG" => "MG",
    "PA" => "PA",
    "PB" => "PB",
    "PR" => "PR",
    "PE" => "PE",
    "PI" => "PI",
    "RJ" => "RJ",
    "RN" => "RN",
    "RS" => "RS",
    "RO" => "RO",
    "RR" => "RR",
    "SC" => "SC",
    "SP" => "SP",
    "SE" => "SE",
    "TO" => "TO",
    _ => "Outros",
  };
}
