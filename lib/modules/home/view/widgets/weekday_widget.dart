import 'package:agenciave_dash/models/weekday_model.dart';
import 'package:agenciave_dash/modules/home/core/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class WeekdayWidget extends StatelessWidget {
  const WeekdayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Injector.get<HomeController>();
    return Expanded(
      child: Watch(
        (_) => SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          title: const ChartTitle(text: 'Vendas por dia da semana'),
          tooltipBehavior: TooltipBehavior(
            enable: true,
            header: "Vendas",
          ),
          series: [
            ColumnSeries<WeekdayModel, String>(
              dataSource: controller.getData(GetData.weekdayData),
              xValueMapper: (WeekdayModel data, _) => data.weekday,
              yValueMapper: (WeekdayModel data, _) => data.quantity,
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
