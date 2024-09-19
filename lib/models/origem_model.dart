import 'package:agenciave_dash/models/home_model.dart';

class OrigemModel {
  final String name;
  final double value;
  final String? text;
  final int total;
  OrigemModel({
    required this.name,
    required this.value,
    this.text,
    required this.total,
  });
}

List<OrigemModel> setOrigemData(List<HomeModel> data) {
  final List<OrigemModel> origemTotal = [];

  final Map<String, int> countOrigem = {
    "Zoom": 0,
    "Whatsapp": 0,
    "Manychat": 0,
    "Chatbot": 0,
    "Bio": 0,
    "Poliana": 0,
    "fbads Frio": 0,
    "fbads Quente": 0,
  };

  for (var item in data) {
    switch (item.origem.toLowerCase()) {
      case "zoom":
        countOrigem["Zoom"] = (countOrigem["Zoom"] ?? 0) + item.quantidade;
        break;
      case "whatsapp":
        countOrigem["Whatsapp"] =
            (countOrigem["Whatsapp"] ?? 0) + item.quantidade;
        break;
      case "manychat":
        countOrigem["Manychat"] =
            (countOrigem["Manychat"] ?? 0) + item.quantidade;
        break;
      case "chatbot":
        countOrigem["Chatbot"] =
            (countOrigem["Chatbot"] ?? 0) + item.quantidade;
        break;
      case "bio":
        countOrigem["Bio"] = (countOrigem["Bio"] ?? 0) + item.quantidade;
        break;
      case "poliana":
        countOrigem["Poliana"] =
            (countOrigem["Poliana"] ?? 0) + item.quantidade;
        break;
      case "fbads-frio":
        countOrigem["fbads Frio"] =
            (countOrigem["fbads Frio"] ?? 0) + item.quantidade;
        break;
      case "fbads-quente":
        countOrigem["fbads Quente"] =
            (countOrigem["fbads Quente"] ?? 0) + item.quantidade;
        break;
    }
  }

  countOrigem.forEach((key, value) {
    origemTotal.add(OrigemModel(
        name: key,
        value: value.toDouble(),
        total: value,
        text: "$key: ${(value * 100 / data.length).toStringAsFixed(2)}%"));
  });

  return origemTotal;
}
