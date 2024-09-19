import 'dart:developer';

import 'package:agenciave_dash/models/date_model.dart';
import 'package:asyncstate/asyncstate.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:intl/intl.dart';
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
  final Signal<List<HomeModel>> _homeDataBackup = Signal<List<HomeModel>>([]);
  final Signal<List<OrigemModel>> _origemData = Signal<List<OrigemModel>>([]);
  final Signal<List<DateModel>> _dateData = Signal<List<DateModel>>([]);
  final Signal<int> _totalVendas = Signal<int>(0);
  final Signal<DateTime?> _selectedDate = Signal<DateTime?>(null);

  List<HomeModel> get homeData => _homeData.value;
  List<OrigemModel> get origemData => _origemData.value;
  List<DateModel> get dateData => _dateData.value;
  int get totalVendas => _totalVendas.value;
  DateTime? get selectedDate => _selectedDate.value;

  final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  void setHomeData(List<HomeModel> data) {
    if (_selectedDate.value == null) {
      setChartData(_homeDataBackup.value);
    } else {
      final filteredData = data.where((item) {
        DateTime date;
        final split = item.dataVenda.split("/");
        date = DateTime(
            int.parse(split[2]), int.parse(split[1]), int.parse(split[0]));
        return date == _selectedDate.value;
      }).toList();
      setChartData(filteredData);
    }
  }

  String get totalFaturamento {
    final total = homeData.length * 197;

    return formatter.format(total);
  }

  String get totalReceita {
    final total = homeData.length * 174.85;
    return formatter.format(total);
  }

  void setChartData(List<HomeModel> data) {
    _homeData.set(data, force: true);
    _origemData.set(setOrigemData(data), force: true);
    _dateData.set(setDateData(data), force: true);
    _totalVendas.set(data.length, force: true);
    log("============= ${homeData.length} =============");
  }

  void resetSelectedDate() {
    _selectedDate.set(null, force: true);
    setHomeData(homeData);
  }

  void setSelectedDate(DateTime date) {
    _selectedDate.set(date, force: true);
    setHomeData(homeData);
  }

  Future<void> getHomeData() async {
    if (await isAuthenticaded()) {
      final result = await _homeServices.getHomeData().asyncLoader();

      switch (result) {
        case Left():
          showError("Erro ao buscar dados");
        case Right(value: List<HomeModel> data):
          _homeDataBackup.set(data, force: true);
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
