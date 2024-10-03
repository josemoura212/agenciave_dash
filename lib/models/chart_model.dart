import 'package:agenciave_dash/models/home_model.dart';

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

List<ChartModel> setOrigemData(List<HomeModel> data) {
  final List<ChartModel> origemTotal = [];

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
    switch (item.origin.toLowerCase()) {
      case "zoom":
        countOrigem["Zoom"] = (countOrigem["Zoom"] ?? 0) + item.quantity;
        break;
      case "whatsapp":
        countOrigem["Whatsapp"] =
            (countOrigem["Whatsapp"] ?? 0) + item.quantity;
        break;
      case "manychat":
        countOrigem["Manychat"] =
            (countOrigem["Manychat"] ?? 0) + item.quantity;
        break;
      case "chatbot":
        countOrigem["Chatbot"] = (countOrigem["Chatbot"] ?? 0) + item.quantity;
        break;
      case "bio":
        countOrigem["Bio"] = (countOrigem["Bio"] ?? 0) + item.quantity;
        break;
      case "poliana":
        countOrigem["Poliana"] = (countOrigem["Poliana"] ?? 0) + item.quantity;
        break;
      case "fbads-frio":
        countOrigem["fbads Frio"] =
            (countOrigem["fbads Frio"] ?? 0) + item.quantity;
        break;
      case "fbads-quente":
        countOrigem["fbads Quente"] =
            (countOrigem["fbads Quente"] ?? 0) + item.quantity;
        break;
      case "redirect-cap":
        countOrigem["Redirect Cap"] =
            (countOrigem["Redirect Cap"] ?? 0) + item.quantity;
        break;
      case "email":
        countOrigem["Email"] = (countOrigem["Email"] ?? 0) + item.quantity;
        break;
      case "aluno":
        countOrigem["Aluno"] = (countOrigem["Aluno"] ?? 0) + item.quantity;
        break;
      default:
        countOrigem["Outros"] = (countOrigem["Outros"] ?? 0) + item.quantity;
        break;
    }
  }

  countOrigem.forEach((key, value) {
    if (value == 0) return;
    origemTotal.add(ChartModel(
        name: key,
        value: value.toDouble(),
        total: value,
        text: "$key: ${(value * 100 / data.length).toStringAsFixed(2)}%"));
  });

  return origemTotal;
}

List<ChartModel> setPaymentTypeOffer(List<HomeModel> data) {
  final List<ChartModel> paymentTypeOfferTotal = [];

  final Map<String, int> countPaymentTypeOffer = {};

  for (var item in data) {
    final paymentTypeOffer = item.paymenteTypeOffer.toLowerCase();
    countPaymentTypeOffer[paymentTypeOffer] =
        (countPaymentTypeOffer[paymentTypeOffer] ?? 0) + item.quantity;
  }

  countPaymentTypeOffer.forEach((key, value) {
    if (value == 0) return;
    paymentTypeOfferTotal.add(ChartModel(
        name: key,
        value: value.toDouble(),
        total: value,
        text: "$key: ${(value * 100 / data.length).toStringAsFixed(2)}%"));
  });

  return paymentTypeOfferTotal;
}

List<ChartModel> setPaymentType(List<HomeModel> data) {
  final List<ChartModel> paymentTypeTotal = [];

  final Map<String, int> countPaymentType = {};

  for (var item in data) {
    final paymentType = item.paymentType.toLowerCase();
    countPaymentType[paymentType] =
        (countPaymentType[paymentType] ?? 0) + item.quantity;
  }

  countPaymentType.forEach((key, value) {
    if (value == 0) return;
    paymentTypeTotal.add(ChartModel(
        name: key,
        value: value.toDouble(),
        total: value,
        text: "$key: ${(value * 100 / data.length).toStringAsFixed(2)}%"));
  });

  return paymentTypeTotal;
}

List<ChartModel> setStateData(List<HomeModel> data) {
  final List<ChartModel> stateTotal = [];

  final Map<String, int> countState = {};

  for (var item in data) {
    switch (item.state.toLowerCase()) {
      case "sp":
        countState["SP"] = (countState["SP"] ?? 0) + item.quantity;
        break;
      case "rj":
        countState["RJ"] = (countState["RJ"] ?? 0) + item.quantity;
        break;
      case "mg":
        countState["MG"] = (countState["MG"] ?? 0) + item.quantity;
        break;
      case "es":
        countState["ES"] = (countState["ES"] ?? 0) + item.quantity;
        break;
      case "pr":
        countState["PR"] = (countState["PR"] ?? 0) + item.quantity;
        break;
      case "sc":
        countState["SC"] = (countState["SC"] ?? 0) + item.quantity;
        break;
      case "rs":
        countState["RS"] = (countState["RS"] ?? 0) + item.quantity;
        break;
      case "ms":
        countState["MS"] = (countState["MS"] ?? 0) + item.quantity;
        break;
      case "mt":
        countState["MT"] = (countState["MT"] ?? 0) + item.quantity;
        break;
      case "go":
        countState["GO"] = (countState["GO"] ?? 0) + item.quantity;
        break;
      case "df":
        countState["DF"] = (countState["DF"] ?? 0) + item.quantity;
        break;
      case "ba":
        countState["BA"] = (countState["BA"] ?? 0) + item.quantity;
        break;
      case "se":
        countState["SE"] = (countState["SE"] ?? 0) + item.quantity;
        break;
      case "al":
        countState["AL"] = (countState["AL"] ?? 0) + item.quantity;
        break;
      case "pe":
        countState["PE"] = (countState["PE"] ?? 0) + item.quantity;
        break;
      case "pb":
        countState["PB"] = (countState["PB"] ?? 0) + item.quantity;
        break;
      case "rn":
        countState["RN"] = (countState["RN"] ?? 0) + item.quantity;
        break;
      case "ce":
        countState["CE"] = (countState["CE"] ?? 0) + item.quantity;
        break;
      case "pi":
        countState["PI"] = (countState["PI"] ?? 0) + item.quantity;
        break;
      case "ma":
        countState["MA"] = (countState["MA"] ?? 0) + item.quantity;
        break;
      case "pa":
        countState["PA"] = (countState["PA"] ?? 0) + item.quantity;
        break;
      case "ap":
        countState["AP"] = (countState["AP"] ?? 0) + item.quantity;
        break;
      case "to":
        countState["TO"] = (countState["TO"] ?? 0) + item.quantity;
        break;
      case "ro":
        countState["RO"] = (countState["RO"] ?? 0) + item.quantity;
        break;
      case "ac":
        countState["AC"] = (countState["AC"] ?? 0) + item.quantity;
        break;
      case "am":
        countState["AM"] = (countState["AM"] ?? 0) + item.quantity;
        break;
      case "rr":
        countState["RR"] = (countState["RR"] ?? 0) + item.quantity;
        break;
    }
  }

  countState.forEach((key, value) {
    if (value == 0) return;
    stateTotal.add(ChartModel(
      name: key,
      value: value.toDouble(),
      text: "$key: ${(value * 100 / data.length).toStringAsFixed(2)}%",
      total: value,
    ));
  });

  return stateTotal;
}
