import 'package:agenciave_dash/core/constants/local_storage_constants.dart';
import 'package:agenciave_dash/core/local_storage/local_storage.dart';
import 'package:agenciave_dash/models/chart_model.dart';
import 'package:agenciave_dash/models/date_model.dart';
import 'package:agenciave_dash/models/grid_model.dart';
import 'package:agenciave_dash/models/hour_model.dart';
import 'package:agenciave_dash/models/weekday_model.dart';
import 'package:asyncstate/asyncstate.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:intl/intl.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:agenciave_dash/core/auth/auth_controller.dart';
import 'package:agenciave_dash/core/fp/either.dart';
import 'package:agenciave_dash/core/helpers/messages.dart';
import 'package:agenciave_dash/models/home_model.dart';
import 'package:agenciave_dash/services/home/home_services.dart';
import 'package:table_calendar/table_calendar.dart';

enum Product {
  vi,
  si,
  pe;

  @override
  toString() {
    switch (this) {
      case Product.vi:
        return 'VI';
      case Product.si:
        return 'SI';
      case Product.pe:
        return 'PE';
    }
  }
}

class HomeController with MessageStateMixin {
  HomeController({
    required HomeServices homeServices,
  }) : _homeServices = homeServices;

  final HomeServices _homeServices;

  final _authController = Injector.get<AuthController>();
  final _localStore = Injector.get<LocalStorage>();

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
  final Signal<int> _selectedRelease = Signal<int>(1);

  final Signal<Product> _selectedProduct = Signal<Product>(Product.vi);

  set focusedDay(DateTime focusedDay) {
    _focusedDay.value = focusedDay;
  }

  final Signal<RangeSelectionMode> _rangeSelectionMode =
      Signal<RangeSelectionMode>(RangeSelectionMode.toggledOff);

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

  Product get selectedProduct => _selectedProduct.value;
  int get selectedRelease => _selectedRelease.value;

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

  final release = {
    "1": [DateTime.utc(2024, 7, 30), DateTime.utc(2024, 8, 05)],
    "2": [DateTime.utc(2024, 9, 01), DateTime.utc(2024, 9, 5)],
    "3": [DateTime.utc(2024, 9, 27), DateTime.now()],
  };

  Future<void> changeRelease(bool toglee, {bool initial = false}) async {
    final start = 0;
    final end = release.length;
    final current = selectedRelease;
    if (initial) {
      _selectedRelease.set(1, force: true);
      _rangeStartDay.set(release["1"]![0], force: true);
      _rangeEndDay.set(release["1"]![1], force: true);
      _focusedDay.set(release["1"]![0].add(Duration(days: 1)), force: true);
      _rangeSelectionMode.value = RangeSelectionMode.toggledOn;
      _setHomeData(_homeDataBackup.value);
      return;
    }
    if (toglee) {
      if (current != end) {
        _selectedRelease.set(current + 1);
      }
    } else {
      if (current != start) {
        _selectedRelease.set(current - 1);
      }
    }
    _rangeStartDay.value = release[selectedRelease.toString()]![0];
    _rangeEndDay.value = release[selectedRelease.toString()]![1];
    _focusedDay.value =
        release[selectedRelease.toString()]![0].add(Duration(days: 1));
    _rangeSelectionMode.value = RangeSelectionMode.toggledOn;
    _setHomeData(_homeDataBackup.value);
    await _localStore.write(
        LocalStorageConstants.release, selectedRelease.toString());
  }

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
    if (_rangeSelectionMode.value == RangeSelectionMode.toggledOn) {
      _rangeStartDay.value = null;
      _rangeEndDay.value = null;
    } else {
      _selectedDay.value = null;
    }
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

    _setHomeData(_homeDataBackup.value);
  }

  Future<void> changeProduct(Product product) async {
    await _localStore.write(LocalStorageConstants.product, product.toString());
    _selectedProduct.set(product);
    _homeData.set([], force: true);
    _homeDataBackup.set([], force: true);
    _dateData.set([], force: true);
    _origemData.set([], force: true);
    _stateData.set([], force: true);
    _gridMediaData.set(
        GridMediaModel(
            mediaDiaria: MediaDiaria(
                vendas: 0, mediaFaturamento: "0.0", mediaReceita: "0.0"),
            mediaMensal: MediaMensal(
                vendas: 0, mediaFaturamento: "0.0", mediaReceita: "0.0")),
        force: true);
    _hourData.set([], force: true);
    _weekdayData.set([], force: true);
    _totalVendas.set(0, force: true);
    _totalFaturamento.set('', force: true);
    _totalReceita.set('', force: true);
    await getHomeData().asyncLoader();
    if (product == Product.pe) {
      changeRelease(true, initial: true);
    }
  }

  Future<void> getHomeData() async {
    if (await isAuthenticaded()) {
      final result = await _homeServices.getHomeData(selectedProduct);

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
      final productResult =
          await _localStore.read(LocalStorageConstants.product);
      if (productResult != null) {
        _selectedProduct.set(
            Product.values
                .firstWhere((element) => element.toString() == productResult),
            force: true);
      }
      return true;
    } else {
      showError("Usuário não autenticado");
      return false;
    }
  }
}
