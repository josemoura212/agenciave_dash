import 'package:agenciave_dash/core/fp/either.dart';
import 'package:agenciave_dash/core/helpers/messages.dart';
import 'package:agenciave_dash/services/splash/splash_services.dart';

class SplashController with MessageStateMixin {
  final SplashServices _splashServices;

  SplashController({
    required SplashServices splashServices,
  }) : _splashServices = splashServices;

  Future<bool> checkAuth({required String apiKey}) async {
    final result = await _splashServices.checkAuth(apiKey: apiKey);

    switch (result) {
      case Left(value: _):
        showError("Api Key inválida");
        return false;
      case Right(value: _):
        return true;
    }
  }
}
