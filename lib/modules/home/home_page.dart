import 'package:agenciave_dash/core/helpers/messages.dart';
import 'package:agenciave_dash/core/ui/theme_manager.dart';
import 'package:agenciave_dash/models/home_model.dart';
import 'package:agenciave_dash/modules/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with MessageViewMixin {
  final controller = Injector.get<HomeController>();
  final _themeManager = Injector.get<ThemeManager>();

  @override
  void initState() {
    messageListener(controller);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final logged = await controller.isAuthenticaded();
      if (!logged) {
        Navigator.pushNamedAndRemoveUntil(
          // ignore: use_build_context_synchronously
          context,
          "/splash",
          (_) => false,
        );
      }

      await controller.getHomeData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              // Logic to toggle theme
              _themeManager.toggleTheme();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Watch(
            (_) => Expanded(
              child: SfCircularChart(
                title: const ChartTitle(text: "Origem"),
                legend: const Legend(isVisible: true),
                series: [
                  PieSeries<Origem, String>(
                    explode: true,
                    explodeIndex: 0,
                    dataSource: controller.origemData,
                    xValueMapper: (Origem data, _) => data.name,
                    yValueMapper: (Origem data, _) => data.value,
                    dataLabelMapper: (Origem data, _) => data.text,
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
