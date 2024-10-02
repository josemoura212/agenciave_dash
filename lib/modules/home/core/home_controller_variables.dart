part of "home_controller.dart";

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

mixin _HomeControllerVariables {
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

  set focusedDay(DateTime focusedDay) {
    _focusedDay.value = focusedDay;
  }

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
    "3": [
      DateTime.utc(2024, 9, 27, 0, 0, 0),
      DateTime.now().add(Duration(hours: 3))
    ],
  };
}
