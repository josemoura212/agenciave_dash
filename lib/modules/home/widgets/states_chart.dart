import 'package:agenciave_dash/models/state_model.dart';
import 'package:agenciave_dash/modules/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StatesChart extends StatelessWidget {
  const StatesChart({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Injector.get<HomeController>();

    return Watch(
      (_) => SfCircularChart(
        title: const ChartTitle(text: "Estados"),
        legend: const Legend(isVisible: true),
        series: [
          PieSeries<StateModel, String>(
            explode: true,
            explodeIndex: 0,
            dataSource: controller.stateData,
            xValueMapper: (StateModel data, _) =>
                "${data.name} : Total ${data.total}",
            yValueMapper: (StateModel data, _) => data.value,
            dataLabelMapper: (StateModel data, _) => data.text,
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelPosition: ChartDataLabelPosition.outside,
              textStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
