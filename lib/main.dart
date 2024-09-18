import 'package:agenciave_dash/core/bindings/dash_application_bindins.dart';
import 'package:agenciave_dash/core/ui/loader.dart';
import 'package:agenciave_dash/core/ui/theme_manager.dart';
import 'package:agenciave_dash/core/ui/ui_config.dart';
import 'package:agenciave_dash/modules/home/home_module.dart';
import 'package:agenciave_dash/modules/splash/splash_module.dart';
import 'package:asyncstate/asyncstate.dart' as asyncstate;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:signals_flutter/signals_flutter.dart';

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
        SplashModule(),
        HomeModule(),
      ],
      builder: (context, routes, flutterGetItObserver) {
        final themeManager = Injector.get<ThemeManager>()..getDarkMode();
        return asyncstate.AsyncStateBuilder(
          loader: DashLoader(),
          builder: (asyncNavigatorObserver) {
            return Watch(
              (_) => MaterialApp(
                debugShowCheckedModeBanner: false,
                title: "Agência Vê Dashboard",
                theme: UiConfig.lightTheme,
                darkTheme: UiConfig.darkTheme,
                themeMode:
                    themeManager.isDarkMode ? ThemeMode.dark : ThemeMode.light,
                navigatorObservers: [
                  asyncNavigatorObserver,
                  flutterGetItObserver
                ],
                routes: routes,
              ),
            );
          },
        );
      },
    );
  }
}
