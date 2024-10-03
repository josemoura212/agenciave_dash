import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:agenciave_dash/models/chart_model.dart';

class ChartWidget extends StatelessWidget {
  const ChartWidget({
    super.key,
    required this.chartData,
    required this.title,
  });

  final List<ChartModel> chartData;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
              dataSource: chartData,
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
    );
  }
}
