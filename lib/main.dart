import 'package:agenciave_dash/core/bindings/dash_application_bindins.dart';
import 'package:agenciave_dash/core/ui/loader.dart';
import 'package:agenciave_dash/modules/home/home_module.dart';
import 'package:agenciave_dash/pages/splash_page.dart';
import 'package:asyncstate/asyncstate.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterGetIt(
      debugMode: kDebugMode,
      bindings: DashApplicationBindins(),
      modules: [
        HomeModule(),
      ],
      pages: [
        FlutterGetItPageBuilder(
          path: "/",
          page: (_) => const SplashPage(),
        )
      ],
      builder: (context, routes, flutterGetItObserver) {
        return AsyncStateBuilder(
          loader: DashLoader(),
          builder: (asyncNavigatorObserver) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: "Agência Vê Dashboard",
              navigatorObservers: [
                asyncNavigatorObserver,
                flutterGetItObserver
              ],
              routes: routes,
            );
          },
        );
      },
    );
  }
}
