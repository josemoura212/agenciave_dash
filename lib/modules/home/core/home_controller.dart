import 'dart:developer';

import 'package:agenciave_dash/core/constants/local_storage_constants.dart';
import 'package:agenciave_dash/core/local_storage/local_storage.dart';
import 'package:agenciave_dash/models/ads_model.dart';
import 'package:agenciave_dash/models/grid_model.dart';
import 'package:agenciave_dash/models/processed_sale_model.dart';
import 'package:agenciave_dash/models/product_model.dart';
import 'package:asyncstate/asyncstate.dart';
import 'package:flutter/material.dart';
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
      final resultData =
          await _homeServices.getHomeData(_selectedProduct.value);
      if (selectedProduct != Product.black) {
        final resultAds =
            await _homeServices.getAdsData(_selectedProduct.value);
        switch (resultAds) {
          case Left():
            showError("Erro ao buscar dados");
          case Right(value: var data):
            _adsData.set(data, force: true);
        }
      }

      switch (resultData) {
        case Left():
          showError("Erro ao buscar dados");
        case Right(value: var data):
          _homeDataBackup.set(data, force: true);
          if (_selectedProduct.value == Product.pe) {
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
        _localStore.readBool(LocalStorageConstants.gridMedia),
        _localStore.readBool(LocalStorageConstants.weekday),
        _localStore.readBool(LocalStorageConstants.hour),
        _localStore.readBool(LocalStorageConstants.status),
        _localStore.readBool(LocalStorageConstants.recovery),
        _localStore.readBool(LocalStorageConstants.country),
      ]);

      if (result[0] != null) {
        _selectedProduct.set(
            Product.values
                .firstWhere((element) => element.toString() == result[0]),
            force: true);
      }
      if (result[1] != null) _showOrigen.set(result[1] as bool, force: true);
      if (result[2] != null) _showState.set(result[2] as bool, force: true);
      if (result[3] != null) {
        _showPaymentType.set(result[3] as bool, force: true);
      }
      if (result[4] != null) {
        _showPaymentTypeOffer.set(result[4] as bool, force: true);
      }
      if (result[5] != null) _showGridMedia.set(result[5] as bool, force: true);
      if (result[6] != null) _showWeekday.set(result[6] as bool, force: true);
      if (result[7] != null) _showHour.set(result[7] as bool, force: true);
      if (result[8] != null) _showStatus.set(result[8] as bool, force: true);
      if (result[9] != null) _showRecovery.set(result[9] as bool, force: true);
      if (result[10] != null) {
        _showCountry.set(result[10] as bool, force: true);
      }

      return true;
    } else {
      showError("Usuário não autenticado");
      return false;
    }
  }

  Future<void> changeProduct(Product product) async {
    log("changeProduct ${product.toString()}");
    await _localStore.write(LocalStorageConstants.product, product.toString());
    _selectedProduct.set(product);
    _homeData.set([], force: true);
    _homeDataBackup.set([], force: true);
    _processedSaleData.set(ProcessedSaleModel.empty(), force: true);
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

  Future<void> initProducts() async {
    final result = await _homeServices.getProducts();

    switch (result) {
      case Left():
        showError("Erro ao buscar produtos");
      case Right(value: var data):
        _products.set(data, force: true);
    }
  }
}
