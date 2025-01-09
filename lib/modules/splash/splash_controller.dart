import 'package:agenciave_dash/core/auth/auth_controller.dart';
import 'package:agenciave_dash/core/fp/either.dart';
import 'package:agenciave_dash/core/helpers/messages.dart';
import 'package:agenciave_dash/models/product_model.dart';
import 'package:agenciave_dash/services/splash/splash_services.dart';
import 'package:asyncstate/asyncstate.dart';

class SplashController with MessageStateMixin {
  final SplashServices _splashServices;
  final AuthController _authController;

  SplashController({
    required SplashServices splashServices,
    required AuthController authController,
  })  : _splashServices = splashServices,
        _authController = authController;

  Future<List<ProductModel>> checkAuth({required String apiKey}) async {
    final result =
        await _splashServices.checkAuth(apiKey: apiKey).asyncLoader();

    switch (result) {
      case Left(value: _):
        showError("Api Key inválida");
        return [];
      case Right():
        return result.value;
    }
  }

  Future<List<ProductModel>> isAuthenticate() async {
    final apiKey = await _authController.isAuthenticate();

    if (apiKey != null) {
      return await checkAuth(apiKey: apiKey);
    } else {
      return [];
    }
  }
}
