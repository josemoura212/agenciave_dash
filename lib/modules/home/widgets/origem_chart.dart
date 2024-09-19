import 'package:agenciave_dash/models/home_model.dart';
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
          title: ChartTitle(
              text: "Origem das Vendas - Quant. ${controller.homeData.length}"),
          legend: const Legend(isVisible: true),
          series: [
            PieSeries<Origem, String>(
              explode: true,
              explodeIndex: 0,
              dataSource: controller.origemData,
              xValueMapper: (Origem data, _) =>
                  "${data.name} : Total ${data.total}",
              yValueMapper: (Origem data, _) => data.value,
              dataLabelMapper: (Origem data, _) =>
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
