import 'package:agenciave_dash/modules/home/core/home_controller.dart';
import 'package:agenciave_dash/modules/home/view/home_page.dart';
import 'package:agenciave_dash/repositories/home/home_repository.dart';
import 'package:agenciave_dash/repositories/home/home_repository_impl.dart';
import 'package:agenciave_dash/services/home/home_services.dart';
import 'package:agenciave_dash/services/home/home_services_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';

class HomeModule extends FlutterGetItModule {
  @override
  String get moduleRouteName => "/home";

  @override
  List<Bind<Object>> get bindings => [
        Bind.lazySingleton<HomeRepository>((i) => HomeRepositoryImpl(
              restClient: i(),
              localStorage: i(),
            )),
        Bind.lazySingleton<HomeServices>(
            (i) => HomeServicesImpl(homeRepository: i())),
        Bind.lazySingleton((i) => HomeController(homeServices: i())),
      ];

  @override
  Map<String, WidgetBuilder> get pages => {
        "/": (context) => const HomePage(),
      };
}
