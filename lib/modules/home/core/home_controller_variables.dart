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
  List<HomeModel> get homeData => _homeData.value;

  final Signal<List<DateModel>> _dateData = Signal<List<DateModel>>([]);
  List<DateModel> get dateData => _dateData.value;

  final Signal<List<ChartModel>> _origemData = Signal<List<ChartModel>>([]);
  List<ChartModel> get origemData => _origemData.value;

  final Signal<List<ChartModel>> _stateData = Signal<List<ChartModel>>([]);
  List<ChartModel> get stateData => _stateData.value;

  final Signal<GridMediaModel> _gridMediaData = Signal<GridMediaModel>(
      GridMediaModel(
          mediaDiaria: MediaDiaria(
              vendas: 0, mediaFaturamento: "0.0", mediaReceita: "0.0"),
          mediaMensal: MediaMensal(
              vendas: 0, mediaFaturamento: "0.0", mediaReceita: "0.0")));
  GridMediaModel get gridMediaData => _gridMediaData.value;

  final Signal<List<HourModel>> _hourData = Signal<List<HourModel>>([]);
  List<HourModel> get hourData => _hourData.value;

  final Signal<List<WeekdayModel>> _weekdayData =
      Signal<List<WeekdayModel>>([]);
  List<WeekdayModel> get weekdayData => _weekdayData.value;

  final Signal<int> _totalVendas = Signal<int>(0);
  int get totalVendas => _totalVendas.value;

  final Signal<String> _totalFaturamento = Signal<String>('');
  String get totalFaturamento => _totalFaturamento.value;

  final Signal<String> _totalReceita = Signal<String>('');
  String get totalReceita => _totalReceita.value;

  final Signal<DateTime?> _rangeStartDay = Signal<DateTime?>(null);
  DateTime? get rangeStartDay => _rangeStartDay.value;

  final Signal<DateTime?> _rangeEndDay = Signal<DateTime?>(null);
  DateTime? get rangeEndDay => _rangeEndDay.value;

  final Signal<DateTime?> _selectedDay = Signal<DateTime?>(null);
  DateTime? get selectedDay => _selectedDay.value;

  final Signal<DateTime> _focusedDay = Signal<DateTime>(DateTime.now());
  DateTime get focusedDay => _focusedDay.value;

  final Signal<int> _selectedRelease = Signal<int>(1);
  int get selectedRelease => _selectedRelease.value;

  final Signal<Product> _selectedProduct = Signal<Product>(Product.vi);
  Product get selectedProduct => _selectedProduct.value;

  final Signal<RangeSelectionMode> _rangeSelectionMode =
      Signal<RangeSelectionMode>(RangeSelectionMode.toggledOff);
  RangeSelectionMode get rangeSelectionMode => _rangeSelectionMode.value;

  final Signal<bool> _showSettings = Signal<bool>(false);
  bool get showSettings => _showSettings.value;

  final Signal<bool> _showOrigen = Signal<bool>(true);
  bool get showOrigen => _showOrigen.value;

  final Signal<bool> _showState = Signal<bool>(true);
  bool get showState => _showState.value;

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
