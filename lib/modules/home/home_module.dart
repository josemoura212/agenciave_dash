import 'package:agenciave_dash/modules/home/home_controller.dart';
import 'package:agenciave_dash/modules/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';

class HomeModule extends FlutterGetItModule {
  @override
  String get moduleRouteName => "/home";

  @override
  List<Bind<Object>> get bindings =>
      [Bind.lazySingleton((i) => HomeController())];

  @override
  Map<String, WidgetBuilder> get pages => {
        "/": (context) => const HomePage(),
      };
}
