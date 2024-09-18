import 'package:agenciave_dash/core/auth/auth_controller.dart';
import 'package:agenciave_dash/core/constants/local_storage_constants.dart';
import 'package:agenciave_dash/core/local_storage/local_storage.dart';
import 'package:agenciave_dash/core/local_storage/local_storage_impl.dart';
import 'package:agenciave_dash/core/rest_client/rest_client.dart';
import 'package:agenciave_dash/core/ui/theme_manager.dart';
import 'package:flutter_getit/flutter_getit.dart';

class DashApplicationBindins extends ApplicationBindings {
  @override
  List<Bind<Object>> bindings() => [
        Bind.lazySingleton<RestClient>(
            (i) => RestClient(LocalStorageConstants.baseUrl)),
        Bind.lazySingleton<LocalStorage>((i) => SharedPreferenceImpl()),
        Bind.lazySingleton<ThemeManager>((i) => ThemeManager(false)),
        Bind.lazySingleton<AuthController>(
            (i) => AuthController(localStorage: i())),
      ];
}
