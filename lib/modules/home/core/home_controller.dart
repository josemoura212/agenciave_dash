import 'package:agenciave_dash/core/constants/local_storage_constants.dart';
import 'package:agenciave_dash/core/local_storage/local_storage.dart';
import 'package:agenciave_dash/models/chart_model.dart';
import 'package:agenciave_dash/models/date_model.dart';
import 'package:agenciave_dash/models/grid_model.dart';
import 'package:agenciave_dash/models/cartesian_model.dart';
import 'package:agenciave_dash/models/processed_sale_model.dart';
import 'package:agenciave_dash/models/weekday_model.dart';
import 'package:asyncstate/asyncstate.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:intl/intl.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:agenciave_dash/core/auth/auth_controller.dart';
import 'package:agenciave_dash/core/fp/either.dart';
import 'package:agenciave_dash/core/helpers/messages.dart';
import 'package:agenciave_dash/models/raw_sale_model.dart';
import 'package:agenciave_dash/services/home/home_services.dart';
import 'package:table_calendar/table_calendar.dart';
part 'home_controller_variables.dart';
part 'home_controller_functions.dart';

class HomeController
    with MessageStateMixin, _HomeControllerVariables, _HomeControllerFunctions {
  HomeController({
    required HomeServices homeServices,
  }) : _homeServices = homeServices;

  final HomeServices _homeServices;

  Future<void> getHomeData() async {
    if (await isAuthenticaded()) {
      final result = await _homeServices.getHomeData(selectedProduct);

      switch (result) {
        case Left():
          showError("Erro ao buscar dados");
        case Right(value: List<RawSaleModel> data):
          _homeDataBackup.set(data, force: true);
          if (selectedProduct == Product.pe) {
            changeRelease(true, initial: true);
          } else {
            _setHomeData(data);
          }
      }
    }
  }

  Future<bool> isAuthenticaded() async {
    final apyKey = await _authController.isAuthenticate();

    if (apyKey != null) {
      final result = await Future.wait([
        _localStore.read(LocalStorageConstants.product),
        _localStore.readBool(LocalStorageConstants.origen),
        _localStore.readBool(LocalStorageConstants.state),
        _localStore.readBool(LocalStorageConstants.paymentType),
        _localStore.readBool(LocalStorageConstants.paymentTypeOffer),
      ]);

      _selectedProduct.set(
          Product.values
              .firstWhere((element) => element.toString() == result[0]),
          force: true);
      if (result[1] != null) _showOrigen.set(result[1] as bool, force: true);
      if (result[2] != null) _showState.set(result[2] as bool, force: true);
      if (result[3] != null) {
        _showPaymentType.set(result[3] as bool, force: true);
      }
      if (result[4] != null) {
        _showPaymentTypeOffer.set(result[4] as bool, force: true);
      }

      return true;
    } else {
      showError("Usuário não autenticado");
      return false;
    }
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
    _selectedDay.set(null, force: true);
    _rangeStartDay.set(null, force: true);
    _rangeEndDay.set(null, force: true);
    _focusedDay.set(DateTime.now(), force: true);
    _showSettings.set(false, force: true);
    await getHomeData().asyncLoader();
    if (product == Product.pe) {
      changeRelease(true);
    }
  }
}
