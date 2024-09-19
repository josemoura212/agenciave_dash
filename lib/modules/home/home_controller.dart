import 'package:agenciave_dash/models/date_model.dart';
import 'package:asyncstate/asyncstate.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'package:agenciave_dash/core/auth/auth_controller.dart';
import 'package:agenciave_dash/core/fp/either.dart';
import 'package:agenciave_dash/core/helpers/messages.dart';
import 'package:agenciave_dash/models/home_model.dart';
import 'package:agenciave_dash/services/home/home_services.dart';
import 'package:agenciave_dash/models/origem_model.dart';

class HomeController with MessageStateMixin {
  HomeController({
    required HomeServices homeServices,
  }) : _homeServices = homeServices;

  final HomeServices _homeServices;

  final _authController = Injector.get<AuthController>();

  final Signal<List<HomeModel>> _homeData = Signal<List<HomeModel>>([]);
  final Signal<List<OrigemModel>> _origemData = Signal<List<OrigemModel>>([]);
  final Signal<List<DateModel>> _dateData = Signal<List<DateModel>>([]);

  List<HomeModel> get homeData => _homeData.value;
  List<OrigemModel> get origemData => _origemData.value;
  List<DateModel> get dateData => _dateData.value;

  void setHomeData(List<HomeModel> data) {
    _homeData.set(data, force: true);
    _origemData.set(setOrigemData(data), force: true);
    _dateData.set(setDateData(data), force: true);
  }

  Future<void> getHomeData() async {
    if (await isAuthenticaded()) {
      final result = await _homeServices.getHomeData().asyncLoader();

      switch (result) {
        case Left():
          showError("Erro ao buscar dados");
        case Right(value: List<HomeModel> data):
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
