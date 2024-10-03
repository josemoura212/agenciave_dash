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

enum GetData {
  homeData,
  dateData,
  origemData,
  stateData,
  paymentTypeData,
  paymentTypeOfferData,
  gridMediaData,
  hourData,
  weekdayData,
  status,
  totalVendas,
  totalFaturamento,
  totalReceita,
  selectedRelease,
  selectedProduct,
  rangeSelectionMode,
  showSettings,
}

enum ShowAndHide {
  settings,
  origem,
  state,
  paymentType,
  paymentTypeOffer,
  gridMedia,
  weekday,
  hour,
  status,
}

mixin _HomeControllerVariables {
  final _authController = Injector.get<AuthController>();
  final _localStore = Injector.get<LocalStorage>();

  final Signal<List<RawSaleModel>> _homeData = Signal<List<RawSaleModel>>([]);
  final Signal<List<RawSaleModel>> _homeDataBackup =
      Signal<List<RawSaleModel>>([]);

  final Signal<ProcessedSaleModel> _processedSaleData =
      Signal<ProcessedSaleModel>(ProcessedSaleModel.empty());
  ProcessedSaleModel get processedSaleData => _processedSaleData.value;
  GridMediaModel get gridMediaData => _processedSaleData.value.mediaData;

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

  final Signal<bool> _showSettings = Signal<bool>(false);

  final Signal<bool> _showOrigen = Signal<bool>(true);

  final Signal<bool> _showState = Signal<bool>(true);

  final Signal<bool> _showPaymentType = Signal<bool>(true);

  final Signal<bool> _showPaymentTypeOffer = Signal<bool>(true);

  set focusedDay(DateTime focusedDay) {
    _focusedDay.value = focusedDay;
  }

  String? get selectedDayFormatted {
    if (_rangeStartDay.value != null && _rangeEndDay.value != null) {
      return "${DateFormat('dd/MM/yyyy').format(_rangeStartDay.value!)} - ${DateFormat('dd/MM/yyyy').format(_rangeEndDay.value!)}";
    }
    return _selectedDay.value != null
        ? DateFormat('dd/MM/yyyy').format(_selectedDay.value!)
        : null;
  }

  final release = {
    "1": [DateTime.utc(2024, 7, 30), DateTime.utc(2024, 8, 05)],
    "2": [DateTime.utc(2024, 9, 01), DateTime.utc(2024, 9, 5)],
    "3": [
      DateTime.utc(2024, 9, 27, 0, 0, 0),
      DateTime.now().add(Duration(hours: 3))
    ],
  };

  bool getShowAndHide(ShowAndHide showAndHide) {
    switch (showAndHide) {
      case ShowAndHide.settings:
        return _showSettings.value;
      case ShowAndHide.origem:
        return _showOrigen.value;
      case ShowAndHide.state:
        return _showState.value;
      case ShowAndHide.paymentType:
        return _showPaymentType.value;
      case ShowAndHide.paymentTypeOffer:
        return _showPaymentTypeOffer.value;
      case _:
        return true;
    }
  }

  T getData<T>(GetData data) {
    switch (data) {
      case GetData.homeData:
        return _homeData.value as T;
      case GetData.dateData:
        return _processedSaleData.value.dateData as T;
      case GetData.origemData:
        return _processedSaleData.value.origemData as T;
      case GetData.stateData:
        return _processedSaleData.value.stateData as T;
      case GetData.paymentTypeData:
        return _processedSaleData.value.paymentTypeData as T;
      case GetData.paymentTypeOfferData:
        return _processedSaleData.value.paymentTypeOfferData as T;
      case GetData.gridMediaData:
        return _processedSaleData.value.mediaData as T;
      case GetData.hourData:
        return _processedSaleData.value.hourData as T;
      case GetData.weekdayData:
        return _processedSaleData.value.weekdayData as T;
      case GetData.status:
        return _processedSaleData.value.status as T;
      case GetData.totalVendas:
        return _processedSaleData.value.totalSales as T;
      case GetData.totalFaturamento:
        return _processedSaleData.value.totalInvoicing as T;
      case GetData.totalReceita:
        return _processedSaleData.value.totalCommission as T;
      case GetData.selectedRelease:
        return _selectedRelease.value as T;
      case GetData.selectedProduct:
        return _selectedProduct.value as T;
      case GetData.rangeSelectionMode:
        return _rangeSelectionMode.value as T;
      case GetData.showSettings:
        return _showSettings.value as T;
    }
  }
}
