import 'package:flutter_getit/flutter_getit.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'package:agenciave_dash/core/auth/auth_controller.dart';
import 'package:agenciave_dash/core/fp/either.dart';
import 'package:agenciave_dash/core/helpers/messages.dart';
import 'package:agenciave_dash/models/home_model.dart';
import 'package:agenciave_dash/services/home/home_services.dart';

class HomeController with MessageStateMixin {
  HomeController({
    required HomeServices homeServices,
  }) : _homeServices = homeServices;

  final HomeServices _homeServices;
  final _authController = Injector.get<AuthController>();
  final Signal<List<HomeModel>> _homeData = Signal<List<HomeModel>>([]);
  final Signal<List<Origem>> _origemData = Signal<List<Origem>>([]);

  List<HomeModel> get homeData => _homeData.value;
  List<Origem> get origemData => _origemData.value;

  void setHomeData(List<HomeModel> data) {
    _homeData.set(data, force: true);

    final List<Origem> origemTotal = [];

    final Map<String, int> countOrigem = {
      "zoom": 0,
      "whatsapp": 0,
      "manychat": 0,
      "chatbot": 0,
      "bio": 0,
      "poliana": 0,
      "fbads-frio": 0,
      "fbads-quente": 0,
    };

    for (var item in data) {
      switch (item.origem.toLowerCase()) {
        case "zoom":
          countOrigem["zoom"] = (countOrigem["zoom"] ?? 0) + item.quantidade;
          break;
        case "whatsapp":
          countOrigem["whatsapp"] =
              (countOrigem["whatsapp"] ?? 0) + item.quantidade;
          break;
        case "manychat":
          countOrigem["manychat"] =
              (countOrigem["manychat"] ?? 0) + item.quantidade;
          break;
        case "chatbot":
          countOrigem["chatbot"] =
              (countOrigem["chatbot"] ?? 0) + item.quantidade;
          break;
        case "bio":
          countOrigem["bio"] = (countOrigem["bio"] ?? 0) + item.quantidade;
          break;
        case "poliana":
          countOrigem["poliana"] =
              (countOrigem["poliana"] ?? 0) + item.quantidade;
          break;
        case "fbads-frio":
          countOrigem["fbads-frio"] =
              (countOrigem["fbads-frio"] ?? 0) + item.quantidade;
          break;
        case "fbads-quente":
          countOrigem["fbads-quente"] =
              (countOrigem["fbads-quente"] ?? 0) + item.quantidade;
          break;
      }
    }

    countOrigem.forEach((key, value) {
      origemTotal.add(Origem(
          name: key,
          value: value.toDouble(),
          text: "$key: ${(value * 100 / data.length).toStringAsFixed(2)}%"));
    });

    _origemData.set(origemTotal, force: true);
  }

  Future<void> getHomeData() async {
    if (await isAuthenticaded()) {
      final result = await _homeServices.getHomeData();

      switch (result) {
        case Left():
          showError("Erro ao buscar dados");
        case Right(value: List<HomeModel> data):
          _homeData.set(data, force: true);
          setHomeData(data);
      }
    }
  }

  Future<bool> isAuthenticaded() async {
    final apyKey = await _authController.isAuthenticate();

    if (apyKey != null) {
      return true;
    } else {
      showError("Usuário não autenticado");
      return false;
    }
  }
}
