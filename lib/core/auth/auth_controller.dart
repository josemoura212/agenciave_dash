import 'package:agenciave_dash/core/constants/local_storage_constants.dart';
import 'package:agenciave_dash/core/local_storage/local_storage.dart';
import 'package:signals_flutter/signals_flutter.dart';

class AuthController {
  final LocalStorage _localStorage;
  final Signal<bool> _isAuthenticated = Signal(false);

  AuthController({required LocalStorage localStorage})
      : _localStorage = localStorage;

  Signal<bool> get isAuthenticated => _isAuthenticated;

  Future<void> setAuthenticate(String apiKey) async {
    _isAuthenticated.value = true;
    _localStorage.write(LocalStorageConstants.apiKey, apiKey);
  }

  Future<void> isAuthenticate() async {
    String apiKey =
        await _localStorage.read(LocalStorageConstants.apiKey) ?? "";

    if (apiKey.isNotEmpty) {
      _isAuthenticated.value = true;
    }
  }
}
