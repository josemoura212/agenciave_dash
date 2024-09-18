import 'package:agenciave_dash/modules/splash/splash_controller.dart';
import 'package:agenciave_dash/modules/splash/splash_page.dart';
import 'package:agenciave_dash/repositories/splash/splash_repository.dart';
import 'package:agenciave_dash/repositories/splash/splash_repository_impl.dart';
import 'package:agenciave_dash/services/splash/splash_services.dart';
import 'package:agenciave_dash/services/splash/splash_services_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';

class SplashModule extends FlutterGetItModule {
  @override
  String get moduleRouteName => "/";

  @override
  List<Bind<Object>> get bindings => [
        Bind.lazySingleton<SplashRepository>((i) => SplashRepositoryImpl(
              restClient: i(),
            )),
        Bind.lazySingleton<SplashServices>((i) => SplashServicesImpl(
              splashRepository: i(),
            )),
        Bind.lazySingleton((i) => SplashController(
              splashServices: i(),
            )),
      ];

  @override
  Map<String, WidgetBuilder> get pages => {
        moduleRouteName: (_) => const SplashPage(),
      };
}
