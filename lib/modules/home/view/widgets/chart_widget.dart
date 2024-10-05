import 'package:agenciave_dash/modules/home/core/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:agenciave_dash/models/chart_model.dart';

class ChartWidget extends StatelessWidget {
  const ChartWidget({
    super.key,
    required this.chartData,
    required this.title,
    required this.showAndHide,
  });

  final GetData chartData;
  final String title;
  final ShowAndHide showAndHide;

  @override
  Widget build(BuildContext context) {
    final controller = Injector.get<HomeController>();

    return Watch(
      (_) => Visibility(
        visible: controller.getShowAndHide(showAndHide),
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 2 - 50,
          child: Card(
            child: SfCircularChart(
              title: ChartTitle(text: title),
              legend: const Legend(
                isVisible: true,
              ),
              series: [
                PieSeries<ChartModel, String>(
                  explode: true,
                  explodeIndex: 0,
                  dataSource: controller.getData(chartData),
                  xValueMapper: (ChartModel data, _) =>
                      "${data.name} : Total ${data.total}",
                  yValueMapper: (ChartModel data, _) => data.value,
                  dataLabelMapper: (ChartModel data, _) => data.text,
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.outside,
                    overflowMode: OverflowMode.shift,
                    textStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
