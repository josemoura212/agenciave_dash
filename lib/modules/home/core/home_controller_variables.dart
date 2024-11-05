part of "home_controller.dart";

enum Product {
  vi,
  si,
  pe,
  cd,
  black;

  @override
  toString() {
    return switch (this) {
      Product.vi => 'VI',
      Product.si => 'SI',
      Product.pe => 'SI',
      Product.cd => 'SI',
      Product.black => 'BLACK',
    };
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
  countryData,
  recoveryData,
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
  adsData,
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
  recovery,
  country;

  @override
  toString() {
    return switch (this) {
      ShowAndHide.settings => "settings",
      ShowAndHide.origem => "origin",
      ShowAndHide.state => "state",
      ShowAndHide.paymentType => "paymentType",
      ShowAndHide.paymentTypeOffer => "paymentTypeOffer",
      ShowAndHide.gridMedia => "gridMedia",
      ShowAndHide.weekday => "weekday",
      ShowAndHide.hour => "hour",
      ShowAndHide.status => "status",
      ShowAndHide.recovery => "recovery",
      ShowAndHide.country => "country",
    };
  }
}

mixin _HomeControllerVariables {
  final _authController = Injector.get<AuthController>();
  final _localStore = Injector.get<LocalStorage>();

  final Signal<List<RawSaleModel>> _homeData = Signal<List<RawSaleModel>>([]);
  List<RawSaleModel> get homeData => _homeData.value;
  final Signal<List<RawSaleModel>> _homeDataBackup =
      Signal<List<RawSaleModel>>([]);

  final Signal<List<AdsModel>> _adsData = Signal<List<AdsModel>>([]);

  final Signal<ProcessedSaleModel> _processedSaleData =
      Signal<ProcessedSaleModel>(ProcessedSaleModel.empty());
  ProcessedSaleModel get processedSaleData => _processedSaleData.value;
  GridMediaModel get gridMediaData => _processedSaleData.value.mediaData;

  final Signal<DateTime> _focusedDay = Signal<DateTime>(DateTime.now());
  final Signal<DateTime?> _selectedDay = Signal<DateTime?>(null);
  final Signal<DateTime?> _rangeStartDay = Signal<DateTime?>(null);
  final Signal<DateTime?> _rangeEndDay = Signal<DateTime?>(null);
  final Signal<RangeSelectionMode> _rangeSelectionMode =
      Signal<RangeSelectionMode>(RangeSelectionMode.toggledOff);
  DateTime get focusedDay => _focusedDay.value;
  DateTime? get selectedDay => _selectedDay.value;
  DateTime? get rangeEndDay => _rangeEndDay.value;
  DateTime? get rangeStartDay => _rangeStartDay.value;

  final Signal<int> _selectedRelease = Signal<int>(1);
  int get selectedRelease => _selectedRelease.value;
  final Signal<Product> _selectedProduct = Signal<Product>(Product.vi);
  Product get selectedProduct => _selectedProduct.value;

  final Signal<bool> _showSettings = Signal<bool>(false);
  final Signal<bool> _showOrigen = Signal<bool>(true);
  final Signal<bool> _showState = Signal<bool>(true);
  final Signal<bool> _showPaymentType = Signal<bool>(true);
  final Signal<bool> _showPaymentTypeOffer = Signal<bool>(true);
  final Signal<bool> _showCountry = Signal<bool>(true);
  final Signal<bool> _showGridMedia = Signal<bool>(true);
  final Signal<bool> _showWeekday = Signal<bool>(true);
  final Signal<bool> _showHour = Signal<bool>(true);
  final Signal<bool> _showStatus = Signal<bool>(true);
  final Signal<bool> _showRecovery = Signal<bool>(true);

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
    return switch (showAndHide) {
      ShowAndHide.settings => _showSettings.value,
      ShowAndHide.origem => _showOrigen.value,
      ShowAndHide.state => _showState.value,
      ShowAndHide.paymentType => _showPaymentType.value,
      ShowAndHide.paymentTypeOffer => _showPaymentTypeOffer.value,
      ShowAndHide.gridMedia => _showGridMedia.value,
      ShowAndHide.weekday => _showWeekday.value,
      ShowAndHide.hour => _showHour.value,
      ShowAndHide.status => _showStatus.value,
      ShowAndHide.recovery => _showRecovery.value,
      ShowAndHide.country => _showCountry.value,
    };
  }

  T getData<T>(GetData data) {
    return switch (data) {
      GetData.countryData => _processedSaleData.value.countryData as T,
      GetData.homeData => _homeData.value as T,
      GetData.recoveryData => _processedSaleData.value.recoveryData as T,
      GetData.dateData => _processedSaleData.value.dateData as T,
      GetData.origemData => _processedSaleData.value.origemData as T,
      GetData.stateData => _processedSaleData.value.stateData as T,
      GetData.paymentTypeData => _processedSaleData.value.paymentTypeData as T,
      GetData.paymentTypeOfferData =>
        _processedSaleData.value.paymentTypeOfferData as T,
      GetData.gridMediaData => _processedSaleData.value.mediaData as T,
      GetData.hourData => _processedSaleData.value.hourData as T,
      GetData.weekdayData => _processedSaleData.value.weekdayData as T,
      GetData.status => _processedSaleData.value.status as T,
      GetData.totalVendas => _processedSaleData.value.totalSales as T,
      GetData.totalFaturamento => _processedSaleData.value.totalInvoicing as T,
      GetData.totalReceita => _processedSaleData.value.totalCommission as T,
      GetData.selectedRelease => _selectedRelease.value as T,
      GetData.selectedProduct => _selectedProduct.value as T,
      GetData.rangeSelectionMode => _rangeSelectionMode.value as T,
      GetData.showSettings => _showSettings.value as T,
      GetData.adsData => _adsData.value as T,
    };
  }

  final porcometroData = listSignal<int>([]);
  Connect? _porcometroDataConnect;
  Function? _socketDispose;

  final Signal<Stream?> _channel = Signal(null);

  Stream? get channel => _channel.value;
}
