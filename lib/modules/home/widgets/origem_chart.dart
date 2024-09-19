import 'package:agenciave_dash/models/origem_model.dart';
import 'package:agenciave_dash/modules/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class OrigemChart extends StatelessWidget {
  const OrigemChart({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Injector.get<HomeController>();

    return Watch(
      (_) => Expanded(
        child: SfCircularChart(
          title: const ChartTitle(text: "Origem das Vendas"),
          legend: const Legend(isVisible: true),
          series: [
            PieSeries<OrigemModel, String>(
              explode: true,
              explodeIndex: 0,
              dataSource: controller.origemData,
              xValueMapper: (OrigemModel data, _) =>
                  "${data.name} : Total ${data.total}",
              yValueMapper: (OrigemModel data, _) => data.value,
              dataLabelMapper: (OrigemModel data, _) =>
                  "${data.text} : Total ${data.total}",
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                textStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
