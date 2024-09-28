import 'dart:developer';

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
import 'package:table_calendar/table_calendar.dart';

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
  final Signal<String> _totalFaturamento = Signal<String>('');
  final Signal<String> _totalReceita = Signal<String>('');

  final Signal<DateTime?> _rangeEndDay = Signal<DateTime?>(null);
  final Signal<DateTime?> _rangeStartDay = Signal<DateTime?>(null);
  final Signal<DateTime?> _selectedDay = Signal<DateTime?>(null);
  final Signal<DateTime> _focusedDay = Signal<DateTime>(DateTime.now());

  set focusedDay(DateTime focusedDay) {
    _focusedDay.value = focusedDay;
  }

  final Signal<RangeSelectionMode> _rangeSelectionMode =
      Signal<RangeSelectionMode>(RangeSelectionMode.toggledOn);

  List<HomeModel> get homeData => _homeData.value;
  List<DateModel> get dateData => _dateData.value;

  List<ChartModel> get origemData => _origemData.value;
  List<ChartModel> get stateData => _stateData.value;
  GridMediaModel get gridMediaData => _gridMediaData.value;
  List<HourModel> get hourData => _hourData.value;
  List<WeekdayModel> get weekdayData => _weekdayData.value;

  int get totalVendas => _totalVendas.value;

  DateTime? get rangeStartDay => _rangeStartDay.value;
  DateTime? get rangeEndDay => _rangeEndDay.value;
  DateTime? get selectedDay => _selectedDay.value;
  DateTime get focusedDay => _focusedDay.value;

  String? get selectedDayFormatted {
    if (rangeStartDay != null && rangeEndDay != null) {
      return "${DateFormat('dd/MM/yyyy').format(rangeStartDay!)} - ${DateFormat('dd/MM/yyyy').format(rangeEndDay!)}";
    }
    return selectedDay != null
        ? DateFormat('dd/MM/yyyy').format(selectedDay!)
        : null;
  }

  RangeSelectionMode get rangeSelectionMode => _rangeSelectionMode.value;

  String get totalFaturamento => _totalFaturamento.value;
  String get totalReceita => _totalReceita.value;

  final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  void _setHomeData(List<HomeModel> data) {
    if (_selectedDay.value != null) {
      final filteredData = data.where((item) {
        final normalizedSaleDate = DateTime(
            item.saleDate.year, item.saleDate.month, item.saleDate.day);

        return isSameDay(normalizedSaleDate, _selectedDay.value);
      }).toList();
      _setChartData(filteredData);
    } else if (_rangeStartDay.value != null && _rangeEndDay.value != null) {
      final filteredData = data.where((item) {
        final normalizedSaleDate = DateTime(
            item.saleDate.year, item.saleDate.month, item.saleDate.day);
        final normalizedStartDate = DateTime(
            rangeStartDay!.year, rangeStartDay!.month, rangeStartDay!.day);
        final normalizedEndDate =
            DateTime(rangeEndDay!.year, rangeEndDay!.month, rangeEndDay!.day);

        return normalizedSaleDate.isAfter(
                normalizedStartDate.subtract(const Duration(days: 1))) &&
            normalizedSaleDate
                .isBefore(normalizedEndDate.add(const Duration(days: 1)));
      }).toList();

      _setChartData(filteredData);
    } else {
      _setChartData(data);
    }
  }

  void _setChartData(List<HomeModel> data) {
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
    _calcTotalFaturamento();
    _calcTotalReceita();
    _gridMediaData.set(setGridMediaData(dateData));
    _hourData.set(setHourData(dataResult), force: true);
    _weekdayData.set(setWeekdayData(dataResult), force: true);
  }

  void _calcTotalFaturamento() {
    final total = homeData.fold<double>(
        0, (previusValue, element) => previusValue + element.invoicing);

    _totalFaturamento.set(formatter.format(total));
  }

  void _calcTotalReceita() {
    final total = homeData.fold<double>(
        0,
        (previusValue, element) =>
            previusValue + element.commissionValueGenerated);
    _totalReceita.set(formatter.format(total));
  }

  void resetSelectedDate() {
    DateTime now = DateTime.now();
    _rangeStartDay.value = null;
    _rangeEndDay.value = null;
    _selectedDay.value = null;
    _focusedDay.value = now;
    if (_homeData.value.length != _homeDataBackup.value.length) {
      _setHomeData(_homeDataBackup.value);
    }
  }

  void onRangeSelectionModeChanged() {
    final mode = rangeSelectionMode == RangeSelectionMode.toggledOff
        ? RangeSelectionMode.toggledOn
        : RangeSelectionMode.toggledOff;
    _rangeSelectionMode.value = mode;
    resetSelectedDate();
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    _selectedDay.value = selectedDay;
    _focusedDay.value = focusedDay;

    _rangeStartDay.value = null;
    _rangeEndDay.value = null;
    _setHomeData(_homeDataBackup.value);
  }

  void onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    log('4522 starttt: $start');
    log('4522 enddd: $end');
    log('4522 focusedDay: $focusedDay');
    log('4522 selectedDay ${_selectedDay.value}');

    if (_rangeStartDay.value != null && _rangeEndDay.value != null) {
      return;
    }

    if (start != null) {
      _rangeStartDay.value = start;
      _focusedDay.value = start;
    }

    if (end != null) {
      _rangeEndDay.value = end;
    }

    if (start != null && end != null) {
      if (start.isAfter(end)) {
        _rangeStartDay.value = end;
        _rangeEndDay.value = start;
        _focusedDay.value = end;
      }
    }

    _selectedDay.value = null;

    log('4522 depois starttt: $start');
    log('4522 depois enddd: $end');
    log('4522 depois focusedDay: $focusedDay');
    log('4522 depois selectedDay ${_selectedDay.value}');
    _setHomeData(_homeDataBackup.value);
  }

  Future<void> getHomeData() async {
    if (await isAuthenticaded()) {
      final result = await _homeServices.getHomeData();

      switch (result) {
        case Left():
          showError("Erro ao buscar dados");
        case Right(value: List<HomeModel> data):
          _homeDataBackup.set(data, force: true);
          _setHomeData(data);
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
