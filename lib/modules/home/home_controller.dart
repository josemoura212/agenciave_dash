import 'dart:developer';

import 'package:flutter_getit/flutter_getit.dart';

import 'package:agenciave_dash/core/auth/auth_controller.dart';
import 'package:agenciave_dash/core/helpers/messages.dart';
import 'package:agenciave_dash/services/home/home_services.dart';

class HomeController with MessageStateMixin {
  final HomeServices _homeServices;
  HomeController({
    required HomeServices homeServices,
  }) : _homeServices = homeServices;

  final _authController = Injector.get<AuthController>();

  Future<void> getHomeData() async {
    if (await isAuthenticaded()) {
      final result = await _homeServices.getHomeData();

      log(result.toString());
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
