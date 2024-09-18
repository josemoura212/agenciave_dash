import 'package:agenciave_dash/core/auth/auth_controller.dart';
import 'package:agenciave_dash/core/helpers/messages.dart';
import 'package:flutter_getit/flutter_getit.dart';

class HomeController with MessageStateMixin {
  final _authController = Injector.get<AuthController>();

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
