import 'package:agenciave_dash/models/hour_model.dart';
import 'package:agenciave_dash/modules/home/core/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HourWidget extends StatelessWidget {
  const HourWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Injector.get<HomeController>();

    return Expanded(
      child: Watch(
        (_) => SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          title: const ChartTitle(text: 'Vendas por hora'),
          tooltipBehavior: TooltipBehavior(
            enable: true,
            header: "Vendas",
          ),
          series: [
            ColumnSeries<HourModel, String>(
              dataSource: controller.hourData,
              xValueMapper: (HourModel data, _) => "${data.hour}:00h",
              yValueMapper: (HourModel data, _) => data.quantity,
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
      ),
    );
  }
}
