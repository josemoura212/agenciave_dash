import 'package:agenciave_dash/models/chart_model.dart';
import 'package:agenciave_dash/models/date_model.dart';
import 'package:agenciave_dash/models/grid_model.dart';
import 'package:agenciave_dash/models/hour_model.dart';
import 'package:agenciave_dash/models/weekday_model.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:intl/intl.dart';
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
  final Signal<List<HomeModel>> _homeDataBackup = Signal<List<HomeModel>>([]);
  final Signal<List<DateModel>> _dateData = Signal<List<DateModel>>([]);

  final Signal<List<ChartModel>> _origemData = Signal<List<ChartModel>>([]);
  final Signal<List<ChartModel>> _stateData = Signal<List<ChartModel>>([]);
  final Signal<GridMediaModel> _gridMediaData = Signal<GridMediaModel>(
      GridMediaModel(
          mediaDiaria: MediaDiaria(
              vendas: 0, mediaFaturamento: "0.0", mediaReceita: "0.0"),
          mediaMensal: MediaMensal(
              vendas: 0, mediaFaturamento: "0.0", mediaReceita: "0.0")));

  final Signal<List<HourModel>> _hourData = Signal<List<HourModel>>([]);
  final Signal<List<WeekdayModel>> _weekdayData =
      Signal<List<WeekdayModel>>([]);

  final Signal<int> _totalVendas = Signal<int>(0);
  final Signal<DateTime?> _selectedDate = Signal<DateTime?>(null);
  final Signal<String> _totalFaturamento = Signal<String>('');
  final Signal<String> _totalReceita = Signal<String>('');

  List<HomeModel> get homeData => _homeData.value;
  List<DateModel> get dateData => _dateData.value;

  List<ChartModel> get origemData => _origemData.value;
  List<ChartModel> get stateData => _stateData.value;
  GridMediaModel get gridMediaData => _gridMediaData.value;
  List<HourModel> get hourData => _hourData.value;
  List<WeekdayModel> get weekdayData => _weekdayData.value;

  int get totalVendas => _totalVendas.value;
  DateTime? get selectedDate => _selectedDate.value;
  String get totalFaturamento => _totalFaturamento.value;
  String get totalReceita => _totalReceita.value;

  final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  void setHomeData(List<HomeModel> data) {
    if (_selectedDate.value == null) {
      setChartData(_homeDataBackup.value);
    } else {
      final filteredData =
          data.where((item) => item.saleDate.day == selectedDate!.day).toList();
      setChartData(filteredData);
    }
  }

  void calcTotalFaturamento() {
    final total = homeData.length * homeData[0].invoicing;

    _totalFaturamento.set(formatter.format(total));
  }

  void calcTotalReceita() {
    final total = homeData.length * homeData[0].commissionValueGenerated;
    _totalReceita.set(formatter.format(total));
  }

  void setChartData(List<HomeModel> data) {
    var dataResult = data
        .where((item) =>
            item.status == "Aprovado" ||
            item.status == "APPROVED" ||
            item.status == "Completo" ||
            item.status == "COMPLETED")
        .toList();
    _homeData.set(data, force: true);
    _dateData.set(setDateData(dataResult), force: true);

    _origemData.set(setOrigemData(dataResult), force: true);
    _stateData.set(setStateData(dataResult), force: true);

    _totalVendas.set(dataResult.length, force: true);
    calcTotalFaturamento();
    calcTotalReceita();
    _gridMediaData.set(setGridMediaData(dateData));
    _hourData.set(setHourData(dataResult), force: true);
    _weekdayData.set(setWeekdayData(dataResult), force: true);
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
      final result = await _homeServices.getHomeData();

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
